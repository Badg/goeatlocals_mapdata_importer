DO $$ BEGIN RAISE NOTICE 'Processing layer water'; END$$;

-- Layer water - ./water.sql

-- This statement can be deleted after the water importer image stops creating this object as a table
DO $$ BEGIN DROP TABLE IF EXISTS osm_ocean_polygon_gen1 CASCADE; EXCEPTION WHEN wrong_object_type THEN END; $$ language 'plpgsql';
-- etldoc: osm_ocean_polygon -> osm_ocean_polygon_gen1
DROP MATERIALIZED VIEW IF EXISTS osm_ocean_polygon_gen1 CASCADE;
CREATE MATERIALIZED VIEW osm_ocean_polygon_gen1 AS (
  SELECT ST_Simplify(geometry, 20) AS geometry
  FROM osm_ocean_polygon
) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_ocean_polygon_gen1_idx ON osm_ocean_polygon_gen1 USING gist (geometry);


-- This statement can be deleted after the water importer image stops creating this object as a table
DO $$ BEGIN DROP TABLE IF EXISTS osm_ocean_polygon_gen2 CASCADE; EXCEPTION WHEN wrong_object_type THEN END; $$ language 'plpgsql';
-- etldoc: osm_ocean_polygon -> osm_ocean_polygon_gen2
DROP MATERIALIZED VIEW IF EXISTS osm_ocean_polygon_gen2 CASCADE;
CREATE MATERIALIZED VIEW osm_ocean_polygon_gen2 AS (
  SELECT ST_Simplify(geometry, 40) AS geometry
  FROM osm_ocean_polygon
) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_ocean_polygon_gen2_idx ON osm_ocean_polygon_gen2 USING gist (geometry);


-- This statement can be deleted after the water importer image stops creating this object as a table
DO $$ BEGIN DROP TABLE IF EXISTS osm_ocean_polygon_gen3 CASCADE; EXCEPTION WHEN wrong_object_type THEN END; $$ language 'plpgsql';
-- etldoc: osm_ocean_polygon -> osm_ocean_polygon_gen3
DROP MATERIALIZED VIEW IF EXISTS osm_ocean_polygon_gen3 CASCADE;
CREATE MATERIALIZED VIEW osm_ocean_polygon_gen3 AS (
  SELECT ST_Simplify(geometry, 80) AS geometry
  FROM osm_ocean_polygon
) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_ocean_polygon_gen3_idx ON osm_ocean_polygon_gen3 USING gist (geometry);


-- This statement can be deleted after the water importer image stops creating this object as a table
DO $$ BEGIN DROP TABLE IF EXISTS osm_ocean_polygon_gen4 CASCADE; EXCEPTION WHEN wrong_object_type THEN END; $$ language 'plpgsql';
-- etldoc: osm_ocean_polygon -> osm_ocean_polygon_gen4
DROP MATERIALIZED VIEW IF EXISTS osm_ocean_polygon_gen4 CASCADE;
CREATE MATERIALIZED VIEW osm_ocean_polygon_gen4 AS (
  SELECT ST_Simplify(geometry, 160) AS geometry
  FROM osm_ocean_polygon
) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_ocean_polygon_gen4_idx ON osm_ocean_polygon_gen4 USING gist (geometry);



CREATE OR REPLACE FUNCTION water_class(waterway TEXT) RETURNS TEXT AS $$
    SELECT CASE
           WHEN "waterway" IN ('', 'lake') THEN 'lake'
           WHEN "waterway" = 'dock' THEN 'dock'
           ELSE 'river'
   END;
$$
LANGUAGE SQL
IMMUTABLE PARALLEL SAFE;


CREATE OR REPLACE FUNCTION waterway_brunnel(is_bridge BOOL, is_tunnel BOOL) RETURNS TEXT AS $$
    SELECT CASE
        WHEN is_bridge THEN 'bridge'
        WHEN is_tunnel THEN 'tunnel'
    END;
