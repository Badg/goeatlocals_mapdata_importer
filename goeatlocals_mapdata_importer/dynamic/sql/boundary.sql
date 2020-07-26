DO $$ BEGIN RAISE NOTICE 'Processing layer boundary'; END$$;

-- Layer boundary - ./boundary.sql

-- This statement can be deleted after the border importer image stops creating this object as a table
DO $$ BEGIN DROP TABLE IF EXISTS :use_schema.osm_border_linestring_gen1 CASCADE; EXCEPTION WHEN wrong_object_type THEN END; $$ language 'plpgsql';
-- etldoc: osm_border_linestring -> :use_schema.osm_border_linestring_gen1
DROP MATERIALIZED VIEW IF EXISTS :use_schema.osm_border_linestring_gen1 CASCADE;
CREATE MATERIALIZED VIEW :use_schema.osm_border_linestring_gen1 AS (
  SELECT ST_Simplify(geometry, 10) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime
  FROM :use_schema.osm_border_linestring
  WHERE admin_level <= 10
) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_border_linestring_gen1_idx ON :use_schema.osm_border_linestring_gen1 USING gist (geometry);

-- This statement can be deleted after the border importer image stops creating this object as a table
DO $$ BEGIN DROP TABLE IF EXISTS :use_schema.osm_border_linestring_gen2 CASCADE; EXCEPTION WHEN wrong_object_type THEN END; $$ language 'plpgsql';
-- etldoc: osm_border_linestring -> :use_schema.osm_border_linestring_gen2
DROP MATERIALIZED VIEW IF EXISTS :use_schema.osm_border_linestring_gen2 CASCADE;
CREATE MATERIALIZED VIEW :use_schema.osm_border_linestring_gen2 AS (
  SELECT ST_Simplify(geometry, 20) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime
  FROM osm_border_linestring
  WHERE admin_level <= 10
) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_border_linestring_gen2_idx ON :use_schema.osm_border_linestring_gen2 USING gist (geometry);

-- This statement can be deleted after the border importer image stops creating this object as a table
DO $$ BEGIN DROP TABLE IF EXISTS :use_schema.osm_border_linestring_gen3 CASCADE; EXCEPTION WHEN wrong_object_type THEN END; $$ language 'plpgsql';
-- etldoc: osm_border_linestring -> :use_schema.osm_border_linestring_gen3
DROP MATERIALIZED VIEW IF EXISTS :use_schema.osm_border_linestring_gen3 CASCADE;
CREATE MATERIALIZED VIEW :use_schema.osm_border_linestring_gen3 AS (
  SELECT ST_Simplify(geometry, 40) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime
  FROM osm_border_linestring
  WHERE admin_level <= 8
) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_border_linestring_gen3_idx ON :use_schema.osm_border_linestring_gen3 USING gist (geometry);

-- This statement can be deleted after the border importer image stops creating this object as a table
DO $$ BEGIN DROP TABLE IF EXISTS :use_schema.osm_border_linestring_gen4 CASCADE; EXCEPTION WHEN wrong_object_type THEN END; $$ language 'plpgsql';
-- etldoc: osm_border_linestring -> :use_schema.osm_border_linestring_gen4
DROP MATERIALIZED VIEW IF EXISTS :use_schema.osm_border_linestring_gen4 CASCADE;
CREATE MATERIALIZED VIEW :use_schema.osm_border_linestring_gen4 AS (
  SELECT ST_Simplify(geometry, 80) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime
  FROM osm_border_linestring
  WHERE admin_level <= 6
) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_border_linestring_gen4_idx ON :use_schema.osm_border_linestring_gen4 USING gist (geometry);

-- This statement can be deleted after the border importer image stops creating this object as a table
DO $$ BEGIN DROP TABLE IF EXISTS :use_schema.osm_border_linestring_gen5 CASCADE; EXCEPTION WHEN wrong_object_type THEN END; $$ language 'plpgsql';
-- etldoc: osm_border_linestring -> :use_schema.osm_border_linestring_gen5
DROP MATERIALIZED VIEW IF EXISTS :use_schema.osm_border_linestring_gen5 CASCADE;
CREATE MATERIALIZED VIEW :use_schema.osm_border_linestring_gen5 AS (
  SELECT ST_Simplify(geometry, 160) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime
  FROM osm_border_linestring
  WHERE admin_level <= 6
) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_border_linestring_gen5_idx ON :use_schema.osm_border_linestring_gen5 USING gist (geometry);

