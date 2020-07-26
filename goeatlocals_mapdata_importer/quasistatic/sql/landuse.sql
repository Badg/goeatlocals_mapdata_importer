
-- etldoc: layer_landuse[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_landuse |<z4> z4|<z5>z5|<z6>z6|<z7>z7| <z8> z8 |<z9> z9 |<z10> z10 |<z11> z11|<z12> z12|<z13> z13|<z14> z14+" ] ;

CREATE OR REPLACE FUNCTION mapdata_layers.layer_landuse(bbox geometry, zoom_level int)
RETURNS TABLE(osm_id bigint, geometry geometry, class text) AS $$
    SELECT osm_id, geometry,
        COALESCE(
            NULLIF(landuse, ''),
            NULLIF(amenity, ''),
            NULLIF(leisure, ''),
            NULLIF(tourism, ''),
            NULLIF(place, ''),
            NULLIF(waterway, '')
        ) AS class
        FROM (
        -- etldoc: landuse_z4 -> layer_landuse:z4
        SELECT * FROM landuse_z4
        WHERE zoom_level = 4
        UNION ALL
        -- etldoc: landuse_z5 -> layer_landuse:z5
        SELECT * FROM landuse_z5
        WHERE zoom_level = 5
        UNION ALL
        -- etldoc: landuse_z6 -> layer_landuse:z6
        -- etldoc: landuse_z6 -> layer_landuse:z7
        SELECT * FROM landuse_z6 WHERE zoom_level BETWEEN 6 AND 7
        UNION ALL
        -- etldoc: landuse_z8 -> layer_landuse:z8
        SELECT * FROM landuse_z8 WHERE zoom_level = 8
        UNION ALL
        -- etldoc: landuse_z9 -> layer_landuse:z9
        SELECT * FROM landuse_z9 WHERE zoom_level = 9
        UNION ALL
        -- etldoc: landuse_z10 -> layer_landuse:z10
        SELECT * FROM landuse_z10 WHERE zoom_level = 10
        UNION ALL
        -- etldoc: landuse_z11 -> layer_landuse:z11
        SELECT * FROM landuse_z11 WHERE zoom_level = 11
        UNION ALL
        -- etldoc: landuse_z12 -> layer_landuse:z12
        SELECT * FROM landuse_z12 WHERE zoom_level = 12
        UNION ALL
        -- etldoc: landuse_z13 -> layer_landuse:z13
        SELECT * FROM landuse_z13 WHERE zoom_level = 13
        UNION ALL
        -- etldoc: landuse_z14 -> layer_landuse:z14
        SELECT * FROM landuse_z14 WHERE zoom_level >= 14
    ) AS zoom_levels
    WHERE geometry && bbox;
$$
LANGUAGE SQL
IMMUTABLE PARALLEL SAFE;
