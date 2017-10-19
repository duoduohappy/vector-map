#!/usr/bin/env bash

if [ ! -e data.pbf ]; then
	wget -O data.pbf http://osm.ramuno.lt/vilnius.pbf
fi

CONTAINER_DB=`docker-compose ps -q db`
# install shp2pgsql
docker exec $CONTAINER_DB apt update -qy && apt install -qy postgis

# load data
docker run --rm -it -w /tmp/src -v `pwd`:/tmp/src --network "container:$CONTAINER_DB" -e PGPASSWORD=osm openmap/osm2pgsql:latest osm2pgsql -s -c -C 512 --multi-geometry -S osm2pgsql.style -d osm -U osm -H db data.pbf
docker exec -it -u postgres $CONTAINER_DB sh -c 'shp2pgsql -dDI -s 3857 /src/queries/coastline/coastline.shp | psql osm'
