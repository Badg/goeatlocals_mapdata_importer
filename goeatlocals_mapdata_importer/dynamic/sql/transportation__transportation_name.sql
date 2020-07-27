DO $$ BEGIN RAISE NOTICE 'Processing layer transportation'; END$$;


-- Instead of using relations to find out the road names we
-- stitch together the touching ways with the same name
-- to allow for nice label rendering
-- Because this works well for roads that do not have relations as well


-- Improve performance of the sql in transportation_name/network_type.sql
CREATE INDEX IF NOT EXISTS osm_highway_linestring_highway_idx
  ON __use_schema__.osm_highway_linestring(highway);

-- Improve performance of the sql below
CREATE INDEX IF NOT EXISTS osm_highway_linestring_highway_partial_idx
  ON __use_schema__.osm_highway_linestring(highway)
  WHERE highway IN ('motorway','trunk', 'primary', 'construction');

  -- etldoc: osm_highway_linestring ->  osm_transportation_merge_linestring
CREATE MATERIALIZED VIEW __use_schema__.osm_transportation_merge_linestring AS (
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
      FROM __use_schema__.osm_highway_linestring
      WHERE (highway IN ('motorway','trunk', 'primary') OR highway = 'construction' AND construction IN ('motorway','trunk', 'primary'))
          AND ST_IsValid(geometry)
      group by highway, construction
    ) AS highway_union
) /* DELAY_MATERIALIZED_VIEW_CREATION */;
CREATE INDEX IF NOT EXISTS osm_transportation_merge_linestring_geometry_idx
  ON __use_schema__.osm_transportation_merge_linestring USING gist(geometry);
CREATE INDEX IF NOT EXISTS osm_transportation_merge_linestring_highway_partial_idx
  ON __use_schema__.osm_transportation_merge_linestring(highway, construction)
  WHERE highway IN ('motorway','trunk', 'primary', 'construction');

-- etldoc: osm_transportation_merge_linestring -> osm_transportation_merge_linestring_gen3
CREATE MATERIALIZED VIEW __use_schema__.osm_transportation_merge_linestring_gen3 AS (
    SELECT ST_Simplify(geometry, 120) AS geometry, osm_id, highway, construction, z_order
    FROM __use_schema__.osm_transportation_merge_linestring
    WHERE highway IN ('motorway','trunk', 'primary')
      OR highway = 'construction' AND construction IN ('motorway','trunk', 'primary')
) /* DELAY_MATERIALIZED_VIEW_CREATION */;
CREATE INDEX IF NOT EXISTS osm_transportation_merge_linestring_gen3_geometry_idx
  ON __use_schema__.osm_transportation_merge_linestring_gen3 USING gist(geometry);
CREATE INDEX IF NOT EXISTS osm_transportation_merge_linestring_gen3_highway_partial_idx
  ON __use_schema__.osm_transportation_merge_linestring_gen3(highway, construction)
  WHERE highway IN ('motorway','trunk', 'primary', 'construction');

-- etldoc: osm_transportation_merge_linestring_gen3 -> osm_transportation_merge_linestring_gen4
CREATE MATERIALIZED VIEW __use_schema__.osm_transportation_merge_linestring_gen4 AS (
    SELECT ST_Simplify(geometry, 200) AS geometry, osm_id, highway, construction, z_order
    FROM __use_schema__.osm_transportation_merge_linestring_gen3
    WHERE (highway IN ('motorway','trunk', 'primary') OR highway = 'construction' AND construction IN ('motorway','trunk', 'primary'))
        AND ST_Length(geometry) > 50
) /* DELAY_MATERIALIZED_VIEW_CREATION */;
CREATE INDEX IF NOT EXISTS osm_transportation_merge_linestring_gen4_geometry_idx
  ON __use_schema__.osm_transportation_merge_linestring_gen4 USING gist(geometry);
CREATE INDEX IF NOT EXISTS osm_transportation_merge_linestring_gen4_highway_partial_idx
  ON __use_schema__.osm_transportation_merge_linestring_gen4(highway, construction)
  WHERE highway IN ('motorway','trunk', 'primary', 'construction');

