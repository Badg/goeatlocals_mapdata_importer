DO $$ BEGIN RAISE NOTICE 'Processing layer aerodrome_label'; END$$;

-- Layer aerodrome_label - ./update_aerodrome_label_point.sql

DROP TRIGGER IF EXISTS trigger_flag ON osm_aerodrome_label_point;
DROP TRIGGER IF EXISTS trigger_refresh ON aerodrome_label.updates;

-- etldoc: osm_aerodrome_label_point -> osm_aerodrome_label_point
CREATE OR REPLACE FUNCTION update_aerodrome_label_point() RETURNS VOID AS $$
BEGIN
  UPDATE osm_aerodrome_label_point
  SET geometry = ST_Centroid(geometry)
  WHERE ST_GeometryType(geometry) <> 'ST_Point';

  UPDATE osm_aerodrome_label_point
  SET tags = update_tags(tags, geometry)
  WHERE COALESCE(tags->'name:latin', tags->'name:nonlatin', tags->'name_int') IS NULL;
END;
$$ LANGUAGE plpgsql;

SELECT update_aerodrome_label_point();

-- Handle updates

CREATE SCHEMA IF NOT EXISTS aerodrome_label;

CREATE TABLE IF NOT EXISTS aerodrome_label.updates(id serial primary key, t text, unique (t));
CREATE OR REPLACE FUNCTION aerodrome_label.flag() RETURNS trigger AS $$
BEGIN
    INSERT INTO aerodrome_label.updates(t) VALUES ('y')  ON CONFLICT(t) DO NOTHING;
    RETURN null;
END;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION aerodrome_label.refresh() RETURNS trigger AS
  $BODY$
  BEGIN
    RAISE LOG 'Refresh aerodrome_label';
    PERFORM update_aerodrome_label_point();
    DELETE FROM aerodrome_label.updates;
    RETURN null;
  END;
  $BODY$
language plpgsql;

CREATE TRIGGER trigger_flag
    AFTER INSERT OR UPDATE OR DELETE ON osm_aerodrome_label_point
    FOR EACH STATEMENT
    EXECUTE PROCEDURE aerodrome_label.flag();

CREATE CONSTRAINT TRIGGER trigger_refresh
    AFTER INSERT ON aerodrome_label.updates
    INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE PROCEDURE aerodrome_label.refresh();

-- Layer aerodrome_label - ./layer.sql


-- etldoc: layer_aerodrome_label[shape=record fillcolor=lightpink, style="rounded,filled", label="layer_aerodrome_label | <z10_> z10+" ] ;

CREATE OR REPLACE FUNCTION layer_aerodrome_label(
    bbox geometry,
    zoom_level integer,
    pixel_width numeric)
  RETURNS TABLE(
    osm_id bigint,
    geometry geometry,
    name text,
    name_en text,
    name_de text,
    tags hstore,
    class text,
    iata text,
    icao text,
    ele int,
    ele_ft int) AS
$$
  -- etldoc: osm_aerodrome_label_point -> layer_aerodrome_label:z10_
  SELECT
    osm_id,
    geometry,
    name,
    COALESCE(NULLIF(name_en, ''), name) AS name_en,
    COALESCE(NULLIF(name_de, ''), name, name_en) AS name_de,
    tags,
    CASE
      WHEN "aerodrome" = 'international'
          OR "aerodrome_type" = 'international'
          THEN 'international'
      WHEN "aerodrome" = 'public'
          OR "aerodrome_type" = 'civil'
          OR "aerodrome_type" LIKE '%public%'
          THEN 'public'
      WHEN "aerodrome" = 'regional'
          OR "aerodrome_type" = 'regional'
          THEN 'regional'
      WHEN "aerodrome" = 'military'
          OR "aerodrome_type" LIKE '%military%'
          OR "military" = 'airfield'
          THEN 'military'
      WHEN "aerodrome" = 'private'
          OR "aerodrome_type" = 'private'
          THEN 'private'
      ELSE 'other'
    END AS class,
    NULLIF(iata, '') AS iata,
    NULLIF(icao, '') AS icao,
    substring(ele from E'^(-?\\d+)(\\D|$)')::int AS ele,
    round(substring(ele from E'^(-?\\d+)(\\D|$)')::int*3.2808399)::int AS ele_ft
  FROM osm_aerodrome_label_point
  WHERE geometry && bbox AND zoom_level >= 10;
$$
LANGUAGE SQL
IMMUTABLE PARALLEL SAFE;

DO $$ BEGIN RAISE NOTICE 'Finished layer aerodrome_label'; END$$;
