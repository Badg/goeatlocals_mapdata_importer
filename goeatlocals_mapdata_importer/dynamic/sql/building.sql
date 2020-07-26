DO $$ BEGIN RAISE NOTICE 'Processing layer building'; END$$;

-- Layer building - ./building.sql

-- etldoc: layer_building[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_building | <z13> z13 | <z14_> z14+ " ] ;

CREATE INDEX IF NOT EXISTS osm_building_relation_building_idx ON :use_schema.osm_building_relation(building) WHERE building = '' AND ST_GeometryType(geometry) = 'ST_Polygon';
CREATE INDEX IF NOT EXISTS osm_building_relation_member_idx ON :use_schema.osm_building_relation(member) WHERE role = 'outline';

CREATE OR REPLACE VIEW :use_schema.osm_all_buildings AS (
         -- etldoc: osm_building_relation -> layer_building:z14_
         -- Buildings built from relations
         SELECT member AS osm_id, geometry,
                  COALESCE(CleanNumeric(height), CleanNumeric(buildingheight)) as height,
                  COALESCE(CleanNumeric(min_height), CleanNumeric(buildingmin_height)) as min_height,
                  COALESCE(CleanNumeric(levels), CleanNumeric(buildinglevels)) as levels,
                  COALESCE(CleanNumeric(min_level), CleanNumeric(buildingmin_level)) as min_level,
                  nullif(material, '') AS material,
                  nullif(colour, '') AS colour,
                  FALSE as hide_3d
         FROM
         :use_schema.osm_building_relation WHERE building = '' AND ST_GeometryType(geometry) = 'ST_Polygon'
         UNION ALL

         -- etldoc: osm_building_polygon -> layer_building:z14_
         -- Standalone buildings
         SELECT obp.osm_id, obp.geometry,
                  COALESCE(CleanNumeric(obp.height), CleanNumeric(obp.buildingheight)) as height,
                  COALESCE(CleanNumeric(obp.min_height), CleanNumeric(obp.buildingmin_height)) as min_height,
                  COALESCE(CleanNumeric(obp.levels), CleanNumeric(obp.buildinglevels)) as levels,
                  COALESCE(CleanNumeric(obp.min_level), CleanNumeric(obp.buildingmin_level)) as min_level,
                  nullif(obp.material, '') AS material,
                  nullif(obp.colour, '') AS colour,
                  obr.role IS NOT NULL AS hide_3d
         FROM
         :use_schema.osm_building_polygon obp
           LEFT JOIN :use_schema.osm_building_relation obr ON
             obp.osm_id >= 0 AND
             obr.member = obp.osm_id AND
             obr.role = 'outline'
         WHERE ST_GeometryType(obp.geometry) IN ('ST_Polygon', 'ST_MultiPolygon')
);

-- not handled: where a building outline covers building parts

DO $$ BEGIN RAISE NOTICE 'Finished layer building'; END$$;
