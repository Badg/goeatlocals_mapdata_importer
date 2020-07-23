DO $$ BEGIN RAISE NOTICE 'Processing layer transportation'; END$$;

-- Layer transportation - ./class.sql

CREATE OR REPLACE FUNCTION brunnel(is_bridge BOOL, is_tunnel BOOL, is_ford BOOL) RETURNS TEXT AS $$
    SELECT CASE
        WHEN is_bridge THEN 'bridge'
        WHEN is_tunnel THEN 'tunnel'
        WHEN is_ford THEN 'ford'
    END;
$$
LANGUAGE SQL
IMMUTABLE STRICT PARALLEL SAFE;

-- The classes for highways are derived from the classes used in ClearTables
-- https://github.com/ClearTables/ClearTables/blob/master/transportation.lua
CREATE OR REPLACE FUNCTION highway_class(highway TEXT, public_transport TEXT, construction TEXT) RETURNS TEXT AS $$
    SELECT CASE
        WHEN "highway" IN ('motorway', 'motorway_link') THEN 'motorway'
        WHEN "highway" IN ('trunk', 'trunk_link') THEN 'trunk'
        WHEN "highway" IN ('primary', 'primary_link') THEN 'primary'
        WHEN "highway" IN ('secondary', 'secondary_link') THEN 'secondary'
        WHEN "highway" IN ('tertiary', 'tertiary_link') THEN 'tertiary'
        WHEN "highway" IN ('unclassified', 'residential', 'living_street', 'road') THEN 'minor'
        WHEN "highway" IN ('pedestrian', 'path', 'footway', 'cycleway', 'steps', 'bridleway', 'corridor')
            OR "public_transport" = 'platform'
            THEN 'path'
        WHEN "highway" = 'service' THEN 'service'
        WHEN "highway" = 'track' THEN 'track'
        WHEN "highway" = 'raceway' THEN 'raceway'
        WHEN "highway" = 'construction'
            AND "construction" IN ('motorway', 'motorway_link')
            THEN 'motorway_construction'
        WHEN "highway" = 'construction'
            AND "construction" IN ('trunk', 'trunk_link')
            THEN 'trunk_construction'
        WHEN "highway" = 'construction'
            AND "construction" IN ('primary', 'primary_link')
            THEN 'primary_construction'
        WHEN "highway" = 'construction'
            AND "construction" IN ('secondary', 'secondary_link')
            THEN 'secondary_construction'
        WHEN "highway" = 'construction'
            AND "construction" IN ('tertiary', 'tertiary_link')
            THEN 'tertiary_construction'
        WHEN "highway" = 'construction'
            AND "construction" IN ('', 'unclassified', 'residential', 'living_street', 'road')
            THEN 'minor_construction'
        WHEN "highway" = 'construction'
            AND ("construction" IN ('pedestrian', 'path', 'footway', 'cycleway', 'steps', 'bridleway', 'corridor') OR "public_transport" = 'platform')
            THEN 'path_construction'
        WHEN "highway" = 'construction'
            AND "construction" = 'service'
            THEN 'service_construction'
        WHEN "highway" = 'construction'
            AND "construction" = 'track'
            THEN 'track_construction'
        WHEN "highway" = 'construction'
            AND "construction" = 'raceway'
            THEN 'raceway_construction'
    END;
$$
LANGUAGE SQL
IMMUTABLE PARALLEL SAFE;

-- The classes for railways are derived from the classes used in ClearTables
-- https://github.com/ClearTables/ClearTables/blob/master/transportation.lua
CREATE OR REPLACE FUNCTION railway_class(railway TEXT) RETURNS TEXT AS $$
    SELECT CASE
        WHEN railway IN ('rail', 'narrow_gauge', 'preserved', 'funicular') THEN 'rail'
        WHEN railway IN ('subway', 'light_rail', 'monorail', 'tram') THEN 'transit'
    END;
$$
LANGUAGE SQL
IMMUTABLE STRICT PARALLEL SAFE;

-- Limit service to only the most important values to ensure
-- we always know the values of service
CREATE OR REPLACE FUNCTION service_value(service TEXT) RETURNS TEXT AS $$
    SELECT CASE
        WHEN service IN ('spur', 'yard', 'siding', 'crossover', 'driveway', 'alley', 'parking_aisle') THEN service
    END;
$$
LANGUAGE SQL
IMMUTABLE STRICT PARALLEL SAFE;

-- Limit surface to only the most important values to ensure
-- we always know the values of surface
CREATE OR REPLACE FUNCTION surface_value(surface TEXT) RETURNS TEXT AS $$
    SELECT CASE
        WHEN surface IN ('paved', 'asphalt', 'cobblestone', 'concrete', 'concrete:lanes', 'concrete:plates', 'metal', 'paving_stones', 'sett', 'unhewn_cobblestone', 'wood') THEN 'paved'
        WHEN surface IN ('unpaved', 'compacted', 'dirt', 'earth', 'fine_gravel', 'grass', 'grass_paver', 'gravel', 'gravel_turf', 'ground', 'ice', 'mud', 'pebblestone', 'salt', 'sand', 'snow', 'woodchips') THEN 'unpaved'
    END;
$$
LANGUAGE SQL
IMMUTABLE STRICT PARALLEL SAFE;

-- Layer transportation - ./update_transportation_merge.sql

DROP MATERIALIZED VIEW IF EXISTS osm_transportation_merge_linestring CASCADE;
DROP MATERIALIZED VIEW IF EXISTS osm_transportation_merge_linestring_gen3 CASCADE;
DROP MATERIALIZED VIEW IF EXISTS osm_transportation_merge_linestring_gen4 CASCADE;
DROP MATERIALIZED VIEW IF EXISTS osm_transportation_merge_linestring_gen5 CASCADE;
DROP MATERIALIZED VIEW IF EXISTS osm_transportation_merge_linestring_gen6 CASCADE;
DROP MATERIALIZED VIEW IF EXISTS osm_transportation_merge_linestring_gen7 CASCADE;


DROP TRIGGER IF EXISTS trigger_flag_transportation ON osm_highway_linestring;
DROP TRIGGER IF EXISTS trigger_refresh ON transportation.updates;

-- Instead of using relations to find out the road names we
-- stitch together the touching ways with the same name
-- to allow for nice label rendering
-- Because this works well for roads that do not have relations as well


-- Improve performance of the sql in transportation_name/network_type.sql
CREATE INDEX IF NOT EXISTS osm_highway_linestring_highway_idx
  ON osm_highway_linestring(highway);

