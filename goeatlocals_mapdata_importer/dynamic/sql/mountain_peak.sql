DO $$ BEGIN RAISE NOTICE 'Processing layer mountain_peak'; END$$;


BEGIN;
  UPDATE __use_schema__.osm_peak_point
  SET tags = update_tags(tags, geometry)
  WHERE COALESCE(tags->'name:latin', tags->'name:nonlatin', tags->'name_int') IS NULL;
END;

-- Layer mountain_peak - ./layer.sql

DO $$ BEGIN RAISE NOTICE 'Finished layer mountain_peak'; END$$;
