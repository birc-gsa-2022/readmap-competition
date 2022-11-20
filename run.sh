#!/usr/local/bin/bash

source config.sh
source scripts/utils.h
source scripts/pull.sh
source scripts/build.sh
source scripts/yaml.sh

verbose "GETTING PROJECT STATUS FROM GITHUB"
status=( $(get_status ${teams[@]}) )
print_status teams status > status.txt
verbose

verbose "DOWNLOADING REPOS THAT PASS THEIR TESTS"
passing=( $(passing_teams teams status) )
download_project_repos $org passing || error "Couldn't download projects"

verbose "DOWNLOADING MY REPOS"
download_project_repos birc-gsa-solutions mydirs || error "Couldn't download my versions"

verbose "BUILDING PROJECTS"
build_projects parsing  || error "Couldn't build projects"
build_projects mydirs   || error "Couldn't build my solutions"

verbose "RUNNING GSA PERFORMANCE TOOL"
generate_yaml_spec passing mydirs > gsa.yaml          || error "Error generating gsa yaml"
gsa perf -p preprocessing.txt -m mapping.txt gsa.yaml || error "Error running gsa"

verbose "GENERATING REPORT"
Rscript -e "rmarkdown::render('R/gen_report.rmd', output_file = '../README.md')"

