#! env bash

source config.sh

function get_action_id() {
    local repo=$1
    gh --repo ${org}/${repo} run list | \
        grep 'GitHub Classroom Workflow' | \
        head -1 | cut -f 7
}

function get_status() {
    local repo=$1
    gh --repo ${org}/${repo} \
        run view $(get_action_id $repo) \
        --exit-status \
        > /dev/null
    if (( $? == 0 )); then 
        echo 'pass' 
    else 
        echo 'fail' 
    fi
}

echo
echo "CHECKING IF PROJECTS TEST SUCCESSFULLY"
echo
passing=()
for team in ${teams[@]}; do
    status=$(get_status $team)
    passing+=($status)
done

success=()
for i in ${!passing[@]}; do
    echo ${teams[$i]} ${passing[$i]}
    if [[ ${passing[$i]} == 'pass' ]]; then
        success+=(${teams[$i]})
    fi
done

echo
echo "DOWNLOADING PASSING TESTS"
echo
[[ -d projects ]] || mkdir projects
for team in ${success[@]}; do
    teamdir="projects/$team"
    if [[ -d $teamdir ]]; then
        echo "Pulling ${team}..."
        (cd $teamdir ; git pull)
    else
        echo "Downloading ${team}..."
        gh repo clone $org/$team $teamdir
    fi
done