-- Improve performance of the sql below
CREATE INDEX IF NOT EXISTS osm_highway_linestring_highway_partial_idx
  ON osm_highway_linestring(highway)
  WHERE highway IN ('motorway','trunk', 'primary', 'construction');

  -- etldoc: osm_highway_linestring ->  osm_transportation_merge_linestring
CREATE MATERIALIZED VIEW osm_transportation_merge_linestring AS (
    SELECT
        (ST_Dump(geometry)).geom AS geometry,
        NULL::bigint AS osm_id,
        highway, construction,
        z_order
    FROM (
      SELECT
          ST_LineMerge(ST_Collect(geometry)) AS geometry,
          highway, construction,
          min(z_order) AS z_order
      FROM osm_highway_linestring
      WHERE (highway IN ('motorway','trunk', 'primary') OR highway = 'construction' AND construction IN ('motorway','trunk', 'primary'))
          AND ST_IsValid(geometry)
      group by highway, construction
    ) AS highway_union
) /* DELAY_MATERIALIZED_VIEW_CREATION */;
CREATE INDEX IF NOT EXISTS osm_transportation_merge_linestring_geometry_idx
  ON osm_transportation_merge_linestring USING gist(geometry);
CREATE INDEX IF NOT EXISTS osm_transportation_merge_linestring_highway_partial_idx
  ON osm_transportation_merge_linestring(highway, construction)
  WHERE highway IN ('motorway','trunk', 'primary', 'construction');

-- etldoc: osm_transportation_merge_linestring -> osm_transportation_merge_linestring_gen3
CREATE MATERIALIZED VIEW osm_transportation_merge_linestring_gen3 AS (
    SELECT ST_Simplify(geometry, 120) AS geometry, osm_id, highway, construction, z_order
    FROM osm_transportation_merge_linestring
    WHERE highway IN ('motorway','trunk', 'primary')
      OR highway = 'construction' AND construction IN ('motorway','trunk', 'primary')
) /* DELAY_MATERIALIZED_VIEW_CREATION */;
CREATE INDEX IF NOT EXISTS osm_transportation_merge_linestring_gen3_geometry_idx
  ON osm_transportation_merge_linestring_gen3 USING gist(geometry);
CREATE INDEX IF NOT EXISTS osm_transportation_merge_linestring_gen3_highway_partial_idx
  ON osm_transportation_merge_linestring_gen3(highway, construction)
  WHERE highway IN ('motorway','trunk', 'primary', 'construction');

-- etldoc: osm_transportation_merge_linestring_gen3 -> osm_transportation_merge_linestring_gen4
CREATE MATERIALIZED VIEW osm_transportation_merge_linestring_gen4 AS (
    SELECT ST_Simplify(geometry, 200) AS geometry, osm_id, highway, construction, z_order
    FROM osm_transportation_merge_linestring_gen3
    WHERE (highway IN ('motorway','trunk', 'primary') OR highway = 'construction' AND construction IN ('motorway','trunk', 'primary'))
        AND ST_Length(geometry) > 50
) /* DELAY_MATERIALIZED_VIEW_CREATION */;
CREATE INDEX IF NOT EXISTS osm_transportation_merge_linestring_gen4_geometry_idx
  ON osm_transportation_merge_linestring_gen4 USING gist(geometry);
CREATE INDEX IF NOT EXISTS osm_transportation_merge_linestring_gen4_highway_partial_idx
  ON osm_transportation_merge_linestring_gen4(highway, construction)
  WHERE highway IN ('motorway','trunk', 'primary', 'construction');

-- etldoc: osm_transportation_merge_linestring_gen4 -> osm_transportation_merge_linestring_gen5
CREATE MATERIALIZED VIEW osm_transportation_merge_linestring_gen5 AS (
    SELECT ST_Simplify(geometry, 500) AS geometry, osm_id, highway, construction, z_order
    FROM osm_transportation_merge_linestring_gen4
    WHERE (highway IN ('motorway','trunk') OR highway = 'construction' AND construction IN ('motorway','trunk'))
        AND ST_Length(geometry) > 100
) /* DELAY_MATERIALIZED_VIEW_CREATION */;
CREATE INDEX IF NOT EXISTS osm_transportation_merge_linestring_gen5_geometry_idx
  ON osm_transportation_merge_linestring_gen5 USING gist(geometry);
CREATE INDEX IF NOT EXISTS osm_transportation_merge_linestring_gen5_highway_partial_idx
  ON osm_transportation_merge_linestring_gen5(highway, construction)
  WHERE highway IN ('motorway','trunk', 'construction');

-- etldoc: osm_transportation_merge_linestring_gen5 -> osm_transportation_merge_linestring_gen6
CREATE MATERIALIZED VIEW osm_transportation_merge_linestring_gen6 AS (
    SELECT ST_Simplify(geometry, 1000) AS geometry, osm_id, highway, construction, z_order
    FROM osm_transportation_merge_linestring_gen5
    WHERE (highway IN ('motorway','trunk') OR highway = 'construction' AND construction IN ('motorway','trunk')) AND ST_Length(geometry) > 500
) /* DELAY_MATERIALIZED_VIEW_CREATION */;
CREATE INDEX IF NOT EXISTS osm_transportation_merge_linestring_gen6_geometry_idx
  ON osm_transportation_merge_linestring_gen6 USING gist(geometry);
CREATE INDEX IF NOT EXISTS osm_transportation_merge_linestring_gen6_highway_partial_idx
  ON osm_transportation_merge_linestring_gen6(highway, construction)
  WHERE highway IN ('motorway','trunk', 'construction');

-- etldoc: osm_transportation_merge_linestring_gen6 -> osm_transportation_merge_linestring_gen7
CREATE MATERIALIZED VIEW osm_transportation_merge_linestring_gen7 AS (
    SELECT ST_Simplify(geometry, 2000) AS geometry, osm_id, highway, construction, z_order
    FROM osm_transportation_merge_linestring_gen6
    WHERE (highway = 'motorway' OR highway = 'construction' AND construction = 'motorway') AND ST_Length(geometry) > 1000
) /* DELAY_MATERIALIZED_VIEW_CREATION */;
CREATE INDEX IF NOT EXISTS osm_transportation_merge_linestring_gen7_geometry_idx
  ON osm_transportation_merge_linestring_gen7 USING gist(geometry);


-- Handle updates

CREATE SCHEMA IF NOT EXISTS transportation;

CREATE TABLE IF NOT EXISTS transportation.updates(id serial primary key, t text, unique (t));
CREATE OR REPLACE FUNCTION transportation.flag() RETURNS trigger AS $$
BEGIN
    INSERT INTO transportation.updates(t) VALUES ('y')  ON CONFLICT(t) DO NOTHING;
    RETURN null;
