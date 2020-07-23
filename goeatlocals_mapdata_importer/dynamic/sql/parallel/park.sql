DO $$ BEGIN RAISE NOTICE 'Processing layer park'; END$$;

-- Layer park - ./update_park_polygon.sql

ALTER TABLE osm_park_polygon ADD COLUMN IF NOT EXISTS geometry_point geometry;
ALTER TABLE osm_park_polygon_gen1 ADD COLUMN IF NOT EXISTS geometry_point geometry;
ALTER TABLE osm_park_polygon_gen2 ADD COLUMN IF NOT EXISTS geometry_point geometry;
ALTER TABLE osm_park_polygon_gen3 ADD COLUMN IF NOT EXISTS geometry_point geometry;
ALTER TABLE osm_park_polygon_gen4 ADD COLUMN IF NOT EXISTS geometry_point geometry;
ALTER TABLE osm_park_polygon_gen5 ADD COLUMN IF NOT EXISTS geometry_point geometry;
ALTER TABLE osm_park_polygon_gen6 ADD COLUMN IF NOT EXISTS geometry_point geometry;
ALTER TABLE osm_park_polygon_gen7 ADD COLUMN IF NOT EXISTS geometry_point geometry;
ALTER TABLE osm_park_polygon_gen8 ADD COLUMN IF NOT EXISTS geometry_point geometry;
DROP TRIGGER IF EXISTS update_row ON osm_park_polygon;
DROP TRIGGER IF EXISTS update_row ON osm_park_polygon_gen1;
DROP TRIGGER IF EXISTS update_row ON osm_park_polygon_gen2;
DROP TRIGGER IF EXISTS update_row ON osm_park_polygon_gen3;
DROP TRIGGER IF EXISTS update_row ON osm_park_polygon_gen4;
DROP TRIGGER IF EXISTS update_row ON osm_park_polygon_gen5;
DROP TRIGGER IF EXISTS update_row ON osm_park_polygon_gen6;
DROP TRIGGER IF EXISTS update_row ON osm_park_polygon_gen7;
DROP TRIGGER IF EXISTS update_row ON osm_park_polygon_gen8;

-- etldoc:  osm_park_polygon ->  osm_park_polygon
-- etldoc:  osm_park_polygon_gen1 ->  osm_park_polygon_gen1
-- etldoc:  osm_park_polygon_gen2 ->  osm_park_polygon_gen2
-- etldoc:  osm_park_polygon_gen3 ->  osm_park_polygon_gen3
-- etldoc:  osm_park_polygon_gen4 ->  osm_park_polygon_gen4
-- etldoc:  osm_park_polygon_gen5 ->  osm_park_polygon_gen5
-- etldoc:  osm_park_polygon_gen6 ->  osm_park_polygon_gen6
-- etldoc:  osm_park_polygon_gen7 ->  osm_park_polygon_gen7
-- etldoc:  osm_park_polygon_gen8 ->  osm_park_polygon_gen8
CREATE OR REPLACE FUNCTION update_osm_park_polygon() RETURNS VOID AS $$
BEGIN
  UPDATE osm_park_polygon
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

  UPDATE osm_park_polygon_gen1
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

  UPDATE osm_park_polygon_gen2
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

  UPDATE osm_park_polygon_gen3
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

  UPDATE osm_park_polygon_gen4
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

  UPDATE osm_park_polygon_gen5
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

  UPDATE osm_park_polygon_gen6
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

  UPDATE osm_park_polygon_gen7
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

  UPDATE osm_park_polygon_gen8
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

END;
$$ LANGUAGE plpgsql;

SELECT update_osm_park_polygon();
CREATE INDEX IF NOT EXISTS osm_park_polygon_point_geom_idx ON osm_park_polygon USING gist(geometry_point);
CREATE INDEX IF NOT EXISTS osm_park_polygon_gen1_point_geom_idx ON osm_park_polygon_gen1 USING gist(geometry_point);
CREATE INDEX IF NOT EXISTS osm_park_polygon_gen2_point_geom_idx ON osm_park_polygon_gen2 USING gist(geometry_point);
CREATE INDEX IF NOT EXISTS osm_park_polygon_gen3_point_geom_idx ON osm_park_polygon_gen3 USING gist(geometry_point);
CREATE INDEX IF NOT EXISTS osm_park_polygon_gen4_point_geom_idx ON osm_park_polygon_gen4 USING gist(geometry_point);
CREATE INDEX IF NOT EXISTS osm_park_polygon_gen5_point_geom_idx ON osm_park_polygon_gen5 USING gist(geometry_point);
CREATE INDEX IF NOT EXISTS osm_park_polygon_gen6_point_geom_idx ON osm_park_polygon_gen6 USING gist(geometry_point);
CREATE INDEX IF NOT EXISTS osm_park_polygon_gen7_point_geom_idx ON osm_park_polygon_gen7 USING gist(geometry_point);
CREATE INDEX IF NOT EXISTS osm_park_polygon_gen8_point_geom_idx ON osm_park_polygon_gen8 USING gist(geometry_point);


