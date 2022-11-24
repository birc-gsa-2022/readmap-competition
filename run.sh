#!/usr/local/bin/bash
#/opt/homebrew/bin/bash

source config.sh
source scripts/utils.sh
source scripts/pull.sh
source scripts/build.sh
source scripts/yaml.sh

# setup a python environment for stuff that might be installed...
if [[ -d ./gsa ]]; then
    source ./gsa/bin/activate
else
    python3 -m venv ./gsa
    source ./gsa/bin/activate
    python3 -m pip install git+https://github.com/birc-gsa/gsa#egg=gsa
fi

verbose $(blue "GETTING PROJECT STATUS FROM GITHUB")
status=( $(get_status ${teams[@]}) )
print_status teams status > res/status.txt
verbose

verbose $(blue "DOWNLOADING REPOS THAT PASS THEIR TESTS")
passing=( $(passing_teams teams status) )
download_project_repos $org passing || error $(red "Couldn't download projects")

verbose $(yellow "DOWNLOADING MY REPOS")
download_project_repos birc-gsa-solutions mydirs || error $(red "Couldn't download my versions")

verbose $(blue "BUILDING PROJECTS")
build_projects parsing  || error $(red "Couldn't build projects")
build_projects mydirs   || error $(red "Couldn't build my solutions")

verbose $(blue "RUNNING GSA PERFORMANCE TOOL") $(orange "(this will be slow...)")
[[ -d res ]] || mkdir res
generate_yaml_spec passing mydirs > gsa.yaml                                || error $(red "Error generating gsa yaml")
gsa perf -n ${gsa_rep} -p res/preprocessing.txt -m res/mapping.txt gsa.yaml || error $(red "Error running gsa")
verbose $(green "Slow stuff finally done!")

verbose $(blue "GENERATING REPORT")
Rscript -e "rmarkdown::render('README.rmd')"

deactivate # leave the python environment again