END;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION transportation.refresh() RETURNS trigger AS
  $BODY$
  BEGIN
    RAISE NOTICE 'Refresh transportation';
    REFRESH MATERIALIZED VIEW osm_transportation_merge_linestring;
    REFRESH MATERIALIZED VIEW osm_transportation_merge_linestring_gen3;
    REFRESH MATERIALIZED VIEW osm_transportation_merge_linestring_gen4;
    REFRESH MATERIALIZED VIEW osm_transportation_merge_linestring_gen5;
    REFRESH MATERIALIZED VIEW osm_transportation_merge_linestring_gen6;
    REFRESH MATERIALIZED VIEW osm_transportation_merge_linestring_gen7;
    DELETE FROM transportation.updates;
    RETURN null;
  END;
  $BODY$
language plpgsql;

CREATE TRIGGER trigger_flag_transportation
    AFTER INSERT OR UPDATE OR DELETE ON osm_highway_linestring
    FOR EACH STATEMENT
    EXECUTE PROCEDURE transportation.flag();

CREATE CONSTRAINT TRIGGER trigger_refresh
    AFTER INSERT ON transportation.updates
    INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE PROCEDURE transportation.refresh();

-- Layer transportation - ./layer.sql

CREATE OR REPLACE FUNCTION highway_is_link(highway TEXT) RETURNS BOOLEAN AS $$
    SELECT highway LIKE '%_link';
$$
LANGUAGE SQL
IMMUTABLE STRICT PARALLEL SAFE;


