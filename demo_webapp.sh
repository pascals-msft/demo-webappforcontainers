#!/bin/bash

# Creates a demo Web App for Containers
#
# Prerequisites:
# build and push the demo app container image
#   See src/app.py, Dockerfile and demo_build.sh
# install Azure CLI 2.0:
#   https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest
# login:
#   az login
#   az account set --subscription <subscription name>

set -x
LOG_FILE=demo_webapp.log
echo $(date) - $0 > $LOG_FILE

# Variables
LOCATION=westeurope
RG_NAME=demoapplinux
APP_NAME=demoapp$RANDOM
PLAN_NAME=demoappserviceplan
DOCKER_IMAGE="pascals/demo-flask:latest"

read -p "Check above variables: [Enter] if OK, [Ctrl+C] if not."

cat >> $LOG_FILE <<EOF
LOCATION=$LOCATION
RG_NAME=$RG_NAME
APP_NAME=$APP_NAME
PLAN_NAME=$PLAN_NAME
DOCKER_IMAGE=$DOCKER_IMAGE
EOF

# Create a Resource Group
echo ---------- >> $LOG_FILE
echo Resource Group >> $LOG_FILE
az group create -n $RG_NAME -l $LOCATION -o json | tee -a $LOG_FILE

# Create an App Service Plan
# Only Basic or Standard are supported for Web App for Containers
echo ---------- >> $LOG_FILE
echo App Service Plan >> $LOG_FILE
az appservice plan create -n $PLAN_NAME -g $RG_NAME --is-linux --sku B1 -o json | tee -a $LOG_FILE

# Create a Web App
echo ---------- >> $LOG_FILE
echo Web app >> $LOG_FILE
az webapp create -n $APP_NAME -p $PLAN_NAME -g $RG_NAME -i $DOCKER_IMAGE -o json | tee -a $LOG_FILE

# App settings: port translation
echo ---------- >> $LOG_FILE
echo Web app settings: port translation >> $LOG_FILE
az webapp config appsettings set -g $RG_NAME -n $APP_NAME --settings WEBSITES_PORT=5000 -o json | tee -a $LOG_FILE
az webapp config appsettings list -g $RG_NAME -n $APP_NAME -o json | tee -a $LOG_FILE

# Test the app
curl http://$APP_NAME.azurewebsites.net
curl http://$APP_NAME.azurewebsites.net/json



