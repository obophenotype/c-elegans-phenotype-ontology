docker pull obolibrary/odkfull

./seed-via-docker.sh -c -C wbphenotype-odk.yaml

# -c means clean directory, delete temporary directory
# -C means config file location

cp target/wbphenotype/src/sparql/* ../sparql

cp target/wbphenotype/src/ontology/Makefile ../ontology/


