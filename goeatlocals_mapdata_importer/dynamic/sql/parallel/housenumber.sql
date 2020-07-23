DO $$ BEGIN RAISE NOTICE 'Processing layer housenumber'; END$$;

-- Layer housenumber - ./housenumber_centroid.sql

DROP TRIGGER IF EXISTS trigger_flag ON osm_housenumber_point;
DROP TRIGGER IF EXISTS trigger_refresh ON housenumber.updates;

-- etldoc: osm_housenumber_point -> osm_housenumber_point
CREATE OR REPLACE FUNCTION convert_housenumber_point() RETURNS VOID AS $$
BEGIN
  UPDATE osm_housenumber_point
  SET geometry =
           CASE WHEN ST_NPoints(ST_ConvexHull(geometry))=ST_NPoints(geometry)
           THEN ST_Centroid(geometry)
           ELSE ST_PointOnSurface(geometry)
    END
  WHERE ST_GeometryType(geometry) <> 'ST_Point';
END;
$$ LANGUAGE plpgsql;

SELECT convert_housenumber_point();

-- Handle updates

CREATE SCHEMA IF NOT EXISTS housenumber;

CREATE TABLE IF NOT EXISTS housenumber.updates(id serial primary key, t text, unique (t));
CREATE OR REPLACE FUNCTION housenumber.flag() RETURNS trigger AS $$
BEGIN
    INSERT INTO housenumber.updates(t) VALUES ('y')  ON CONFLICT(t) DO NOTHING;
    RETURN null;
END;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION housenumber.refresh() RETURNS trigger AS
  $BODY$
  BEGIN
    RAISE LOG 'Refresh housenumber';
    PERFORM convert_housenumber_point();
    DELETE FROM housenumber.updates;
    RETURN null;
  END;
  $BODY$
language plpgsql;

CREATE TRIGGER trigger_flag
    AFTER INSERT OR UPDATE OR DELETE ON osm_housenumber_point
    FOR EACH STATEMENT
    EXECUTE PROCEDURE housenumber.flag();

CREATE CONSTRAINT TRIGGER trigger_refresh
    AFTER INSERT ON housenumber.updates
    INITIALLY DEFERRED
    FOR EACH ROW
    EXECUTE PROCEDURE housenumber.refresh();

-- Layer housenumber - ./layer.sql


-- etldoc: layer_housenumber[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="layer_housenumber | <z14_> z14+" ] ;

CREATE OR REPLACE FUNCTION layer_housenumber(bbox geometry, zoom_level integer)
RETURNS TABLE(osm_id bigint, geometry geometry, housenumber text) AS $$
   -- etldoc: osm_housenumber_point -> layer_housenumber:z14_
    SELECT osm_id, geometry, housenumber FROM osm_housenumber_point
    WHERE zoom_level >= 14 AND geometry && bbox;
$$
LANGUAGE SQL
IMMUTABLE PARALLEL SAFE;

DO $$ BEGIN RAISE NOTICE 'Finished layer housenumber'; END$$;