-- etldoc: layer_transportation[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="<sql> layer_transportation |<z4> z4 |<z5> z5 |<z6> z6 |<z7> z7 |<z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14_> z14+" ] ;
CREATE OR REPLACE FUNCTION layer_transportation(bbox geometry, zoom_level int)
RETURNS TABLE(osm_id bigint, geometry geometry, class text, subclass text,
ramp int, oneway int, brunnel TEXT, service TEXT, layer INT, level INT,
indoor INT, bicycle TEXT, foot TEXT, horse TEXT, mtb_scale TEXT, surface TEXT) AS $$
    SELECT
        osm_id, geometry,
        CASE
            WHEN NULLIF(highway, '') IS NOT NULL OR NULLIF(public_transport, '') IS NOT NULL THEN highway_class(highway, public_transport, construction)
            WHEN NULLIF(railway, '') IS NOT NULL THEN railway_class(railway)
            WHEN NULLIF(aerialway, '') IS NOT NULL THEN aerialway
            WHEN NULLIF(shipway, '') IS NOT NULL THEN shipway
            WHEN NULLIF(man_made, '') IS NOT NULL THEN man_made
        END AS class,
        CASE
            WHEN railway IS NOT NULL THEN railway
            WHEN (highway IS NOT NULL OR public_transport IS NOT NULL)
                AND highway_class(highway, public_transport, construction) = 'path'
                THEN COALESCE(NULLIF(public_transport, ''), highway)
        END AS subclass,
        -- All links are considered as ramps as well
        CASE WHEN highway_is_link(highway) OR highway = 'steps'
             THEN 1 ELSE is_ramp::int END AS ramp,
        is_oneway::int AS oneway,
        brunnel(is_bridge, is_tunnel, is_ford) AS brunnel,
        NULLIF(service, '') AS service,
        NULLIF(layer, 0) AS layer,
        "level",
        CASE WHEN indoor=TRUE THEN 1 END as indoor,
        NULLIF(bicycle, '') AS bicycle,
        NULLIF(foot, '') AS foot,
        NULLIF(horse, '') AS horse,
        NULLIF(mtb_scale, '') AS mtb_scale,
        NULLIF(surface, '') AS surface
    FROM (
        -- etldoc: osm_transportation_merge_linestring_gen7 -> layer_transportation:z4
        SELECT
            osm_id, geometry,
            highway, construction, NULL AS railway, NULL AS aerialway, NULL AS shipway,
            NULL AS public_transport, NULL AS service,
            NULL::boolean AS is_bridge, NULL::boolean AS is_tunnel,
            NULL::boolean AS is_ford,
            NULL::boolean AS is_ramp, NULL::int AS is_oneway, NULL as man_made,
            NULL::int AS layer, NULL::int AS level, NULL::boolean AS indoor,
            NULL as bicycle, NULL as foot, NULL as horse, NULL as mtb_scale,
            NULL AS surface, z_order
        FROM osm_transportation_merge_linestring_gen7
        WHERE zoom_level = 4
        UNION ALL

        -- etldoc: osm_transportation_merge_linestring_gen6 -> layer_transportation:z5
        SELECT
            osm_id, geometry,
            highway, construction, NULL AS railway, NULL AS aerialway, NULL AS shipway,
            NULL AS public_transport, NULL AS service,
            NULL::boolean AS is_bridge, NULL::boolean AS is_tunnel,
            NULL::boolean AS is_ford,
            NULL::boolean AS is_ramp, NULL::int AS is_oneway, NULL as man_made,
            NULL::int AS layer, NULL::int AS level, NULL::boolean AS indoor,
            NULL as bicycle, NULL as foot, NULL as horse, NULL as mtb_scale,
            NULL AS surface, z_order
        FROM osm_transportation_merge_linestring_gen6
        WHERE zoom_level = 5
        UNION ALL

        -- etldoc: osm_transportation_merge_linestring_gen5 -> layer_transportation:z6
        SELECT
            osm_id, geometry,
            highway, construction, NULL AS railway, NULL AS aerialway, NULL AS shipway,
            NULL AS public_transport, NULL AS service,
            NULL::boolean AS is_bridge, NULL::boolean AS is_tunnel,
            NULL::boolean AS is_ford,
            NULL::boolean AS is_ramp, NULL::int AS is_oneway, NULL as man_made,
            NULL::int AS layer, NULL::int AS level, NULL::boolean AS indoor,
            NULL as bicycle, NULL as foot, NULL as horse, NULL as mtb_scale,
            NULL AS surface, z_order
        FROM osm_transportation_merge_linestring_gen5
        WHERE zoom_level = 6
        UNION ALL

        -- etldoc: osm_transportation_merge_linestring_gen4  ->  layer_transportation:z7
        SELECT
            osm_id, geometry,
            highway, construction, NULL AS railway, NULL AS aerialway, NULL AS shipway,
            NULL AS public_transport, NULL AS service,
            NULL::boolean AS is_bridge, NULL::boolean AS is_tunnel,
            NULL::boolean AS is_ford,
            NULL::boolean AS is_ramp, NULL::int AS is_oneway, NULL as man_made,
            NULL::int AS layer, NULL::int AS level, NULL::boolean AS indoor,
            NULL as bicycle, NULL as foot, NULL as horse, NULL as mtb_scale,
            NULL AS surface, z_order
        FROM osm_transportation_merge_linestring_gen4
        WHERE zoom_level = 7
        UNION ALL

        -- etldoc: osm_transportation_merge_linestring_gen3  ->  layer_transportation:z8
        SELECT
            osm_id, geometry,
            highway, construction, NULL AS railway, NULL AS aerialway, NULL AS shipway,
            NULL AS public_transport, NULL AS service,
            NULL::boolean AS is_bridge, NULL::boolean AS is_tunnel,
            NULL::boolean AS is_ford,
            NULL::boolean AS is_ramp, NULL::int AS is_oneway, NULL as man_made,
            NULL::int AS layer, NULL::int AS level, NULL::boolean AS indoor,
            NULL as bicycle, NULL as foot, NULL as horse, NULL as mtb_scale,
            NULL AS surface, z_order
        FROM osm_transportation_merge_linestring_gen3
        WHERE zoom_level = 8
        UNION ALL

        -- etldoc: osm_highway_linestring_gen2  ->  layer_transportation:z9
        -- etldoc: osm_highway_linestring_gen2  ->  layer_transportation:z10
        SELECT
            osm_id, geometry,
            highway, construction, NULL AS railway, NULL AS aerialway, NULL AS shipway,
            NULL AS public_transport, NULL AS service,
            NULL::boolean AS is_bridge, NULL::boolean AS is_tunnel,
            NULL::boolean AS is_ford,
            NULL::boolean AS is_ramp, NULL::int AS is_oneway, NULL as man_made,
            layer, NULL::int AS level, NULL::boolean AS indoor,
            bicycle, foot, horse, mtb_scale,
            NULL AS surface, z_order
        FROM osm_highway_linestring_gen2
        WHERE zoom_level BETWEEN 9 AND 10
          AND st_length(geometry)>zres(11)
        UNION ALL

        -- etldoc: osm_highway_linestring_gen1  ->  layer_transportation:z11
        SELECT
            osm_id, geometry,
            highway, construction, NULL AS railway, NULL AS aerialway, NULL AS shipway,
            NULL AS public_transport, NULL AS service,
            NULL::boolean AS is_bridge, NULL::boolean AS is_tunnel,
            NULL::boolean AS is_ford,
            NULL::boolean AS is_ramp, NULL::int AS is_oneway, NULL as man_made,
            layer, NULL::int AS level, NULL::boolean AS indoor,
            bicycle, foot, horse, mtb_scale,
            NULL AS surface, z_order
        FROM osm_highway_linestring_gen1
        WHERE zoom_level = 11
          AND st_length(geometry)>zres(12)
        UNION ALL

        -- etldoc: osm_highway_linestring       ->  layer_transportation:z12
        -- etldoc: osm_highway_linestring       ->  layer_transportation:z13
        -- etldoc: osm_highway_linestring       ->  layer_transportation:z14_
        SELECT
            osm_id, geometry,
            highway, construction, NULL AS railway, NULL AS aerialway, NULL AS shipway,
            public_transport, service_value(service) AS service,
            is_bridge, is_tunnel, is_ford, is_ramp, is_oneway, man_made,
            layer,
            CASE WHEN highway IN ('footway', 'steps') THEN "level" END AS "level",
            CASE WHEN highway IN ('footway', 'steps') THEN indoor END AS indoor,
            bicycle, foot, horse, mtb_scale,
            surface_value(surface) AS "surface",
            z_order
        FROM osm_highway_linestring
        WHERE NOT is_area AND (
            zoom_level = 12 AND (
                highway_class(highway, public_transport, construction) NOT IN ('track', 'path', 'minor')
                OR highway IN ('unclassified', 'residential')
            ) AND man_made <> 'pier'
            OR zoom_level = 13
                AND (
                    highway_class(highway, public_transport, construction) NOT IN ('track', 'path') AND man_made <> 'pier'
                OR
                    man_made = 'pier' AND NOT ST_IsClosed(geometry)
                )
            OR zoom_level >= 14
                AND (
                    man_made <> 'pier'
                OR
                    NOT ST_IsClosed(geometry)
                )
        )
        UNION ALL

        -- etldoc: osm_railway_linestring_gen5  ->  layer_transportation:z8
        SELECT
            osm_id, geometry,
            NULL AS highway, NULL AS construction, railway, NULL AS aerialway, NULL AS shipway,
            NULL AS public_transport, service_value(service) AS service,
            NULL::boolean AS is_bridge, NULL::boolean AS is_tunnel,
            NULL::boolean AS is_ford,
            NULL::boolean AS is_ramp, NULL::int AS is_oneway, NULL as man_made,
            NULL::int AS layer, NULL::int AS level, NULL::boolean AS indoor,
            NULL as bicycle, NULL as foot, NULL as horse, NULL as mtb_scale,
            NULL as surface, z_order
        FROM osm_railway_linestring_gen5
        WHERE zoom_level = 8
            AND railway='rail' AND service = '' and usage='main'
        UNION ALL

        -- etldoc: osm_railway_linestring_gen4  ->  layer_transportation:z9
        SELECT
            osm_id, geometry,
            NULL AS highway, NULL AS construction, railway, NULL AS aerialway, NULL AS shipway,
            NULL AS public_transport, service_value(service) AS service,
            NULL::boolean AS is_bridge, NULL::boolean AS is_tunnel,
            NULL::boolean AS is_ford,
            NULL::boolean AS is_ramp, NULL::int AS is_oneway, NULL as man_made,
            layer, NULL::int AS level, NULL::boolean AS indoor,
            NULL as bicycle, NULL as foot, NULL as horse, NULL as mtb_scale,
            NULL AS surface, z_order
        FROM osm_railway_linestring_gen4
        WHERE zoom_level = 9
            AND railway='rail' AND service = '' and usage='main'
        UNION ALL

        -- etldoc: osm_railway_linestring_gen3  ->  layer_transportation:z10
        SELECT
            osm_id, geometry,
            NULL AS highway, NULL AS construction, railway, NULL AS aerialway, NULL AS shipway,
            NULL AS public_transport, service_value(service) AS service,
            is_bridge, is_tunnel, is_ford, is_ramp, is_oneway, NULL as man_made,
            layer, NULL::int AS level, NULL::boolean AS indoor,
            NULL as bicycle, NULL as foot, NULL as horse, NULL as mtb_scale,
            NULL AS surface, z_order
        FROM osm_railway_linestring_gen3
        WHERE zoom_level = 10
            AND railway IN ('rail', 'narrow_gauge') AND service = ''
        UNION ALL

        -- etldoc: osm_railway_linestring_gen2  ->  layer_transportation:z11
        SELECT
            osm_id, geometry,
            NULL AS highway, NULL AS construction, railway, NULL AS aerialway, NULL AS shipway,
            NULL AS public_transport, service_value(service) AS service,
            is_bridge, is_tunnel, is_ford, is_ramp, is_oneway, NULL as man_made,
            layer, NULL::int AS level, NULL::boolean AS indoor,
            NULL as bicycle, NULL as foot, NULL as horse, NULL as mtb_scale,
            NULL as surface, z_order
        FROM osm_railway_linestring_gen2
        WHERE zoom_level = 11
            AND railway IN ('rail', 'narrow_gauge', 'light_rail') AND service = ''
        UNION ALL

        -- etldoc: osm_railway_linestring_gen1  ->  layer_transportation:z12
        SELECT
            osm_id, geometry,
            NULL AS highway, NULL AS construction, railway, NULL AS aerialway, NULL AS shipway,
            NULL AS public_transport, service_value(service) AS service,
            is_bridge, is_tunnel, is_ford, is_ramp, is_oneway, NULL as man_made,
            layer, NULL::int AS level, NULL::boolean AS indoor,
            NULL as bicycle, NULL as foot, NULL as horse, NULL as mtb_scale,
            NULL as surface, z_order
        FROM osm_railway_linestring_gen1
        WHERE zoom_level = 12
            AND railway IN ('rail', 'narrow_gauge', 'light_rail') AND service = ''
        UNION ALL

        -- etldoc: osm_railway_linestring       ->  layer_transportation:z13
        -- etldoc: osm_railway_linestring       ->  layer_transportation:z14_
        SELECT
            osm_id, geometry,
            NULL AS highway, NULL AS construction, railway, NULL AS aerialway, NULL AS shipway,
            NULL AS public_transport, service_value(service) AS service,
            is_bridge, is_tunnel, is_ford, is_ramp, is_oneway, NULL as man_made,
            layer, NULL::int AS level, NULL::boolean AS indoor,
            NULL as bicycle, NULL as foot, NULL as horse, NULL as mtb_scale,
            NULL as surface, z_order
        FROM osm_railway_linestring
        WHERE zoom_level = 13
                AND railway IN ('rail', 'narrow_gauge', 'light_rail') AND service = ''
            OR zoom_Level >= 14
        UNION ALL

        -- etldoc: osm_aerialway_linestring_gen1  ->  layer_transportation:z12
        SELECT
            osm_id, geometry,
            NULL AS highway, NULL AS construction, NULL as railway, aerialway, NULL AS shipway,
            NULL AS public_transport, service_value(service) AS service,
            is_bridge, is_tunnel, is_ford, is_ramp, is_oneway, NULL as man_made,
            layer, NULL::int AS level, NULL::boolean AS indoor,
            NULL as bicycle, NULL as foot, NULL as horse, NULL as mtb_scale,
            NULL AS surface, z_order
        FROM osm_aerialway_linestring_gen1
        WHERE zoom_level = 12
        UNION ALL

        -- etldoc: osm_aerialway_linestring       ->  layer_transportation:z13
        -- etldoc: osm_aerialway_linestring       ->  layer_transportation:z14_
        SELECT
            osm_id, geometry,
            NULL AS highway, NULL AS construction, NULL as railway, aerialway, NULL AS shipway,
            NULL AS public_transport, service_value(service) AS service,
            is_bridge, is_tunnel, is_ford, is_ramp, is_oneway, NULL as man_made,
            layer, NULL::int AS level, NULL::boolean AS indoor,
            NULL as bicycle, NULL as foot, NULL as horse, NULL as mtb_scale,
            NULL AS surface, z_order
        FROM osm_aerialway_linestring
        WHERE zoom_level >= 13
        UNION ALL

        -- etldoc: osm_shipway_linestring_gen2  ->  layer_transportation:z11
        SELECT
            osm_id, geometry,
            NULL AS highway, NULL AS construction, NULL AS railway, NULL AS aerialway, shipway,
            NULL AS public_transport, service_value(service) AS service,
            is_bridge, is_tunnel, is_ford, is_ramp, is_oneway, NULL as man_made,
            layer, NULL::int AS level, NULL::boolean AS indoor,
            NULL as bicycle, NULL as foot, NULL as horse, NULL as mtb_scale,
            NULL AS surface, z_order
        FROM osm_shipway_linestring_gen2
        WHERE zoom_level = 11
        UNION ALL

        -- etldoc: osm_shipway_linestring_gen1  ->  layer_transportation:z12
        SELECT
            osm_id, geometry,
            NULL AS highway, NULL AS construction, NULL AS railway, NULL AS aerialway, shipway,
            NULL AS public_transport, service_value(service) AS service,
            is_bridge, is_tunnel, is_ford, is_ramp, is_oneway, NULL as man_made,
            layer, NULL::int AS level, NULL::boolean AS indoor,
            NULL as bicycle, NULL as foot, NULL as horse, NULL as mtb_scale,
            NULL AS surface, z_order
        FROM osm_shipway_linestring_gen1
        WHERE zoom_level = 12
        UNION ALL

        -- etldoc: osm_shipway_linestring       ->  layer_transportation:z13
        -- etldoc: osm_shipway_linestring       ->  layer_transportation:z14_
        SELECT
            osm_id, geometry,
            NULL AS highway, NULL AS construction, NULL AS railway, NULL AS aerialway, shipway,
            NULL AS public_transport, service_value(service) AS service,
            is_bridge, is_tunnel, is_ford, is_ramp, is_oneway, NULL as man_made,
            layer, NULL::int AS level, NULL::boolean AS indoor,
            NULL as bicycle, NULL as foot, NULL as horse, NULL as mtb_scale,
            NULL AS surface, z_order
        FROM osm_shipway_linestring
        WHERE zoom_level >= 13
        UNION ALL

        -- NOTE: We limit the selection of polys because we need to be
        -- careful to net get false positives here because
        -- it is possible that closed linestrings appear both as
        -- highway linestrings and as polygon
        -- etldoc: osm_highway_polygon          ->  layer_transportation:z13
        -- etldoc: osm_highway_polygon          ->  layer_transportation:z14_
        SELECT
            osm_id, geometry,
            highway, NULL AS construction, NULL AS railway, NULL AS aerialway, NULL AS shipway,
            public_transport, NULL AS service,
            CASE WHEN man_made IN ('bridge') THEN TRUE
                ELSE FALSE
            END AS is_bridge, FALSE AS is_tunnel, FALSE AS is_ford,
            FALSE AS is_ramp, FALSE::int AS is_oneway, man_made,
            layer, NULL::int AS level, NULL::boolean AS indoor,
            NULL as bicycle, NULL as foot, NULL as horse, NULL as mtb_scale,
            NULL AS surface, z_order
        FROM osm_highway_polygon
        -- We do not want underground pedestrian areas for now
        WHERE zoom_level >= 13
            AND (
                  man_made IN ('bridge', 'pier')
                  OR (is_area AND COALESCE(layer, 0) >= 0)
            )
    ) AS zoom_levels
    WHERE geometry && bbox
    ORDER BY z_order ASC;