$$
LANGUAGE SQL
IMMUTABLE STRICT PARALLEL SAFE;



CREATE OR REPLACE VIEW water_z0 AS (
    -- etldoc:  ne_110m_ocean ->  water_z0
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM ne_110m_ocean
    UNION ALL
    -- etldoc:  ne_110m_lakes ->  water_z0
    SELECT geometry,
        'lake'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM ne_110m_lakes
);

CREATE OR REPLACE VIEW water_z1 AS (
    -- etldoc:  ne_110m_ocean ->  water_z1
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM ne_110m_ocean
    UNION ALL
    -- etldoc:  ne_110m_lakes ->  water_z1
    SELECT geometry,
        'lake'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM ne_110m_lakes
);

CREATE OR REPLACE VIEW water_z2 AS (
    -- etldoc:  ne_50m_ocean ->  water_z2
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM ne_50m_ocean
    UNION ALL
    -- etldoc:  ne_50m_lakes ->  water_z2
    SELECT geometry,
        'lake'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM ne_50m_lakes
);

CREATE OR REPLACE VIEW water_z4 AS (
    -- etldoc:  ne_50m_ocean ->  water_z4
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM ne_50m_ocean
    UNION ALL
    -- etldoc:  ne_10m_lakes ->  water_z4
    SELECT geometry,
        'lake'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM ne_10m_lakes
);

CREATE OR REPLACE VIEW water_z5 AS (
    -- etldoc:  ne_10m_ocean ->  water_z5
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM ne_10m_ocean
    UNION ALL
    -- etldoc:  ne_10m_lakes ->  water_z5
    SELECT geometry,
        'lake'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM ne_10m_lakes
);

CREATE OR REPLACE VIEW water_z6 AS (
    -- etldoc:  osm_ocean_polygon_gen4 ->  water_z6
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM osm_ocean_polygon_gen4
    UNION ALL
   -- etldoc:  osm_water_polygon_gen6 ->  water_z6
    SELECT geometry,
        water_class(waterway) AS class,
        is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM osm_water_polygon_gen6
    WHERE "natural" != 'bay'
);

CREATE OR REPLACE VIEW water_z7 AS (
    -- etldoc:  osm_ocean_polygon_gen4 ->  water_z7
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM osm_ocean_polygon_gen4
    UNION ALL
    -- etldoc:  osm_water_polygon_gen5 ->  water_z7
    SELECT geometry,
        water_class(waterway) AS class,
        is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM osm_water_polygon_gen5
    WHERE "natural" != 'bay'
);

CREATE OR REPLACE VIEW water_z8 AS (
    -- etldoc:  osm_ocean_polygon_gen4 ->  water_z8
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM osm_ocean_polygon_gen4
    UNION ALL
    -- etldoc:  osm_water_polygon_gen4 ->  water_z8
    SELECT geometry,
        water_class(waterway) AS class,
        is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM osm_water_polygon_gen4
    WHERE "natural" != 'bay'
);

CREATE OR REPLACE VIEW water_z9 AS (
    -- etldoc:  osm_ocean_polygon_gen3 ->  water_z9
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM osm_ocean_polygon_gen3
    UNION ALL
    -- etldoc:  osm_water_polygon_gen3 ->  water_z9
    SELECT geometry,
        water_class(waterway) AS class,
        is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM osm_water_polygon_gen3
    WHERE "natural" != 'bay'
);

CREATE OR REPLACE VIEW water_z10 AS (
    -- etldoc:  osm_ocean_polygon_gen2 ->  water_z10
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM osm_ocean_polygon_gen2
    UNION ALL
    -- etldoc:  osm_water_polygon_gen2 ->  water_z10
    SELECT geometry,
        water_class(waterway) AS class,
        is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM osm_water_polygon_gen2
    WHERE "natural" != 'bay'
);

