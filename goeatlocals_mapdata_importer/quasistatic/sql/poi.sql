CREATE OR REPLACE FUNCTION mapdata_layers.layer_poi(bbox geometry, zoom_level integer, pixel_width numeric)
RETURNS TABLE(osm_id bigint, geometry geometry, name text, name_en text, name_de text, tags hstore, class text, subclass text, agg_stop integer, layer integer, level integer, indoor integer, "rank" int) AS $$
    SELECT osm_id_hash AS osm_id, geometry, NULLIF(name, '') AS name,
        COALESCE(NULLIF(name_en, ''), name) AS name_en,
        COALESCE(NULLIF(name_de, ''), name, name_en) AS name_de,
        tags,
        poi_class(subclass, mapping_key) AS class,
        CASE
            WHEN subclass = 'information'
                THEN NULLIF(information, '')
            WHEN subclass = 'place_of_worship'
                    THEN NULLIF(religion, '')
            WHEN subclass = 'pitch'
                    THEN NULLIF(sport, '')
            ELSE subclass
        END AS subclass,
        agg_stop,
        NULLIF(layer, 0) AS layer,
        "level",
        CASE WHEN indoor=TRUE THEN 1 END as indoor,
        row_number() OVER (
            PARTITION BY LabelGrid(geometry, 100 * pixel_width)
            ORDER BY CASE WHEN name = '' THEN 2000 ELSE poi_class_rank(poi_class(subclass, mapping_key)) END ASC
        )::int AS "rank"
    FROM (
        -- etldoc: osm_poi_point ->  layer_poi:z12
        -- etldoc: osm_poi_point ->  layer_poi:z13
        SELECT *,
            osm_id*10 AS osm_id_hash FROM __use_schema__.osm_poi_point
            WHERE geometry && bbox
                AND zoom_level BETWEEN 12 AND 13
                AND ((subclass='station' AND mapping_key = 'railway')
                    OR subclass IN ('halt', 'ferry_terminal'))
        UNION ALL

        -- etldoc: osm_poi_point ->  layer_poi:z14_
        SELECT *,
            osm_id*10 AS osm_id_hash FROM __use_schema__.osm_poi_point
            WHERE geometry && bbox
                AND zoom_level >= 14

        UNION ALL
        -- etldoc: osm_poi_polygon ->  layer_poi:z12
        -- etldoc: osm_poi_polygon ->  layer_poi:z13
        SELECT *,
            NULL::INTEGER AS agg_stop,
            CASE WHEN osm_id<0 THEN -osm_id*10+4
                ELSE osm_id*10+1
            END AS osm_id_hash
        FROM __use_schema__.osm_poi_polygon
            WHERE geometry && bbox
                AND zoom_level BETWEEN 12 AND 13
                AND ((subclass='station' AND mapping_key = 'railway')
                    OR subclass IN ('halt', 'ferry_terminal'))

        UNION ALL
        -- etldoc: osm_poi_polygon ->  layer_poi:z14_
        SELECT *,
            NULL::INTEGER AS agg_stop,
            CASE WHEN osm_id<0 THEN -osm_id*10+4
                ELSE osm_id*10+1
            END AS osm_id_hash
        FROM __use_schema__.osm_poi_polygon
            WHERE geometry && bbox
                AND zoom_level >= 14
        ) as poi_union
    ORDER BY "rank"
    ;
$$
LANGUAGE SQL
IMMUTABLE PARALLEL SAFE;


CREATE OR REPLACE FUNCTION mapdata_utils.poi_class_rank(class TEXT)
RETURNS INT AS $$
    SELECT CASE class
        WHEN 'hospital' THEN 20
        WHEN 'railway' THEN 40
        WHEN 'bus' THEN 50
        WHEN 'attraction' THEN 70
        WHEN 'harbor' THEN 75
        WHEN 'college' THEN 80
        WHEN 'school' THEN 85
        WHEN 'stadium' THEN 90
        WHEN 'zoo' THEN 95
        WHEN 'town_hall' THEN 100
        WHEN 'campsite' THEN 110
        WHEN 'cemetery' THEN 115
        WHEN 'park' THEN 120
        WHEN 'library' THEN 130
        WHEN 'police' THEN 135
        WHEN 'post' THEN 140
        WHEN 'golf' THEN 150
        WHEN 'shop' THEN 400
        WHEN 'grocery' THEN 500
        WHEN 'fast_food' THEN 600
        WHEN 'clothing_store' THEN 700
        WHEN 'bar' THEN 800
        ELSE 1000
    END;
$$
LANGUAGE SQL
IMMUTABLE PARALLEL SAFE;


