DO $$ BEGIN RAISE NOTICE 'Processing layer place'; END$$;

-- Layer place - ./types.sql

ALTER TABLE :use_schema.osm_city_point ALTER COLUMN place TYPE city_place USING place::city_place;


-- etldoc: layer_city[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_city | <z2_14> z2-z14+" ] ;



-- Layer place - ./island_rank.sql


-- Layer place - ./update_continent_point.sql

-- etldoc:  osm_continent_point ->  osm_continent_point
BEGIN
  UPDATE :use_schema.osm_continent_point
  SET tags = update_tags(tags, geometry)
  WHERE COALESCE(tags->'name:latin', tags->'name:nonlatin', tags->'name_int') IS NULL;

END;

-- Layer place - ./update_country_point.sql

ALTER TABLE :use_schema.osm_country_point DROP CONSTRAINT IF EXISTS osm_country_point_rank_constraint;

-- etldoc: ne_10m_admin_0_countries   -> osm_country_point
-- etldoc: osm_country_point          -> osm_country_point

CREATE OR REPLACE FUNCTION update_osm_country_point() RETURNS VOID AS $$
BEGIN

  UPDATE :use_schema.osm_country_point AS osm
  SET
    "rank" = 7,
    iso3166_1_alpha_2 = COALESCE(
      NULLIF(osm.country_code_iso3166_1_alpha_2, ''),
      NULLIF(osm.iso3166_1_alpha_2, ''),
      NULLIF(osm.iso3166_1, '')
    )
  ;

  WITH important_country_point AS (
      SELECT osm.geometry, osm.osm_id, osm.name, COALESCE(NULLIF(osm.name_en, ''), ne.name) AS name_en, ne.scalerank, ne.labelrank
      FROM mapdata_prod.ne_10m_admin_0_countries AS ne, :use_schema.osm_country_point AS osm
      WHERE
        -- We match only countries with ISO codes to eliminate disputed countries
        iso3166_1_alpha_2 IS NOT NULL
        -- that lies inside polygon of sovereign country
        AND ST_Within(osm.geometry, ne.geometry)
  )
  UPDATE :use_schema.osm_country_point AS osm
  -- Normalize both scalerank and labelrank into a ranking system from 1 to 6
  -- where the ranks are still distributed uniform enough across all countries
  SET "rank" = LEAST(6, CEILING((scalerank + labelrank)/2.0))
  FROM important_country_point AS ne
  WHERE osm.osm_id = ne.osm_id;

  -- Repeat the step for archipelago countries like Philippines or Indonesia
  -- whose label point is not within country's polygon
  WITH important_country_point AS (
    SELECT
      osm.osm_id,
--       osm.name,
      ne.scalerank,
      ne.labelrank,
--       ST_Distance(osm.geometry, ne.geometry) AS distance,
      ROW_NUMBER()
      OVER (
        PARTITION BY osm.osm_id
        ORDER BY
          ST_Distance(osm.geometry, ne.geometry)
      ) AS rk
    FROM :use_schema.osm_country_point osm,
      mapdata_prod.ne_10m_admin_0_countries AS ne
    WHERE
      iso3166_1_alpha_2 IS NOT NULL
      AND NOT (osm."rank" BETWEEN 1 AND 6)
  )
  UPDATE :use_schema.osm_country_point AS osm
  -- Normalize both scalerank and labelrank into a ranking system from 1 to 6
  -- where the ranks are still distributed uniform enough across all countries
  SET "rank" = LEAST(6, CEILING((ne.scalerank + ne.labelrank)/2.0))
  FROM important_country_point AS ne
  WHERE osm.osm_id = ne.osm_id AND ne.rk = 1;

  UPDATE :use_schema.osm_country_point AS osm
  SET "rank" = 6
  WHERE "rank" = 7;

  -- TODO: This shouldn't be necessary? The rank function makes something wrong...
  UPDATE :use_schema.osm_country_point AS osm
  SET "rank" = 1
  WHERE "rank" = 0;

  UPDATE :use_schema.osm_country_point
  SET tags = update_tags(tags, geometry)
  WHERE COALESCE(tags->'name:latin', tags->'name:nonlatin', tags->'name_int') IS NULL;

END;
$$ LANGUAGE plpgsql;

SELECT :use_schema.update_osm_country_point();

-- ALTER TABLE osm_country_point ADD CONSTRAINT osm_country_point_rank_constraint CHECK("rank" BETWEEN 1 AND 6);
CREATE INDEX IF NOT EXISTS osm_country_point_rank_idx ON :use_schema.osm_country_point("rank");


-- Layer place - ./update_island_polygon.sql

-- etldoc:  osm_island_polygon ->  osm_island_polygon
CREATE OR REPLACE FUNCTION :use_schema.update_osm_island_polygon() RETURNS VOID AS $$
BEGIN
  UPDATE :use_schema.osm_island_polygon
  SET geometry=ST_PointOnSurface(geometry)
  WHERE ST_GeometryType(geometry) <> 'ST_Point';

  UPDATE :use_schema.osm_island_polygon
  SET tags = update_tags(tags, geometry)
  WHERE COALESCE(tags->'name:latin', tags->'name:nonlatin', tags->'name_int') IS NULL;

  ANALYZE :use_schema.osm_island_polygon;
END;
$$ LANGUAGE plpgsql;

SELECT :use_schema.update_osm_island_polygon();


-- Layer place - ./update_island_point.sql

-- etldoc:  osm_island_point ->  osm_island_point
CREATE OR REPLACE FUNCTION :use_schema.update_osm_island_point() RETURNS VOID AS $$
BEGIN
  UPDATE :use_schema.osm_island_point
  SET tags = update_tags(tags, geometry)
  WHERE COALESCE(tags->'name:latin', tags->'name:nonlatin', tags->'name_int') IS NULL;

END;
$$ LANGUAGE plpgsql;

SELECT :use_schema.update_osm_island_point();


-- Layer place - ./update_state_point.sql

ALTER TABLE :use_schema.osm_state_point DROP CONSTRAINT IF EXISTS osm_state_point_rank_constraint;

-- etldoc: ne_10m_admin_1_states_provinces   -> osm_state_point
-- etldoc: osm_state_point                       -> osm_state_point

CREATE OR REPLACE FUNCTION :use_schema.update_osm_state_point() RETURNS VOID AS $$
BEGIN

  WITH important_state_point AS (
      SELECT osm.geometry, osm.osm_id, osm.name, COALESCE(NULLIF(osm.name_en, ''), ne.name) AS name_en, ne.scalerank, ne.labelrank, ne.datarank
      FROM mapdata_prod.ne_10m_admin_1_states_provinces AS ne, :use_schema.osm_state_point AS osm
      WHERE
      -- We only match whether the point is within the Natural Earth polygon
      -- because name matching is difficult
      ST_Within(osm.geometry, ne.geometry)
      -- We leave out leess important states
      AND ne.scalerank <= 3 AND ne.labelrank <= 2
  )
  UPDATE :use_schema.osm_state_point AS osm
  -- Normalize both scalerank and labelrank into a ranking system from 1 to 6.
  SET "rank" = LEAST(6, CEILING((scalerank + labelrank + datarank)/3.0))
  FROM important_state_point AS ne
  WHERE osm.osm_id = ne.osm_id;

  -- TODO: This shouldn't be necessary? The rank function makes something wrong...
  UPDATE :use_schema.osm_state_point AS osm
  SET "rank" = 1
  WHERE "rank" = 0;

  DELETE FROM :use_schema.osm_state_point WHERE "rank" IS NULL;

  UPDATE :use_schema.osm_state_point
  SET tags = update_tags(tags, geometry)
  WHERE COALESCE(tags->'name:latin', tags->'name:nonlatin', tags->'name_int') IS NULL;

END;
$$ LANGUAGE plpgsql;

SELECT :use_schema.update_osm_state_point();

-- ALTER TABLE osm_state_point ADD CONSTRAINT osm_state_point_rank_constraint CHECK("rank" BETWEEN 1 AND 6);
CREATE INDEX IF NOT EXISTS osm_state_point_rank_idx ON :use_schema.osm_state_point("rank");


-- Layer place - ./update_city_point.sql

CREATE OR REPLACE FUNCTION :use_schema.update_osm_city_point() RETURNS VOID AS $$
BEGIN

  -- Clear  OSM key:rank ( https://github.com/openmaptiles/openmaptiles/issues/108 )
  -- etldoc: osm_city_point          -> osm_city_point
  UPDATE :use_schema.osm_city_point AS osm  SET "rank" = NULL WHERE "rank" IS NOT NULL;

  -- etldoc: ne_10m_populated_places -> osm_city_point
  -- etldoc: osm_city_point          -> osm_city_point

  WITH important_city_point AS (
      SELECT osm.geometry, osm.osm_id, osm.name, osm.name_en, ne.scalerank, ne.labelrank
      FROM mapdata_prod.ne_10m_populated_places AS ne, :use_schema.osm_city_point AS osm
      WHERE
      (
          (osm.tags ? 'wikidata' AND osm.tags->'wikidata' = ne.wikidataid) OR
          ne.name ILIKE osm.name OR
          ne.name ILIKE osm.name_en OR
          ne.namealt ILIKE osm.name OR
          ne.namealt ILIKE osm.name_en OR
          ne.meganame ILIKE osm.name OR
          ne.meganame ILIKE osm.name_en OR
          ne.gn_ascii ILIKE osm.name OR
          ne.gn_ascii ILIKE osm.name_en OR
          ne.nameascii ILIKE osm.name OR
          ne.nameascii ILIKE osm.name_en OR
          ne.name = unaccent(osm.name)
      )
      AND osm.place IN ('city', 'town', 'village')
      AND ST_DWithin(ne.geometry, osm.geometry, 50000)
  )
  UPDATE :use_schema.osm_city_point AS osm
  -- Move scalerank to range 1 to 10 and merge scalerank 5 with 6 since not enough cities
  -- are in the scalerank 5 bucket
  SET "rank" = CASE WHEN scalerank <= 5 THEN scalerank + 1 ELSE scalerank END
  FROM important_city_point AS ne
  WHERE osm.osm_id = ne.osm_id;

  UPDATE :use_schema.osm_city_point
  SET tags = update_tags(tags, geometry)
  WHERE COALESCE(tags->'name:latin', tags->'name:nonlatin', tags->'name_int') IS NULL;

END;
$$ LANGUAGE plpgsql;

SELECT :use_schema.update_osm_city_point();

CREATE INDEX IF NOT EXISTS osm_city_point_rank_idx ON :use_schema.osm_city_point("rank");

-- Layer place - ./layer.sql

DO $$ BEGIN RAISE NOTICE 'Finished layer place'; END$$;