$$
LANGUAGE SQL
IMMUTABLE PARALLEL SAFE;

DO $$ BEGIN RAISE NOTICE 'Finished layer transportation'; END$$;

DO $$ BEGIN RAISE NOTICE 'Processing layer transportation_name'; END$$;

-- Layer transportation_name - ./network_type.sql

DROP MATERIALIZED VIEW IF EXISTS osm_transportation_name_network CASCADE;
DROP MATERIALIZED VIEW IF EXISTS osm_transportation_name_linestring CASCADE;
DROP MATERIALIZED VIEW IF EXISTS osm_transportation_name_linestring_gen1 CASCADE;
DROP MATERIALIZED VIEW IF EXISTS osm_transportation_name_linestring_gen2 CASCADE;
DROP MATERIALIZED VIEW IF EXISTS osm_transportation_name_linestring_gen3 CASCADE;
DROP MATERIALIZED VIEW IF EXISTS osm_transportation_name_linestring_gen4 CASCADE;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'route_network_type') THEN
        CREATE TYPE route_network_type AS ENUM (
          'us-interstate', 'us-highway', 'us-state',
          'ca-transcanada',
          'gb-motorway', 'gb-trunk'
        );
    END IF;
END
$$
;

DO $$
    BEGIN
        BEGIN
            ALTER TABLE osm_route_member ADD COLUMN network_type route_network_type;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column network_type already exists in network_type.';
        END;
    END;
