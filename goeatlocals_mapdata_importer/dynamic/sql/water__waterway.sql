DO $$ BEGIN RAISE NOTICE 'Processing layer water'; END$$;

-- Layer water - ./water.sql

-- This statement can be deleted after the water importer image stops creating this object as a table
DO $$ BEGIN DROP TABLE IF EXISTS __use_schema__.osm_ocean_polygon_gen1 CASCADE; EXCEPTION WHEN wrong_object_type THEN END; $$ language 'plpgsql';
-- etldoc: osm_ocean_polygon -> osm_ocean_polygon_gen1
DROP MATERIALIZED VIEW IF EXISTS __use_schema__.osm_ocean_polygon_gen1 CASCADE;
CREATE MATERIALIZED VIEW __use_schema__.osm_ocean_polygon_gen1 AS (
  SELECT ST_Simplify(geometry, 20) AS geometry
  FROM __prod_schema__.osm_ocean_polygon
) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_ocean_polygon_gen1_idx ON __use_schema__.osm_ocean_polygon_gen1 USING gist (geometry);


-- This statement can be deleted after the water importer image stops creating this object as a table
DO $$ BEGIN DROP TABLE IF EXISTS __use_schema__.osm_ocean_polygon_gen2 CASCADE; EXCEPTION WHEN wrong_object_type THEN END; $$ language 'plpgsql';
-- etldoc: osm_ocean_polygon -> osm_ocean_polygon_gen2
DROP MATERIALIZED VIEW IF EXISTS __use_schema__.osm_ocean_polygon_gen2 CASCADE;
CREATE MATERIALIZED VIEW __use_schema__.osm_ocean_polygon_gen2 AS (
  SELECT ST_Simplify(geometry, 40) AS geometry
  FROM __prod_schema__.osm_ocean_polygon
) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_ocean_polygon_gen2_idx ON __use_schema__.osm_ocean_polygon_gen2 USING gist (geometry);


-- This statement can be deleted after the water importer image stops creating this object as a table
DO $$ BEGIN DROP TABLE IF EXISTS __use_schema__.osm_ocean_polygon_gen3 CASCADE; EXCEPTION WHEN wrong_object_type THEN END; $$ language 'plpgsql';
-- etldoc: osm_ocean_polygon -> osm_ocean_polygon_gen3
DROP MATERIALIZED VIEW IF EXISTS __use_schema__.osm_ocean_polygon_gen3 CASCADE;
CREATE MATERIALIZED VIEW __use_schema__.osm_ocean_polygon_gen3 AS (
  SELECT ST_Simplify(geometry, 80) AS geometry
  FROM __prod_schema__.osm_ocean_polygon
) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_ocean_polygon_gen3_idx ON __use_schema__.osm_ocean_polygon_gen3 USING gist (geometry);


-- This statement can be deleted after the water importer image stops creating this object as a table
DO $$ BEGIN DROP TABLE IF EXISTS __use_schema__.osm_ocean_polygon_gen4 CASCADE; EXCEPTION WHEN wrong_object_type THEN END; $$ language 'plpgsql';
-- etldoc: osm_ocean_polygon -> osm_ocean_polygon_gen4
DROP MATERIALIZED VIEW IF EXISTS __use_schema__.osm_ocean_polygon_gen4 CASCADE;
CREATE MATERIALIZED VIEW __use_schema__.osm_ocean_polygon_gen4 AS (
  SELECT ST_Simplify(geometry, 160) AS geometry
  FROM __prod_schema__.osm_ocean_polygon
) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_ocean_polygon_gen4_idx ON __use_schema__.osm_ocean_polygon_gen4 USING gist (geometry);


CREATE OR REPLACE VIEW __use_schema__.water_z0 AS (
    -- etldoc:  ne_110m_ocean ->  water_z0
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM mapdata_prod.ne_110m_ocean
    UNION ALL
    -- etldoc:  ne_110m_lakes ->  water_z0
    SELECT geometry,
        'lake'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM mapdata_prod.ne_110m_lakes
);