-- etldoc: osm_transportation_merge_linestring_gen4 -> osm_transportation_merge_linestring_gen5
CREATE MATERIALIZED VIEW __use_schema__.osm_transportation_merge_linestring_gen5 AS (
    SELECT ST_Simplify(geometry, 500) AS geometry, osm_id, highway, construction, z_order
    FROM __use_schema__.osm_transportation_merge_linestring_gen4
    WHERE (highway IN ('motorway','trunk') OR highway = 'construction' AND construction IN ('motorway','trunk'))
        AND ST_Length(geometry) > 100
) /* DELAY_MATERIALIZED_VIEW_CREATION */;
CREATE INDEX IF NOT EXISTS osm_transportation_merge_linestring_gen5_geometry_idx
  ON __use_schema__.osm_transportation_merge_linestring_gen5 USING gist(geometry);
CREATE INDEX IF NOT EXISTS osm_transportation_merge_linestring_gen5_highway_partial_idx
  ON __use_schema__.osm_transportation_merge_linestring_gen5(highway, construction)
  WHERE highway IN ('motorway','trunk', 'construction');

-- etldoc: osm_transportation_merge_linestring_gen5 -> osm_transportation_merge_linestring_gen6
CREATE MATERIALIZED VIEW __use_schema__.osm_transportation_merge_linestring_gen6 AS (
    SELECT ST_Simplify(geometry, 1000) AS geometry, osm_id, highway, construction, z_order
    FROM __use_schema__.osm_transportation_merge_linestring_gen5
    WHERE (highway IN ('motorway','trunk') OR highway = 'construction' AND construction IN ('motorway','trunk')) AND ST_Length(geometry) > 500
) /* DELAY_MATERIALIZED_VIEW_CREATION */;
CREATE INDEX IF NOT EXISTS osm_transportation_merge_linestring_gen6_geometry_idx
  ON __use_schema__.osm_transportation_merge_linestring_gen6 USING gist(geometry);
CREATE INDEX IF NOT EXISTS osm_transportation_merge_linestring_gen6_highway_partial_idx
  ON __use_schema__.osm_transportation_merge_linestring_gen6(highway, construction)
  WHERE highway IN ('motorway','trunk', 'construction');

-- etldoc: osm_transportation_merge_linestring_gen6 -> osm_transportation_merge_linestring_gen7
CREATE MATERIALIZED VIEW __use_schema__.osm_transportation_merge_linestring_gen7 AS (
    SELECT ST_Simplify(geometry, 2000) AS geometry, osm_id, highway, construction, z_order
    FROM __use_schema__.osm_transportation_merge_linestring_gen6
    WHERE (highway = 'motorway' OR highway = 'construction' AND construction = 'motorway') AND ST_Length(geometry) > 1000
) /* DELAY_MATERIALIZED_VIEW_CREATION */;
CREATE INDEX IF NOT EXISTS osm_transportation_merge_linestring_gen7_geometry_idx
  ON __use_schema__.osm_transportation_merge_linestring_gen7 USING gist(geometry);


-- Layer transportation - ./layer.sql

DO $$ BEGIN RAISE NOTICE 'Finished layer transportation'; END$$;

DO $$ BEGIN RAISE NOTICE 'Processing layer transportation_name'; END$$;

-- Layer transportation_name - ./network_type.sql

DO $$
    BEGIN
        BEGIN
            ALTER TABLE __use_schema__.osm_route_member ADD COLUMN network_type route_network_type;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column network_type already exists in network_type.';
        END;
    END;
$$
;

-- Layer transportation_name - ./update_route_member.sql


