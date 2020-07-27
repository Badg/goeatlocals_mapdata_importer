DO $$ BEGIN RAISE NOTICE 'Processing layer water_name'; END$$;


BEGIN;
  -- etldoc: osm_marine_point          -> osm_marine_point
  UPDATE __use_schema__.osm_marine_point AS osm SET "rank" = NULL WHERE "rank" IS NOT NULL;

  -- etldoc: ne_10m_geography_marine_polys -> osm_marine_point
  -- etldoc: osm_marine_point              -> osm_marine_point

  WITH important_marine_point AS (
      SELECT osm.geometry, osm.osm_id, osm.name, osm.name_en, ne.scalerank, osm.is_intermittent
      FROM mapdata_prod.ne_10m_geography_marine_polys AS ne, __use_schema__.osm_marine_point AS osm
      WHERE trim(regexp_replace(ne.name, '\\s+', ' ', 'g')) ILIKE osm.name
        OR trim(regexp_replace(ne.name, '\\s+', ' ', 'g')) ILIKE osm.tags->'name:en'
        OR trim(regexp_replace(ne.name, '\\s+', ' ', 'g')) ILIKE osm.tags->'name:es'
        OR osm.name ILIKE trim(regexp_replace(ne.name, '\\s+', ' ', 'g')) || ' %'
  )
  UPDATE __use_schema__.osm_marine_point AS osm
  SET "rank" = scalerank
  FROM important_marine_point AS ne
  WHERE osm.osm_id = ne.osm_id;

  UPDATE __use_schema__.osm_marine_point
  SET tags = update_tags(tags, geometry)
  WHERE COALESCE(tags->'name:latin', tags->'name:nonlatin', tags->'name_int') IS NULL;

END;


CREATE INDEX IF NOT EXISTS osm_marine_point_rank_idx ON __use_schema__.osm_marine_point("rank");


CREATE OR REPLACE VIEW __use_schema__.osm_water_lakeline_view AS
	SELECT wp.osm_id,
		ll.wkb_geometry AS geometry,
		name, name_en, name_de,
		update_tags(tags, ll.wkb_geometry) AS tags,
		ST_Area(wp.geometry) AS area,
		is_intermittent
    FROM __use_schema__.osm_water_polygon AS wp
    INNER JOIN __prod_schema__.lake_centerline ll ON wp.osm_id = ll.osm_id
    WHERE wp.name <> '' AND ST_IsValid(wp.geometry)
;

-- etldoc:  osm_water_polygon ->  osm_water_lakeline
-- etldoc:  lake_centerline  ->  osm_water_lakeline
CREATE TABLE IF NOT EXISTS __use_schema__.osm_water_lakeline AS
SELECT * FROM __use_schema__.osm_water_lakeline_view;
DO $$
    BEGIN
        ALTER TABLE __use_schema__.osm_water_lakeline
        ADD CONSTRAINT osm_water_lakeline_pk PRIMARY KEY (osm_id);
    EXCEPTION WHEN others then
        RAISE NOTICE 'primary key osm_water_lakeline_pk already exists in osm_water_lakeline.';
    END;
$$;
CREATE INDEX IF NOT EXISTS osm_water_lakeline_geometry_idx ON __use_schema__.osm_water_lakeline USING gist(geometry);

-- Handle updates

CREATE OR REPLACE VIEW __use_schema__.osm_water_point_view AS
    SELECT
        wp.osm_id, ST_PointOnSurface(wp.geometry) AS geometry,
        wp.name, wp.name_en, wp.name_de,
        update_tags(wp.tags, ST_PointOnSurface(wp.geometry)) AS tags,
        ST_Area(wp.geometry) AS area,
        wp.is_intermittent
    FROM __use_schema__.osm_water_polygon AS wp
    LEFT JOIN __prod_schema__.lake_centerline ll ON wp.osm_id = ll.osm_id
    WHERE ll.osm_id IS NULL AND wp.name <> ''
;

-- etldoc:  osm_water_polygon ->  osm_water_point
-- etldoc:  lake_centerline ->  osm_water_point
CREATE TABLE IF NOT EXISTS __use_schema__.osm_water_point AS
SELECT * FROM __use_schema__.osm_water_point_view;
DO $$
    BEGIN
        ALTER TABLE __use_schema__.osm_water_point
        ADD CONSTRAINT osm_water_point_pk PRIMARY KEY (osm_id);
    EXCEPTION WHEN others then
        RAISE NOTICE 'primary key osm_water_point_pk already exists in osm_water_point.';
    END;
$$;
CREATE INDEX IF NOT EXISTS osm_water_point_geometry_idx ON __use_schema__.osm_water_point USING gist (geometry);


DO $$ BEGIN RAISE NOTICE 'Finished layer water_name'; END$$;
