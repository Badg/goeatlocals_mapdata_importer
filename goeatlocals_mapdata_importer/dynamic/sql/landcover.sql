DO $$ BEGIN RAISE NOTICE 'Processing layer landcover'; END$$;

-- Layer landcover - ./landcover.sql

--TODO: Find a way to nicely generalize landcover
--CREATE TABLE IF NOT EXISTS landcover_grouped_gen2 AS (
--	SELECT osm_id, ST_Simplify((ST_Dump(geometry)).geom, 600) AS geometry, landuse, "natural", wetland
--	FROM (
--	  SELECT max(osm_id) AS osm_id, ST_Union(ST_Buffer(geometry, 600)) AS geometry, landuse, "natural", wetland
--	  FROM osm_landcover_polygon_gen1
--	  GROUP BY LabelGrid(geometry, 15000000), landuse, "natural", wetland
--	) AS grouped_measurements
--);
--CREATE INDEX IF NOT EXISTS landcover_grouped_gen2_geometry_idx ON landcover_grouped_gen2 USING gist(geometry);



-- etldoc: ne_110m_glaciated_areas ->  landcover_z0
CREATE OR REPLACE VIEW :use_schema.landcover_z0 AS (
    SELECT NULL::bigint AS osm_id, geometry, 'glacier'::text AS subclass FROM mapdata_prod.ne_110m_glaciated_areas
);

CREATE OR REPLACE VIEW :use_schema.landcover_z2 AS (
    -- etldoc: ne_50m_glaciated_areas ->  landcover_z2
    SELECT NULL::bigint AS osm_id, geometry, 'glacier'::text AS subclass FROM mapdata_prod.ne_50m_glaciated_areas
    UNION ALL
    -- etldoc: ne_50m_antarctic_ice_shelves_polys ->  landcover_z2
    SELECT NULL::bigint AS osm_id, geometry, 'ice_shelf'::text AS subclass FROM mapdata_prod.ne_50m_antarctic_ice_shelves_polys
);

CREATE OR REPLACE VIEW :use_schema.landcover_z5 AS (
    -- etldoc: ne_10m_glaciated_areas ->  landcover_z5
    SELECT NULL::bigint AS osm_id, geometry, 'glacier'::text AS subclass FROM mapdata_prod.ne_10m_glaciated_areas
    UNION ALL
    -- etldoc: ne_10m_antarctic_ice_shelves_polys ->  landcover_z5
    SELECT NULL::bigint AS osm_id, geometry, 'ice_shelf'::text AS subclass FROM mapdata_prod.ne_10m_antarctic_ice_shelves_polys
);

CREATE OR REPLACE VIEW :use_schema.landcover_z7 AS (
    -- etldoc: osm_landcover_polygon_gen7 ->  landcover_z7
    SELECT osm_id, geometry, subclass FROM :use_schema.osm_landcover_polygon_gen7
);

CREATE OR REPLACE VIEW :use_schema.landcover_z8 AS (
    -- etldoc: osm_landcover_polygon_gen6 ->  landcover_z8
    SELECT osm_id, geometry, subclass FROM :use_schema.osm_landcover_polygon_gen6
);

CREATE OR REPLACE VIEW :use_schema.landcover_z9 AS (
    -- etldoc: osm_landcover_polygon_gen5 ->  landcover_z9
    SELECT osm_id, geometry, subclass FROM :use_schema.osm_landcover_polygon_gen5
);

CREATE OR REPLACE VIEW :use_schema.landcover_z10 AS (
    -- etldoc: osm_landcover_polygon_gen4 ->  landcover_z10
    SELECT osm_id, geometry, subclass FROM :use_schema.osm_landcover_polygon_gen4
);

CREATE OR REPLACE VIEW :use_schema.landcover_z11 AS (
    -- etldoc: osm_landcover_polygon_gen3 ->  landcover_z11
    SELECT osm_id, geometry, subclass FROM :use_schema.osm_landcover_polygon_gen3
);

CREATE OR REPLACE VIEW :use_schema.landcover_z12 AS (
    -- etldoc: osm_landcover_polygon_gen2 ->  landcover_z12
    SELECT osm_id, geometry, subclass FROM :use_schema.osm_landcover_polygon_gen2
);

CREATE OR REPLACE VIEW :use_schema.landcover_z13 AS (
    -- etldoc: osm_landcover_polygon_gen1 ->  landcover_z13
    SELECT osm_id, geometry, subclass FROM :use_schema.osm_landcover_polygon_gen1
);

CREATE OR REPLACE VIEW :use_schema.landcover_z14 AS (
    -- etldoc: osm_landcover_polygon ->  landcover_z14
    SELECT osm_id, geometry, subclass FROM :use_schema.osm_landcover_polygon
);

-- etldoc: layer_landcover[shape=record fillcolor=lightpink, style="rounded, filled", label="layer_landcover | <z0_1> z0-z1 | <z2_4> z2-z4 | <z5_6> z5-z6 |<z7> z7 |<z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14_> z14+" ] ;



DO $$ BEGIN RAISE NOTICE 'Finished layer landcover'; END$$;
