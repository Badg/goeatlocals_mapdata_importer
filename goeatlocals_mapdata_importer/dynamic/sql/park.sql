DO $$ BEGIN RAISE NOTICE 'Processing layer park'; END$$;

-- Layer park - ./update_park_polygon.sql

ALTER TABLE :use_schema.osm_park_polygon ADD COLUMN IF NOT EXISTS geometry_point geometry;
ALTER TABLE :use_schema.osm_park_polygon_gen1 ADD COLUMN IF NOT EXISTS geometry_point geometry;
ALTER TABLE :use_schema.osm_park_polygon_gen2 ADD COLUMN IF NOT EXISTS geometry_point geometry;
ALTER TABLE :use_schema.osm_park_polygon_gen3 ADD COLUMN IF NOT EXISTS geometry_point geometry;
ALTER TABLE :use_schema.osm_park_polygon_gen4 ADD COLUMN IF NOT EXISTS geometry_point geometry;
ALTER TABLE :use_schema.osm_park_polygon_gen5 ADD COLUMN IF NOT EXISTS geometry_point geometry;
ALTER TABLE :use_schema.osm_park_polygon_gen6 ADD COLUMN IF NOT EXISTS geometry_point geometry;
ALTER TABLE :use_schema.osm_park_polygon_gen7 ADD COLUMN IF NOT EXISTS geometry_point geometry;
ALTER TABLE :use_schema.osm_park_polygon_gen8 ADD COLUMN IF NOT EXISTS geometry_point geometry;

-- etldoc:  :use_schema.osm_park_polygon ->  :use_schema.osm_park_polygon
-- etldoc:  :use_schema.osm_park_polygon_gen1 ->  :use_schema.osm_park_polygon_gen1
-- etldoc:  :use_schema.osm_park_polygon_gen2 ->  :use_schema.osm_park_polygon_gen2
-- etldoc:  :use_schema.osm_park_polygon_gen3 ->  :use_schema.osm_park_polygon_gen3
-- etldoc:  :use_schema.osm_park_polygon_gen4 ->  :use_schema.osm_park_polygon_gen4
-- etldoc:  :use_schema.osm_park_polygon_gen5 ->  :use_schema.osm_park_polygon_gen5
-- etldoc:  :use_schema.osm_park_polygon_gen6 ->  :use_schema.osm_park_polygon_gen6
-- etldoc:  :use_schema.osm_park_polygon_gen7 ->  :use_schema.osm_park_polygon_gen7
-- etldoc:  :use_schema.osm_park_polygon_gen8 ->  :use_schema.osm_park_polygon_gen8
BEGIN
  UPDATE :use_schema.osm_park_polygon
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

  UPDATE :use_schema.osm_park_polygon_gen1
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

  UPDATE :use_schema.osm_park_polygon_gen2
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

  UPDATE :use_schema.osm_park_polygon_gen3
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

  UPDATE :use_schema.osm_park_polygon_gen4
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

  UPDATE :use_schema.osm_park_polygon_gen5
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

  UPDATE :use_schema.osm_park_polygon_gen6
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

  UPDATE :use_schema.osm_park_polygon_gen7
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

  UPDATE :use_schema.osm_park_polygon_gen8
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

END;

SELECT update_osm_park_polygon();
CREATE INDEX IF NOT EXISTS osm_park_polygon_point_geom_idx ON :use_schema.osm_park_polygon USING gist(geometry_point);
CREATE INDEX IF NOT EXISTS osm_park_polygon_gen1_point_geom_idx ON :use_schema.osm_park_polygon_gen1 USING gist(geometry_point);
CREATE INDEX IF NOT EXISTS osm_park_polygon_gen2_point_geom_idx ON :use_schema.osm_park_polygon_gen2 USING gist(geometry_point);
CREATE INDEX IF NOT EXISTS osm_park_polygon_gen3_point_geom_idx ON :use_schema.osm_park_polygon_gen3 USING gist(geometry_point);
CREATE INDEX IF NOT EXISTS osm_park_polygon_gen4_point_geom_idx ON :use_schema.osm_park_polygon_gen4 USING gist(geometry_point);
CREATE INDEX IF NOT EXISTS osm_park_polygon_gen5_point_geom_idx ON :use_schema.osm_park_polygon_gen5 USING gist(geometry_point);
CREATE INDEX IF NOT EXISTS osm_park_polygon_gen6_point_geom_idx ON :use_schema.osm_park_polygon_gen6 USING gist(geometry_point);
CREATE INDEX IF NOT EXISTS osm_park_polygon_gen7_point_geom_idx ON :use_schema.osm_park_polygon_gen7 USING gist(geometry_point);
CREATE INDEX IF NOT EXISTS osm_park_polygon_gen8_point_geom_idx ON :use_schema.osm_park_polygon_gen8 USING gist(geometry_point);

DO $$ BEGIN RAISE NOTICE 'Finished layer park'; END; $$;
