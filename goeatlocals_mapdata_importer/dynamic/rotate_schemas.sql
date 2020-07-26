BEGIN
    -- Tables
    DROP TABLE IF EXISTS :backup_schema.osm_aerialway_linestring_gen1 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_aerialway_linestring_gen1
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_aerialway_linestring_gen1
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_aeroway_linestring_gen1 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_aeroway_linestring_gen1
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_aeroway_linestring_gen1
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_aeroway_linestring_gen2 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_aeroway_linestring_gen2
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_aeroway_linestring_gen2
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_aeroway_linestring_gen3 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_aeroway_linestring_gen3
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_aeroway_linestring_gen3
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_aeroway_polygon_gen1 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_aeroway_polygon_gen1
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_aeroway_polygon_gen1
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_aeroway_polygon_gen2 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_aeroway_polygon_gen2
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_aeroway_polygon_gen2
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_aeroway_polygon_gen3 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_aeroway_polygon_gen3
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_aeroway_polygon_gen3
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_border_disp_linestring CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_border_disp_linestring
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_border_disp_linestring
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_border_disp_linestring_gen1 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_border_disp_linestring_gen1
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_border_disp_linestring_gen1
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_border_disp_linestring_gen10 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_border_disp_linestring_gen10
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_border_disp_linestring_gen10
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_border_disp_linestring_gen11 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_border_disp_linestring_gen11
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_border_disp_linestring_gen11
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_border_disp_linestring_gen2 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_border_disp_linestring_gen2
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_border_disp_linestring_gen2
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_border_disp_linestring_gen3 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_border_disp_linestring_gen3
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_border_disp_linestring_gen3
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_border_disp_linestring_gen4 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_border_disp_linestring_gen4
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_border_disp_linestring_gen4
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_border_disp_linestring_gen5 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_border_disp_linestring_gen5
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_border_disp_linestring_gen5
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_border_disp_linestring_gen6 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_border_disp_linestring_gen6
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_border_disp_linestring_gen6
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_border_disp_linestring_gen7 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_border_disp_linestring_gen7
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_border_disp_linestring_gen7
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_border_disp_linestring_gen8 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_border_disp_linestring_gen8
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_border_disp_linestring_gen8
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_border_disp_linestring_gen9 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_border_disp_linestring_gen9
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_border_disp_linestring_gen9
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_building_polygon_gen1 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_building_polygon_gen1
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_building_polygon_gen1
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_highway_linestring_gen1 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_highway_linestring_gen1
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_highway_linestring_gen1
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_highway_linestring_gen2 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_highway_linestring_gen2
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_highway_linestring_gen2
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_landcover_polygon_gen1 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_landcover_polygon_gen1
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_landcover_polygon_gen1
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_landcover_polygon_gen2 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_landcover_polygon_gen2
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_landcover_polygon_gen2
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_landcover_polygon_gen3 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_landcover_polygon_gen3
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_landcover_polygon_gen3
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_landcover_polygon_gen4 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_landcover_polygon_gen4
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_landcover_polygon_gen4
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_landcover_polygon_gen5 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_landcover_polygon_gen5
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_landcover_polygon_gen5
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_landcover_polygon_gen6 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_landcover_polygon_gen6
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_landcover_polygon_gen6
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_landcover_polygon_gen7 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_landcover_polygon_gen7
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_landcover_polygon_gen7
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_landuse_polygon_gen1 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_landuse_polygon_gen1
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_landuse_polygon_gen1
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_landuse_polygon_gen2 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_landuse_polygon_gen2
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_landuse_polygon_gen2
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_landuse_polygon_gen3 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_landuse_polygon_gen3
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_landuse_polygon_gen3
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_landuse_polygon_gen4 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_landuse_polygon_gen4
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_landuse_polygon_gen4
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_landuse_polygon_gen5 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_landuse_polygon_gen5
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_landuse_polygon_gen5
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_landuse_polygon_gen6 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_landuse_polygon_gen6
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_landuse_polygon_gen6
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_landuse_polygon_gen7 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_landuse_polygon_gen7
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_landuse_polygon_gen7
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_park_polygon_gen1 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_park_polygon_gen1
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_park_polygon_gen1
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_park_polygon_gen2 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_park_polygon_gen2
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_park_polygon_gen2
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_park_polygon_gen3 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_park_polygon_gen3
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_park_polygon_gen3
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_park_polygon_gen4 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_park_polygon_gen4
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_park_polygon_gen4
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_park_polygon_gen5 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_park_polygon_gen5
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_park_polygon_gen5
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_park_polygon_gen6 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_park_polygon_gen6
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_park_polygon_gen6
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_park_polygon_gen7 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_park_polygon_gen7
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_park_polygon_gen7
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_park_polygon_gen8 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_park_polygon_gen8
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_park_polygon_gen8
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_railway_linestring_gen1 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_railway_linestring_gen1
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_railway_linestring_gen1
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_railway_linestring_gen2 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_railway_linestring_gen2
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_railway_linestring_gen2
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_railway_linestring_gen3 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_railway_linestring_gen3
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_railway_linestring_gen3
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_railway_linestring_gen4 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_railway_linestring_gen4
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_railway_linestring_gen4
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_railway_linestring_gen5 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_railway_linestring_gen5
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_railway_linestring_gen5
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_shipway_linestring_gen1 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_shipway_linestring_gen1
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_shipway_linestring_gen1
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_shipway_linestring_gen2 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_shipway_linestring_gen2
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_shipway_linestring_gen2
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_water_polygon_gen1 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_water_polygon_gen1
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_water_polygon_gen1
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_water_polygon_gen2 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_water_polygon_gen2
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_water_polygon_gen2
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_water_polygon_gen3 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_water_polygon_gen3
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_water_polygon_gen3
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_water_polygon_gen4 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_water_polygon_gen4
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_water_polygon_gen4
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_water_polygon_gen5 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_water_polygon_gen5
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_water_polygon_gen5
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_water_polygon_gen6 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_water_polygon_gen6
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_water_polygon_gen6
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_waterway_linestring_gen1 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_waterway_linestring_gen1
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_waterway_linestring_gen1
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_waterway_linestring_gen2 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_waterway_linestring_gen2
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_waterway_linestring_gen2
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_waterway_linestring_gen3 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_waterway_linestring_gen3
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_waterway_linestring_gen3
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_aerialway_linestring CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_aerialway_linestring
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_aerialway_linestring
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_aerodrome_label_point CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_aerodrome_label_point
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_aerodrome_label_point
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_aeroway_linestring CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_aeroway_linestring
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_aeroway_linestring
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_aeroway_polygon CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_aeroway_polygon
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_aeroway_polygon
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_border_disp_relation CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_border_disp_relation
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_border_disp_relation
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_building_polygon CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_building_polygon
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_building_polygon
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_building_relation CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_building_relation
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_building_relation
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_city_point CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_city_point
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_city_point
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_continent_point CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_continent_point
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_continent_point
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_country_point CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_country_point
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_country_point
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_highway_linestring CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_highway_linestring
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_highway_linestring
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_highway_polygon CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_highway_polygon
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_highway_polygon
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_housenumber_point CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_housenumber_point
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_housenumber_point
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_island_point CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_island_point
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_island_point
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_island_polygon CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_island_polygon
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_island_polygon
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_landcover_polygon CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_landcover_polygon
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_landcover_polygon
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_landuse_polygon CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_landuse_polygon
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_landuse_polygon
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_marine_point CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_marine_point
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_marine_point
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_park_polygon CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_park_polygon
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_park_polygon
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_peak_point CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_peak_point
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_peak_point
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_poi_point CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_poi_point
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_poi_point
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_poi_polygon CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_poi_polygon
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_poi_polygon
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_railway_linestring CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_railway_linestring
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_railway_linestring
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_route_member CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_route_member
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_route_member
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_shipway_linestring CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_shipway_linestring
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_shipway_linestring
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_state_point CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_state_point
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_state_point
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_water_polygon CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_water_polygon
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_water_polygon
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_waterway_linestring CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_waterway_linestring
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_waterway_linestring
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_border_linestring CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_border_linestring
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_border_linestring
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.lake_centerline CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.lake_centerline
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.lake_centerline
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_water_lakeline CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_water_lakeline
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_water_lakeline
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_important_waterway_linestring CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_important_waterway_linestring
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_important_waterway_linestring
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_important_waterway_linestring_gen1 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_important_waterway_linestring_gen1
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_important_waterway_linestring_gen1
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_important_waterway_linestring_gen2 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_important_waterway_linestring_gen2
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_important_waterway_linestring_gen2
        SET SCHEMA :prod_schema;

    DROP TABLE IF EXISTS :backup_schema.osm_important_waterway_linestring_gen3 CASCADE;
    ALTER TABLE IF EXISTS :prod_schema.osm_important_waterway_linestring_gen3
        SET SCHEMA :backup_schema;
    ALTER TABLE IF EXISTS :staging_schema.osm_important_waterway_linestring_gen3
        SET SCHEMA :prod_schema;


    -- Views
    DROP VIEW IF EXISTS :backup_schema.osm_all_buildings CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.osm_all_buildings
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.osm_all_buildings
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.osm_border_linestrint_gen1 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.osm_border_linestrint_gen1
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.osm_border_linestrint_gen1
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.osm_border_linestrint_gen2 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.osm_border_linestrint_gen2
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.osm_border_linestrint_gen2
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.osm_border_linestrint_gen3 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.osm_border_linestrint_gen3
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.osm_border_linestrint_gen3
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.osm_border_linestrint_gen4 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.osm_border_linestrint_gen4
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.osm_border_linestrint_gen4
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.osm_border_linestrint_gen5 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.osm_border_linestrint_gen5
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.osm_border_linestrint_gen5
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.osm_border_linestrint_gen6 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.osm_border_linestrint_gen6
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.osm_border_linestrint_gen6
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.osm_border_linestrint_gen7 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.osm_border_linestrint_gen7
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.osm_border_linestrint_gen7
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.osm_border_linestrint_gen8 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.osm_border_linestrint_gen8
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.osm_border_linestrint_gen8
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.osm_border_linestrint_gen9 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.osm_border_linestrint_gen9
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.osm_border_linestrint_gen9
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.osm_border_linestrint_gen10 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.osm_border_linestrint_gen10
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.osm_border_linestrint_gen10
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.boundary_z0 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.boundary_z0
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.boundary_z0
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.boundary_z1 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.boundary_z1
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.boundary_z1
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.boundary_z3 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.boundary_z3
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.boundary_z3
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.boundary_z4 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.boundary_z4
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.boundary_z4
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.boundary_z5 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.boundary_z5
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.boundary_z5
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.boundary_z6 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.boundary_z6
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.boundary_z6
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.boundary_z7 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.boundary_z7
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.boundary_z7
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.boundary_z8 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.boundary_z8
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.boundary_z8
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.boundary_z9 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.boundary_z9
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.boundary_z9
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.boundary_z10 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.boundary_z10
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.boundary_z10
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.boundary_z11 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.boundary_z11
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.boundary_z11
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.boundary_z12 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.boundary_z12
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.boundary_z12
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.boundary_z13 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.boundary_z13
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.boundary_z13
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.osm_poi_stop_centroid CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.osm_poi_stop_centroid
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.osm_poi_stop_centroid
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.osm_poi_stop_rank CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.osm_poi_stop_rank
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.osm_poi_stop_rank
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.landcover_z0 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.landcover_z0
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.landcover_z0
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.landcover_z2 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.landcover_z2
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.landcover_z2
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.landcover_z5 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.landcover_z5
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.landcover_z5
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.landcover_z7 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.landcover_z7
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.landcover_z7
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.landcover_z8 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.landcover_z8
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.landcover_z8
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.landcover_z9 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.landcover_z9
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.landcover_z9
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.landcover_z10 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.landcover_z10
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.landcover_z10
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.landcover_z11 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.landcover_z11
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.landcover_z11
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.landcover_z12 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.landcover_z12
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.landcover_z12
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.landcover_z13 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.landcover_z13
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.landcover_z13
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.landcover_z14 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.landcover_z14
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.landcover_z14
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.landuse_z4 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.landuse_z4
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.landuse_z4
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.landuse_z5 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.landuse_z5
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.landuse_z5
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.landuse_z6 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.landuse_z6
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.landuse_z6
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.landuse_z8 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.landuse_z8
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.landuse_z8
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.landuse_z9 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.landuse_z9
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.landuse_z9
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.landuse_z10 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.landuse_z10
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.landuse_z10
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.landuse_z11 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.landuse_z11
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.landuse_z11
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.landuse_z12 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.landuse_z12
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.landuse_z12
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.landuse_z13 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.landuse_z13
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.landuse_z13
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.landuse_z14 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.landuse_z14
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.landuse_z14
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.osm_water_lakeline_view CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.osm_water_lakeline_view
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.osm_water_lakeline_view
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.osm_water_point_view CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.osm_water_point_view
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.osm_water_point_view
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.water_z0 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.water_z0
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.water_z0
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.water_z1 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.water_z1
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.water_z1
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.water_z2 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.water_z2
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.water_z2
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.water_z4 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.water_z4
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.water_z4
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.water_z5 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.water_z5
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.water_z5
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.water_z6 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.water_z6
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.water_z6
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.water_z7 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.water_z7
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.water_z7
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.water_z8 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.water_z8
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.water_z8
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.water_z9 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.water_z9
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.water_z9
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.water_z10 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.water_z10
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.water_z10
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.water_z11 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.water_z11
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.water_z11
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.water_z12 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.water_z12
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.water_z12
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.water_z13 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.water_z13
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.water_z13
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.water_z14 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.water_z14
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.water_z14
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.osm_important_waterway_linestring_gen1_view CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.osm_important_waterway_linestring_gen1_view
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.osm_important_waterway_linestring_gen1_view
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.osm_important_waterway_linestring_gen2_view CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.osm_important_waterway_linestring_gen2_view
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.osm_important_waterway_linestring_gen2_view
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.osm_important_waterway_linestring_gen3_view CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.osm_important_waterway_linestring_gen3_view
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.osm_important_waterway_linestring_gen3_view
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.waterway_z3 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.waterway_z3
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.waterway_z3
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.waterway_z4 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.waterway_z4
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.waterway_z4
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.waterway_z6 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.waterway_z6
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.waterway_z6
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.waterway_z9 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.waterway_z9
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.waterway_z9
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.waterway_z10 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.waterway_z10
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.waterway_z10
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.waterway_z11 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.waterway_z11
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.waterway_z11
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.waterway_z12 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.waterway_z12
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.waterway_z12
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.waterway_z13 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.waterway_z13
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.waterway_z13
        SET SCHEMA :prod_schema;

    DROP VIEW IF EXISTS :backup_schema.waterway_z14 CASCADE;
    ALTER VIEW IF EXISTS :prod_schema.waterway_z14
        SET SCHEMA :backup_schema;
    ALTER VIEW IF EXISTS :staging_schema.waterway_z14
        SET SCHEMA :prod_schema;


    -- Materialized views
    DROP MATERIALIZED VIEW IF EXISTS :backup_schema.osm_transportation_merge_linestring CASCADE;
    ALTER MATERIALIZED VIEW IF EXISTS :prod_schema.osm_transportation_merge_linestring
        SET SCHEMA :backup_schema;
    ALTER MATERIALIZED VIEW IF EXISTS :staging_schema.osm_transportation_merge_linestring
        SET SCHEMA :prod_schema;

    DROP MATERIALIZED VIEW IF EXISTS :backup_schema.osm_transportation_merge_linestring_gen3 CASCADE;
    ALTER MATERIALIZED VIEW IF EXISTS :prod_schema.osm_transportation_merge_linestring_gen3
        SET SCHEMA :backup_schema;
    ALTER MATERIALIZED VIEW IF EXISTS :staging_schema.osm_transportation_merge_linestring_gen3
        SET SCHEMA :prod_schema;

    DROP MATERIALIZED VIEW IF EXISTS :backup_schema.osm_transportation_merge_linestring_gen4 CASCADE;
    ALTER MATERIALIZED VIEW IF EXISTS :prod_schema.osm_transportation_merge_linestring_gen4
        SET SCHEMA :backup_schema;
    ALTER MATERIALIZED VIEW IF EXISTS :staging_schema.osm_transportation_merge_linestring_gen4
        SET SCHEMA :prod_schema;

    DROP MATERIALIZED VIEW IF EXISTS :backup_schema.osm_transportation_merge_linestring_gen5 CASCADE;
    ALTER MATERIALIZED VIEW IF EXISTS :prod_schema.osm_transportation_merge_linestring_gen5
        SET SCHEMA :backup_schema;
    ALTER MATERIALIZED VIEW IF EXISTS :staging_schema.osm_transportation_merge_linestring_gen5
        SET SCHEMA :prod_schema;

    DROP MATERIALIZED VIEW IF EXISTS :backup_schema.osm_transportation_merge_linestring_gen6 CASCADE;
    ALTER MATERIALIZED VIEW IF EXISTS :prod_schema.osm_transportation_merge_linestring_gen6
        SET SCHEMA :backup_schema;
    ALTER MATERIALIZED VIEW IF EXISTS :staging_schema.osm_transportation_merge_linestring_gen6
        SET SCHEMA :prod_schema;

    DROP MATERIALIZED VIEW IF EXISTS :backup_schema.osm_transportation_merge_linestring_gen7 CASCADE;
    ALTER MATERIALIZED VIEW IF EXISTS :prod_schema.osm_transportation_merge_linestring_gen7
        SET SCHEMA :backup_schema;
    ALTER MATERIALIZED VIEW IF EXISTS :staging_schema.osm_transportation_merge_linestring_gen7
        SET SCHEMA :prod_schema;

    DROP MATERIALIZED VIEW IF EXISTS :backup_schema.osm_transportation_name_network CASCADE;
    ALTER MATERIALIZED VIEW IF EXISTS :prod_schema.osm_transportation_name_network
        SET SCHEMA :backup_schema;
    ALTER MATERIALIZED VIEW IF EXISTS :staging_schema.osm_transportation_name_network
        SET SCHEMA :prod_schema;

    DROP MATERIALIZED VIEW IF EXISTS :backup_schema.osm_transportation_name_linestring CASCADE;
    ALTER MATERIALIZED VIEW IF EXISTS :prod_schema.osm_transportation_name_linestring
        SET SCHEMA :backup_schema;
    ALTER MATERIALIZED VIEW IF EXISTS :staging_schema.osm_transportation_name_linestring
        SET SCHEMA :prod_schema;

    DROP MATERIALIZED VIEW IF EXISTS :backup_schema.osm_transportation_name_linestring_gen1 CASCADE;
    ALTER MATERIALIZED VIEW IF EXISTS :prod_schema.osm_transportation_name_linestring_gen1
        SET SCHEMA :backup_schema;
    ALTER MATERIALIZED VIEW IF EXISTS :staging_schema.osm_transportation_name_linestring_gen1
        SET SCHEMA :prod_schema;

    DROP MATERIALIZED VIEW IF EXISTS :backup_schema.osm_transportation_name_linestring_gen2 CASCADE;
    ALTER MATERIALIZED VIEW IF EXISTS :prod_schema.osm_transportation_name_linestring_gen2
        SET SCHEMA :backup_schema;
    ALTER MATERIALIZED VIEW IF EXISTS :staging_schema.osm_transportation_name_linestring_gen2
        SET SCHEMA :prod_schema;

    DROP MATERIALIZED VIEW IF EXISTS :backup_schema.osm_transportation_name_linestring_gen3 CASCADE;
    ALTER MATERIALIZED VIEW IF EXISTS :prod_schema.osm_transportation_name_linestring_gen3
        SET SCHEMA :backup_schema;
    ALTER MATERIALIZED VIEW IF EXISTS :staging_schema.osm_transportation_name_linestring_gen3
        SET SCHEMA :prod_schema;

    DROP MATERIALIZED VIEW IF EXISTS :backup_schema.osm_transportation_name_linestring_gen4 CASCADE;
    ALTER MATERIALIZED VIEW IF EXISTS :prod_schema.osm_transportation_name_linestring_gen4
        SET SCHEMA :backup_schema;
    ALTER MATERIALIZED VIEW IF EXISTS :staging_schema.osm_transportation_name_linestring_gen4
        SET SCHEMA :prod_schema;
END;
