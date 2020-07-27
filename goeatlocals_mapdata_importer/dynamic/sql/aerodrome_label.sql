DO $$ BEGIN RAISE NOTICE 'Processing layer aerodrome_label'; END$$;

-- Layer aerodrome_label - ./update_aerodrome_label_point.sql
BEGIN;
    UPDATE __use_schema__.osm_aerodrome_label_point
    SET geometry = normalize_aerodrome_label_point(geometry);

    UPDATE __use_schema__.osm_aerodrome_label_point
    SET tags = update_tags(tags, geometry)
    WHERE COALESCE(tags->'name:latin', tags->'name:nonlatin', tags->'name_int') IS NULL;
END;

DO $$ BEGIN RAISE NOTICE 'Finished layer aerodrome_label'; END$$;