CREATE OR REPLACE VIEW __use_schema__.water_z1 AS (
    -- etldoc:  ne_110m_ocean ->  water_z1
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM mapdata_prod.ne_110m_ocean
    UNION ALL
    -- etldoc:  ne_110m_lakes ->  water_z1
    SELECT geometry,
        'lake'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM mapdata_prod.ne_110m_lakes
);

CREATE OR REPLACE VIEW __use_schema__.water_z2 AS (
    -- etldoc:  ne_50m_ocean ->  water_z2
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM mapdata_prod.ne_50m_ocean
    UNION ALL
    -- etldoc:  ne_50m_lakes ->  water_z2
    SELECT geometry,
        'lake'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM mapdata_prod.ne_50m_lakes
);

CREATE OR REPLACE VIEW __use_schema__.water_z4 AS (
    -- etldoc:  ne_50m_ocean ->  water_z4
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM mapdata_prod.ne_50m_ocean
    UNION ALL
    -- etldoc:  ne_10m_lakes ->  water_z4
    SELECT geometry,
        'lake'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM mapdata_prod.ne_10m_lakes
);

CREATE OR REPLACE VIEW __use_schema__.water_z5 AS (
    -- etldoc:  ne_10m_ocean ->  water_z5
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM mapdata_prod.ne_10m_ocean
    UNION ALL
    -- etldoc:  ne_10m_lakes ->  water_z5
    SELECT geometry,
        'lake'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM mapdata_prod.ne_10m_lakes
);

CREATE OR REPLACE VIEW __use_schema__.water_z6 AS (
    -- etldoc:  osm_ocean_polygon_gen4 ->  water_z6
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM __use_schema__.osm_ocean_polygon_gen4
    UNION ALL
   -- etldoc:  osm_water_polygon_gen6 ->  water_z6
    SELECT geometry,
        water_class(waterway) AS class,
        is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM __use_schema__.osm_water_polygon_gen6
    WHERE "natural" != 'bay'
);

CREATE OR REPLACE VIEW __use_schema__.water_z7 AS (
    -- etldoc:  osm_ocean_polygon_gen4 ->  water_z7
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM __use_schema__.osm_ocean_polygon_gen4
    UNION ALL
    -- etldoc:  osm_water_polygon_gen5 ->  water_z7
    SELECT geometry,
        water_class(waterway) AS class,
        is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM __use_schema__.osm_water_polygon_gen5
    WHERE "natural" != 'bay'
);

CREATE OR REPLACE VIEW __use_schema__.water_z8 AS (
    -- etldoc:  osm_ocean_polygon_gen4 ->  water_z8
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM __use_schema__.osm_ocean_polygon_gen4
    UNION ALL
    -- etldoc:  osm_water_polygon_gen4 ->  water_z8
    SELECT geometry,
        water_class(waterway) AS class,
        is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM __use_schema__.osm_water_polygon_gen4
    WHERE "natural" != 'bay'
);

CREATE OR REPLACE VIEW __use_schema__.water_z9 AS (
    -- etldoc:  osm_ocean_polygon_gen3 ->  water_z9
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM __use_schema__.osm_ocean_polygon_gen3
    UNION ALL
    -- etldoc:  osm_water_polygon_gen3 ->  water_z9
    SELECT geometry,
        water_class(waterway) AS class,
        is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM __use_schema__.osm_water_polygon_gen3
    WHERE "natural" != 'bay'
);

CREATE OR REPLACE VIEW __use_schema__.water_z10 AS (
    -- etldoc:  osm_ocean_polygon_gen2 ->  water_z10
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM __use_schema__.osm_ocean_polygon_gen2
    UNION ALL
    -- etldoc:  osm_water_polygon_gen2 ->  water_z10
    SELECT geometry,
        water_class(waterway) AS class,
        is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM __use_schema__.osm_water_polygon_gen2
    WHERE "natural" != 'bay'
);

