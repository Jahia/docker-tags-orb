# Runs prior to every test
setup() {
    # Load our script file.
    source ./src/scripts/docker-tags.sh
}

log() {
  echo "$(tput setaf 6)status: ${status}$(tput sgr 0)"
  echo "$(tput setaf 6)output: ${output}$(tput sgr 0)"
}

@test '1: Run DockerTags' {
    # Mock environment variables or functions by exporting them (after the script has been sourced)
    export PARAM_VERSION="1.0.0.0"
    export PARAM_VERSION="jahia"
    export PARAM_VERSION="jahia"
    # Capture the output of our "DockerTags" function
    result=$(DockerTags)
    [ "$result" == "Checking version: 1.0.0.0*" ]
}