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
## make sure the image is already built using 
##   docker build  --no-cache -t agnione.net/unitbuilder:0.0.0.2 .
##
# 1.    start the unit builder container
# 2.    clone the AgniOne packages from repo and move to go packages folder
# 3.    clone the demo HTTP unit repo
# 4.    executes the ./build.sh of unit
# 5.    copy unit binary & config files to "release" folder
# 6.    stop and delete the unit build container
###################################################################################################################

echo "AgniOne Unit Building Starting "


docker run --name unit_builder -it -d agnione.net/unitbuilder:0.0.0.2 

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
docker stop unit_builder && docker rm unit_builder

echo "AgniOne Unit Building completed"