CREATE OR REPLACE VIEW __use_schema__.water_z11 AS (
    -- etldoc:  osm_ocean_polygon_gen1 ->  water_z11
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM __use_schema__.osm_ocean_polygon_gen1
    UNION ALL
    -- etldoc:  osm_water_polygon_gen1 ->  water_z11
    SELECT geometry,
        water_class(waterway) AS class,
        is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM __use_schema__.osm_water_polygon_gen1
    WHERE "natural" != 'bay'
);

CREATE OR REPLACE VIEW __use_schema__.water_z12 AS (
    -- etldoc:  osm_ocean_polygon_gen1 ->  water_z12
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM __prod_schema__.osm_ocean_polygon
    UNION ALL
    -- etldoc:  osm_water_polygon ->  water_z12
    SELECT geometry,
        water_class(waterway) AS class,
        is_intermittent,
        is_bridge,
        is_tunnel
    FROM __use_schema__.osm_water_polygon
    WHERE "natural" != 'bay'
);

CREATE OR REPLACE VIEW __use_schema__.water_z13 AS (
    -- etldoc:  osm_ocean_polygon ->  water_z13
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM __prod_schema__.osm_ocean_polygon
    UNION ALL
    -- etldoc:  osm_water_polygon ->  water_z13
    SELECT geometry,
        water_class(waterway) AS class,
        is_intermittent,
        is_bridge,
        is_tunnel
    FROM __use_schema__.osm_water_polygon
    WHERE "natural" != 'bay'
);

CREATE OR REPLACE VIEW __use_schema__.water_z14 AS (
    -- etldoc:  osm_ocean_polygon ->  water_z14
    SELECT geometry,
        'ocean'::text AS class,
        NULL::boolean AS is_intermittent,
        NULL::boolean AS is_bridge,
        NULL::boolean AS is_tunnel
    FROM __prod_schema__.osm_ocean_polygon
    UNION ALL
    -- etldoc:  osm_water_polygon ->  water_z14
    SELECT geometry,
        water_class(waterway) AS class,
        is_intermittent,
        is_bridge,
        is_tunnel
    FROM __use_schema__.osm_water_polygon
    WHERE "natural" != 'bay'
);

DO $$ BEGIN RAISE NOTICE 'Finished layer water'; END$$;


DO $$ BEGIN RAISE NOTICE 'Processing layer waterway'; END$$;

-- Layer waterway - ./update_waterway_linestring.sql

DO $$
BEGIN
  update __use_schema__.osm_waterway_linestring
      SET tags = update_tags(tags, geometry);

  update __use_schema__.osm_waterway_linestring_gen1
      SET tags = update_tags(tags, geometry);

  update __use_schema__.osm_waterway_linestring_gen2
      SET tags = update_tags(tags, geometry);

  update __use_schema__.osm_waterway_linestring_gen3
      SET tags = update_tags(tags, geometry);
END $$;


-- Layer waterway - ./update_important_waterway.sql

-- We merge the waterways by name like the highways
-- This helps to drop not important rivers (since they do not have a name)
-- and also makes it possible to filter out too short rivers

CREATE INDEX IF NOT EXISTS osm_waterway_linestring_waterway_partial_idx
    ON __use_schema__.osm_waterway_linestring(waterway)
    WHERE waterway = 'river';

CREATE INDEX IF NOT EXISTS osm_waterway_linestring_name_partial_idx
    ON __use_schema__.osm_waterway_linestring(name)
    WHERE name <> '';

-- etldoc: osm_waterway_linestring ->  osm_important_waterway_linestring
CREATE TABLE IF NOT EXISTS __use_schema__.osm_important_waterway_linestring AS
    SELECT
        (ST_Dump(geometry)).geom AS geometry,
        name, name_en, name_de, tags
    FROM (
        SELECT
            ST_LineMerge(ST_Union(geometry)) AS geometry,
            name, name_en, name_de, slice_language_tags(tags) AS tags
        FROM __use_schema__.osm_waterway_linestring
        WHERE name <> '' AND waterway = 'river' AND ST_IsValid(geometry)
        GROUP BY name, name_en, name_de, slice_language_tags(tags)
    ) AS waterway_union;
