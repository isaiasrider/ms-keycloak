docker build \
    -t local_build:keycloak \
    --build-arg KEYCLOAK_DB_HOST=$KEYCLOAK_DB_QAS_HOST \
    --build-arg KEYCLOAK_DB_DATABASE=$KEYCLOAK_DB_QAS_DATABASE \
    --build-arg KEYCLOAK_DB_USER=$KEYCLOAK_DB_QAS_USER \
    --build-arg KEYCLOAK_DB_PASS=$KEYCLOAK_DB_QAS_PASSWORD \
    -f ../Dockerfile ../

docker run --rm --name Keycloak_Test -p8080:8080 local_build:keycloak