CREATE OR REPLACE FUNCTION mapdata_utils.poi_class(subclass TEXT, mapping_key TEXT)
RETURNS TEXT AS $$
    SELECT CASE
        WHEN "subclass" IN ('accessories', 'antiques', 'beauty', 'bed', 'boutique', 'camera', 'carpet', 'charity', 'chemist', 'coffee', 'computer', 'convenience', 'copyshop', 'cosmetics', 'garden_centre', 'doityourself', 'erotic', 'electronics', 'fabric', 'florist', 'frozen_food', 'furniture', 'video_games', 'video', 'general', 'gift', 'hardware', 'hearing_aids', 'hifi', 'ice_cream', 'interior_decoration', 'jewelry', 'kiosk', 'lamps', 'mall', 'massage', 'motorcycle', 'mobile_phone', 'newsagent', 'optician', 'outdoor', 'perfumery', 'perfume', 'pet', 'photo', 'second_hand', 'shoes', 'sports', 'stationery', 'tailor', 'tattoo', 'ticket', 'tobacco', 'toys', 'travel_agency', 'watches', 'weapons', 'wholesale') THEN 'shop'
        WHEN "subclass" IN ('townhall', 'public_building', 'courthouse', 'community_centre') THEN 'town_hall'
        WHEN "subclass" IN ('golf', 'golf_course', 'miniature_golf') THEN 'golf'
        WHEN "subclass" IN ('fast_food', 'food_court') THEN 'fast_food'
        WHEN "subclass" IN ('park', 'bbq') THEN 'park'
        WHEN "subclass" IN ('bus_stop', 'bus_station') THEN 'bus'
        WHEN ("subclass" = 'station' AND "mapping_key" = 'railway')
            OR "subclass" IN ('halt', 'tram_stop', 'subway')
            THEN 'railway'
        WHEN "subclass" = 'station'
            AND "mapping_key" = 'aerialway'
            THEN 'aerialway'
        WHEN "subclass" IN ('subway_entrance', 'train_station_entrance') THEN 'entrance'
        WHEN "subclass" IN ('camp_site', 'caravan_site') THEN 'campsite'
        WHEN "subclass" IN ('laundry', 'dry_cleaning') THEN 'laundry'
        WHEN "subclass" IN ('supermarket', 'deli', 'delicatessen', 'department_store', 'greengrocer', 'marketplace') THEN 'grocery'
        WHEN "subclass" IN ('books', 'library') THEN 'library'
        WHEN "subclass" IN ('university', 'college') THEN 'college'
        WHEN "subclass" IN ('hotel', 'motel', 'bed_and_breakfast', 'guest_house', 'hostel', 'chalet', 'alpine_hut', 'dormitory') THEN 'lodging'
        WHEN "subclass" IN ('chocolate', 'confectionery') THEN 'ice_cream'
        WHEN "subclass" IN ('post_box', 'post_office') THEN 'post'
        WHEN "subclass" = 'cafe' THEN 'cafe'
        WHEN "subclass" IN ('school', 'kindergarten') THEN 'school'
        WHEN "subclass" IN ('alcohol', 'beverages', 'wine') THEN 'alcohol_shop'
        WHEN "subclass" IN ('bar', 'nightclub') THEN 'bar'
        WHEN "subclass" IN ('marina', 'dock') THEN 'harbor'
        WHEN "subclass" IN ('car', 'car_repair', 'taxi') THEN 'car'
        WHEN "subclass" IN ('hospital', 'nursing_home', 'clinic') THEN 'hospital'
        WHEN "subclass" IN ('grave_yard', 'cemetery') THEN 'cemetery'
        WHEN "subclass" IN ('attraction', 'viewpoint') THEN 'attraction'
        WHEN "subclass" IN ('biergarten', 'pub') THEN 'beer'
        WHEN "subclass" IN ('music', 'musical_instrument') THEN 'music'
        WHEN "subclass" IN ('american_football', 'stadium', 'soccer') THEN 'stadium'
        WHEN "subclass" IN ('art', 'artwork', 'gallery', 'arts_centre') THEN 'art_gallery'
        WHEN "subclass" IN ('bag', 'clothes') THEN 'clothing_store'
        WHEN "subclass" IN ('swimming_area', 'swimming') THEN 'swimming'
        WHEN "subclass" IN ('castle', 'ruins') THEN 'castle'
        ELSE subclass
    END;
$$
LANGUAGE SQL
IMMUTABLE PARALLEL SAFE;


CREATE OR REPLACE FUNCTION mapdata_utils.normalize_poi_polygon_geo(raw_geo geometry)
RETURNS geometry AS $$
    SELECT CASE
        WHEN ST_GeometryType(raw_geo) = 'ST_Point' THEN raw_geo
        WHEN ST_NPoints(ST_ConvexHull(raw_geo))=ST_NPoints(raw_geo)
            THEN ST_Centroid(raw_geo)
        ELSE ST_PointOnSurface(raw_geo)
    END;
$$ LANGUAGE SQL
IMMUTABLE;


CREATE OR REPLACE FUNCTION mapdata_utils.normalize_osm_poi_subclass(station text, subclass text, funicular text)
RETURNS text AS $$
    SELECT CASE
        WHEN station = 'subway' and subclass='station' THEN 'subway'
        WHEN funicular = 'yes' and subclass='station' THEN 'halt'
        ELSE subclass
    END;
$$ LANGUAGE SQL
IMMUTABLE PARALLEL SAFE;


CREATE OR REPLACE FUNCTION mapdata_utils.normalize_osm_poi_point_agg(subclass varchar, rank bigint)
RETURNS bigint AS $$
    SELECT CASE
        WHEN subclass IN ('bus_stop', 'bus_station', 'tram_stop', 'subway')
            THEN 1::bigint

        -- WTF? Very confused. Might be a bug in the OMT original
        WHEN subclass IN ('bus_stop', 'bus_station', 'tram_stop', 'subway')
            AND rank IS NULL OR rank = 1
            THEN 1::bigint

        ELSE rank
    END;
$$ LANGUAGE SQL
IMMUTABLE PARALLEL SAFE;


CREATE OR REPLACE FUNCTION mapdata_utils.normalize_poi_relevance(
    name varchar, mapping_key varchar, subclass varchar)
RETURNS bool AS $$
    SELECT CASE
        WHEN (
            name IS NOT NULL AND
            name <> '' AND
            mapping_key IN ('amenity', 'shop') AND
            subclass IN (
                'fast_food', 'food_court', 'biergarten', 'restaurant',
                'bar', 'pub', 'nightclub', 'cafe', 'greengrocer', 'wine',
                'wholesale', 'supermarket', 'butcher', 'convenience',
                'alcohol')
        ) THEN TRUE
    END;
$$ LANGUAGE SQL
IMMUTABLE PARALLEL SAFE;
