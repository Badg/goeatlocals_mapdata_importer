#!/bin/bash
STAGING_SCHEMA=mapdata_staging
PROD_SCHEMA=mapdata_prod
BACKUP_SCHEMA=mapdata_backup

# Prod schema
# TODO: if you want to canary the database updates, you'll need to add copies
# of this for the staging_schema
PGPASSWORD=postgres ogr2ogr \
    -progress \
    -f Postgresql \
    -s_srs EPSG:3857 \
    -t_srs EPSG:3857 \
    -lco OVERWRITE=YES \
    -lco GEOMETRY_NAME=geometry \
    -lco SCHEMA=$PROD_SCHEMA \
    -nln "osm_ocean_polygon" \
    -nlt geometry \
    --config PG_USE_COPY YES \
    PG:"host=goeatlocals_client_web-postgis user=postgres dbname=gis" "/project_data/osm_extracts/water-polygons-split-3857/water_polygons.shp" \
    || exit $?
PGPASSWORD=postgres ogr2ogr \
    -progress \
    -f Postgresql \
    -s_srs EPSG:4326 \
    -t_srs EPSG:3857 \
    -clipsrc -180.1 -85.0511 180.1 85.0511 \
    -lco GEOMETRY_NAME=geometry \
    -lco OVERWRITE=YES \
    -lco DIM=2 \
    -lco SCHEMA=$PROD_SCHEMA \
    -nlt GEOMETRY \
    -overwrite \
    PG:"host=goeatlocals_client_web-postgis user=postgres dbname=gis" "/project_data/osm_extracts/natural_earth_vector.sqlite" \
    || exit $?
PGPASSWORD=postgres ogr2ogr \
    -progress \
    -f Postgresql \
    -s_srs EPSG:4326 \
    -t_srs EPSG:3857 \
    -lco OVERWRITE=YES \
    -lco SCHEMA=$PROD_SCHEMA \
    -overwrite \
    -nln "lake_centerline" \
    PG:"host=goeatlocals_client_web-postgis user=postgres dbname=gis"  "/project_data/osm_extracts/lake_centerline.geojson" \
    || exit $?

mkdir -p /tmp/sql_sed

for f in /project_src/goeatlocals_mapdata_importer/quasistatic/sql/*.sql
do
    FILENAME=$(basename "$f")
    DEST_TMPFILE="/tmp/sql_sed/$FILENAME"
    echo "Source $f"
    echo "Temp $DEST_TMPFILE"
    sed \
        -e "s/__use_schema__/$PROD_SCHEMA/g" \
        -e "s/__prod_schema__/$PROD_SCHEMA/g" \
        -e "s/__staging_schema__/$STAGING_SCHEMA/g" \
        -e "s/__backup_schema__/$BACKUP_SCHEMA/g" \
        "$f" > "$DEST_TMPFILE" \
        || exit $?

    PGPASSWORD=postgres psql \
        --host=goeatlocals_client_web-postgis \
        --username=postgres \
        -d gis \
        -v ON_ERROR_STOP=1 \
        -v check_function_bodies=off \
        -c "SET check_function_bodies = off;" \
        -f "$DEST_TMPFILE" \
        -c "SET check_function_bodies = on;" \
        2>&1 \
        || exit $?
done

rm -r /tmp/sql_sed
echo "Success!"
