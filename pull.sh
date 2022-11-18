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

# Pull working solutions down
passing=()
for team in $teams; do
    status=$(get_status $team)
    echo $team $status
    passing+=($status)
done

success=()
for i in ${passing[@]}; do
    if [[ ${passing[$i]} == 'pass' ]]; then
        echo ${teams[$i]} ${passing[$i]}
    fi
done
echo ${passing[@]}