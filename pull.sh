#!/usr/local/bin/bash
# FIXME: find more robust way to get the most recent bash

source config.sh

function verbose() {
    echo $* > /dev/stderr
}

function workflow_action_id() {
    local repo=$1
    gh --repo ${repo} run list | \
        grep 'GitHub Classroom Workflow' | \
        head -1 | cut -f 7
}

function repo_status() {
    local repo=$1
    gh --repo $repo run view $(workflow_action_id $repo) \
        --exit-status \
        > /dev/null
    (( $? == 0 )) && echo 'pass' || echo 'fail'
}

function get_status() {
    local teams=($@)
    verbose
    verbose "CHECKING IF PROJECTS TEST SUCCESSFULLY"
    verbose
    for team in ${teams[@]}; do
        verbose -n "${team}..."
        local repo=$(repo $team)
        #local status=$(repo_status ${repo})
        status='pass' # FIXME
        verbose $status
        echo $status # returning status
    done
    verbose
    verbose "DONE"
    verbose
}

# For the following functions, the two array arguments must be passed
# by name, as that is the only way to call a function with
# two arrays.
function print_status() {
    local -n _teams=$1
    local -n _status=$2
    
    echo Project Status
    for (( i = 0; i < ${#_teams[@]}; i++ )); do
        echo -e "${_teams[$i]}\t${_status[$i]}"
    done
}

function passing_teams() {
    local -n _teams=$1
    local -n _status=$2
    
    for (( i = 0; i < ${#_teams[@]}; i++ )); do
        if [[ ${_status[$i]} == 'pass' ]]; then
            echo ${_teams[i]}
        fi
    done
}

function download_repos() {
    local -n _passing=$1

    verbose
    verbose "DOWNLOADING PASSING TESTS"
    verbose

    [[ -d project_repos ]] || mkdir project_repos
    
    for team in ${_passing[@]}; do
        teamdir="project_repos/$team"
        if [[ -d $teamdir ]]; then
            verbose "Pulling ${team}..."
            (cd $teamdir ; git pull)
        else
            verbose "Downloading ${team}..."
            gh repo clone $org/$team $teamdir
        fi
    done
}

status=( $(get_status ${teams[@]}) )
print_status teams status > /dev/stdout # FIXME: write to file

passing=( $(passing_teams teams status) )
download_repos passing