-- This statement can be deleted after the border importer image stops creating this object as a table
DO $$ BEGIN DROP TABLE IF EXISTS :use_schema.osm_border_linestring_gen6 CASCADE; EXCEPTION WHEN wrong_object_type THEN END; $$ language 'plpgsql';
-- etldoc: osm_border_linestring -> :use_schema.osm_border_linestring_gen6
DROP MATERIALIZED VIEW IF EXISTS :use_schema.osm_border_linestring_gen6 CASCADE;
CREATE MATERIALIZED VIEW :use_schema.osm_border_linestring_gen6 AS (
  SELECT ST_Simplify(geometry, 300) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime
  FROM osm_border_linestring
  WHERE admin_level <= 4
) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_border_linestring_gen6_idx ON :use_schema.osm_border_linestring_gen6 USING gist (geometry);

-- This statement can be deleted after the border importer image stops creating this object as a table
DO $$ BEGIN DROP TABLE IF EXISTS :use_schema.osm_border_linestring_gen7 CASCADE; EXCEPTION WHEN wrong_object_type THEN END; $$ language 'plpgsql';
-- etldoc: osm_border_linestring -> :use_schema.osm_border_linestring_gen7
DROP MATERIALIZED VIEW IF EXISTS :use_schema.osm_border_linestring_gen7 CASCADE;
CREATE MATERIALIZED VIEW :use_schema.osm_border_linestring_gen7 AS (
  SELECT ST_Simplify(geometry, 600) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime
  FROM osm_border_linestring
  WHERE admin_level <= 4
) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_border_linestring_gen7_idx ON :use_schema.osm_border_linestring_gen7 USING gist (geometry);

-- This statement can be deleted after the border importer image stops creating this object as a table
DO $$ BEGIN DROP TABLE IF EXISTS :use_schema.osm_border_linestring_gen8 CASCADE; EXCEPTION WHEN wrong_object_type THEN END; $$ language 'plpgsql';
-- etldoc: osm_border_linestring -> :use_schema.osm_border_linestring_gen8
DROP MATERIALIZED VIEW IF EXISTS :use_schema.osm_border_linestring_gen8 CASCADE;
CREATE MATERIALIZED VIEW :use_schema.osm_border_linestring_gen8 AS (
  SELECT ST_Simplify(geometry, 1200) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime
  FROM osm_border_linestring
  WHERE admin_level <= 4
) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_border_linestring_gen8_idx ON :use_schema.osm_border_linestring_gen8 USING gist (geometry);

-- This statement can be deleted after the border importer image stops creating this object as a table
DO $$ BEGIN DROP TABLE IF EXISTS :use_schema.osm_border_linestring_gen9 CASCADE; EXCEPTION WHEN wrong_object_type THEN END; $$ language 'plpgsql';
-- etldoc: osm_border_linestring -> :use_schema.osm_border_linestring_gen9
DROP MATERIALIZED VIEW IF EXISTS :use_schema.osm_border_linestring_gen9 CASCADE;
CREATE MATERIALIZED VIEW :use_schema.osm_border_linestring_gen9 AS (
  SELECT ST_Simplify(geometry, 2400) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime
  FROM osm_border_linestring
  WHERE admin_level <= 4
) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS osm_border_linestring_gen9_idx ON :use_schema.osm_border_linestring_gen9 USING gist (geometry);

-- This statement can be deleted after the border importer image stops creating this object as a table
DO $$ BEGIN DROP TABLE IF EXISTS :use_schema.osm_border_linestring_gen10 CASCADE; EXCEPTION WHEN wrong_object_type THEN END; $$ language 'plpgsql';
-- etldoc: osm_border_linestring -> :use_schema.osm_border_linestring_gen10
DROP MATERIALIZED VIEW IF EXISTS :use_schema.osm_border_linestring_gen10 CASCADE;
CREATE MATERIALIZED VIEW :use_schema.osm_border_linestring_gen10 AS (
  SELECT ST_Simplify(geometry, 4800) AS geometry, osm_id, admin_level, dividing_line, disputed, maritime
  FROM osm_border_linestring
  WHERE admin_level <= 2
) /* DELAY_MATERIALIZED_VIEW_CREATION */ ;
CREATE INDEX IF NOT EXISTS :use_schema.osm_border_linestring_gen10_idx ON :use_schema.osm_border_linestring_gen10 USING gist (geometry);


