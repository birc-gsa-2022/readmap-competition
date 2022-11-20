
[[ -z ${gsa_utils_included+present} ]] || return
gsa_utils_included="gsa_utils_included"

# Utility functions
verbose()    { echo $* > /dev/stderr ; }
error()      { echo $* > /dev/stderr ; exit 1 ; }
build_dir()  { echo project_repos/$1 ; }
action_yml() { echo $(build_dir $1)/.github/actions/build/action.yml ; }
