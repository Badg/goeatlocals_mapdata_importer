#!/bin/bash
PGPASSWORD=postgres ogr2ogr \
    -progress \
    -f Postgresql \
    -s_srs EPSG:3857 \
    -t_srs EPSG:3857 \
    -lco OVERWRITE=YES \
    -lco GEOMETRY_NAME=geometry \
    -nln "osm_ocean_polygon" \
    -nlt geometry \
    --config PG_USE_COPY YES \
    PG:"host=goeatlocals_client_web-postgis user=postgres dbname=gis" "/project_data/osm_extracts/water-polygons-split-3857/water_polygons.shp" && \
PGPASSWORD=postgres ogr2ogr \
    -progress \
    -f Postgresql \
    -s_srs EPSG:4326 \
    -t_srs EPSG:3857 \
    -clipsrc -180.1 -85.0511 180.1 85.0511 \
    -lco GEOMETRY_NAME=geometry \
    -lco OVERWRITE=YES \
    -lco DIM=2 \
    -nlt GEOMETRY \
    -overwrite \
    PG:"host=goeatlocals_client_web-postgis user=postgres dbname=gis" "/project_data/osm_extracts/natural_earth_vector.sqlite" && \
PGPASSWORD=postgres ogr2ogr \
    -progress \
    -f Postgresql \
    -s_srs EPSG:4326 \
    -t_srs EPSG:3857 \
    -lco OVERWRITE=YES \
    -overwrite \
    -nln "lake_centerline" \
    PG:"host=goeatlocals_client_web-postgis user=postgres dbname=gis"  "/project_data/osm_extracts/lake_centerline.geojson"
