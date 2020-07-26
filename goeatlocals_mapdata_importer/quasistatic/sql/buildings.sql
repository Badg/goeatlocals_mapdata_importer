CREATE OR REPLACE FUNCTION mapdata_layers.layer_building(bbox geometry, zoom_level int)
RETURNS TABLE(geometry geometry, osm_id bigint, render_height int, render_min_height int, colour text, hide_3d boolean) AS $$
    SELECT geometry, osm_id, render_height, render_min_height,
       COALESCE(colour, CASE material
           -- Ordered by count from taginfo
           WHEN 'cement_block' THEN '#6a7880'
           WHEN 'brick' THEN '#bd8161'
           WHEN 'plaster' THEN '#dadbdb'
           WHEN 'wood' THEN '#d48741'
           WHEN 'concrete' THEN '#d3c2b0'
           WHEN 'metal' THEN '#b7b1a6'
           WHEN 'stone' THEN '#b4a995'
           WHEN 'mud' THEN '#9d8b75'
           WHEN 'steel' THEN '#b7b1a6' -- same as metal
           WHEN 'glass' THEN '#5a81a0'
           WHEN 'traditional' THEN '#bd8161' -- same as brick
           WHEN 'masonry' THEN '#bd8161' -- same as brick
           WHEN 'Brick' THEN '#bd8161' -- same as brick
           WHEN 'tin' THEN '#b7b1a6' -- same as metal
           WHEN 'timber_framing' THEN '#b3b0a9'
           WHEN 'sandstone' THEN '#b4a995' -- same as stone
           WHEN 'clay' THEN '#9d8b75' -- same as mud
       END) AS colour,
      CASE WHEN hide_3d THEN TRUE END AS hide_3d
    FROM (
        -- etldoc: osm_building_polygon_gen1 -> layer_building:z13
        SELECT
            osm_id, geometry,
            NULL::int AS render_height, NULL::int AS render_min_height,
            NULL::text AS material, NULL::text AS colour,
            FALSE AS hide_3d
        FROM :use_schema.osm_building_polygon_gen1
        WHERE zoom_level = 13 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_building_polygon -> layer_building:z14_
        SELECT DISTINCT ON (osm_id)
           osm_id, geometry,
           ceil(COALESCE(height, levels*3.66, 5))::int AS render_height,
           floor(COALESCE(min_height, min_level*3.66, 0))::int AS render_min_height,
           material,
           colour,
           hide_3d
        FROM :use_schema.osm_all_buildings
        WHERE
            (levels IS NULL OR levels < 1000) AND
            (min_level IS NULL OR min_level < 1000) AND
            (height IS NULL OR height < 3000) AND
            (min_height IS NULL OR min_height < 3000) AND
            zoom_level >= 14 AND geometry && bbox
    ) AS zoom_levels
    ORDER BY render_height ASC, ST_YMin(geometry) DESC;
$$
LANGUAGE SQL IMMUTABLE;
