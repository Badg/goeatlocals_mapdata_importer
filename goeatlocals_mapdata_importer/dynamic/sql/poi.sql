DO $$ BEGIN RAISE NOTICE 'Processing layer poi'; END$$;


DROP MATERIALIZED VIEW IF EXISTS __use_schema__.osm_poi_stop_centroid CASCADE;
CREATE MATERIALIZED VIEW __use_schema__.osm_poi_stop_centroid AS (
  SELECT
      uic_ref,
      count(*) as count,
      CASE WHEN count(*) > 2 THEN ST_Centroid(ST_UNION(geometry)) END AS centroid
  FROM __use_schema__.osm_poi_point
	WHERE
		nullif(uic_ref, '') IS NOT NULL
		AND subclass IN ('bus_stop', 'bus_station', 'tram_stop', 'subway')
	GROUP BY
		uic_ref
	HAVING
		count(*) > 1
) /* DELAY_MATERIALIZED_VIEW_CREATION */;

DROP MATERIALIZED VIEW IF EXISTS __use_schema__.osm_poi_stop_rank CASCADE;
CREATE MATERIALIZED VIEW __use_schema__.osm_poi_stop_rank AS (
	SELECT
		p.osm_id,
-- 		p.uic_ref,
-- 		p.subclass,
		ROW_NUMBER()
		OVER (
			PARTITION BY p.uic_ref
			ORDER BY
				p.subclass :: public_transport_stop_type NULLS LAST,
				ST_Distance(c.centroid, p.geometry)
		) AS rk
	FROM __use_schema__.osm_poi_point p
		INNER JOIN __use_schema__.osm_poi_stop_centroid c ON (p.uic_ref = c.uic_ref)
	WHERE
		subclass IN ('bus_stop', 'bus_station', 'tram_stop', 'subway')
	ORDER BY p.uic_ref, rk
) /* DELAY_MATERIALIZED_VIEW_CREATION */;


BEGIN;
    UPDATE __use_schema__.osm_poi_polygon
    SET geometry = normalize_poi_polygon_geo(geometry);

    UPDATE __use_schema__.osm_poi_point
    SET subclass = normalize_osm_poi_subclass(station, subclass, funicular);

    UPDATE __use_schema__.osm_poi_polygon
    SET tags = update_tags(tags, geometry)
    WHERE COALESCE(tags->'name:latin', tags->'name:nonlatin', tags->'name_int') IS NULL;

    ANALYZE __use_schema__.osm_poi_polygon;
END;


BEGIN;
    ALTER TABLE __use_schema__.osm_poi_point
    ADD COLUMN IF NOT EXISTS agg_stop INTEGER DEFAULT NULL;

    UPDATE __use_schema__.osm_poi_point
    SET subclass = normalize_osm_poi_subclass(station, subclass, funicular);

    UPDATE __use_schema__.osm_poi_point
    SET tags = update_tags(tags, geometry)
    WHERE COALESCE(tags->'name:latin', tags->'name:nonlatin', tags->'name_int') IS NULL;

    UPDATE __use_schema__.osm_poi_point p
    SET agg_stop = normalize_osm_poi_point_agg(p.subclass, r.rk)
    FROM __use_schema__.osm_poi_stop_rank r
    WHERE p.osm_id = r.osm_id;

END;

DO $$ BEGIN RAISE NOTICE 'Finished layer poi'; END$$;