$$
;

-- Layer transportation_name - ./update_route_member.sql

DROP TRIGGER IF EXISTS trigger_flag_transportation_name ON osm_route_member;


-- create GBR relations (so we can use it in the same way as other relations)
CREATE OR REPLACE FUNCTION update_gbr_route_members() RETURNS VOID AS $$
DECLARE gbr_geom geometry;
BEGIN
    SELECT st_buffer(geometry, 10000) INTO gbr_geom FROM ne_10m_admin_0_countries where iso_a2 = 'GB';
    DELETE FROM osm_route_member WHERE network IN ('omt-gb-motorway', 'omt-gb-trunk');

    INSERT INTO osm_route_member (osm_id, member, ref, network)
    SELECT 0, osm_id, substring(ref FROM E'^[AM][0-9AM()]+'),
        CASE WHEN highway = 'motorway' THEN 'omt-gb-motorway' ELSE 'omt-gb-trunk' END
    FROM osm_highway_linestring
    WHERE
        length(ref)>0 AND
        ST_Intersects(geometry, gbr_geom) AND
        highway IN ('motorway', 'trunk')
    ;
END;
$$ LANGUAGE plpgsql;


-- etldoc:  osm_route_member ->  osm_route_member
CREATE OR REPLACE FUNCTION update_osm_route_member() RETURNS VOID AS $$
BEGIN
  PERFORM update_gbr_route_members();

  -- see http://wiki.openstreetmap.org/wiki/Relation:route#Road_routes
  UPDATE osm_route_member
  SET network_type =
      CASE
        WHEN network = 'US:I' THEN 'us-interstate'::route_network_type
        WHEN network = 'US:US' THEN 'us-highway'::route_network_type
        WHEN network LIKE 'US:__' THEN 'us-state'::route_network_type
        -- https://en.wikipedia.org/wiki/Trans-Canada_Highway
        -- TODO: improve hierarchical queries using
        --    http://www.openstreetmap.org/relation/1307243
        --    however the relation does not cover the whole Trans-Canada_Highway
        WHEN
            (network = 'CA:transcanada') OR
            (network = 'CA:BC:primary' AND ref IN ('16')) OR
            (name = 'Yellowhead Highway (AB)' AND ref IN ('16')) OR
            (network = 'CA:SK:primary' AND ref IN ('16')) OR
            (network = 'CA:ON:primary' AND ref IN ('17', '417')) OR
            (name = 'Route Transcanadienne') OR
            (network = 'CA:NB:primary' AND ref IN ('2', '16')) OR
            (network = 'CA:PE' AND ref IN ('1')) OR
            (network = 'CA:NS' AND ref IN ('104', '105')) OR
            (network = 'CA:NL:R' AND ref IN ('1')) OR
            (name = 'Trans-Canada Highway')
          THEN 'ca-transcanada'::route_network_type
        WHEN network = 'omt-gb-motorway' THEN 'gb-motorway'::route_network_type
        WHEN network = 'omt-gb-trunk' THEN 'gb-trunk'::route_network_type
      END
  ;

END;
$$ LANGUAGE plpgsql;

CREATE INDEX IF NOT EXISTS osm_route_member_network_idx ON osm_route_member("network");
CREATE INDEX IF NOT EXISTS osm_route_member_member_idx ON osm_route_member("member");
CREATE INDEX IF NOT EXISTS osm_route_member_name_idx ON osm_route_member("name");
CREATE INDEX IF NOT EXISTS osm_route_member_ref_idx ON osm_route_member("ref");

SELECT update_osm_route_member();

CREATE INDEX IF NOT EXISTS osm_route_member_network_type_idx ON osm_route_member("network_type");

-- Layer transportation_name - ./update_transportation_name.sql

DROP TRIGGER IF EXISTS trigger_flag_transportation_name ON osm_highway_linestring;
DROP TRIGGER IF EXISTS trigger_refresh ON transportation_name.updates;

-- Instead of using relations to find out the road names we
-- stitch together the touching ways with the same name
-- to allow for nice label rendering
-- Because this works well for roads that do not have relations as well