CREATE OR REPLACE VIEW water_z11 AS (
    -- etldoc:  osm_ocean_polygon_gen1 ->  water_z11
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM osm_ocean_polygon_gen1
    UNION ALL
    -- etldoc:  osm_water_polygon_gen1 ->  water_z11
    SELECT geometry,
        water_class(waterway) AS class,
        is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM osm_water_polygon_gen1
    WHERE "natural" != 'bay'
);

CREATE OR REPLACE VIEW water_z12 AS (
    -- etldoc:  osm_ocean_polygon_gen1 ->  water_z12
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM osm_ocean_polygon
    UNION ALL
    -- etldoc:  osm_water_polygon ->  water_z12
    SELECT geometry,
        water_class(waterway) AS class,
        is_intermittent,
        is_bridge,
        is_tunnel
    FROM osm_water_polygon
    WHERE "natural" != 'bay'
);

CREATE OR REPLACE VIEW water_z13 AS (
    -- etldoc:  osm_ocean_polygon ->  water_z13
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM osm_ocean_polygon
    UNION ALL
    -- etldoc:  osm_water_polygon ->  water_z13
    SELECT geometry,
        water_class(waterway) AS class,
        is_intermittent,
        is_bridge,
        is_tunnel
    FROM osm_water_polygon
    WHERE "natural" != 'bay'
);

CREATE OR REPLACE VIEW water_z14 AS (
    -- etldoc:  osm_ocean_polygon ->  water_z14
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM osm_ocean_polygon
    UNION ALL
    -- etldoc:  osm_water_polygon ->  water_z14
    SELECT geometry,
        water_class(waterway) AS class,
        is_intermittent,
        is_bridge,
        is_tunnel
    FROM osm_water_polygon
    WHERE "natural" != 'bay'
);

