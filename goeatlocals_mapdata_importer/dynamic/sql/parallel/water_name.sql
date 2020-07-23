DO $$ BEGIN RAISE NOTICE 'Processing layer water_name'; END$$;

-- Layer water_name - ./update_marine_point.sql

DROP TRIGGER IF EXISTS trigger_flag ON osm_marine_point;
DROP TRIGGER IF EXISTS trigger_refresh ON water_name_marine.updates;

CREATE EXTENSION IF NOT EXISTS unaccent;

CREATE OR REPLACE FUNCTION update_osm_marine_point() RETURNS VOID AS $$
BEGIN
  -- etldoc: osm_marine_point          -> osm_marine_point
  UPDATE osm_marine_point AS osm SET "rank" = NULL WHERE "rank" IS NOT NULL;

  -- etldoc: ne_10m_geography_marine_polys -> osm_marine_point
  -- etldoc: osm_marine_point              -> osm_marine_point

  WITH important_marine_point AS (
      SELECT osm.geometry, osm.osm_id, osm.name, osm.name_en, ne.scalerank, osm.is_intermittent
      FROM ne_10m_geography_marine_polys AS ne, osm_marine_point AS osm
      WHERE trim(regexp_replace(ne.name, '\\s+', ' ', 'g')) ILIKE osm.name
        OR trim(regexp_replace(ne.name, '\\s+', ' ', 'g')) ILIKE osm.tags->'name:en'
        OR trim(regexp_replace(ne.name, '\\s+', ' ', 'g')) ILIKE osm.tags->'name:es'
        OR osm.name ILIKE trim(regexp_replace(ne.name, '\\s+', ' ', 'g')) || ' %'
  )
  UPDATE osm_marine_point AS osm
  SET "rank" = scalerank
  FROM important_marine_point AS ne
  WHERE osm.osm_id = ne.osm_id;

  UPDATE osm_marine_point
  SET tags = update_tags(tags, geometry)
  WHERE COALESCE(tags->'name:latin', tags->'name:nonlatin', tags->'name_int') IS NULL;

END;
$$ LANGUAGE plpgsql;

SELECT update_osm_marine_point();

CREATE INDEX IF NOT EXISTS osm_marine_point_rank_idx ON osm_marine_point("rank");

-- Handle updates
CREATE SCHEMA IF NOT EXISTS water_name_marine;

CREATE TABLE IF NOT EXISTS water_name_marine.updates(id serial primary key, t text, unique (t));
CREATE OR REPLACE FUNCTION water_name_marine.flag() RETURNS trigger AS $$
BEGIN
    INSERT INTO water_name_marine.updates(t) VALUES ('y')  ON CONFLICT(t) DO NOTHING;
    RETURN null;
END;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION water_name_marine.refresh() RETURNS trigger AS
  $BODY$
  BEGIN
    RAISE LOG 'Refresh water_name_marine rank';
    PERFORM update_osm_marine_point();
    DELETE FROM water_name_marine.updates;
    RETURN null;
  END;
  $BODY$
language plpgsql;

CREATE TRIGGER trigger_flag
    AFTER INSERT OR UPDATE OR DELETE ON osm_marine_point
    FOR EACH STATEMENT
    EXECUTE PROCEDURE water_name_marine.flag();

CREATE CONSTRAINT TRIGGER trigger_refresh
    AFTER INSERT ON water_name_marine.updates
    INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE PROCEDURE water_name_marine.refresh();

-- Layer water_name - ./update_water_lakeline.sql

DROP TRIGGER IF EXISTS trigger_delete_line ON osm_water_polygon;
DROP TRIGGER IF EXISTS trigger_update_line ON osm_water_polygon;
DROP TRIGGER IF EXISTS trigger_insert_line ON osm_water_polygon;

CREATE OR REPLACE VIEW osm_water_lakeline_view AS
	SELECT wp.osm_id,
		ll.wkb_geometry AS geometry,
		name, name_en, name_de,
		update_tags(tags, ll.wkb_geometry) AS tags,
		ST_Area(wp.geometry) AS area,
		is_intermittent
    FROM osm_water_polygon AS wp
    INNER JOIN lake_centerline ll ON wp.osm_id = ll.osm_id
    WHERE wp.name <> '' AND ST_IsValid(wp.geometry)
;

