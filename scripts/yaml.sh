# Code for generating the gsa yaml file running the performance tests.

[[ -z ${gsa_yaml_included+present} ]] || return
gsa_yaml_included="gsa_yaml_included"


function generate_tool_spec() {
    local team=$1
    cat <<EOF
  ${team^^}:
    preprocess: "{root}/project_repos/${team}/readmap -p {genome}"
    map: "{root}/project_repos/${team}/readmap -d {e} {genome} {reads} > {outfile}"
EOF
}

function generate_yaml_spec() {
    local -n teams=$1
    local -n mine=$2
    local team

    cat <<EOF
tools:
EOF
    for team in "${teams[@]}"; do
        generate_tool_spec $team
    done
    for team in "${mine[@]}"; do
        generate_tool_spec $team
    done
    cat <<EOF


reference-tool: READMAP-PYTHON

genomes:
  length: [1000, 5000, 10000]
  chromosomes: 10

reads:
  number: 10
  length: [100, 200]
  edits: [1, 2]

EOF
}

