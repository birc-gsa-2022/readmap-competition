#!/usr/local/bin/bash

source config.sh
source scripts/pull.sh
source scripts/build.sh
source scripts/yaml.sh

# verbose "GETTING PROJECT STATUS FROM GITHUB"
# status=( $(get_status ${teams[@]}) )
# print_status teams status > /dev/stdout # FIXME: write to file
# verbose
# 
# verbose "DOWNLOADING REPOS THAT PASS THEIR TESTS"
# passing=( $(passing_teams teams status) )
# download_repos passing

passing=("project-5-python-armando-christian-perez", "project-5-go-holdet")
generate_yaml_spec passing