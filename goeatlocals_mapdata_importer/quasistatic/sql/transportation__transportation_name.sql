-- etldoc: layer_transportation[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="<sql> layer_transportation |<z4> z4 |<z5> z5 |<z6> z6 |<z7> z7 |<z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14_> z14+" ] ;
CREATE OR REPLACE FUNCTION mapdata_layers.layer_transportation(bbox geometry, zoom_level int)
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
        FROM __use_schema__.osm_transportation_merge_linestring_gen7
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
        FROM __use_schema__.osm_transportation_merge_linestring_gen6
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
        FROM __use_schema__.osm_transportation_merge_linestring_gen5
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
        FROM __use_schema__.osm_transportation_merge_linestring_gen4
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
        FROM __use_schema__.osm_transportation_merge_linestring_gen3
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
        FROM __use_schema__.osm_highway_linestring_gen2
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
        FROM __use_schema__.osm_highway_linestring_gen1
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
        FROM __use_schema__.osm_highway_linestring
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
        FROM __use_schema__.osm_railway_linestring_gen5
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
        FROM __use_schema__.osm_railway_linestring_gen4
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
        FROM __use_schema__.osm_railway_linestring_gen3
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
        FROM __use_schema__.osm_railway_linestring_gen2
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
        FROM __use_schema__.osm_railway_linestring_gen1
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
        FROM __use_schema__.osm_railway_linestring
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
        FROM __use_schema__.osm_aerialway_linestring_gen1
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
        FROM __use_schema__.osm_aerialway_linestring
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
        FROM __use_schema__.osm_shipway_linestring_gen2
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
        FROM __use_schema__.osm_shipway_linestring_gen1
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
        FROM __use_schema__.osm_shipway_linestring
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
        FROM __use_schema__.osm_highway_polygon
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
IMMUTABLE PARALLEL SAFE;-- etldoc: layer_transportation_name[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_transportation_name | <z6> z6 | <z7> z7 | <z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14_> z14+" ] ;

CREATE OR REPLACE FUNCTION mapdata_layers.layer_transportation_name(bbox geometry, zoom_level integer)
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
        FROM __use_schema__.osm_transportation_name_linestring_gen4
        WHERE zoom_level = 6
        UNION ALL

        -- etldoc: osm_transportation_name_linestring_gen3 ->  layer_transportation_name:z7
        SELECT *,
            NULL::int AS layer, NULL::int AS level, NULL::boolean AS indoor
        FROM __use_schema__.osm_transportation_name_linestring_gen3
        WHERE zoom_level = 7
        UNION ALL

        -- etldoc: osm_transportation_name_linestring_gen2 ->  layer_transportation_name:z8
        SELECT *,
            NULL::int AS layer, NULL::int AS level, NULL::boolean AS indoor
        FROM __use_schema__.osm_transportation_name_linestring_gen2
        WHERE zoom_level = 8
        UNION ALL

        -- etldoc: osm_transportation_name_linestring_gen1 ->  layer_transportation_name:z9
        -- etldoc: osm_transportation_name_linestring_gen1 ->  layer_transportation_name:z10
        -- etldoc: osm_transportation_name_linestring_gen1 ->  layer_transportation_name:z11
        SELECT *,
            NULL::int AS layer, NULL::int AS level, NULL::boolean AS indoor
        FROM __use_schema__.osm_transportation_name_linestring_gen1
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
        FROM __use_schema__.osm_transportation_name_linestring
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
        FROM __use_schema__.osm_transportation_name_linestring
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
        FROM __use_schema__.osm_transportation_name_linestring
        WHERE zoom_level >= 14

    ) AS zoom_levels
    WHERE geometry && bbox
    ORDER BY z_order ASC;
$$
LANGUAGE SQL
IMMUTABLE PARALLEL SAFE;


CREATE OR REPLACE FUNCTION mapdata_utils.brunnel(is_bridge BOOL, is_tunnel BOOL, is_ford BOOL)
RETURNS TEXT AS $$
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
CREATE OR REPLACE FUNCTION mapdata_utils.highway_class(highway TEXT, public_transport TEXT, construction TEXT)
RETURNS TEXT AS $$
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
CREATE OR REPLACE FUNCTION mapdata_utils.railway_class(railway TEXT)
RETURNS TEXT AS $$
    SELECT CASE
        WHEN railway IN ('rail', 'narrow_gauge', 'preserved', 'funicular') THEN 'rail'
        WHEN railway IN ('subway', 'light_rail', 'monorail', 'tram') THEN 'transit'
    END;
$$
LANGUAGE SQL
IMMUTABLE STRICT PARALLEL SAFE;


-- Limit service to only the most important values to ensure
-- we always know the values of service
CREATE OR REPLACE FUNCTION mapdata_utils.service_value(service TEXT)
RETURNS TEXT AS $$
    SELECT CASE
        WHEN service IN ('spur', 'yard', 'siding', 'crossover', 'driveway', 'alley', 'parking_aisle') THEN service
    END;
$$
LANGUAGE SQL
IMMUTABLE STRICT PARALLEL SAFE;


-- Limit surface to only the most important values to ensure
-- we always know the values of surface
CREATE OR REPLACE FUNCTION mapdata_utils.surface_value(surface TEXT)
RETURNS TEXT AS $$
    SELECT CASE
        WHEN surface IN ('paved', 'asphalt', 'cobblestone', 'concrete', 'concrete:lanes', 'concrete:plates', 'metal', 'paving_stones', 'sett', 'unhewn_cobblestone', 'wood') THEN 'paved'
        WHEN surface IN ('unpaved', 'compacted', 'dirt', 'earth', 'fine_gravel', 'grass', 'grass_paver', 'gravel', 'gravel_turf', 'ground', 'ice', 'mud', 'pebblestone', 'salt', 'sand', 'snow', 'woodchips') THEN 'unpaved'
    END;
$$
LANGUAGE SQL
IMMUTABLE STRICT PARALLEL SAFE;


CREATE OR REPLACE FUNCTION mapdata_utils.highway_is_link(highway TEXT) RETURNS BOOLEAN AS $$
    SELECT highway LIKE '%_link';
$$
LANGUAGE SQL
IMMUTABLE STRICT PARALLEL SAFE;
