#!/bin/bash

set -x
LOG_FILE=demo_db.log
echo $(date) - $0 > $LOG_FILE

# Resource Group
RG_NAME=demoapplinux
echo RG_NAME=$RG_NAME >> $LOG_FILE

read -p "Check above variables: [Enter] if OK, [Ctrl+C] if not."

# Cosmos DB account
while :
do
    ACCOUNT_NAME=db$RANDOM
    echo ACCOUNT_NAME=$ACCOUNT_NAME >> $LOG_FILE
    NAME_EXISTS=$(az cosmosdb check-name-exists -n $ACCOUNT_NAME -o tsv)
    echo NAME_EXISTS=$NAME_EXISTS >> $LOG_FILE
    if [ $NAME_EXISTS = false ]
    then
        break
    fi
done

echo ---------- >> $LOG_FILE
echo Create a new Azure Cosmos DB database account >> $LOG_FILE
az cosmosdb create -n $ACCOUNT_NAME -g $RG_NAME --kind MongoDB -o json | tee -a $LOG_FILE

# Database
echo ---------- >> $LOG_FILE
echo Creates an Azure Cosmos DB database >> $LOG_FILE
DB_NAME=${ACCOUNT_NAME}_database
echo DB_NAME=$DB_NAME >> $LOG_FILE
az cosmosdb database create -d $DB_NAME -n $ACCOUNT_NAME -g $RG_NAME -o json | tee -a $LOG_FILE

# Collection
echo ---------- >> $LOG_FILE
echo Creates an Azure Cosmos DB collection >> $LOG_FILE
COLL_NAME=${ACCOUNT_NAME}_collection
echo COLL_NAME=$COLL_NAME >> $LOG_FILE
az cosmosdb collection create -c $COLL_NAME -d $DB_NAME -n $ACCOUNT_NAME  -g $RG_NAME -o json | tee -a $LOG_FILE
