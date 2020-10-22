#!/bin/bash
#==============================================================================
# filename          : python_setup.sh
# description       : script responsável por criar o ambiente no GCP
# author            : daniel
# email             : daniel@dqsdatalabs.com
# date              : 17.10.2020
# version           : 0.01
#==============================================================================

###############################################
# functions
###############################################

function create_gcp_params_file(){
    > ./src/config/configuration.ini
    echo "[GCP]" >> ./src/config/configuration.ini
    echo "CONFIG=config-"$RANDOM  >> ./src/config/configuration.ini
    echo "SVC_NAME=svc-"$RANDOM  >> ./src/config/configuration.ini
    echo "PROJECT_ID=gcp-boavista-"$RANDOM  >> ./src/config/configuration.ini
    echo "REGION=southamerica-east1"  >> ./src/config/configuration.ini
    echo "ZONE=southamerica-east1-a"  >> ./src/config/configuration.ini
    echo "DATASET=raw"  >> ./src/config/configuration.ini
}

function set_variables(){
    CONFIG=$(awk -F "=" '/CONFIG/ {print $2}' ./src/config/configuration.ini)
    SVC_NAME=$(awk -F "=" '/SVC_NAME/ {print $2}' ./src/config/configuration.ini)
    PROJECT_ID=$(awk -F "=" '/PROJECT_ID/ {print $2}' ./src/config/configuration.ini)
    REGION=$(awk -F "=" '/REGION/ {print $2}' src/config/configuration.ini)
    ZONE=$(awk -F "=" '/ZONE/ {print $2}' ./src/config/configuration.ini)
}

function build_gcp_enviroment() {

    echo "-----------------------------------"
    echo "construindo artefatos no GCP, aguarde.."
    echo "-----------------------------------"

    gcloud config configurations create ${CONFIG}
    gcloud config configurations activate ${CONFIG}

    gcloud config set compute/zone ${ZONE}
    gcloud config set compute/region ${REGION}
    gcloud config set project ${PROJECT_ID}
    gcloud config set account ${GCP_ACCOUNT}

    gcloud projects create ${PROJECT_ID} \
        --quiet

    gcloud iam service-accounts create ${SVC_NAME} \
        --display-name ${SVC_NAME} \
        --quiet

    gcloud projects add-iam-policy-binding ${PROJECT_ID} \
        --member serviceAccount:${SVC_NAME}@${PROJECT_ID}.iam.gserviceaccount.com \
        --role roles/owner \
        --quiet

    gcloud iam service-accounts keys create .private/account.json \
        --iam-account=${SVC_NAME}@${PROJECT_ID}.iam.gserviceaccount.com \
        --quiet

    export GOOGLE_APPLICATION_CREDENTIALS="./.private/account.json"

}

function build_python_enviroment() {
    echo "-----------------------------------"
    echo "inicializando o ambiente, aguarde.."
    echo "-----------------------------------"

    pip install virtualenv
    virtualenv boa_vista_env

    ./boa_vista_env/bin/activate
    ./boa_vista_env/bin/pip3 install configparser
    ./boa_vista_env/bin/pip3 install google.oauth2
    ./boa_vista_env/bin/pip3 install google-cloud-bigquery
}

function run_pipeline() {
    echo "-----------------------------------"
    echo "inicializando o pipeline, aguarde..."
    echo "-----------------------------------"

    ./boa_vista_env/bin/python3 src/main.py 
}

###############################################
# main
###############################################

if test -z "${GCP_ACCOUNT}"; then
  echo "ERRO: variável GCP_ACCOUNT não informada!"
  exit 1
fi

create_gcp_params_file;
set_variables;
build_gcp_enviroment;
build_python_enviroment;
sleep 3
run_pipeline;