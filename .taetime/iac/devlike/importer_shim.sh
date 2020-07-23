mkdir -p /project_data/importer
/bin/bash /project_src/goeatlocals_mapdata_importer/quasistatic/import_quasistatic.sh && \
/bin/bash /project_src/goeatlocals_mapdata_importer/dynamic/import_dynamic.sh
