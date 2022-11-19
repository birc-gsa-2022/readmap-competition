# Code for generating the gsa yaml file running the performance tests.

[[ -z ${gsa_yaml_included+present} ]] || return
gsa_yaml_included="gsa_yaml_included"
echo "sourcing yaml"


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
    local team

    cat <<EOF
tools:
EOF
    for team in "${teams[@]}"; do
        generate_tool_spec $team
    done
    cat <<EOF

  TM:Python:
    preprocess: "gsa preprocess {genome} approx-bwt"
    map: "gsa search {genome} {reads} -o {outfile} approx -e {e} bwt"
  TM:Go:
    preprocess: "gostr bwt preproc {genome}"
    map: "gostr bwt approx -d {e} {genome} {reads} > {outfile}"
  TM:C:
    preprocess: "/Users/mailund/Projects/stralg/tools/readmappers/bwt_readmapper/bwt_readmapper -p {genome}"
    map: "/Users/mailund/Projects/stralg/tools/readmappers/bwt_readmapper/bwt_readmapper -d {e} {genome} {reads} > {outfile}"


reference-tool: TM:C

genomes:
  length: [1000]
  chromosomes: 10

reads:
  number: 10
  length: 100
  edits: [1, 2]

EOF
}