-- etldoc: ne_110m_admin_0_boundary_lines_land  -> boundary_z0
CREATE OR REPLACE VIEW :use_schema.boundary_z0 AS (
    SELECT geometry,
        2 AS admin_level,
        (CASE WHEN featurecla LIKE 'Disputed%' THEN true ELSE false END) AS disputed,
        NULL::text AS disputed_name,
        NULL::text AS claimed_by,
        false AS maritime
    FROM mapdata_prod.ne_110m_admin_0_boundary_lines_land
);

-- etldoc: ne_50m_admin_0_boundary_lines_land  -> boundary_z1
-- etldoc: ne_50m_admin_1_states_provinces_lines -> boundary_z1
-- etldoc: osm_border_disp_linestring_gen11 -> boundary_z1
CREATE OR REPLACE VIEW :use_schema.boundary_z1 AS (
    SELECT geometry,
        2 AS admin_level,
        (CASE WHEN featurecla LIKE 'Disputed%' THEN true ELSE false END) AS disputed,
        NULL AS disputed_name,
        NULL AS claimed_by,
        false AS maritime
    FROM mapdata_prod.ne_50m_admin_0_boundary_lines_land
    UNION ALL
    SELECT geometry,
        4 AS admin_level,
        false AS disputed,
        NULL AS disputed_name,
        NULL AS claimed_by,
        false AS maritime
    FROM mapdata_prod.ne_50m_admin_1_states_provinces_lines
    UNION ALL
    SELECT geometry,
        admin_level,
        true AS disputed,
        edit_name(name) AS disputed_name,
        claimed_by,
        maritime
    FROM :use_schema.osm_border_disp_linestring_gen11
);


-- etldoc: ne_50m_admin_0_boundary_lines_land -> boundary_z3
-- etldoc: ne_50m_admin_1_states_provinces_lines -> boundary_z3
-- etldoc: osm_border_disp_linestring_gen11 -> boundary_z3
CREATE OR REPLACE VIEW :use_schema.boundary_z3 AS (
    SELECT geometry,
        2 AS admin_level,
        (CASE WHEN featurecla LIKE 'Disputed%' THEN true ELSE false END) AS disputed,
        NULL AS disputed_name,
        NULL AS claimed_by,
        false AS maritime
    FROM mapdata_prod.ne_50m_admin_0_boundary_lines_land
    UNION ALL
    SELECT geometry,
        4 AS admin_level,
        false AS disputed,
        NULL AS disputed_name,
        NULL AS claimed_by,
        false AS maritime
    FROM mapdata_prod.ne_50m_admin_1_states_provinces_lines
    UNION ALL
    SELECT geometry,
        admin_level,
        true AS disputed,
        edit_name(name) AS disputed_name,
        claimed_by,
        maritime
    FROM :use_schema.osm_border_disp_linestring_gen11
);


-- etldoc: ne_10m_admin_0_boundary_lines_land -> boundary_z4
-- etldoc: ne_10m_admin_1_states_provinces_lines -> boundary_z4
-- etldoc: :use_schema.osm_border_linestring_gen10 -> boundary_z4
-- etldoc: osm_border_disp_linestring_gen10 -> boundary_z4
CREATE OR REPLACE VIEW :use_schema.boundary_z4 AS (
    SELECT geometry,
        2 AS admin_level,
        (CASE WHEN featurecla LIKE 'Disputed%' THEN true ELSE false END) AS disputed,
        NULL AS disputed_name,
        NULL AS claimed_by,
        false AS maritime
    FROM mapdata_prod.ne_10m_admin_0_boundary_lines_land
    WHERE featurecla <> 'Lease limit'
    UNION ALL
    SELECT geometry,
        4 AS admin_level,
        false AS disputed,
        NULL AS disputed_name,
        NULL AS claimed_by,
        false AS maritime
    FROM mapdata_prod.ne_10m_admin_1_states_provinces_lines
    WHERE min_zoom <= 5
    UNION ALL
    SELECT geometry,
        admin_level,
        disputed,
        NULL AS disputed_name,
        NULL AS claimed_by,
        maritime
    FROM :use_schema.osm_border_linestring_gen10
    WHERE maritime=true AND admin_level <= 2
    UNION ALL
    SELECT geometry,
        admin_level,
        true AS disputed,
        edit_name(name) AS disputed_name,
        claimed_by,
        maritime
    FROM :use_schema.osm_border_disp_linestring_gen10
);