CREATE INDEX IF NOT EXISTS osm_important_waterway_linestring_names ON __use_schema__.osm_important_waterway_linestring(name);
CREATE INDEX IF NOT EXISTS osm_important_waterway_linestring_geometry_idx ON __use_schema__.osm_important_waterway_linestring USING gist(geometry);

-- etldoc: osm_important_waterway_linestring -> osm_important_waterway_linestring_gen1
CREATE OR REPLACE VIEW __use_schema__.osm_important_waterway_linestring_gen1_view AS
    SELECT ST_Simplify(geometry, 60) AS geometry, name, name_en, name_de, tags
    FROM __use_schema__.osm_important_waterway_linestring
    WHERE ST_Length(geometry) > 1000
;
CREATE TABLE IF NOT EXISTS __use_schema__.osm_important_waterway_linestring_gen1 AS
    SELECT * FROM __use_schema__.osm_important_waterway_linestring_gen1_view;
    CREATE INDEX IF NOT EXISTS osm_important_waterway_linestring_gen1_name_idx ON __use_schema__.osm_important_waterway_linestring_gen1(name);
    CREATE INDEX IF NOT EXISTS osm_important_waterway_linestring_gen1_geometry_idx ON __use_schema__.osm_important_waterway_linestring_gen1 USING gist(geometry);

-- etldoc: osm_important_waterway_linestring_gen1 -> osm_important_waterway_linestring_gen2
CREATE OR REPLACE VIEW __use_schema__.osm_important_waterway_linestring_gen2_view AS
    SELECT ST_Simplify(geometry, 100) AS geometry, name, name_en, name_de, tags
    FROM __use_schema__.osm_important_waterway_linestring_gen1
    WHERE ST_Length(geometry) > 4000
;
CREATE TABLE IF NOT EXISTS __use_schema__.osm_important_waterway_linestring_gen2 AS
    SELECT * FROM __use_schema__.osm_important_waterway_linestring_gen2_view;
    CREATE INDEX IF NOT EXISTS osm_important_waterway_linestring_gen2_name_idx ON __use_schema__.osm_important_waterway_linestring_gen2(name);
    CREATE INDEX IF NOT EXISTS osm_important_waterway_linestring_gen2_geometry_idx ON __use_schema__.osm_important_waterway_linestring_gen2 USING gist(geometry);

-- etldoc: osm_important_waterway_linestring_gen2 -> osm_important_waterway_linestring_gen3
CREATE OR REPLACE VIEW __use_schema__.osm_important_waterway_linestring_gen3_view AS
    SELECT ST_Simplify(geometry, 200) AS geometry, name, name_en, name_de, tags
    FROM __use_schema__.osm_important_waterway_linestring_gen2
    WHERE ST_Length(geometry) > 8000
;
CREATE TABLE IF NOT EXISTS __use_schema__.osm_important_waterway_linestring_gen3 AS
    SELECT * FROM __use_schema__.osm_important_waterway_linestring_gen3_view;
    CREATE INDEX IF NOT EXISTS osm_important_waterway_linestring_gen3_name_idx ON __use_schema__.osm_important_waterway_linestring_gen3(name);
    CREATE INDEX IF NOT EXISTS osm_important_waterway_linestring_gen3_geometry_idx ON __use_schema__.osm_important_waterway_linestring_gen3 USING gist(geometry);


-- Layer waterway - ./waterway.sql

-- etldoc: ne_110m_rivers_lake_centerlines ->  waterway_z3
CREATE OR REPLACE VIEW __use_schema__.waterway_z3 AS (
    SELECT geometry, 'river'::text AS class, NULL::text AS name, NULL::text AS name_en, NULL::text AS name_de, NULL::hstore AS tags, NULL::boolean AS is_bridge, NULL::boolean AS is_tunnel, NULL::boolean AS is_intermittent
    FROM mapdata_prod.ne_110m_rivers_lake_centerlines
    WHERE featurecla = 'River'
);