CREATE OR REPLACE FUNCTION update_osm_park_polygon_row()
  RETURNS TRIGGER
AS
$BODY$
BEGIN
  NEW.tags = update_tags(NEW.tags, NEW.geometry);
  NEW.geometry_point = st_centroid(NEW.geometry);
  RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER update_row
BEFORE INSERT OR UPDATE ON osm_park_polygon
FOR EACH ROW
EXECUTE PROCEDURE update_osm_park_polygon_row();

CREATE TRIGGER update_row
BEFORE INSERT OR UPDATE ON osm_park_polygon_gen1
FOR EACH ROW
EXECUTE PROCEDURE update_osm_park_polygon_row();

CREATE TRIGGER update_row
BEFORE INSERT OR UPDATE ON osm_park_polygon_gen2
FOR EACH ROW
EXECUTE PROCEDURE update_osm_park_polygon_row();

CREATE TRIGGER update_row
BEFORE INSERT OR UPDATE ON osm_park_polygon_gen3
FOR EACH ROW
EXECUTE PROCEDURE update_osm_park_polygon_row();

CREATE TRIGGER update_row
BEFORE INSERT OR UPDATE ON osm_park_polygon_gen4
FOR EACH ROW
EXECUTE PROCEDURE update_osm_park_polygon_row();

CREATE TRIGGER update_row
BEFORE INSERT OR UPDATE ON osm_park_polygon_gen5
FOR EACH ROW
EXECUTE PROCEDURE update_osm_park_polygon_row();

CREATE TRIGGER update_row
BEFORE INSERT OR UPDATE ON osm_park_polygon_gen6
FOR EACH ROW
EXECUTE PROCEDURE update_osm_park_polygon_row();

CREATE TRIGGER update_row
BEFORE INSERT OR UPDATE ON osm_park_polygon_gen7
FOR EACH ROW
EXECUTE PROCEDURE update_osm_park_polygon_row();

CREATE TRIGGER update_row
BEFORE INSERT OR UPDATE ON osm_park_polygon_gen8
FOR EACH ROW
EXECUTE PROCEDURE update_osm_park_polygon_row();

-- Layer park - ./layer.sql

