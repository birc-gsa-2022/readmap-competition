#!/usr/local/bin/bash
# FIXME: find more robust way to get the most recent bash



# Get this one from pull.sh
passing=( project-5-python-armando-christian-perez project-5-go-holdet )

# and this one
function verbose() {
    echo $* > /dev/stderr
}


repo_dir()   { echo project_repos/$1 ; }
action_yml() { echo $(repo_dir $1)/.github/actions/build/action.yml ; }

function get_build_commands() {
    local team=$1
    local -n _commands=$2 # pass by reference
    readarray -t _commands  < <( grep 'run:' < $(action_yml $team) | sed 's/run://g' )
}

function build_project() {
    local team=$1
    local -a commands
    get_build_commands $team commands

    verbose
    verbose "BUILDING FOR ${team^^}"
    verbose
    {
        cd $(repo_dir $team)
        for cmd in "${commands[@]}"; do
            verbose '~>' $cmd
            eval $cmd
        done
        cd -
    }
    verbose
}

for team in ${passing[@]}; do
    build_project $team
done
