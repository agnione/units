#! /bin/bash
##########################################################################################################################
##########################################################################################################################
#   
#   This is the unit build script.
#   This will build and deploy the AgniOne unit to the given AgniOne Framework path
#   Scrip will copy the AgniOne Unit binary to <AgniOne-PATH>/apps/units/ folder
#   Before copy the app.config it will update the unit and config paths
#   Scrip will create folder for the unit name in the <AgniOne-PATH>/apps/config folder & 
#       copy the app.config & unit specific.config (in this case demohttp.config) into it
#
#   usage:  
#        ./build.sh <AgniOne-Framework path>
#   eg:
#        ./build.sh ~/AgniOneFM/AgniOne
##########################################################################################################################

echo "Changed to the Unit folder"
cd $(dirname "$0")

UNIT_NAME=demohttp
VESRION=1.0.0
SOURCE="./unit/demohttp_main.go ./unit/demohttp.go"
BINARY=./unit/demohttp.so

BuildTime=`date`
BuildGoVersion=`go version`

# Setup the -ldflags option for build 
LDFLAGS=" -s -w -X 'unit.demo.http/src/build.Version=${VESRION}' \
-X 'unit.demo.http/src/build.User=$(id -u -n)' \
-X 'unit.demo.http/src/build.Time=${BuildTime}' \
-X 'unit.demo.http/src/build.BuildGoVersion=${BuildGoVersion}' "

cd ${PWD}

cd ./src
echo "clean old binaries....."
rm ${BINARY}
echo "clean old binaries ......... DONE"

echo "building plug-in....."

go build -v -buildmode=plugin -ldflags="${LDFLAGS}" -o ${BINARY} ${SOURCE}

echo "building plug-in ......... DONE"

echo "Deploying ${UNIT_NAME} to $1/apps/units/${UNIT_NAME}.so"

cp ${BINARY} $1/apps/units

cd ..

mkdir -p $1/apps/configs/${UNIT_NAME}

cd ./config
cp ./${UNIT_NAME}.config $1/apps/configs/${UNIT_NAME}/

## make the unit & config path in the app.config
echo "Updating the application configuration ........."
cp ./app.config ./app.temp

sed -i "s|UNIT|$1/apps/units/${UNIT_NAME}.so|g" ./app.temp
sed -i "s|CONFIG|$1/apps/configs/${UNIT_NAME}/${UNIT_NAME}.config|g" ./app.temp
mv ./app.temp $1/apps/configs/${UNIT_NAME}/app.config

echo "Updating the application configuration ......... DONE"

echo "Deployed  ${UNIT_NAME}.so to $1/apps/units/${UNIT_NAME}.so"
echo "Deploying ${UNIT_NAME}.config to $1/apps/configs/${UNIT_NAME}/${UNIT_NAME}.config"
echo "Deploying app.config to $1/apps/configs/${UNIT_NAME}/app.config"
echo "Deploying ${UNIT_NAME} ................... DONE"
cd ..