-- create GBR relations (so we can use it in the same way as other relations)
CREATE OR REPLACE FUNCTION __use_schema__.update_gbr_route_members() RETURNS VOID AS $$
DECLARE gbr_geom geometry;
BEGIN
    SELECT st_buffer(geometry, 10000) INTO gbr_geom FROM mapdata_prod.ne_10m_admin_0_countries where iso_a2 = 'GB';
    DELETE FROM __use_schema__.osm_route_member WHERE network IN ('omt-gb-motorway', 'omt-gb-trunk');

    INSERT INTO __use_schema__.osm_route_member (osm_id, member, ref, network)
    SELECT 0, osm_id, substring(ref FROM E'^[AM][0-9AM()]+'),
        CASE WHEN highway = 'motorway' THEN 'omt-gb-motorway' ELSE 'omt-gb-trunk' END
    FROM __use_schema__.osm_highway_linestring
    WHERE
        length(ref)>0 AND
        ST_Intersects(geometry, gbr_geom) AND
        highway IN ('motorway', 'trunk')
    ;
END;
$$ LANGUAGE plpgsql;


-- etldoc:  osm_route_member ->  osm_route_member
CREATE OR REPLACE FUNCTION __use_schema__.update_osm_route_member() RETURNS VOID AS $$
BEGIN
  PERFORM __use_schema__.update_gbr_route_members();

  -- see http://wiki.openstreetmap.org/wiki/Relation:route#Road_routes
  UPDATE __use_schema__.osm_route_member
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

CREATE INDEX IF NOT EXISTS osm_route_member_network_idx ON __use_schema__.osm_route_member("network");
CREATE INDEX IF NOT EXISTS osm_route_member_member_idx ON __use_schema__.osm_route_member("member");
CREATE INDEX IF NOT EXISTS osm_route_member_name_idx ON __use_schema__.osm_route_member("name");
CREATE INDEX IF NOT EXISTS osm_route_member_ref_idx ON __use_schema__.osm_route_member("ref");

SELECT __use_schema__.update_osm_route_member();

CREATE INDEX IF NOT EXISTS osm_route_member_network_type_idx ON __use_schema__.osm_route_member("network_type");

-- Layer transportation_name - ./update_transportation_name.sql

-- Instead of using relations to find out the road names we
-- stitch together the touching ways with the same name
-- to allow for nice label rendering
-- Because this works well for roads that do not have relations as well


-- etldoc: osm_highway_linestring ->  osm_transportation_name_network
-- etldoc: osm_route_member ->  osm_transportation_name_network
CREATE MATERIALIZED VIEW __use_schema__.osm_transportation_name_network AS (
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
  FROM __use_schema__.osm_highway_linestring hl
  left join __use_schema__.osm_route_member rm on (rm.member = hl.osm_id)
) /* DELAY_MATERIALIZED_VIEW_CREATION */;
CREATE INDEX IF NOT EXISTS osm_transportation_name_network_geometry_idx ON __use_schema__.osm_transportation_name_network USING gist(geometry);


-- etldoc: osm_transportation_name_network ->  osm_transportation_name_linestring
CREATE MATERIALIZED VIEW __use_schema__.osm_transportation_name_linestring AS (
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
      FROM __use_schema__.osm_transportation_name_network
      WHERE ("rank"=1 OR "rank" is null)
        AND (name <> '' OR ref <> '')
        AND NULLIF(highway, '') IS NOT NULL
      group by name, name_en, name_de, ref, highway, construction, "level", layer, indoor, network_type
    ) AS highway_union
) /* DELAY_MATERIALIZED_VIEW_CREATION */;
CREATE INDEX IF NOT EXISTS osm_transportation_name_linestring_geometry_idx ON __use_schema__.osm_transportation_name_linestring USING gist(geometry);

CREATE INDEX IF NOT EXISTS osm_transportation_name_linestring_highway_partial_idx
  ON __use_schema__.osm_transportation_name_linestring(highway, construction)
  WHERE highway IN ('motorway','trunk', 'construction');

