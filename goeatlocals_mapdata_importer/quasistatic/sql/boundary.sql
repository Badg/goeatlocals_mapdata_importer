CREATE OR REPLACE FUNCTION mapdata_utils.edit_name(name VARCHAR) RETURNS TEXT AS $$
    SELECT CASE
        WHEN POSITION(' at ' in name) > 0
            THEN replace(SUBSTRING(name, POSITION(' at ' in name)+4), ' ', '')
        ELSE replace(replace(name,' ',''),'Extentof','')
    END;
$$ LANGUAGE SQL IMMUTABLE;


-- etldoc: layer_boundary[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="<sql> layer_boundary |<z0> z0 |<z1_2> z1_2 | <z3> z3 | <z4> z4 | <z5> z5 | <z6> z6 | <z7> z7 | <z8> z8 | <z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13+"]
CREATE OR REPLACE FUNCTION mapdata_layers.layer_boundary (bbox geometry, zoom_level int)
RETURNS TABLE(geometry geometry, admin_level int, disputed int, disputed_name text, claimed_by text, maritime int) AS $$
    SELECT geometry, admin_level, disputed::int, disputed_name, claimed_by, maritime::int FROM (
        -- etldoc: boundary_z0 ->  layer_boundary:z0
        SELECT * FROM :use_schema.boundary_z0 WHERE geometry && bbox AND zoom_level = 0
        UNION ALL
        -- etldoc: boundary_z1 ->  layer_boundary:z1_2
        SELECT * FROM :use_schema.boundary_z1 WHERE geometry && bbox AND zoom_level BETWEEN 1 AND 2
        UNION ALL
        -- etldoc: boundary_z3 ->  layer_boundary:z3
        SELECT * FROM :use_schema.boundary_z3 WHERE geometry && bbox AND zoom_level = 3
        UNION ALL
        -- etldoc: boundary_z4 ->  layer_boundary:z4
        SELECT * FROM :use_schema.boundary_z4 WHERE geometry && bbox AND zoom_level = 4
        UNION ALL
        -- etldoc: boundary_z5 ->  layer_boundary:z5
        SELECT * FROM :use_schema.boundary_z5 WHERE geometry && bbox AND zoom_level = 5
        UNION ALL
        -- etldoc: boundary_z6 ->  layer_boundary:z6
        SELECT * FROM :use_schema.boundary_z6 WHERE geometry && bbox AND zoom_level = 6
        UNION ALL
        -- etldoc: boundary_z7 ->  layer_boundary:z7
        SELECT * FROM :use_schema.boundary_z7 WHERE geometry && bbox AND zoom_level = 7
        UNION ALL
        -- etldoc: boundary_z8 ->  layer_boundary:z8
        SELECT * FROM :use_schema.boundary_z8 WHERE geometry && bbox AND zoom_level = 8
        UNION ALL
        -- etldoc: boundary_z9 ->  layer_boundary:z9
        SELECT * FROM :use_schema.boundary_z9 WHERE geometry && bbox AND zoom_level = 9
        UNION ALL
        -- etldoc: boundary_z10 ->  layer_boundary:z10
        SELECT * FROM :use_schema.boundary_z10 WHERE geometry && bbox AND zoom_level = 10
        UNION ALL
        -- etldoc: boundary_z11 ->  layer_boundary:z11
        SELECT * FROM :use_schema.boundary_z11 WHERE geometry && bbox AND zoom_level = 11
        UNION ALL
        -- etldoc: boundary_z12 ->  layer_boundary:z12
        SELECT * FROM :use_schema.boundary_z12 WHERE geometry && bbox AND zoom_level = 12
        UNION ALL
        -- etldoc: boundary_z13 -> layer_boundary:z13
        SELECT * FROM :use_schema.boundary_z13 WHERE geometry && bbox AND zoom_level >= 13
    ) AS zoom_levels;
$$
LANGUAGE SQL IMMUTABLE
PARALLEL SAFE;
