DO $$ BEGIN RAISE NOTICE 'Processing layer park'; END$$;

-- Layer park - ./update_park_polygon.sql

ALTER TABLE __use_schema__.osm_park_polygon ADD COLUMN IF NOT EXISTS geometry_point geometry;
ALTER TABLE __use_schema__.osm_park_polygon_gen1 ADD COLUMN IF NOT EXISTS geometry_point geometry;
ALTER TABLE __use_schema__.osm_park_polygon_gen2 ADD COLUMN IF NOT EXISTS geometry_point geometry;
ALTER TABLE __use_schema__.osm_park_polygon_gen3 ADD COLUMN IF NOT EXISTS geometry_point geometry;
ALTER TABLE __use_schema__.osm_park_polygon_gen4 ADD COLUMN IF NOT EXISTS geometry_point geometry;
ALTER TABLE __use_schema__.osm_park_polygon_gen5 ADD COLUMN IF NOT EXISTS geometry_point geometry;
ALTER TABLE __use_schema__.osm_park_polygon_gen6 ADD COLUMN IF NOT EXISTS geometry_point geometry;
ALTER TABLE __use_schema__.osm_park_polygon_gen7 ADD COLUMN IF NOT EXISTS geometry_point geometry;
ALTER TABLE __use_schema__.osm_park_polygon_gen8 ADD COLUMN IF NOT EXISTS geometry_point geometry;

-- etldoc:  __use_schema__.osm_park_polygon ->  __use_schema__.osm_park_polygon
-- etldoc:  __use_schema__.osm_park_polygon_gen1 ->  __use_schema__.osm_park_polygon_gen1
-- etldoc:  __use_schema__.osm_park_polygon_gen2 ->  __use_schema__.osm_park_polygon_gen2
-- etldoc:  __use_schema__.osm_park_polygon_gen3 ->  __use_schema__.osm_park_polygon_gen3
-- etldoc:  __use_schema__.osm_park_polygon_gen4 ->  __use_schema__.osm_park_polygon_gen4
-- etldoc:  __use_schema__.osm_park_polygon_gen5 ->  __use_schema__.osm_park_polygon_gen5
-- etldoc:  __use_schema__.osm_park_polygon_gen6 ->  __use_schema__.osm_park_polygon_gen6
-- etldoc:  __use_schema__.osm_park_polygon_gen7 ->  __use_schema__.osm_park_polygon_gen7
-- etldoc:  __use_schema__.osm_park_polygon_gen8 ->  __use_schema__.osm_park_polygon_gen8
BEGIN;
  UPDATE __use_schema__.osm_park_polygon
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

  UPDATE __use_schema__.osm_park_polygon_gen1
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

  UPDATE __use_schema__.osm_park_polygon_gen2
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

  UPDATE __use_schema__.osm_park_polygon_gen3
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

  UPDATE __use_schema__.osm_park_polygon_gen4
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

  UPDATE __use_schema__.osm_park_polygon_gen5
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

  UPDATE __use_schema__.osm_park_polygon_gen6
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

  UPDATE __use_schema__.osm_park_polygon_gen7
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

  UPDATE __use_schema__.osm_park_polygon_gen8
  SET tags = update_tags(tags, geometry),
      geometry_point = st_centroid(geometry);

END;

CREATE INDEX IF NOT EXISTS osm_park_polygon_point_geom_idx ON __use_schema__.osm_park_polygon USING gist(geometry_point);
CREATE INDEX IF NOT EXISTS osm_park_polygon_gen1_point_geom_idx ON __use_schema__.osm_park_polygon_gen1 USING gist(geometry_point);
CREATE INDEX IF NOT EXISTS osm_park_polygon_gen2_point_geom_idx ON __use_schema__.osm_park_polygon_gen2 USING gist(geometry_point);
CREATE INDEX IF NOT EXISTS osm_park_polygon_gen3_point_geom_idx ON __use_schema__.osm_park_polygon_gen3 USING gist(geometry_point);
CREATE INDEX IF NOT EXISTS osm_park_polygon_gen4_point_geom_idx ON __use_schema__.osm_park_polygon_gen4 USING gist(geometry_point);
CREATE INDEX IF NOT EXISTS osm_park_polygon_gen5_point_geom_idx ON __use_schema__.osm_park_polygon_gen5 USING gist(geometry_point);
CREATE INDEX IF NOT EXISTS osm_park_polygon_gen6_point_geom_idx ON __use_schema__.osm_park_polygon_gen6 USING gist(geometry_point);
CREATE INDEX IF NOT EXISTS osm_park_polygon_gen7_point_geom_idx ON __use_schema__.osm_park_polygon_gen7 USING gist(geometry_point);
CREATE INDEX IF NOT EXISTS osm_park_polygon_gen8_point_geom_idx ON __use_schema__.osm_park_polygon_gen8 USING gist(geometry_point);

DO $$ BEGIN RAISE NOTICE 'Finished layer park'; END; $$;