-- etldoc: osm_highway_linestring ->  osm_transportation_name_network
-- etldoc: osm_route_member ->  osm_transportation_name_network
CREATE MATERIALIZED VIEW osm_transportation_name_network AS (
  SELECT
      hl.geometry,
      hl.osm_id,
      CASE WHEN length(hl.name)>15 THEN osml10n_street_abbrev_all(hl.name) ELSE hl.name END AS "name",
      CASE WHEN length(hl.name_en)>15 THEN osml10n_street_abbrev_en(hl.name_en) ELSE hl.name_en END AS "name_en",
      CASE WHEN length(hl.name_de)>15 THEN osml10n_street_abbrev_de(hl.name_de) ELSE hl.name_de END AS "name_de",
      hl.tags,
      rm.network_type,
      CASE
        WHEN (rm.network_type is not null AND nullif(rm.ref::text, '') is not null)
          then rm.ref::text
        else hl.ref
      end as ref,
      hl.highway,
      hl.construction,
      CASE WHEN highway IN ('footway', 'steps') THEN layer END AS layer,
      CASE WHEN highway IN ('footway', 'steps') THEN "level" END AS "level",
      CASE WHEN highway IN ('footway', 'steps') THEN indoor END AS indoor,
      ROW_NUMBER() OVER(PARTITION BY hl.osm_id
                                   ORDER BY rm.network_type) AS "rank",
      hl.z_order
  FROM osm_highway_linestring hl
  left join osm_route_member rm on (rm.member = hl.osm_id)
) /* DELAY_MATERIALIZED_VIEW_CREATION */;
CREATE INDEX IF NOT EXISTS osm_transportation_name_network_geometry_idx ON osm_transportation_name_network USING gist(geometry);


-- etldoc: osm_transportation_name_network ->  osm_transportation_name_linestring
CREATE MATERIALIZED VIEW osm_transportation_name_linestring AS (
    SELECT
        (ST_Dump(geometry)).geom AS geometry,
        NULL::bigint AS osm_id,
        name,
        name_en,
        name_de,
        tags || get_basic_names(tags, geometry) AS "tags",
        ref,
        highway,
        construction,
        "level",
        layer,
        indoor,
        network_type AS network,
        z_order
    FROM (
      SELECT
          ST_LineMerge(ST_Collect(geometry)) AS geometry,
          name,
          name_en,
          name_de,
          hstore(string_agg(nullif(slice_language_tags(tags || hstore(ARRAY['name', name, 'name:en', name_en, 'name:de', name_de]))::text, ''), ','))
             AS "tags",
          ref,
          highway,
          construction,
          "level",
          layer,
          indoor,
          network_type,
          min(z_order) AS z_order
      FROM osm_transportation_name_network
      WHERE ("rank"=1 OR "rank" is null)
        AND (name <> '' OR ref <> '')
        AND NULLIF(highway, '') IS NOT NULL
      group by name, name_en, name_de, ref, highway, construction, "level", layer, indoor, network_type
    ) AS highway_union
) /* DELAY_MATERIALIZED_VIEW_CREATION */;
CREATE INDEX IF NOT EXISTS osm_transportation_name_linestring_geometry_idx ON osm_transportation_name_linestring USING gist(geometry);

CREATE INDEX IF NOT EXISTS osm_transportation_name_linestring_highway_partial_idx
  ON osm_transportation_name_linestring(highway, construction)
  WHERE highway IN ('motorway','trunk', 'construction');

-- etldoc: osm_transportation_name_linestring -> osm_transportation_name_linestring_gen1
CREATE MATERIALIZED VIEW osm_transportation_name_linestring_gen1 AS (
    SELECT ST_Simplify(geometry, 50) AS geometry, osm_id, name, name_en, name_de, tags, ref, highway, construction, network, z_order
    FROM osm_transportation_name_linestring
    WHERE (highway IN ('motorway','trunk') OR highway = 'construction' AND construction IN ('motorway','trunk'))  AND ST_Length(geometry) > 8000
) /* DELAY_MATERIALIZED_VIEW_CREATION */;
CREATE INDEX IF NOT EXISTS osm_transportation_name_linestring_gen1_geometry_idx ON osm_transportation_name_linestring_gen1 USING gist(geometry);

CREATE INDEX IF NOT EXISTS osm_transportation_name_linestring_gen1_highway_partial_idx
  ON osm_transportation_name_linestring_gen1(highway, construction)
  WHERE highway IN ('motorway','trunk', 'construction');

-- etldoc: osm_transportation_name_linestring_gen1 -> osm_transportation_name_linestring_gen2
CREATE MATERIALIZED VIEW osm_transportation_name_linestring_gen2 AS (
    SELECT ST_Simplify(geometry, 120) AS geometry, osm_id, name, name_en, name_de, tags, ref, highway, construction, network, z_order
    FROM osm_transportation_name_linestring_gen1
    WHERE (highway IN ('motorway','trunk') OR highway = 'construction' AND construction IN ('motorway','trunk'))  AND ST_Length(geometry) > 14000
) /* DELAY_MATERIALIZED_VIEW_CREATION */;
CREATE INDEX IF NOT EXISTS osm_transportation_name_linestring_gen2_geometry_idx ON osm_transportation_name_linestring_gen2 USING gist(geometry);

CREATE INDEX IF NOT EXISTS osm_transportation_name_linestring_gen2_highway_partial_idx
  ON osm_transportation_name_linestring_gen2(highway, construction)
  WHERE highway IN ('motorway','trunk', 'construction');

-- etldoc: osm_transportation_name_linestring_gen2 -> osm_transportation_name_linestring_gen3
CREATE MATERIALIZED VIEW osm_transportation_name_linestring_gen3 AS (
    SELECT ST_Simplify(geometry, 200) AS geometry, osm_id, name, name_en, name_de, tags, ref, highway, construction, network, z_order
    FROM osm_transportation_name_linestring_gen2
    WHERE (highway = 'motorway' OR highway = 'construction' AND construction = 'motorway') AND ST_Length(geometry) > 20000
) /* DELAY_MATERIALIZED_VIEW_CREATION */;
CREATE INDEX IF NOT EXISTS osm_transportation_name_linestring_gen3_geometry_idx ON osm_transportation_name_linestring_gen3 USING gist(geometry);

CREATE INDEX IF NOT EXISTS osm_transportation_name_linestring_gen3_highway_partial_idx
  ON osm_transportation_name_linestring_gen3(highway, construction)
  WHERE highway IN ('motorway', 'construction');

-- etldoc: osm_transportation_name_linestring_gen3 -> osm_transportation_name_linestring_gen4
CREATE MATERIALIZED VIEW osm_transportation_name_linestring_gen4 AS (
    SELECT ST_Simplify(geometry, 500) AS geometry, osm_id, name, name_en, name_de, tags, ref, highway, construction, network, z_order
    FROM osm_transportation_name_linestring_gen3
    WHERE (highway = 'motorway' OR highway = 'construction' AND construction = 'motorway') AND ST_Length(geometry) > 20000
) /* DELAY_MATERIALIZED_VIEW_CREATION */;
CREATE INDEX IF NOT EXISTS osm_transportation_name_linestring_gen4_geometry_idx ON osm_transportation_name_linestring_gen4 USING gist(geometry);

