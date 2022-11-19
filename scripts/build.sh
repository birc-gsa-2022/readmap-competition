
[[ -z ${gsa_build_included+present} ]] || return
gsa_build_included="gsa_build_included"
echo "sourcing build"

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

    verbose
    verbose "BUILDING FOR ${team^^}"
    verbose
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
    local -a teams
    for team in ${passing[@]}; do
        build_team_project $team
    done
}
