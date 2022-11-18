# Configuration file

# Read repos into array
readarray -d "\n" teams < teams.txt

org="birc-gsa-2022"
gh_url="https://github.com/${org}"


function repo_url() {
    echo "${gh_url}/$1"
}
