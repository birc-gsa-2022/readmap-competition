#!/usr/local/bin/bash

source config.sh
source scripts/pull.sh
source scripts/build.sh
source scripts/yaml.sh

verbose "GETTING PROJECT STATUS FROM GITHUB"
status=( $(get_status ${teams[@]}) )
print_status teams status > /dev/stdout # FIXME: write to file
verbose

verbose "DOWNLOADING REPOS THAT PASS THEIR TESTS"
passing=( $(passing_teams teams status) )
download_project_repos $org passing

verbose "DOWNLOADING MY REPOS"
download_project_repos birc-gsa-solutions mydirs

verbose "BUILDING PROJECTS"
#build_projects parsing
build_projects mydirs

verbose "RUNNING GSA PERFORMANCE TOOL"
generate_yaml_spec passing mydirs > gsa.yaml
gsa perf -p preprocessing.txt -m mapping.txt gsa.yaml