-- etldoc: osm_transportation_name_linestring -> osm_transportation_name_linestring_gen1
CREATE MATERIALIZED VIEW __use_schema__.osm_transportation_name_linestring_gen1 AS (
    SELECT ST_Simplify(geometry, 50) AS geometry, osm_id, name, name_en, name_de, tags, ref, highway, construction, network, z_order
    FROM __use_schema__.osm_transportation_name_linestring
    WHERE (highway IN ('motorway','trunk') OR highway = 'construction' AND construction IN ('motorway','trunk'))  AND ST_Length(geometry) > 8000
) /* DELAY_MATERIALIZED_VIEW_CREATION */;
CREATE INDEX IF NOT EXISTS osm_transportation_name_linestring_gen1_geometry_idx ON __use_schema__.osm_transportation_name_linestring_gen1 USING gist(geometry);

CREATE INDEX IF NOT EXISTS osm_transportation_name_linestring_gen1_highway_partial_idx
  ON __use_schema__.osm_transportation_name_linestring_gen1(highway, construction)
  WHERE highway IN ('motorway','trunk', 'construction');

-- etldoc: osm_transportation_name_linestring_gen1 -> osm_transportation_name_linestring_gen2
CREATE MATERIALIZED VIEW __use_schema__.osm_transportation_name_linestring_gen2 AS (
    SELECT ST_Simplify(geometry, 120) AS geometry, osm_id, name, name_en, name_de, tags, ref, highway, construction, network, z_order
    FROM __use_schema__.osm_transportation_name_linestring_gen1
    WHERE (highway IN ('motorway','trunk') OR highway = 'construction' AND construction IN ('motorway','trunk'))  AND ST_Length(geometry) > 14000
) /* DELAY_MATERIALIZED_VIEW_CREATION */;
CREATE INDEX IF NOT EXISTS osm_transportation_name_linestring_gen2_geometry_idx ON __use_schema__.osm_transportation_name_linestring_gen2 USING gist(geometry);

CREATE INDEX IF NOT EXISTS osm_transportation_name_linestring_gen2_highway_partial_idx
  ON __use_schema__.osm_transportation_name_linestring_gen2(highway, construction)
  WHERE highway IN ('motorway','trunk', 'construction');

-- etldoc: osm_transportation_name_linestring_gen2 -> osm_transportation_name_linestring_gen3
CREATE MATERIALIZED VIEW __use_schema__.osm_transportation_name_linestring_gen3 AS (
    SELECT ST_Simplify(geometry, 200) AS geometry, osm_id, name, name_en, name_de, tags, ref, highway, construction, network, z_order
    FROM __use_schema__.osm_transportation_name_linestring_gen2
    WHERE (highway = 'motorway' OR highway = 'construction' AND construction = 'motorway') AND ST_Length(geometry) > 20000
) /* DELAY_MATERIALIZED_VIEW_CREATION */;
CREATE INDEX IF NOT EXISTS osm_transportation_name_linestring_gen3_geometry_idx ON __use_schema__.osm_transportation_name_linestring_gen3 USING gist(geometry);

CREATE INDEX IF NOT EXISTS osm_transportation_name_linestring_gen3_highway_partial_idx
  ON __use_schema__.osm_transportation_name_linestring_gen3(highway, construction)
  WHERE highway IN ('motorway', 'construction');

-- etldoc: osm_transportation_name_linestring_gen3 -> osm_transportation_name_linestring_gen4
CREATE MATERIALIZED VIEW __use_schema__.osm_transportation_name_linestring_gen4 AS (
    SELECT ST_Simplify(geometry, 500) AS geometry, osm_id, name, name_en, name_de, tags, ref, highway, construction, network, z_order
    FROM __use_schema__.osm_transportation_name_linestring_gen3
    WHERE (highway = 'motorway' OR highway = 'construction' AND construction = 'motorway') AND ST_Length(geometry) > 20000
) /* DELAY_MATERIALIZED_VIEW_CREATION */;
CREATE INDEX IF NOT EXISTS osm_transportation_name_linestring_gen4_geometry_idx ON __use_schema__.osm_transportation_name_linestring_gen4 USING gist(geometry);

-- Layer transportation_name - ./layer.sql
DO $$ BEGIN RAISE NOTICE 'Finished layer transportation_name'; END$$;