-- etldoc:  osm_water_polygon ->  osm_water_lakeline
-- etldoc:  lake_centerline  ->  osm_water_lakeline
CREATE TABLE IF NOT EXISTS osm_water_lakeline AS
SELECT * FROM osm_water_lakeline_view;
DO $$
    BEGIN
        ALTER TABLE osm_water_lakeline ADD CONSTRAINT osm_water_lakeline_pk PRIMARY KEY (osm_id);
    EXCEPTION WHEN others then
        RAISE NOTICE 'primary key osm_water_lakeline_pk already exists in osm_water_lakeline.';
    END;
$$;
CREATE INDEX IF NOT EXISTS osm_water_lakeline_geometry_idx ON osm_water_lakeline USING gist(geometry);

-- Handle updates

CREATE SCHEMA IF NOT EXISTS water_lakeline;

CREATE OR REPLACE FUNCTION water_lakeline.delete() RETURNS trigger AS $BODY$
BEGIN
    DELETE FROM osm_water_lakeline
    WHERE osm_water_lakeline.osm_id = OLD.osm_id ;

    RETURN null;
END;
$BODY$ language plpgsql;

CREATE OR REPLACE FUNCTION water_lakeline.update() RETURNS trigger AS $BODY$
BEGIN
    UPDATE osm_water_lakeline
    SET (osm_id, geometry, name, name_en, name_de, tags, area, is_intermittent) =
        (SELECT * FROM osm_water_lakeline_view WHERE osm_water_lakeline_view.osm_id = NEW.osm_id)
    WHERE osm_water_lakeline.osm_id = NEW.osm_id;

    RETURN null;
END;
$BODY$ language plpgsql;

CREATE OR REPLACE FUNCTION water_lakeline.insert() RETURNS trigger AS $BODY$
BEGIN
    INSERT INTO osm_water_lakeline
    SELECT *
    FROM osm_water_lakeline_view
    WHERE osm_water_lakeline_view.osm_id = NEW.osm_id;

    RETURN null;
END;
$BODY$ language plpgsql;

CREATE TRIGGER trigger_delete_line
    AFTER DELETE ON osm_water_polygon
    FOR EACH ROW
    EXECUTE PROCEDURE water_lakeline.delete();

CREATE TRIGGER trigger_update_line
    AFTER UPDATE ON osm_water_polygon
    FOR EACH ROW
    EXECUTE PROCEDURE water_lakeline.update();

CREATE TRIGGER trigger_insert_line
    AFTER INSERT ON osm_water_polygon
    FOR EACH ROW
    EXECUTE PROCEDURE water_lakeline.insert();

-- Layer water_name - ./update_water_point.sql

DROP TRIGGER IF EXISTS trigger_delete_point ON osm_water_polygon;
DROP TRIGGER IF EXISTS trigger_update_point ON osm_water_polygon;
DROP TRIGGER IF EXISTS trigger_insert_point ON osm_water_polygon;

CREATE OR REPLACE VIEW osm_water_point_view AS
    SELECT
        wp.osm_id, ST_PointOnSurface(wp.geometry) AS geometry,
        wp.name, wp.name_en, wp.name_de,
        update_tags(wp.tags, ST_PointOnSurface(wp.geometry)) AS tags,
        ST_Area(wp.geometry) AS area,
        wp.is_intermittent
    FROM osm_water_polygon AS wp
    LEFT JOIN lake_centerline ll ON wp.osm_id = ll.osm_id
    WHERE ll.osm_id IS NULL AND wp.name <> ''
;

-- etldoc:  osm_water_polygon ->  osm_water_point
-- etldoc:  lake_centerline ->  osm_water_point
CREATE TABLE IF NOT EXISTS osm_water_point AS
SELECT * FROM osm_water_point_view;
DO $$
    BEGIN
        ALTER TABLE osm_water_point ADD CONSTRAINT osm_water_point_pk PRIMARY KEY (osm_id);
    EXCEPTION WHEN others then
        RAISE NOTICE 'primary key osm_water_point_pk already exists in osm_water_point.';
    END;
$$;
CREATE INDEX IF NOT EXISTS osm_water_point_geometry_idx ON osm_water_point USING gist (geometry);

-- Handle updates

CREATE SCHEMA IF NOT EXISTS water_point;

CREATE OR REPLACE FUNCTION water_point.delete() RETURNS trigger AS $BODY$
BEGIN
    DELETE FROM osm_water_point
    WHERE osm_water_point.osm_id = OLD.osm_id ;

    RETURN null;
