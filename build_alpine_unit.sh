#! /bin/bash

echo "AgniOne Unit Building Starting "

## make sure the image is already build using 
##   docker build  --no-cache -t agnione.net/unitbuilder:0.0.0.2 .
##   docker run --name unit_builder -it agnione.net/unitbuilder:0.0.0.2


docker start unit_builder

echo "Deleting old files + folders to avoid any issues"
docker exec unit_builder rm -rfv /usr/local/go/src/agnione
docker exec unit_builder rm -rfv /home/src/libs
docker exec unit_builder rm -rfv /home/src/units
docker exec unit_builder rm -rfv /home/agnione/apps

## make for parent target folder
echo "Creating target folders"
docker exec unit_builder mkdir -p -m 755 /usr/local/go/src/agnione
docker exec unit_builder mkdir -p -m 755 /home/agnione/apps/units
docker exec unit_builder mkdir -p -m 755 /home/agnione/apps/configs

echo "Get AgniOne packages"
docker exec unit_builder git clone -b v2 https://github.com/agnione/libs.git 
docker exec unit_builder mv ./libs/v2 /usr/local/go/src/agnione/

echo "Get AgniOne HTTP demo package"
docker exec unit_builder git clone -b v2 https://github.com/agnione/units.git 
docker exec unit_builder chmod 755 /home/src/units/build.sh

echo "Build AgniOne HTTP demo unit"
docker exec unit_builder /home/src/units/build.sh /home/agnione

echo "Copy Built Unit folder (config + binaries) to HOST............................ "
docker cp unit_builder:/home/agnione/apps ${PWD}/release
echo "Copy Built Binaries to HOST............................DONE "

echo "Stop temporary  unit builder container & remove it"
#docker stop unit_builder
##docker rm unit_builder

echo "AgniOne Unit Building completed"






