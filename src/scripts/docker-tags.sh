Setup() {    
    echo "$(date +'%d %B %Y - %k:%M') - Setup: Evaluating the variables coming from context"
    USERNAME=$(eval echo "$PARAM_USERNAME")
    PASSWORD=$(eval echo "$PARAM_PASSWORD")

    PARAM_VERSION_MAJOR=$(echo "${PARAM_VERSION}" | awk -F . '{print $1}' )
    PARAM_VERSION_MINOR=$(echo "${PARAM_VERSION}" | awk -F . '{print $2}' )
    PARAM_VERSION_HF=$(echo "${PARAM_VERSION}" | awk -F . '{print $3}' )
    PARAM_VERSION_CLASSIFIER=$(echo "${PARAM_VERSION}" | awk -F - '{print $2}' )

    if [ "$PARAM_VERSION_CLASSIFIER" != "" ]; then
        PARAM_VERSION_CLASSIFIER='-'$PARAM_VERSION_CLASSIFIER
    fi

    AUTH_DOMAIN="auth.docker.io"
    AUTH_SERVICE="registry.docker.io"
    AUTH_SCOPE="repository:${DOCKER_HUB_ORG}/${DOCKER_HUB_REPO}:pull"
    AUTH_OFFLINE_TOKEN="1"
    AUTH_CLIENT_ID="shell"

    API_DOMAIN="registry-1.docker.io"
}

GetToken() {
    echo "$(date +'%d %B %Y - %k:%M') - GetToken: Fetching Token from container registry: ${AUTH_SERVICE}"
    # TOKEN=$(curl -s -X GET -u ${USERNAME}:${PASSWORD} "https://${AUTH_DOMAIN}/token?service=${AUTH_SERVICE}&scope=${AUTH_SCOPE}&offline_token=${AUTH_OFFLINE_TOKEN}&client_id=${AUTH_CLIENT_ID}" | jq -r '.token')
    TOKEN=$(curl -s -X GET -u "${USERNAME}":"${PASSWORD}" "https://${AUTH_DOMAIN}/token?service=${AUTH_SERVICE}&scope=${AUTH_SCOPE}&offline_token=${AUTH_OFFLINE_TOKEN}&client_id=${AUTH_CLIENT_ID}" | jq -r '.token')
    echo "$(date +'%d %B %Y - %k:%M') - GetToken: Fetch complete"
}

GetVersions() {
    echo "$(date +'%d %B %Y - %k:%M') - GetVersions: Fetching container versions from container registry: ${AUTH_SERVICE}"
    # TOKEN=$(curl -s -X GET -u ${USERNAME}:${PASSWORD} "https://${AUTH_DOMAIN}/token?service=${AUTH_SERVICE}&scope=${AUTH_SCOPE}&offline_token=${AUTH_OFFLINE_TOKEN}&client_id=${AUTH_CLIENT_ID}" | jq -r '.token')
    VERSIONS=$(curl -s -H "Authorization: Bearer ${TOKEN}" https://${API_DOMAIN}/v2/"${DOCKER_HUB_ORG}"/"${DOCKER_HUB_REPO}"/tags/list | jq -r '.tags[]' | grep -E "^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$PARAM_VERSION_CLASSIFIER$")
    echo "$(date +'%d %B %Y - %k:%M') - GetVersions: Fetch complete"

}

DockerTags() {
    echo Checking version: "${PARAM_VERSION}" against repository: "${PARAM_ORG}"/"${PARAM_REPO}"
    
    # VERSIONS=$(curl -s -H "Authorization: Bearer ${TOKEN}" https://${API_DOMAIN}/v2/${DOCKER_HUB_ORG}/${DOCKER_HUB_REPO}/tags/list | jq -r '.tags[]' | grep -E "^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$PARAM_VERSION_CLASSIFIER$")

    # if ! (echo "$VERSIONS" | grep $PARAM_VERSION); then
    if ! (echo "$VERSIONS" | grep "$PARAM_VERSION"); then
        echo "$PARAM_VERSION" not found yet, adding it
        VERSIONS=$(echo -e "${VERSIONS}\n${PARAM_VERSION}")
    fi

    VERSIONS=$(echo "$VERSIONS" | sort --version-sort)

    echo "$(date +'%d %B %Y - %k:%M') - The following tags exists: ${VERSIONS}"

    # echo All versions : "$VERSIONS"

    LATEST=$(echo "$VERSIONS" | tail -1)
    MATCHING1=$(echo "$VERSIONS" | grep -E "^${PARAM_VERSION_MAJOR}\." | tail -1)
    MATCHING2=$(echo "$VERSIONS" | grep -E "^${PARAM_VERSION_MAJOR}\.${PARAM_VERSION_MINOR}\." | tail -1)
    MATCHING3=$(echo "$VERSIONS" | grep -E "^${PARAM_VERSION_MAJOR}\.${PARAM_VERSION_MINOR}\.${PARAM_VERSION_HF}\." | tail -1)


    if [ "$LATEST" == "$PARAM_VERSION" ]; then
        echo latest "${PARAM_VERSION_CLASSIFIER}" is : "$LATEST" , require tag update
    else
        echo latest "${PARAM_VERSION_CLASSIFIER}" is : "$LATEST" , unchanged
    fi

    if [ "$MATCHING1" == "$PARAM_VERSION" ]; then
        echo "${PARAM_VERSION_MAJOR}""${PARAM_VERSION_CLASSIFIER}" is : "$MATCHING1" , require tag update
    else
        echo "${PARAM_VERSION_MAJOR}""${PARAM_VERSION_CLASSIFIER}" is : "$MATCHING1" , unchanged
    fi

    if [ "$MATCHING2" == "$PARAM_VERSION" ]; then
        echo "${PARAM_VERSION_MAJOR}"."${PARAM_VERSION_MINOR}""${PARAM_VERSION_CLASSIFIER}" is : "$MATCHING2" , require tag update
    else
        echo "${PARAM_VERSION_MAJOR}"."${PARAM_VERSION_MINOR}""${PARAM_VERSION_CLASSIFIER}" is : "$MATCHING2" , unchanged
    fi

    if [ "$MATCHING3" == "$PARAM_VERSION" ]; then
        echo "${PARAM_VERSION_MAJOR}"."${PARAM_VERSION_MINOR}"."${PARAM_VERSION_HF}""${PARAM_VERSION_CLASSIFIER}" is : "$MATCHING3" , require tag update
    else
        echo "${PARAM_VERSION_MAJOR}"."${PARAM_VERSION_MINOR}"."${PARAM_VERSION_HF}""${PARAM_VERSION_CLASSIFIER}" is : "$MATCHING3" , unchanged
    fi    
}

Main() {
    Setup
    GetToken
    DockerTags
    
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    Main
fi
