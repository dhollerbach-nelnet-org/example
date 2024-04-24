#!/bin/bash

RUNNER_NAME=${RUNNER_NAME:-default}
RUNNER_WORKDIR=${RUNNER_WORKDIR:-_work}

# Retrieves a runner token from GitHub
get_runner_token() {
  if [[ -z "${GITHUB_ACCESS_TOKEN}" || -z "${GITHUB_ACTIONS_RUNNER_CONTEXT}" ]]; then
    echo 'One of the mandatory parameters is missing. Quit!'
    exit 1
  else
    AUTH_HEADER="Authorization: token ${GITHUB_ACCESS_TOKEN}"
    USERNAME=$(cut -d/ -f4 <<< ${GITHUB_ACTIONS_RUNNER_CONTEXT})
    REPOSITORY=$(cut -d/ -f5 <<< ${GITHUB_ACTIONS_RUNNER_CONTEXT})

    if [[ -z "${REPOSITORY}" ]]; then 
      TOKEN_REGISTRATION_URL="https://api.github.com/orgs/${USERNAME}/actions/runners/registration-token"
    else
      TOKEN_REGISTRATION_URL="https://api.github.com/repos/${USERNAME}/${REPOSITORY}/actions/runners/registration-token"
    fi

    RUNNER_TOKEN="$(curl -XPOST -fsSL \
      -H "Accept: application/vnd.github.v3+json" \
      -H "${AUTH_HEADER}" \
      "${TOKEN_REGISTRATION_URL}" \
      | jq -r '.token')"
  fi
}

# Function to remove the GitHub Runner
remove_github_runner() {
  echo 'Stopping GitHub Runner...'
  ./config.sh remove --token "${RUNNER_TOKEN}"
}

start_github_runner() {
  get_runner_token

  trap remove_github_runner EXIT SIGINT SIGTERM

  ./config.sh --url "${GITHUB_ACTIONS_RUNNER_CONTEXT}" --token "${RUNNER_TOKEN}" --name "${RUNNER_NAME}" --work "${RUNNER_WORKDIR}"
  ./run.sh & wait
}

start_github_runner
