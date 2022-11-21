
[[ -z ${gsa_utils_included+present} ]] || return
gsa_utils_included="gsa_utils_included"

# Utility functions
verbose()    { echo $* > /dev/stderr ; }
error()      { echo $* > /dev/stderr ; exit 1 ; }
build_dir()  { echo project_repos/$1 ; }
action_yml() { echo $(build_dir $1)/.github/actions/build/action.yml ; }

# Colours
if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
  NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
else
  NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
fi
red()    { echo -ne "${RED}$@${NOFORMAT}" ; }
green()  { echo -ne "${GREEN}$@${NOFORMAT}" ; }
orange() { echo -ne "${ORANGE}$@${NOFORMAT}" ; }
blue()   { echo -ne "${BLUE}$@${NOFORMAT}" ; }
purple() { echo -ne "${PURPLE}$@${NOFORMAT}" ; }
cyan()   { echo -ne "${CYAN}$@${NOFORMAT}" ; }
yellow() { echo -ne "${YELLOW}$@${NOFORMAT}" ; }
