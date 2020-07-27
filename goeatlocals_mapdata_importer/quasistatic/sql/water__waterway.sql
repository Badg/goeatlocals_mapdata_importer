-- etldoc: layer_water [shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_water |<z0> z0|<z1>z1|<z2>z2|<z3>z3 |<z4> z4|<z5>z5|<z6>z6|<z7>z7| <z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14_> z14+" ] ;

CREATE OR REPLACE FUNCTION mapdata_layers.layer_water (bbox geometry, zoom_level int)
RETURNS TABLE(geometry geometry, class text, brunnel text, intermittent int) AS $$
    SELECT geometry,
        class::text,
        waterway_brunnel(is_bridge, is_tunnel) AS brunnel,
        is_intermittent::int AS intermittent
    FROM (
        -- etldoc: water_z0 ->  layer_water:z0
        SELECT * FROM __use_schema__.water_z0 WHERE zoom_level = 0
        UNION ALL
        -- etldoc: water_z1 ->  layer_water:z1
        SELECT * FROM __use_schema__.water_z1 WHERE zoom_level = 1
        UNION ALL
        -- etldoc: water_z2 ->  layer_water:z2
        -- etldoc: water_z2 ->  layer_water:z3
        SELECT * FROM __use_schema__.water_z2 WHERE zoom_level BETWEEN 2 AND 3
        UNION ALL
        -- etldoc: water_z4 ->  layer_water:z4
        SELECT * FROM __use_schema__.water_z4 WHERE zoom_level = 4
        UNION ALL
        -- etldoc: water_z5 ->  layer_water:z5
        SELECT * FROM __use_schema__.water_z5 WHERE zoom_level = 5
        UNION ALL
        -- etldoc: water_z6 ->  layer_water:z6
        SELECT * FROM __use_schema__.water_z6 WHERE zoom_level = 6
        UNION ALL
        -- etldoc: water_z7 ->  layer_water:z7
        SELECT * FROM __use_schema__.water_z7 WHERE zoom_level = 7
        UNION ALL
        -- etldoc: water_z8 ->  layer_water:z8
        SELECT * FROM __use_schema__.water_z8 WHERE zoom_level = 8
        UNION ALL
        -- etldoc: water_z9 ->  layer_water:z9
        SELECT * FROM __use_schema__.water_z9 WHERE zoom_level = 9
        UNION ALL
        -- etldoc: water_z10 ->  layer_water:z10
        SELECT * FROM __use_schema__.water_z10 WHERE zoom_level = 10
        UNION ALL
        -- etldoc: water_z11 ->  layer_water:z11
        SELECT * FROM __use_schema__.water_z11 WHERE zoom_level = 11
        UNION ALL
        -- etldoc: water_z12 ->  layer_water:z12
        SELECT * FROM __use_schema__.water_z12 WHERE zoom_level = 12
        UNION ALL
        -- etldoc: water_z13 ->  layer_water:z13
        SELECT * FROM __use_schema__.water_z13 WHERE zoom_level = 13
        UNION ALL
        -- etldoc: water_z14 ->  layer_water:z14_
        SELECT * FROM __use_schema__.water_z14 WHERE zoom_level >= 14
    ) AS zoom_levels
    WHERE geometry && bbox;
$$
LANGUAGE SQL
IMMUTABLE PARALLEL SAFE;-- etldoc: layer_waterway[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_waterway | <z3> z3 |<z4_5> z4-z5 |<z6_8> z6-8 | <z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14> z14+" ];


CREATE OR REPLACE FUNCTION mapdata_layers.layer_waterway(bbox geometry, zoom_level int)
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
        SELECT * FROM __use_schema__.waterway_z3 WHERE zoom_level = 3
        UNION ALL
        -- etldoc: waterway_z4 ->  layer_waterway:z4_5
        SELECT * FROM __use_schema__.waterway_z4 WHERE zoom_level BETWEEN 4 AND 5
        UNION ALL
        -- etldoc: waterway_z6 ->  layer_waterway:z6_8
        SELECT * FROM __use_schema__.waterway_z6 WHERE zoom_level BETWEEN 6 AND 8
        UNION ALL
        -- etldoc: waterway_z9 ->  layer_waterway:z9
        SELECT * FROM __use_schema__.waterway_z9 WHERE zoom_level = 9
        UNION ALL
        -- etldoc: waterway_z10 ->  layer_waterway:z10
        SELECT * FROM __use_schema__.waterway_z10 WHERE zoom_level = 10
        UNION ALL
        -- etldoc: waterway_z11 ->  layer_waterway:z11
        SELECT * FROM __use_schema__.waterway_z11 WHERE zoom_level = 11
        UNION ALL
        -- etldoc: waterway_z12 ->  layer_waterway:z12
        SELECT * FROM __use_schema__.waterway_z12 WHERE zoom_level = 12
        UNION ALL
        -- etldoc: waterway_z13 ->  layer_waterway:z13
        SELECT * FROM __use_schema__.waterway_z13 WHERE zoom_level = 13
        UNION ALL
        -- etldoc: waterway_z14 ->  layer_waterway:z14
        SELECT * FROM __use_schema__.waterway_z14 WHERE zoom_level >= 14
    ) AS zoom_levels
    WHERE geometry && bbox;
$$
LANGUAGE SQL
IMMUTABLE PARALLEL SAFE;


CREATE OR REPLACE FUNCTION mapdata_utils.water_class(waterway TEXT)
RETURNS TEXT AS $$
    SELECT CASE
        WHEN "waterway" IN ('', 'lake') THEN 'lake'
        WHEN "waterway" = 'dock' THEN 'dock'
        ELSE 'river'
    END;
$$
LANGUAGE SQL
IMMUTABLE PARALLEL SAFE;


CREATE OR REPLACE FUNCTION mapdata_utils.waterway_brunnel(is_bridge BOOL, is_tunnel BOOL)
RETURNS TEXT AS $$
    SELECT CASE
        WHEN is_bridge THEN 'bridge'
        WHEN is_tunnel THEN 'tunnel'
    END;
$$
LANGUAGE SQL
IMMUTABLE STRICT PARALLEL SAFE;
