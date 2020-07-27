DO $$ BEGIN RAISE NOTICE 'Processing layer landuse'; END$$;

-- Layer landuse - ./landuse.sql

-- etldoc: ne_50m_urban_areas -> landuse_z4
CREATE OR REPLACE VIEW __use_schema__.landuse_z4 AS (
    SELECT NULL::bigint AS osm_id, geometry, 'residential'::text AS landuse, NULL::text AS amenity, NULL::text AS leisure, NULL::text AS tourism, NULL::text AS place, NULL::text AS waterway
    FROM mapdata_prod.ne_50m_urban_areas
    WHERE scalerank <= 2
);

-- etldoc: ne_50m_urban_areas -> landuse_z5
CREATE OR REPLACE VIEW __use_schema__.landuse_z5 AS (
    SELECT NULL::bigint AS osm_id, geometry, 'residential'::text AS landuse, NULL::text AS amenity, NULL::text AS leisure, NULL::text AS tourism, NULL::text AS place, NULL::text AS waterway
    FROM mapdata_prod.ne_50m_urban_areas
);

-- etldoc: osm_landuse_polygon_gen7 -> landuse_z6
CREATE OR REPLACE VIEW __use_schema__.landuse_z6 AS (
    SELECT osm_id, geometry, landuse, amenity, leisure, tourism, place, waterway
    FROM __use_schema__.osm_landuse_polygon_gen7
);

-- etldoc: osm_landuse_polygon_gen6 -> landuse_z8
CREATE OR REPLACE VIEW __use_schema__.landuse_z8 AS (
    SELECT osm_id, geometry, landuse, amenity, leisure, tourism, place, waterway
    FROM __use_schema__.osm_landuse_polygon_gen6
);

-- etldoc: osm_landuse_polygon_gen5 -> landuse_z9
CREATE OR REPLACE VIEW __use_schema__.landuse_z9 AS (
    SELECT osm_id, geometry, landuse, amenity, leisure, tourism, place, waterway
    FROM __use_schema__.osm_landuse_polygon_gen5
);

-- etldoc: osm_landuse_polygon_gen4 -> landuse_z10
CREATE OR REPLACE VIEW __use_schema__.landuse_z10 AS (
    SELECT osm_id, geometry, landuse, amenity, leisure, tourism, place, waterway
    FROM __use_schema__.osm_landuse_polygon_gen4
);

-- etldoc: osm_landuse_polygon_gen3 -> landuse_z11
CREATE OR REPLACE VIEW __use_schema__.landuse_z11 AS (
    SELECT osm_id, geometry, landuse, amenity, leisure, tourism, place, waterway
    FROM __use_schema__.osm_landuse_polygon_gen3
);

-- etldoc: osm_landuse_polygon_gen2 -> landuse_z12
CREATE OR REPLACE VIEW __use_schema__.landuse_z12 AS (
    SELECT osm_id, geometry, landuse, amenity, leisure, tourism, place, waterway
    FROM __use_schema__.osm_landuse_polygon_gen2
);

-- etldoc: osm_landuse_polygon_gen1 -> landuse_z13
CREATE OR REPLACE VIEW __use_schema__.landuse_z13 AS (
    SELECT osm_id, geometry, landuse, amenity, leisure, tourism, place, waterway
    FROM __use_schema__.osm_landuse_polygon_gen1
);

-- etldoc: osm_landuse_polygon -> landuse_z14
CREATE OR REPLACE VIEW __use_schema__.landuse_z14 AS (
    SELECT osm_id, geometry, landuse, amenity, leisure, tourism, place, waterway
    FROM __use_schema__.osm_landuse_polygon
);


DO $$ BEGIN RAISE NOTICE 'Finished layer landuse'; END$$;
