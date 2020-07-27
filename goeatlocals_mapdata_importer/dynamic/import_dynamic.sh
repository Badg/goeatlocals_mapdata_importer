#!/bin/bash
BORDERS_FILTERED_PBF=/project_data/importer/norcal_borders-latest.pbf
BORDERS_FILTERED_CSV=/project_data/importer/norcal_borders-latest.csv
STAGING_SCHEMA=mapdata_staging
PROD_SCHEMA=mapdata_prod
BACKUP_SCHEMA=mapdata_backup

imposm import \
    -config /project_src/omt_imposm3_config.json \
    -overwritecache \
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

mkdir -p /tmp/sql_sed

# TODO: could *actually* parallelize this, but right now there's not really any
# point
for f in /project_src/goeatlocals_mapdata_importer/dynamic/sql/*.sql
do
    FILENAME=$(basename "$f")
    DEST_TMPFILE="/tmp/sql_sed/$FILENAME"
    echo "Source $f"
    echo "Temp $DEST_TMPFILE"
    sed \
        -e "s/__use_schema__/$STAGING_SCHEMA/g" \
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
        -f "$DEST_TMPFILE" \
        2>&1 \
        || exit $?
done

echo "Rotating schemas..."
SRC_FILE="/project_src/goeatlocals_mapdata_importer/dynamic/rotate_schemas.sql"
DEST_TMPFILE="/tmp/sql_sed/rotate_schemas.sql"
sed \
    -e "s/__use_schema__/$STAGING_SCHEMA/g" \
    -e "s/__prod_schema__/$PROD_SCHEMA/g" \
    -e "s/__staging_schema__/$STAGING_SCHEMA/g" \
    -e "s/__backup_schema__/$BACKUP_SCHEMA/g" \
    "$SRC_FILE" > "$DEST_TMPFILE" \
    || exit $?

PGPASSWORD=postgres psql \
    --host=goeatlocals_client_web-postgis \
    --username=postgres \
    -d gis \
    -v ON_ERROR_STOP=1 \
    -f "$DEST_TMPFILE" \
    2>&1 \
    || exit $?

rm -r /tmp/sql_sed
echo "Success!"
