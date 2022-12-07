# Configuration file

# The organisation and the competing teams
org="birc-gsa-2022"
teams=(
    #project-5-python-asg
    project-5-python-armando-christian-perez
    project-5-python-team
    #project-5-python-illiterate-apes
    project-5-python-ms-world-wides
    
    project-5-go-holdet

    project-5-c-o-no
    # project-5-c-quadratic-solution
)

mydirs=(
    readmap-python
    readmap-go
    readmap-c-cmake
)

gsa_rep=20  # Number of repeats when measuring performance

# Config. for full run of all teams
gsa_genome_lens=(2500 5000)
gsa_reads_lens=(50)

# Config for the faster ones
long_teams=(
    project-5-python-armando-christian-perez
    project-5-c-o-no
    project-5-go-holdet
)
gsa_long_genome_lens=(25000 50000)
gsa_long_reads_lens=(200)
