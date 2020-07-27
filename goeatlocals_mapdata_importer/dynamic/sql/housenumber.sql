DO $$ BEGIN RAISE NOTICE 'Processing layer housenumber'; END$$;

BEGIN;
    UPDATE __use_schema__.osm_housenumber_point
    SET geometry = normalize_housenumber_point(geometry);
END;

DO $$ BEGIN RAISE NOTICE 'Finished layer housenumber'; END$$;