-- Handle updates

CREATE SCHEMA IF NOT EXISTS transportation_name;

CREATE TABLE IF NOT EXISTS transportation_name.updates(id serial primary key, t text, unique (t));
CREATE OR REPLACE FUNCTION transportation_name.flag() RETURNS trigger AS $$
BEGIN
    INSERT INTO transportation_name.updates(t) VALUES ('y')  ON CONFLICT(t) DO NOTHING;
    RETURN null;
END;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION transportation_name.refresh() RETURNS trigger AS
  $BODY$
  BEGIN
    RAISE LOG 'Refresh transportation_name';
    PERFORM update_osm_route_member();
    REFRESH MATERIALIZED VIEW osm_transportation_name_network;
    REFRESH MATERIALIZED VIEW osm_transportation_name_linestring;
    REFRESH MATERIALIZED VIEW osm_transportation_name_linestring_gen1;
    REFRESH MATERIALIZED VIEW osm_transportation_name_linestring_gen2;
    REFRESH MATERIALIZED VIEW osm_transportation_name_linestring_gen3;
    REFRESH MATERIALIZED VIEW osm_transportation_name_linestring_gen4;
    DELETE FROM transportation_name.updates;
    RETURN null;
  END;
  $BODY$
language plpgsql;

CREATE TRIGGER trigger_flag_transportation_name
    AFTER INSERT OR UPDATE OR DELETE ON osm_route_member
    FOR EACH STATEMENT
    EXECUTE PROCEDURE transportation_name.flag();

CREATE TRIGGER trigger_flag_transportation_name
    AFTER INSERT OR UPDATE OR DELETE ON osm_highway_linestring
    FOR EACH STATEMENT
    EXECUTE PROCEDURE transportation_name.flag();

CREATE CONSTRAINT TRIGGER trigger_refresh
    AFTER INSERT ON transportation_name.updates
    INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE PROCEDURE transportation_name.refresh();

-- Layer transportation_name - ./layer.sql


-- etldoc: layer_transportation_name[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_transportation_name | <z6> z6 | <z7> z7 | <z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14_> z14+" ] ;

CREATE OR REPLACE FUNCTION layer_transportation_name(bbox geometry, zoom_level integer)
RETURNS TABLE(osm_id bigint, geometry geometry, name text, name_en text,
  name_de text, tags hstore, ref text, ref_length int, network text, class
  text, subclass text, layer INT, level INT, indoor INT) AS $$
    SELECT osm_id, geometry,
      NULLIF(name, '') AS name,
      COALESCE(NULLIF(name_en, ''), name) AS name_en,
      COALESCE(NULLIF(name_de, ''), name, name_en) AS name_de,
      tags,
      NULLIF(ref, ''), NULLIF(LENGTH(ref), 0) AS ref_length,
      --TODO: The road network of the road is not yet implemented
      case
        when network is not null
          then network::text
        when length(coalesce(ref, ''))>0
          then 'road'
      end as network,
      highway_class(highway, '', construction) AS class,
      CASE
          WHEN highway IS NOT NULL AND highway_class(highway, '', construction) = 'path'
              THEN highway
      END AS subclass,
      NULLIF(layer, 0) AS layer,
      "level",
      CASE WHEN indoor=TRUE THEN 1 END as indoor
    FROM (

        -- etldoc: osm_transportation_name_linestring_gen4 ->  layer_transportation_name:z6
        SELECT *,
            NULL::int AS layer, NULL::int AS level, NULL::boolean AS indoor
        FROM osm_transportation_name_linestring_gen4
        WHERE zoom_level = 6
        UNION ALL

        -- etldoc: osm_transportation_name_linestring_gen3 ->  layer_transportation_name:z7
        SELECT *,
            NULL::int AS layer, NULL::int AS level, NULL::boolean AS indoor
        FROM osm_transportation_name_linestring_gen3
        WHERE zoom_level = 7
        UNION ALL

        -- etldoc: osm_transportation_name_linestring_gen2 ->  layer_transportation_name:z8
        SELECT *,
            NULL::int AS layer, NULL::int AS level, NULL::boolean AS indoor
        FROM osm_transportation_name_linestring_gen2
        WHERE zoom_level = 8
        UNION ALL

        -- etldoc: osm_transportation_name_linestring_gen1 ->  layer_transportation_name:z9
        -- etldoc: osm_transportation_name_linestring_gen1 ->  layer_transportation_name:z10
        -- etldoc: osm_transportation_name_linestring_gen1 ->  layer_transportation_name:z11
        SELECT *,
            NULL::int AS layer, NULL::int AS level, NULL::boolean AS indoor
        FROM osm_transportation_name_linestring_gen1
        WHERE zoom_level BETWEEN 9 AND 11
        UNION ALL

        -- etldoc: osm_transportation_name_linestring ->  layer_transportation_name:z12
        SELECT
          geometry,
          osm_id,
          name,
          name_en,
          name_de,
          "tags",
          ref,
          highway,
          construction,
          network,
          z_order,
          layer,
          "level",
          indoor
        FROM osm_transportation_name_linestring
        WHERE zoom_level = 12
            AND LineLabel(zoom_level, COALESCE(NULLIF(name, ''), ref), geometry)
            AND highway_class(highway, '', construction) NOT IN ('minor', 'track', 'path')
            AND NOT highway_is_link(highway)
        UNION ALL

        -- etldoc: osm_transportation_name_linestring ->  layer_transportation_name:z13
        SELECT
          geometry,
          osm_id,
          name,
          name_en,
          name_de,
          "tags",
          ref,
          highway,
          construction,
          network,
          z_order,
          layer,
          "level",
          indoor
        FROM osm_transportation_name_linestring
        WHERE zoom_level = 13
            AND LineLabel(zoom_level, COALESCE(NULLIF(name, ''), ref), geometry)
            AND highway_class(highway, '', construction) NOT IN ('track', 'path')
        UNION ALL

        -- etldoc: osm_transportation_name_linestring ->  layer_transportation_name:z14_
        SELECT
          geometry,
          osm_id,
          name,
          name_en,
          name_de,
          "tags",
          ref,
          highway,
          construction,
          network,
          z_order,
          layer,
          "level",
          indoor
        FROM osm_transportation_name_linestring
        WHERE zoom_level >= 14

    ) AS zoom_levels
    WHERE geometry && bbox
    ORDER BY z_order ASC;
$$
LANGUAGE SQL
IMMUTABLE PARALLEL SAFE;

DO $$ BEGIN RAISE NOTICE 'Finished layer transportation_name'; END$$;