-- etldoc: layer_water [shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_water |<z0> z0|<z1>z1|<z2>z2|<z3>z3 |<z4> z4|<z5>z5|<z6>z6|<z7>z7| <z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14_> z14+" ] ;

CREATE OR REPLACE FUNCTION layer_water (bbox geometry, zoom_level int)
RETURNS TABLE(geometry geometry, class text, brunnel text, intermittent int) AS $$
    SELECT geometry,
        class::text,
        waterway_brunnel(is_bridge, is_tunnel) AS brunnel,
        is_intermittent::int AS intermittent
    FROM (
        -- etldoc: water_z0 ->  layer_water:z0
        SELECT * FROM water_z0 WHERE zoom_level = 0
        UNION ALL
        -- etldoc: water_z1 ->  layer_water:z1
        SELECT * FROM water_z1 WHERE zoom_level = 1
        UNION ALL
        -- etldoc: water_z2 ->  layer_water:z2
        -- etldoc: water_z2 ->  layer_water:z3
        SELECT * FROM water_z2 WHERE zoom_level BETWEEN 2 AND 3
        UNION ALL
        -- etldoc: water_z4 ->  layer_water:z4
        SELECT * FROM water_z4 WHERE zoom_level = 4
        UNION ALL
        -- etldoc: water_z5 ->  layer_water:z5
        SELECT * FROM water_z5 WHERE zoom_level = 5
        UNION ALL
        -- etldoc: water_z6 ->  layer_water:z6
        SELECT * FROM water_z6 WHERE zoom_level = 6
        UNION ALL
        -- etldoc: water_z7 ->  layer_water:z7
        SELECT * FROM water_z7 WHERE zoom_level = 7
        UNION ALL
        -- etldoc: water_z8 ->  layer_water:z8
        SELECT * FROM water_z8 WHERE zoom_level = 8
        UNION ALL
        -- etldoc: water_z9 ->  layer_water:z9
        SELECT * FROM water_z9 WHERE zoom_level = 9
        UNION ALL
        -- etldoc: water_z10 ->  layer_water:z10
        SELECT * FROM water_z10 WHERE zoom_level = 10
        UNION ALL
        -- etldoc: water_z11 ->  layer_water:z11
        SELECT * FROM water_z11 WHERE zoom_level = 11
        UNION ALL
        -- etldoc: water_z12 ->  layer_water:z12
        SELECT * FROM water_z12 WHERE zoom_level = 12
        UNION ALL
        -- etldoc: water_z13 ->  layer_water:z13
        SELECT * FROM water_z13 WHERE zoom_level = 13
        UNION ALL
        -- etldoc: water_z14 ->  layer_water:z14_
        SELECT * FROM water_z14 WHERE zoom_level >= 14
    ) AS zoom_levels
    WHERE geometry && bbox;
$$
LANGUAGE SQL
IMMUTABLE PARALLEL SAFE;

DO $$ BEGIN RAISE NOTICE 'Finished layer water'; END$$;

DO $$ BEGIN RAISE NOTICE 'Processing layer waterway'; END$$;

-- Layer waterway - ./update_waterway_linestring.sql

DROP TRIGGER IF EXISTS trigger_flag ON osm_waterway_linestring;
DROP TRIGGER IF EXISTS trigger_refresh ON osm_waterway_linestring;

DO $$
BEGIN
  update osm_waterway_linestring
      SET tags = update_tags(tags, geometry);

  update osm_waterway_linestring_gen1
      SET tags = update_tags(tags, geometry);

  update osm_waterway_linestring_gen2
      SET tags = update_tags(tags, geometry);

  update osm_waterway_linestring_gen3
      SET tags = update_tags(tags, geometry);
END $$;


-- Handle updates

CREATE SCHEMA IF NOT EXISTS waterway_linestring;
CREATE OR REPLACE FUNCTION waterway_linestring.refresh() RETURNS trigger AS
  $BODY$
  BEGIN
--     RAISE NOTICE 'Refresh waterway_linestring %', NEW.osm_id;
    NEW.tags = update_tags(NEW.tags, NEW.geometry);
    RETURN NEW;
  END;
  $BODY$
language plpgsql;

CREATE TRIGGER trigger_refresh
    BEFORE INSERT OR UPDATE ON osm_waterway_linestring
    FOR EACH ROW
    EXECUTE PROCEDURE waterway_linestring.refresh();

-- Layer waterway - ./update_important_waterway.sql

DROP TRIGGER IF EXISTS trigger_store ON osm_waterway_linestring;
DROP TRIGGER IF EXISTS trigger_flag ON osm_waterway_linestring;
DROP TRIGGER IF EXISTS trigger_refresh ON waterway_important.updates;

-- We merge the waterways by name like the highways
-- This helps to drop not important rivers (since they do not have a name)
-- and also makes it possible to filter out too short rivers

CREATE INDEX IF NOT EXISTS osm_waterway_linestring_waterway_partial_idx
    ON osm_waterway_linestring(waterway)
    WHERE waterway = 'river';

CREATE INDEX IF NOT EXISTS osm_waterway_linestring_name_partial_idx
    ON osm_waterway_linestring(name)
    WHERE name <> '';

-- etldoc: osm_waterway_linestring ->  osm_important_waterway_linestring
CREATE TABLE IF NOT EXISTS osm_important_waterway_linestring AS
    SELECT
        (ST_Dump(geometry)).geom AS geometry,
        name, name_en, name_de, tags
    FROM (
        SELECT
            ST_LineMerge(ST_Union(geometry)) AS geometry,
            name, name_en, name_de, slice_language_tags(tags) AS tags
        FROM osm_waterway_linestring
        WHERE name <> '' AND waterway = 'river' AND ST_IsValid(geometry)
        GROUP BY name, name_en, name_de, slice_language_tags(tags)
    ) AS waterway_union;
CREATE INDEX IF NOT EXISTS osm_important_waterway_linestring_names ON osm_important_waterway_linestring(name);
CREATE INDEX IF NOT EXISTS osm_important_waterway_linestring_geometry_idx ON osm_important_waterway_linestring USING gist(geometry);

-- etldoc: osm_important_waterway_linestring -> osm_important_waterway_linestring_gen1
CREATE OR REPLACE VIEW osm_important_waterway_linestring_gen1_view AS
    SELECT ST_Simplify(geometry, 60) AS geometry, name, name_en, name_de, tags
    FROM osm_important_waterway_linestring
    WHERE ST_Length(geometry) > 1000
;
CREATE TABLE IF NOT EXISTS osm_important_waterway_linestring_gen1 AS
SELECT * FROM osm_important_waterway_linestring_gen1_view;
CREATE INDEX IF NOT EXISTS osm_important_waterway_linestring_gen1_name_idx ON osm_important_waterway_linestring_gen1(name);
CREATE INDEX IF NOT EXISTS osm_important_waterway_linestring_gen1_geometry_idx ON osm_important_waterway_linestring_gen1 USING gist(geometry);

-- etldoc: osm_important_waterway_linestring_gen1 -> osm_important_waterway_linestring_gen2
CREATE OR REPLACE VIEW osm_important_waterway_linestring_gen2_view AS
    SELECT ST_Simplify(geometry, 100) AS geometry, name, name_en, name_de, tags
    FROM osm_important_waterway_linestring_gen1
    WHERE ST_Length(geometry) > 4000
;
CREATE TABLE IF NOT EXISTS osm_important_waterway_linestring_gen2 AS
SELECT * FROM osm_important_waterway_linestring_gen2_view;
CREATE INDEX IF NOT EXISTS osm_important_waterway_linestring_gen2_name_idx ON osm_important_waterway_linestring_gen2(name);
CREATE INDEX IF NOT EXISTS osm_important_waterway_linestring_gen2_geometry_idx ON osm_important_waterway_linestring_gen2 USING gist(geometry);

-- etldoc: osm_important_waterway_linestring_gen2 -> osm_important_waterway_linestring_gen3
CREATE OR REPLACE VIEW osm_important_waterway_linestring_gen3_view AS
    SELECT ST_Simplify(geometry, 200) AS geometry, name, name_en, name_de, tags
    FROM osm_important_waterway_linestring_gen2
    WHERE ST_Length(geometry) > 8000
;
CREATE TABLE IF NOT EXISTS osm_important_waterway_linestring_gen3 AS
SELECT * FROM osm_important_waterway_linestring_gen3_view;
CREATE INDEX IF NOT EXISTS osm_important_waterway_linestring_gen3_name_idx ON osm_important_waterway_linestring_gen3(name);
CREATE INDEX IF NOT EXISTS osm_important_waterway_linestring_gen3_geometry_idx ON osm_important_waterway_linestring_gen3 USING gist(geometry);

-- Handle updates

CREATE SCHEMA IF NOT EXISTS waterway_important;

CREATE TABLE IF NOT EXISTS waterway_important.changes(
    id serial primary key,
    is_old boolean,
    name character varying,
    name_en character varying,
    name_de character varying,
    tags hstore,
    unique (is_old, name, name_en, name_de, tags)
);
CREATE OR REPLACE FUNCTION waterway_important.store() RETURNS trigger AS $$
BEGIN
    IF (TG_OP IN ('DELETE', 'UPDATE')) AND OLD.name <> '' AND OLD.waterway = 'river' THEN
        INSERT INTO waterway_important.changes(is_old, name, name_en, name_de, tags)
        VALUES (true, OLD.name, OLD.name_en, OLD.name_de, slice_language_tags(OLD.tags))
        ON CONFLICT(is_old, name, name_en, name_de, tags) DO NOTHING;
    END IF;
    IF (TG_OP IN ('UPDATE', 'INSERT')) AND NEW.name <> '' AND NEW.waterway = 'river' THEN
        INSERT INTO waterway_important.changes(is_old, name, name_en, name_de, tags)
        VALUES (false, NEW.name, NEW.name_en, NEW.name_de, slice_language_tags(NEW.tags))
        ON CONFLICT(is_old, name, name_en, name_de, tags) DO NOTHING;
    END IF;
    RETURN NULL;
END;
$$ language plpgsql;

CREATE TABLE IF NOT EXISTS waterway_important.updates(id serial primary key, t text, unique (t));
CREATE OR REPLACE FUNCTION waterway_important.flag() RETURNS trigger AS $$
BEGIN
    INSERT INTO waterway_important.updates(t) VALUES ('y')  ON CONFLICT(t) DO NOTHING;
    RETURN null;
END;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION waterway_important.refresh() RETURNS trigger AS
  $BODY$
  BEGIN
    RAISE LOG 'Refresh waterway';

    -- REFRESH osm_important_waterway_linestring
    DELETE FROM osm_important_waterway_linestring AS w
    USING waterway_important.changes AS c
    WHERE
        c.is_old AND
        w.name = c.name AND w.name_en IS NOT DISTINCT FROM c.name_en AND w.name_de IS NOT DISTINCT FROM c.name_de AND w.tags IS NOT DISTINCT FROM c.tags;

    INSERT INTO osm_important_waterway_linestring
    SELECT
        (ST_Dump(geometry)).geom AS geometry,
        name, name_en, name_de, tags
    FROM (
        SELECT
            ST_LineMerge(ST_Union(geometry)) AS geometry,
            w.name, w.name_en, w.name_de, slice_language_tags(w.tags) AS tags
        FROM osm_waterway_linestring AS w
            JOIN waterway_important.changes AS c ON
                w.name = c.name AND w.name_en IS NOT DISTINCT FROM c.name_en AND w.name_de IS NOT DISTINCT FROM c.name_de AND slice_language_tags(w.tags) IS NOT DISTINCT FROM c.tags
        WHERE w.name <> '' AND w.waterway = 'river' AND ST_IsValid(geometry) AND
            NOT c.is_old
        GROUP BY w.name, w.name_en, w.name_de, slice_language_tags(w.tags)
    ) AS waterway_union;

    -- REFRESH sm_important_waterway_linestring_gen1
    DELETE FROM osm_important_waterway_linestring_gen1 AS w
    USING waterway_important.changes AS c
    WHERE
        c.is_old AND
        w.name = c.name AND w.name_en IS NOT DISTINCT FROM c.name_en AND w.name_de IS NOT DISTINCT FROM c.name_de AND w.tags IS NOT DISTINCT FROM c.tags;

    INSERT INTO osm_important_waterway_linestring_gen1
    SELECT w.*
    FROM osm_important_waterway_linestring_gen1_view AS w
        NATURAL JOIN waterway_important.changes AS c
    WHERE NOT c.is_old;

    -- REFRESH osm_important_waterway_linestring_gen2
    DELETE FROM osm_important_waterway_linestring_gen2 AS w
    USING waterway_important.changes AS c
    WHERE
        c.is_old AND
        w.name = c.name AND w.name_en IS NOT DISTINCT FROM c.name_en AND w.name_de IS NOT DISTINCT FROM c.name_de AND w.tags IS NOT DISTINCT FROM c.tags;

    INSERT INTO osm_important_waterway_linestring_gen2
    SELECT w.*
    FROM osm_important_waterway_linestring_gen2_view AS w
        NATURAL JOIN waterway_important.changes AS c
    WHERE NOT c.is_old;

    -- REFRESH osm_important_waterway_linestring_gen3
    DELETE FROM osm_important_waterway_linestring_gen3 AS w
    USING waterway_important.changes AS c
    WHERE
        c.is_old AND
        w.name = c.name AND w.name_en IS NOT DISTINCT FROM c.name_en AND w.name_de IS NOT DISTINCT FROM c.name_de AND w.tags IS NOT DISTINCT FROM c.tags;

    INSERT INTO osm_important_waterway_linestring_gen3
    SELECT w.*
    FROM osm_important_waterway_linestring_gen3_view AS w
        NATURAL JOIN waterway_important.changes AS c
    WHERE NOT c.is_old;

    DELETE FROM waterway_important.changes;
    DELETE FROM waterway_important.updates;
    RETURN null;
  END;
  $BODY$
language plpgsql;

CREATE TRIGGER trigger_store
    AFTER INSERT OR UPDATE OR DELETE ON osm_waterway_linestring
    FOR EACH ROW
    EXECUTE PROCEDURE waterway_important.store();

CREATE TRIGGER trigger_flag
    AFTER INSERT OR UPDATE OR DELETE ON osm_waterway_linestring
    FOR EACH STATEMENT
    EXECUTE PROCEDURE waterway_important.flag();

CREATE CONSTRAINT TRIGGER trigger_refresh
    AFTER INSERT ON waterway_important.updates
    INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE PROCEDURE waterway_important.refresh();

-- Layer waterway - ./waterway.sql

CREATE OR REPLACE FUNCTION waterway_brunnel(is_bridge BOOL, is_tunnel BOOL) RETURNS TEXT AS $$
    SELECT CASE
        WHEN is_bridge THEN 'bridge'
        WHEN is_tunnel THEN 'tunnel'
    END;
$$
LANGUAGE SQL
IMMUTABLE STRICT PARALLEL SAFE;

-- etldoc: ne_110m_rivers_lake_centerlines ->  waterway_z3
CREATE OR REPLACE VIEW waterway_z3 AS (
    SELECT geometry, 'river'::text AS class, NULL::text AS name, NULL::text AS name_en, NULL::text AS name_de, NULL::hstore AS tags, NULL::boolean AS is_bridge, NULL::boolean AS is_tunnel, NULL::boolean AS is_intermittent
    FROM ne_110m_rivers_lake_centerlines
    WHERE featurecla = 'River'
);

-- etldoc: ne_50m_rivers_lake_centerlines ->  waterway_z4
CREATE OR REPLACE VIEW waterway_z4 AS (
    SELECT geometry, 'river'::text AS class, NULL::text AS name, NULL::text AS name_en, NULL::text AS name_de, NULL::hstore AS tags, NULL::boolean AS is_bridge, NULL::boolean AS is_tunnel, NULL::boolean AS is_intermittent
    FROM ne_50m_rivers_lake_centerlines
    WHERE featurecla = 'River'
);

-- etldoc: ne_10m_rivers_lake_centerlines ->  waterway_z6
CREATE OR REPLACE VIEW waterway_z6 AS (
    SELECT geometry, 'river'::text AS class, NULL::text AS name, NULL::text AS name_en, NULL::text AS name_de, NULL::hstore AS tags, NULL::boolean AS is_bridge, NULL::boolean AS is_tunnel, NULL::boolean AS is_intermittent
    FROM ne_10m_rivers_lake_centerlines
    WHERE featurecla = 'River'
);

-- etldoc: osm_important_waterway_linestring_gen3 ->  waterway_z9
CREATE OR REPLACE VIEW waterway_z9 AS (
    SELECT geometry, 'river'::text AS class, name, name_en, name_de, tags, NULL::boolean AS is_bridge, NULL::boolean AS is_tunnel, NULL::boolean AS is_intermittent
    FROM osm_important_waterway_linestring_gen3
);

-- etldoc: osm_important_waterway_linestring_gen2 ->  waterway_z10
CREATE OR REPLACE VIEW waterway_z10 AS (
    SELECT geometry, 'river'::text AS class, name, name_en, name_de, tags, NULL::boolean AS is_bridge, NULL::boolean AS is_tunnel, NULL::boolean AS is_intermittent
    FROM osm_important_waterway_linestring_gen2
);

-- etldoc:osm_important_waterway_linestring_gen1 ->  waterway_z11
CREATE OR REPLACE VIEW waterway_z11 AS (
    SELECT geometry, 'river'::text AS class, name, name_en, name_de, tags, NULL::boolean AS is_bridge, NULL::boolean AS is_tunnel, NULL::boolean AS is_intermittent
    FROM osm_important_waterway_linestring_gen1
);

-- etldoc: osm_waterway_linestring ->  waterway_z12
CREATE OR REPLACE VIEW waterway_z12 AS (
    SELECT geometry, waterway::text AS class, name, name_en, name_de, tags, is_bridge, is_tunnel, is_intermittent
    FROM osm_waterway_linestring
    WHERE waterway IN ('river', 'canal')
);

-- etldoc: osm_waterway_linestring ->  waterway_z13
CREATE OR REPLACE VIEW waterway_z13 AS (
    SELECT geometry, waterway::text AS class, name, name_en, name_de, tags, is_bridge, is_tunnel, is_intermittent
    FROM osm_waterway_linestring
    WHERE waterway IN ('river', 'canal', 'stream', 'drain', 'ditch')
);

-- etldoc: osm_waterway_linestring ->  waterway_z14
CREATE OR REPLACE VIEW waterway_z14 AS (
    SELECT geometry, waterway::text AS class, name, name_en, name_de, tags, is_bridge, is_tunnel, is_intermittent
    FROM osm_waterway_linestring
);

-- etldoc: layer_waterway[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_waterway | <z3> z3 |<z4_5> z4-z5 |<z6_8> z6-8 | <z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14> z14+" ];

CREATE OR REPLACE FUNCTION layer_waterway(bbox geometry, zoom_level int)
RETURNS TABLE(geometry geometry, class text, name text, name_en text, name_de text, brunnel text, intermittent int, tags hstore) AS $$
    SELECT geometry, class,
        NULLIF(name, '') AS name,
        COALESCE(NULLIF(name_en, ''), name) AS name_en,
        COALESCE(NULLIF(name_de, ''), name, name_en) AS name_de,
        waterway_brunnel(is_bridge, is_tunnel) AS brunnel,
        is_intermittent::int AS intermittent,
        tags
    FROM (
        -- etldoc: waterway_z3 ->  layer_waterway:z3
        SELECT * FROM waterway_z3 WHERE zoom_level = 3
        UNION ALL
        -- etldoc: waterway_z4 ->  layer_waterway:z4_5
        SELECT * FROM waterway_z4 WHERE zoom_level BETWEEN 4 AND 5
        UNION ALL
        -- etldoc: waterway_z6 ->  layer_waterway:z6_8
        SELECT * FROM waterway_z6 WHERE zoom_level BETWEEN 6 AND 8
        UNION ALL
        -- etldoc: waterway_z9 ->  layer_waterway:z9
        SELECT * FROM waterway_z9 WHERE zoom_level = 9
        UNION ALL
        -- etldoc: waterway_z10 ->  layer_waterway:z10
        SELECT * FROM waterway_z10 WHERE zoom_level = 10
        UNION ALL
        -- etldoc: waterway_z11 ->  layer_waterway:z11
        SELECT * FROM waterway_z11 WHERE zoom_level = 11
        UNION ALL
        -- etldoc: waterway_z12 ->  layer_waterway:z12
        SELECT * FROM waterway_z12 WHERE zoom_level = 12
        UNION ALL
        -- etldoc: waterway_z13 ->  layer_waterway:z13
        SELECT * FROM waterway_z13 WHERE zoom_level = 13
        UNION ALL
        -- etldoc: waterway_z14 ->  layer_waterway:z14
        SELECT * FROM waterway_z14 WHERE zoom_level >= 14
    ) AS zoom_levels
    WHERE geometry && bbox;
$$
LANGUAGE SQL
IMMUTABLE PARALLEL SAFE;

DO $$ BEGIN RAISE NOTICE 'Finished layer waterway'; END$$;
