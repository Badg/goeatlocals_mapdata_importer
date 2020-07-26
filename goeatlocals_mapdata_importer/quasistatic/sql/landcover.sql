CREATE OR REPLACE FUNCTION mapdata_layers.layer_landcover(bbox geometry, zoom_level int)
RETURNS TABLE(osm_id bigint, geometry geometry, class text, subclass text) AS $$
    SELECT osm_id, geometry,
        mapdata_utils.landcover_class(subclass) AS class,
        subclass
        FROM (
        -- etldoc:  landcover_z0 -> layer_landcover:z0_1
        SELECT * FROM :use_schema.landcover_z0
        WHERE zoom_level BETWEEN 0 AND 1 AND geometry && bbox
        UNION ALL
        -- etldoc:  landcover_z2 -> layer_landcover:z2_4
        SELECT * FROM :use_schema.landcover_z2
        WHERE zoom_level BETWEEN 2 AND 4 AND geometry && bbox
        UNION ALL
        -- etldoc:  landcover_z5 -> layer_landcover:z5_6
        SELECT * FROM :use_schema.landcover_z5
        WHERE zoom_level BETWEEN 5 AND 6 AND geometry && bbox
        UNION ALL
        -- etldoc:  landcover_z7 -> layer_landcover:z7
        SELECT *
        FROM :use_schema.landcover_z7 WHERE zoom_level = 7 AND geometry && bbox
        UNION ALL
        -- etldoc:  landcover_z8 -> layer_landcover:z8
        SELECT *
        FROM :use_schema.landcover_z8 WHERE zoom_level = 8 AND geometry && bbox
        UNION ALL
        -- etldoc:  landcover_z9 -> layer_landcover:z9
        SELECT *
        FROM :use_schema.landcover_z9 WHERE zoom_level = 9 AND geometry && bbox
        UNION ALL
        -- etldoc:  landcover_z10 -> layer_landcover:z10
        SELECT *
        FROM :use_schema.landcover_z10 WHERE zoom_level = 10 AND geometry && bbox
        UNION ALL
        -- etldoc:  landcover_z11 -> layer_landcover:z11
        SELECT *
        FROM :use_schema.landcover_z11 WHERE zoom_level = 11 AND geometry && bbox
        UNION ALL
        -- etldoc:  landcover_z12 -> layer_landcover:z12
        SELECT *
        FROM :use_schema.landcover_z12 WHERE zoom_level = 12 AND geometry && bbox
        UNION ALL
        -- etldoc:  landcover_z13 -> layer_landcover:z13
        SELECT *
        FROM :use_schema.landcover_z13 WHERE zoom_level = 13 AND geometry && bbox
        UNION ALL
        -- etldoc:  landcover_z14 -> layer_landcover:z14_
        SELECT *
        FROM :use_schema.landcover_z14 WHERE zoom_level >= 14 AND geometry && bbox
    ) AS zoom_levels;
$$
LANGUAGE SQL
IMMUTABLE PARALLEL SAFE;


CREATE OR REPLACE FUNCTION mapdata_utils.landcover_class(subclass VARCHAR)
RETURNS TEXT AS $$
    SELECT CASE
        WHEN "subclass" IN ('farmland', 'farm', 'orchard', 'vineyard', 'plant_nursery') THEN 'farmland'
        WHEN "subclass" IN ('glacier', 'ice_shelf') THEN 'ice'
        WHEN "subclass" IN ('wood', 'forest') THEN 'wood'
        WHEN "subclass" IN ('bare_rock', 'scree') THEN 'rock'
        WHEN "subclass" IN ('fell', 'grassland', 'heath', 'scrub', 'tundra', 'grass', 'meadow', 'allotments', 'park', 'village_green', 'recreation_ground', 'garden', 'golf_course') THEN 'grass'
        WHEN "subclass" IN ('wetland', 'bog', 'swamp', 'wet_meadow', 'marsh', 'reedbed', 'saltern', 'tidalflat', 'saltmarsh', 'mangrove') THEN 'wetland'
        WHEN "subclass" IN ('beach', 'sand', 'dune') THEN 'sand'
    END;
$$
LANGUAGE SQL
IMMUTABLE PARALLEL SAFE;