-- etldoc: layer_park[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_park |<z6> z6 |<z7> z7 |<z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14> z14+" ] ;

CREATE OR REPLACE FUNCTION layer_park(bbox geometry, zoom_level int, pixel_width numeric)
RETURNS TABLE(osm_id bigint, geometry geometry, class text, name text, name_en text, name_de text, tags hstore, rank int) AS $$
    SELECT osm_id, geometry, class, name, name_en, name_de, tags, rank
    FROM (
    SELECT osm_id, geometry,
        COALESCE(
            LOWER(REPLACE(NULLIF(protection_title, ''), ' ', '_')),
            NULLIF(boundary, ''),
            NULLIF(leisure, '')
        ) AS class,
        name, name_en, name_de, tags,
        NULL::int as rank
        FROM (
        -- etldoc: osm_park_polygon_gen8 -> layer_park:z6
        SELECT osm_id, geometry, name, name_en, name_de, tags, leisure, boundary, protection_title
        FROM osm_park_polygon_gen8
        WHERE zoom_level = 6 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_park_polygon_gen7 -> layer_park:z7
        SELECT osm_id, geometry, name, name_en, name_de, tags, leisure, boundary, protection_title
        FROM osm_park_polygon_gen7
        WHERE zoom_level = 7 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_park_polygon_gen6 -> layer_park:z8
        SELECT osm_id, geometry, name, name_en, name_de, tags, leisure, boundary, protection_title
        FROM osm_park_polygon_gen6
        WHERE zoom_level = 8 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_park_polygon_gen5 -> layer_park:z9
        SELECT osm_id, geometry, name, name_en, name_de, tags, leisure, boundary, protection_title
        FROM osm_park_polygon_gen5
        WHERE zoom_level = 9 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_park_polygon_gen4 -> layer_park:z10
        SELECT osm_id, geometry, name, name_en, name_de, tags, leisure, boundary, protection_title
        FROM osm_park_polygon_gen4
        WHERE zoom_level = 10 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_park_polygon_gen3 -> layer_park:z11
        SELECT osm_id, geometry, name, name_en, name_de, tags, leisure, boundary, protection_title
        FROM osm_park_polygon_gen3
        WHERE zoom_level = 11 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_park_polygon_gen2 -> layer_park:z12
        SELECT osm_id, geometry, name, name_en, name_de, tags, leisure, boundary, protection_title
        FROM osm_park_polygon_gen2
        WHERE zoom_level = 12 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_park_polygon_gen1 -> layer_park:z13
        SELECT osm_id, geometry, name, name_en, name_de, tags, leisure, boundary, protection_title
        FROM osm_park_polygon_gen1
        WHERE zoom_level = 13 AND geometry && bbox
        UNION ALL
        -- etldoc: osm_park_polygon -> layer_park:z14
        SELECT osm_id, geometry, name, name_en, name_de, tags, leisure, boundary, protection_title
        FROM osm_park_polygon
        WHERE zoom_level >= 14 AND geometry && bbox
    ) AS park_polygon

    UNION ALL
    SELECT osm_id, geometry_point AS geometry,
        COALESCE(
            LOWER(REPLACE(NULLIF(protection_title, ''), ' ', '_')),
            NULLIF(boundary, ''),
            NULLIF(leisure, '')
        ) AS class,
        name, name_en, name_de, tags,
        row_number() OVER (
           PARTITION BY LabelGrid(geometry_point, 100 * pixel_width)
           ORDER BY
               (CASE WHEN boundary = 'national_park' THEN true ELSE false END) DESC,
               (COALESCE(NULLIF(tags->'wikipedia', ''), NULLIF(tags->'wikidata', '')) IS NOT NULL) DESC,
               area DESC
        )::int AS "rank"
        FROM (
        -- etldoc: osm_park_polygon_gen8 -> layer_park:z6
        SELECT osm_id, geometry_point, name, name_en, name_de, tags, leisure, boundary, protection_title, area
        FROM osm_park_polygon_gen8
        WHERE zoom_level = 6 AND geometry_point && bbox
        UNION ALL

        -- etldoc: osm_park_polygon_gen7 -> layer_park:z7
        SELECT osm_id, geometry_point, name, name_en, name_de, tags, leisure, boundary, protection_title, area
        FROM osm_park_polygon_gen7
        WHERE zoom_level = 7 AND geometry_point && bbox
        UNION ALL

        -- etldoc: osm_park_polygon_gen6 -> layer_park:z8
        SELECT osm_id, geometry_point, name, name_en, name_de, tags, leisure, boundary, protection_title, area
        FROM osm_park_polygon_gen6
        WHERE zoom_level = 8 AND geometry_point && bbox
        UNION ALL

        -- etldoc: osm_park_polygon_gen5 -> layer_park:z9
        SELECT osm_id, geometry_point, name, name_en, name_de, tags, leisure, boundary, protection_title, area
        FROM osm_park_polygon_gen5
        WHERE zoom_level = 9 AND geometry_point && bbox
        UNION ALL

        -- etldoc: osm_park_polygon_gen4 -> layer_park:z10
        SELECT osm_id, geometry_point, name, name_en, name_de, tags, leisure, boundary, protection_title, area
        FROM osm_park_polygon_gen4
        WHERE zoom_level = 10 AND geometry_point && bbox
        UNION ALL

        -- etldoc: osm_park_polygon_gen3 -> layer_park:z11
        SELECT osm_id, geometry_point, name, name_en, name_de, tags, leisure, boundary, protection_title, area
        FROM osm_park_polygon_gen3
        WHERE zoom_level = 11 AND geometry_point && bbox
        UNION ALL

        -- etldoc: osm_park_polygon_gen2 -> layer_park:z12
        SELECT osm_id, geometry_point, name, name_en, name_de, tags, leisure, boundary, protection_title, area
        FROM osm_park_polygon_gen2
        WHERE zoom_level = 12 AND geometry_point && bbox
        UNION ALL

        -- etldoc: osm_park_polygon_gen1 -> layer_park:z13
        SELECT osm_id, geometry_point, name, name_en, name_de, tags, leisure, boundary, protection_title, area
        FROM osm_park_polygon_gen1
        WHERE zoom_level = 13 AND geometry_point && bbox
        UNION ALL

        -- etldoc: osm_park_polygon -> layer_park:z14
        SELECT osm_id, geometry_point, name, name_en, name_de, tags, leisure, boundary, protection_title, area
        FROM osm_park_polygon
        WHERE zoom_level >= 14 AND geometry_point && bbox
    ) AS park_point
    ) AS park_all;
$$
LANGUAGE SQL
IMMUTABLE PARALLEL SAFE;

DO $$ BEGIN RAISE NOTICE 'Finished layer park'; END$$;
