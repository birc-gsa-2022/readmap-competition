
[[ -z ${gsa_utils_included+present} ]] || return
gsa_utils_included="gsa_utils_included"
echo "sourcing utils"

# Utility functions
verbose()    { echo $* > /dev/stderr ; }
build_dir()  { echo project_repos/$1 ; }
action_yml() { echo $(build_dir $1)/.github/actions/build/action.yml ; }
