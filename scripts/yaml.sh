# Code for generating the gsa yaml file running the performance tests.

[[ -z ${gsa_yaml_included+present} ]] || return
gsa_yaml_included="gsa_yaml_included"

function yaml_list() {
  local -n data=$1
  delim=""
  joined=""
  for item in "${data[@]}"; do
    joined="$joined$delim$item"
    delim=", "
  done
  echo "[$joined]"
}


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
  length: $(yaml_list gsa_genome_lens)
  chromosomes: 10

reads:
  number: 10
  length: $(yaml_list gsa_reads_lens)
  edits: [1, 2]

EOF
}

