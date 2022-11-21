
[[ -z ${gsa_build_included+present} ]] || return
gsa_build_included="gsa_build_included"

source "scripts/utils.sh"

function get_build_commands() {
    local team=$1
    local -n _commands=$2 # pass by reference
    readarray -t _commands  < \
        <( grep 'run:' < $(action_yml $team) | sed 's/run://g' )
}

function build_team_project() {
    local team=$1
    local -a commands
    get_build_commands $team commands

    verbose $(yellow "BUILDING FOR ${team^^}")
    {
        cd $(build_dir $team)
        for cmd in "${commands[@]}"; do
            verbose '~>' $cmd
            eval $cmd
        done
        cd -
    }
    verbose
}

function build_projects() {
    local -n teams=$1
    local team
    for team in ${teams[@]}; do
        build_team_project $team
    done
}
