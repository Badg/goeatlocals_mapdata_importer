#!/bin/bash
BORDERS_FILTERED_PBF=/project_data/importer/norcal_borders-latest.pbf
BORDERS_FILTERED_CSV=/project_data/importer/norcal_borders-latest.csv
STAGING_SCHEMA=mapdata_staging
PROD_SCHEMA=mapdata_prod
BACKUP_SCHEMA=mapdata_backup

imposm import \
    -config /project_src/omt_imposm3_config.json \
    -read /project_data/osm_extracts/norcal-latest.osm.pbf \
    -write \
    || exit $?

echo "Imposm done. Doing borders..."

if [ -f $BORDERS_FILTERED_PBF ] ; then
    rm $BORDERS_FILTERED_PBF
fi

if [ -f $BORDERS_FILTERED_CSV ] ; then
    rm $BORDERS_FILTERED_CSV
fi

osmborder_filter -o \
    "$BORDERS_FILTERED_PBF" \
    /project_data/osm_extracts/norcal-latest.osm.pbf \
    || exit $?

osmborder -o \
    "$BORDERS_FILTERED_CSV" \
    "$BORDERS_FILTERED_PBF" \
    || exit $?
    
echo "Borders prepped, psqling them into staging..."

PGPASSWORD=postgres psql \
    --host=goeatlocals_client_web-postgis \
    --username=postgres \
    -d gis \
    -v ON_ERROR_STOP=1 \
    -c "DROP TABLE IF EXISTS ${STAGING_SCHEMA}.osm_border_linestring CASCADE;" \
    -c "CREATE TABLE ${STAGING_SCHEMA}.osm_border_linestring (osm_id bigint, admin_level int, dividing_line bool, disputed bool, maritime bool, geometry Geometry(LineString, 3857));" \
    -c "CREATE INDEX ON ${STAGING_SCHEMA}.osm_border_linestring USING gist (geometry);" \
    -c "\copy ${STAGING_SCHEMA}.osm_border_linestring FROM '$BORDERS_FILTERED_CSV' DELIMITER E'\t' CSV;" \
    || exit $?

echo "Borders done! Proceeding with dynamic-dependent SQL..."

# TODO: could *actually* parallelize this, but right now there's not really any
# point
for f in /project_src/goeatlocals_mapdata_importer/dynamic/sql/*.sql
do
    echo "$f"
    PGPASSWORD=postgres psql \
        --host=goeatlocals_client_web-postgis \
        --username=postgres \
        -d gis \
        -v ON_ERROR_STOP=1 \
        -f "$f" \
        2>&1 \
        || exit $?
done

echo "Rotating schemas..."
PGPASSWORD=postgres psql \
    --host=goeatlocals_client_web-postgis \
    --username=postgres \
    -d gis \
    -v ON_ERROR_STOP=1 \
    -f /project_src/goeatlocals_mapdata_importer/dynamic/rotate_schemas.sql \
    2>&1 \
    || exit $?

echo "Success!"
