#! /bin/bash

#################################################################################################################
# Author        :   D. Ajith Nilantha de Silva ajithdesilva@gmail.com,aontact@agnione.net
# Copyright     :   AgniOne.Net 2025
# Date Written  :   21/06/2025
# Class/module  :   AgniOne Unit Alpine build shell script
# Objective     :   Use the Alpine amd64 latest as platform for AgniOne unit that can work with production docker 
#                   image of  AgniOne Framework.
#                   This script will build the Unit and copy the unit's config files + binary to host "release"
#                   folder
#################################################################################################################
# 1.    start the unit builder container
# 2.    clone the AgniOne packages from repo and move to go packages folder
# 3.    clone the demo HTTP unit repo
# 4.    executes the ./build.sh of unit. ./build_alpine_unit.sh <PATH-TO-TARGET-FOLDER>
# 4.1   ./build_alpine_unit.sh /home/${USER}/agnione/release
# 5.    copy unit binary & config files to  <PATH-TO-TARGET-FOLDER> folder
# 6.    stop and delete the unit build container
###################################################################################################################

echo "AgniOne Unit Building Starting "

docker run --name unit_builder -it -d golang:1.24.4-alpine

docker exec unit_builder apk --no-cache add build-base bash git

## make for parent target folder
echo "Creating target folders"
docker exec unit_builder mkdir -p -m 755 /usr/local/go/src/agnione
docker exec unit_builder mkdir -p -m 755 /usr/src
docker exec unit_builder mkdir -p -m 755 /home/agnione/apps/units
docker exec unit_builder mkdir -p -m 755 /home/agnione/apps/configs

echo "Get AgniOne packages"
docker exec unit_builder git clone -b v2 https://github.com/agnione/libs.git  
docker exec unit_builder mv ./libs/v2 /usr/local/go/src/agnione/

echo "Get AgniOne HTTP demo package"
docker exec unit_builder git clone -b v2 https://github.com/agnione/units.git 
docker exec unit_builder mv ./units /usr/src

echo "Build AgniOne HTTP demo unit"
docker exec unit_builder chmod 755 /usr/src/units/build.sh
docker exec unit_builder /usr/src/units/build.sh /home/agnione

## fetch the given target path
DEST_PATH="$1"
if [ ! -n "$DEST_PATH" ]
then
	$DEST_PATH=./releases
fi

echo "Copy Built Unit folder (config + binaries) to HOST -> $DEST_PATH "
mkdir -p $DEST_PATH
docker cp  unit_builder:/home/agnione/apps ${DEST_PATH}
echo "Copy Built Binaries to HOST............................DONE "

echo "Stop temporary  unit builder container & remove it"
docker stop unit_builder && docker rm unit_builder
echo "AgniOne Unit Building completed"