-- etldoc: ne_50m_rivers_lake_centerlines ->  waterway_z4
CREATE OR REPLACE VIEW __use_schema__.waterway_z4 AS (
    SELECT geometry, 'river'::text AS class, NULL::text AS name, NULL::text AS name_en, NULL::text AS name_de, NULL::hstore AS tags, NULL::boolean AS is_bridge, NULL::boolean AS is_tunnel, NULL::boolean AS is_intermittent
    FROM mapdata_prod.ne_50m_rivers_lake_centerlines
    WHERE featurecla = 'River'
);

-- etldoc: ne_10m_rivers_lake_centerlines ->  waterway_z6
CREATE OR REPLACE VIEW __use_schema__.waterway_z6 AS (
    SELECT geometry, 'river'::text AS class, NULL::text AS name, NULL::text AS name_en, NULL::text AS name_de, NULL::hstore AS tags, NULL::boolean AS is_bridge, NULL::boolean AS is_tunnel, NULL::boolean AS is_intermittent
    FROM mapdata_prod.ne_10m_rivers_lake_centerlines
    WHERE featurecla = 'River'
);

-- etldoc: osm_important_waterway_linestring_gen3 ->  waterway_z9
CREATE OR REPLACE VIEW __use_schema__.waterway_z9 AS (
    SELECT geometry, 'river'::text AS class, name, name_en, name_de, tags, NULL::boolean AS is_bridge, NULL::boolean AS is_tunnel, NULL::boolean AS is_intermittent
    FROM __use_schema__.osm_important_waterway_linestring_gen3
);

-- etldoc: osm_important_waterway_linestring_gen2 ->  waterway_z10
CREATE OR REPLACE VIEW __use_schema__.waterway_z10 AS (
    SELECT geometry, 'river'::text AS class, name, name_en, name_de, tags, NULL::boolean AS is_bridge, NULL::boolean AS is_tunnel, NULL::boolean AS is_intermittent
    FROM __use_schema__.osm_important_waterway_linestring_gen2
);

-- etldoc:osm_important_waterway_linestring_gen1 ->  waterway_z11
CREATE OR REPLACE VIEW __use_schema__.waterway_z11 AS (
    SELECT geometry, 'river'::text AS class, name, name_en, name_de, tags, NULL::boolean AS is_bridge, NULL::boolean AS is_tunnel, NULL::boolean AS is_intermittent
    FROM __use_schema__.osm_important_waterway_linestring_gen1
);

-- etldoc: osm_waterway_linestring ->  waterway_z12
CREATE OR REPLACE VIEW __use_schema__.waterway_z12 AS (
    SELECT geometry, waterway::text AS class, name, name_en, name_de, tags, is_bridge, is_tunnel, is_intermittent
    FROM __use_schema__.osm_waterway_linestring
    WHERE waterway IN ('river', 'canal')
);

-- etldoc: osm_waterway_linestring ->  waterway_z13
CREATE OR REPLACE VIEW __use_schema__.waterway_z13 AS (
    SELECT geometry, waterway::text AS class, name, name_en, name_de, tags, is_bridge, is_tunnel, is_intermittent
    FROM __use_schema__.osm_waterway_linestring
    WHERE waterway IN ('river', 'canal', 'stream', 'drain', 'ditch')
);

-- etldoc: osm_waterway_linestring ->  waterway_z14
CREATE OR REPLACE VIEW __use_schema__.waterway_z14 AS (
    SELECT geometry, waterway::text AS class, name, name_en, name_de, tags, is_bridge, is_tunnel, is_intermittent
    FROM __use_schema__.osm_waterway_linestring
);


DO $$ BEGIN RAISE NOTICE 'Finished layer waterway'; END$$;
