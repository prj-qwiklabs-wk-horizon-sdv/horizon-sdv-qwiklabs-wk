#!/usr/bin/env bash

# Copyright (c) 2024 Accenture, All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Description:
# Initialise the AAOSP repositories.
#
# This script does the following:
#
#  1. Initialises the repository checkout using the given manifest.
#  2. Adds the RPi manifest if the target is an RPi device.
#  3. Downloads the given changeset if the build is from an open review.
#
# The following variables must be set before running this script:
#
#  - AAOS_GERRIT_MANIFEST_URL: the URL of the AAOS manifest.
#  - AAOS_REVISION: the branch or version of the AAOS manifest.
#  - AAOS_LUNCH_TARGET: the target device.
#
# Optional variables:
#  - AAOS_CLEAN: whether to clean before building.
#  - AAOS_ARTIFACT_STORAGE: the persistent storage location for artifacts
#
# For Gerrit review change sets:
#  - GERRIT_PROJECT: the name of the project to download.
#  - GERRIT_CHANGE_NUMBER: the change number of the changeset to download.
#  - GERRIT_PATCHSET_NUMBER: the patchset number of the changeset to download.
#  - GERRIT_FETCH_PATCHSET: use FETCH vs repo download.

# Include common functions and variables.
# shellcheck disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")"/aaos_environment.sh "$0"

# Retry 4 times, on 3rd fail, clean workspace and retry once more.
MAX_RETRIES=4
for ((i=1; i<="${MAX_RETRIES}"; i++)); do
    # Initialise repo checkout.
    repo init -u "${AAOS_GERRIT_MANIFEST_URL}" -b "${AAOS_REVISION}" --depth=1

    # Add RPi manifests if needed.
    if [[ "${AAOS_LUNCH_TARGET}" =~ "rpi" ]]; then
        # Download the RPi manifest if we are building for an RPi device.
        curl -o .repo/local_manifests/manifest_brcm_rpi.xml \
            -L "${AAOS_GERRIT_RPI_MANIFEST_URL}/${AAOS_RPI_REVISION}/manifest_brcm_rpi.xml" \
            --create-dirs || exit 255
        curl -o .repo/local_manifests/remove_projects.xml \
            -L "${AAOS_GERRIT_RPI_MANIFEST_URL}/${AAOS_RPI_REVISION}/remove_projects.xml" \
            || exit 255
    else
        # Remove any old RPi manifests
        rm .repo/local_manifests/manifest_brcm_rpi.xml > /dev/null 2>&1
        rm .repo/local_manifests/remove_projects.xml > /dev/null 2>&1
    fi

    # Clean previous changes.
    # This will automatically clean any previous downloaded changes.
    if ! repo sync --no-tags --optimized-fetch --prune --retry-fetches=3 --auto-gc --no-clone-bundle --fail-fast --force-sync -j2
    then
        echo "WARNING: repo sync failed, sleep 60s and retrying..."
        sleep 60
        if [ "$i" -eq 3 ]; then
            echo "WARNING: clean workspace and retry."
            recreate_workspace
        fi
        if [ "$i" -eq 4 ]; then
            echo "ERROR: repo sync retry failed, giving up."
            exit 255
        fi
    else
        break
    fi
done

echo "SUCCESS: repo sync complete."

# Command to pull in change set from Gerrit.
if [[ -n "${GERRIT_PROJECT}" && -n "${GERRIT_CHANGE_NUMBER}" && -n "${GERRIT_PATCHSET_NUMBER}" ]]; then
    if [[ "${GERRIT_FETCH_PATCHSET}" == "false" ]]; then
        # Use Google repo download to bring in change.
        REPO_CMD="repo download $GERRIT_PROJECT $GERRIT_CHANGE_NUMBER/$GERRIT_PATCHSET_NUMBER"
    else
        # Use standard git fetch to retrieve the change.
        # Find the project name from the manifest.
        PROJECT_PATH=$(repo list -p "${GERRIT_PROJECT}")
        PROJECT_URL=$(echo "${AAOS_GERRIT_MANIFEST_URL}" | cut -d'/' -f1-3)/"${GERRIT_PROJECT}"

        # Extract the last two digits of the change number.
        if (( ${#GERRIT_CHANGE_NUMBER} > 2 )); then
            LAST_TWO_DIGITS=${GERRIT_CHANGE_NUMBER: -2}
        else
            if (( ${#GERRIT_CHANGE_NUMBER} == 1 )); then
                LAST_TWO_DIGITS=0${GERRIT_CHANGE_NUMBER}
            else
                LAST_TWO_DIGITS=${GERRIT_CHANGE_NUMBER}
            fi
        fi

        FETCHED_REFS="refs/changes/${LAST_TWO_DIGITS}"/"${GERRIT_CHANGE_NUMBER}"/"${GERRIT_PATCHSET_NUMBER}"
        # shellcheck disable=SC2164
        REPO_CMD="cd ${PROJECT_PATH} && git fetch ${PROJECT_URL} ${FETCHED_REFS} && git cherry-pick FETCH_HEAD && cd -"
    fi
    echo "Running: ${REPO_CMD}"
    eval "${REPO_CMD}"
fi

# Additional commands to run after repo init.
if [ -n "${POST_INITIALISE_COMMANDS}" ]; then
    eval "${POST_INITIALISE_COMMANDS}"
fi

# Return result
exit $?
