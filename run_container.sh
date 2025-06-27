#!/bin/sh

mkdir -p /var/logs/demohttp

docker run -it \
    --hostname agni_demoHttp_app \
    --name agni_demoHttp_app \
    --restart unless-stopped \
    --volume=/home/$USER/temp/agnione/release/apps/units:/home/agnione/apps/units/  \
    --volume=/home/$USER/temp/agnione/release/apps/configs/demohttp:/home/agnione/apps/configs  \
    --volume=/var/logs/demohttp:/var/log/app \
    -p 8900:8080/tcp \
    -p 9001:8081/tcp \
    -d agnione.net/agnione:0.0.0.2 
    

    docker logs -f agni_demoHttp_app
