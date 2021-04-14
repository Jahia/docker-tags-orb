DockerTags() {
    echo  Checking version: "${PARAM_VERSION}" against image: "${PARAM_ORG}"/"${PARAM_REPO}"
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    DockerTags
fi
