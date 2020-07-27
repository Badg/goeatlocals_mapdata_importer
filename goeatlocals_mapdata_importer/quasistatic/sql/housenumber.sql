CREATE OR REPLACE FUNCTION mapdata_layers.layer_housenumber(bbox geometry, zoom_level integer)
RETURNS TABLE(osm_id bigint, geometry geometry, housenumber text) AS $$
   -- etldoc: osm_housenumber_point -> layer_housenumber:z14_
    SELECT osm_id, geometry, housenumber FROM __use_schema__.osm_housenumber_point
    WHERE zoom_level >= 14 AND geometry && bbox;
$$
LANGUAGE SQL
IMMUTABLE PARALLEL SAFE;


-- This normalizes the housenumber to always be a point
CREATE OR REPLACE FUNCTION mapdata_utils.normalize_housenumber_point(raw_point geometry)
RETURNS geometry AS $$
    SELECT CASE
        WHEN ST_GeometryType(raw_point) = 'ST_Point' THEN raw_point
        WHEN ST_NPoints(ST_ConvexHull(raw_point))=ST_NPoints(raw_point)
            THEN ST_Centroid(raw_point)
        ELSE ST_PointOnSurface(raw_point)
    END;
$$ LANGUAGE SQL;
