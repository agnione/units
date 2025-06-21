#################################################################################################################
# Author        :   D. Ajith Nilantha de Silva ajithdesilva@gmail.com,aontact@agnione.net
# Copyright     :   AgniOne.Net 2025
# Date Written  :   20/06/2025
# Class/module  :   AgniOne Unit Alpine build
# Objective     :   Use the Alpine amd64 latest as platform for AgniOne unit that can work with production docker 
#                   image of  AgniOne Framework.
#################################################################################################################
##  V2
## 0. docker image rm agnione.net/unitbuilder:0.0.0.2
##
## 1. build alpine docker image
##      docker build   -t agnione.net/unitbuilder:0.0.0.2 .
##
## 2 run image
##      docker run --name unit_builder -it agnione.net/unitbuilder:0.0.0.2
##
## 3 remove test container
##      docker stop unit_builder && docker rm unit_builder
###################################################################################################################

## builder
FROM golang:1.24.4-alpine AS agnione_unit_builder

RUN apk --no-cache add build-base bash git

RUN mkdir -p /home/units/
RUN mkdir -p /home/src/units

WORKDIR /home/src
