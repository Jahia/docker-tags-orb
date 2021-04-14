# Runs prior to every test
setup() {
    # Load our script file.
    source ./src/scripts/docker-tags.sh
}

@test '1: Run DockerTags' {
    # Mock environment variables or functions by exporting them (after the script has been sourced)
    export PARAM_VERSION="1.0.0.0"
    # Capture the output of our "DockerTags" function
    result=$(DockerTags)
    [ "$result" == "Received version: 1.0.0.0" ]
}