-- etldoc: :use_schema.osm_border_linestring_gen9 -> boundary_z5
-- etldoc: osm_border_disp_linestring_gen9 -> boundary_z5
CREATE OR REPLACE VIEW :use_schema.boundary_z5 AS (
    SELECT geometry,
        admin_level,
        disputed,
        NULL AS disputed_name,
        NULL AS claimed_by,
        maritime
    FROM :use_schema.osm_border_linestring_gen9
    WHERE admin_level <= 4
        AND osm_id NOT IN (SELECT DISTINCT osm_id FROM :use_schema.osm_border_disp_linestring_gen9)
    UNION ALL
    SELECT geometry,
        admin_level,
        true AS disputed,
        edit_name(name) AS disputed_name,
        claimed_by,
        maritime
    FROM :use_schema.osm_border_disp_linestring_gen9
);

-- etldoc: :use_schema.osm_border_linestring_gen8 -> boundary_z6
-- etldoc: osm_border_disp_linestring_gen8 -> boundary_z6
CREATE OR REPLACE VIEW :use_schema.boundary_z6 AS (
    SELECT geometry,
        admin_level,
        disputed,
        NULL AS disputed_name,
        NULL AS claimed_by,
        maritime
    FROM :use_schema.osm_border_linestring_gen8
    WHERE admin_level <= 4
        AND osm_id NOT IN (SELECT DISTINCT osm_id FROM :use_schema.osm_border_disp_linestring_gen8)
    UNION ALL
    SELECT geometry,
        admin_level,
        true AS disputed,
        edit_name(name) AS disputed_name,
        claimed_by,
        maritime
    FROM :use_schema.osm_border_disp_linestring_gen8
);

-- etldoc: :use_schema.osm_border_linestring_gen7 -> boundary_z7
-- etldoc: osm_border_disp_linestring_gen7 -> boundary_z7
CREATE OR REPLACE VIEW :use_schema.boundary_z7 AS (
    SELECT geometry,
        admin_level,
        disputed,
        NULL AS disputed_name,
        NULL AS claimed_by,
        maritime
    FROM :use_schema.osm_border_linestring_gen7
    WHERE admin_level <= 6
        AND osm_id NOT IN (SELECT DISTINCT osm_id FROM :use_schema.osm_border_disp_linestring_gen7)
    UNION ALL
    SELECT geometry,
        admin_level,
        true AS disputed,
        edit_name(name) AS disputed_name,
        claimed_by,
        maritime
    FROM :use_schema.osm_border_disp_linestring_gen7
);

-- etldoc: :use_schema.osm_border_linestring_gen6 -> boundary_z8
-- etldoc: osm_border_disp_linestring_gen6 -> boundary_z8
CREATE OR REPLACE VIEW :use_schema.boundary_z8 AS (
    SELECT geometry,
        admin_level,
        disputed,
        NULL AS disputed_name,
        NULL AS claimed_by,
        maritime
    FROM :use_schema.osm_border_linestring_gen6
    WHERE admin_level <= 6
        AND osm_id NOT IN (SELECT DISTINCT osm_id FROM :use_schema.osm_border_disp_linestring_gen6)
    UNION ALL
    SELECT geometry,
        admin_level,
        true AS disputed,
        edit_name(name) AS disputed_name,
        claimed_by,
        maritime
    FROM :use_schema.osm_border_disp_linestring_gen6
);