END;
$BODY$ language plpgsql;

CREATE OR REPLACE FUNCTION water_point.update() RETURNS trigger AS $BODY$
BEGIN
    UPDATE osm_water_point
    SET (osm_id, geometry, name, name_en, name_de, tags, area, is_intermittent) =
        (SELECT * FROM osm_water_point_view WHERE osm_water_point_view.osm_id = NEW.osm_id)
    WHERE osm_water_point.osm_id = NEW.osm_id;

    RETURN null;
END;
$BODY$ language plpgsql;

CREATE OR REPLACE FUNCTION water_point.insert() RETURNS trigger AS $BODY$
BEGIN
    INSERT INTO osm_water_point
    SELECT *
    FROM osm_water_point_view
    WHERE osm_water_point_view.osm_id = NEW.osm_id;

    RETURN null;
END;
$BODY$ language plpgsql;

CREATE TRIGGER trigger_delete_point
    AFTER DELETE ON osm_water_polygon
    FOR EACH ROW
    EXECUTE PROCEDURE water_point.delete();

CREATE TRIGGER trigger_update_point
    AFTER UPDATE ON osm_water_polygon
    FOR EACH ROW
    EXECUTE PROCEDURE water_point.update();

CREATE TRIGGER trigger_insert_point
    AFTER INSERT ON osm_water_polygon
    FOR EACH ROW
    EXECUTE PROCEDURE water_point.insert();

-- Layer water_name - ./layer.sql


-- etldoc: layer_water_name[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_water_name | <z0_8> z0_8 | <z9_13> z9_13 | <z14_> z14+" ] ;

CREATE OR REPLACE FUNCTION layer_water_name(bbox geometry, zoom_level integer)
RETURNS TABLE(osm_id bigint, geometry geometry, name text, name_en text, name_de text, tags hstore, class text, intermittent int) AS $$
    -- etldoc: osm_water_lakeline ->  layer_water_name:z9_13
    -- etldoc: osm_water_lakeline ->  layer_water_name:z14_
    SELECT
    CASE WHEN osm_id<0 THEN -osm_id*10+4
        ELSE osm_id*10+1
    END AS osm_id_hash,
    geometry, name,
    COALESCE(NULLIF(name_en, ''), name) AS name_en,
    COALESCE(NULLIF(name_de, ''), name, name_en) AS name_de,
    tags,
    'lake'::text AS class,
    is_intermittent::int AS intermittent
    FROM osm_water_lakeline
    WHERE geometry && bbox
      AND ((zoom_level BETWEEN 9 AND 13 AND LineLabel(zoom_level, NULLIF(name, ''), geometry))
        OR (zoom_level >= 14))
    -- etldoc: osm_water_point ->  layer_water_name:z9_13
    -- etldoc: osm_water_point ->  layer_water_name:z14_
    UNION ALL
    SELECT
    CASE WHEN osm_id<0 THEN -osm_id*10+4
        ELSE osm_id*10+1
    END AS osm_id_hash,
    geometry, name,
    COALESCE(NULLIF(name_en, ''), name) AS name_en,
    COALESCE(NULLIF(name_de, ''), name, name_en) AS name_de,
    tags,
    'lake'::text AS class,
    is_intermittent::int AS intermittent
    FROM osm_water_point
    WHERE geometry && bbox AND (
        (zoom_level BETWEEN 9 AND 13 AND area > 70000*2^(20-zoom_level))
        OR (zoom_level >= 14)
    )
    -- etldoc: osm_marine_point ->  layer_water_name:z0_8
    -- etldoc: osm_marine_point ->  layer_water_name:z9_13
    -- etldoc: osm_marine_point ->  layer_water_name:z14_
    UNION ALL
    SELECT osm_id*10, geometry, name,
    COALESCE(NULLIF(name_en, ''), name) AS name_en,
    COALESCE(NULLIF(name_de, ''), name, name_en) AS name_de,
    tags,
    place::text AS class,
    is_intermittent::int AS intermittent
    FROM osm_marine_point
    WHERE geometry && bbox AND (
        place = 'ocean'
        OR (zoom_level >= "rank" AND "rank" IS NOT NULL)
        OR (zoom_level >= 8)
    );
$$
LANGUAGE SQL
IMMUTABLE PARALLEL SAFE;

DO $$ BEGIN RAISE NOTICE 'Finished layer water_name'; END$$;