-- etldoc: :use_schema.osm_border_linestring_gen5 -> boundary_z9
-- etldoc: osm_border_disp_linestring_gen5 -> boundary_z9
CREATE OR REPLACE VIEW :use_schema.boundary_z9 AS (
    SELECT geometry,
        admin_level,
        disputed,
        NULL AS disputed_name,
        NULL AS claimed_by,
        maritime
    FROM :use_schema.osm_border_linestring_gen5
    WHERE admin_level <= 6
        AND osm_id NOT IN (SELECT DISTINCT osm_id FROM :use_schema.osm_border_disp_linestring_gen5)
    UNION ALL
    SELECT geometry,
        admin_level,
        true AS disputed,
        edit_name(name) AS disputed_name,
        claimed_by,
        maritime
    FROM :use_schema.osm_border_disp_linestring_gen5
);

-- etldoc: :use_schema.osm_border_linestring_gen4 -> boundary_z10
-- etldoc: osm_border_disp_linestring_gen4 -> boundary_z10
CREATE OR REPLACE VIEW :use_schema.boundary_z10 AS (
    SELECT geometry,
        admin_level,
        disputed,
        NULL AS disputed_name,
        NULL AS claimed_by,
        maritime
    FROM :use_schema.osm_border_linestring_gen4
    WHERE admin_level <= 6
        AND osm_id NOT IN (SELECT DISTINCT osm_id FROM :use_schema.osm_border_disp_linestring_gen4)
    UNION ALL
    SELECT geometry,
        admin_level,
        true AS disputed,
        edit_name(name) AS disputed_name,
        claimed_by,
        maritime
    FROM :use_schema.osm_border_disp_linestring_gen4
);

-- etldoc: :use_schema.osm_border_linestring_gen3 -> boundary_z11
-- etldoc: osm_border_disp_linestring_gen3 -> boundary_z11
CREATE OR REPLACE VIEW :use_schema.boundary_z11 AS (
    SELECT geometry,
        admin_level,
        disputed,
        NULL AS disputed_name,
        NULL AS claimed_by,
        maritime
    FROM :use_schema.osm_border_linestring_gen3
    WHERE admin_level <= 8
        AND osm_id NOT IN (SELECT DISTINCT osm_id FROM :use_schema.osm_border_disp_linestring_gen3)
    UNION ALL
    SELECT geometry,
        admin_level,
        true AS disputed,
        edit_name(name) AS disputed_name,
        claimed_by,
        maritime
    FROM :use_schema.osm_border_disp_linestring_gen3
);

-- etldoc: :use_schema.osm_border_linestring_gen2 -> boundary_z12
-- etldoc: osm_border_disp_linestring_gen2 -> boundary_z12
CREATE OR REPLACE VIEW :use_schema.boundary_z12 AS (
    SELECT geometry,
        admin_level,
        disputed,
        NULL AS disputed_name,
        NULL AS claimed_by,
        maritime
    FROM :use_schema.osm_border_linestring_gen2
    WHERE osm_id NOT IN (SELECT DISTINCT osm_id FROM :use_schema.osm_border_disp_linestring_gen2)
    UNION ALL
    SELECT geometry,
        admin_level,
        true AS disputed,
        edit_name(name) AS disputed_name,
        claimed_by,
        maritime
    FROM :use_schema.osm_border_disp_linestring_gen2
);

-- etldoc: :use_schema.osm_border_linestring_gen1 -> boundary_z13
-- etldoc: osm_border_disp_linestring_gen1 -> boundary_z13
CREATE OR REPLACE VIEW :use_schema.boundary_z13 AS (
    SELECT geometry,
        admin_level,
        disputed,
        NULL AS disputed_name,
        NULL AS claimed_by,
        maritime
    FROM :use_schema.osm_border_linestring_gen1
    WHERE osm_id NOT IN (SELECT DISTINCT osm_id FROM :use_schema.osm_border_disp_linestring_gen1)
    UNION ALL
    SELECT geometry,
        admin_level,
        true AS disputed,
        edit_name(name) AS disputed_name,
        claimed_by,
        maritime
    FROM :use_schema.osm_border_disp_linestring_gen1
);

DO $$ BEGIN RAISE NOTICE 'Finished layer boundary'; END$$;
