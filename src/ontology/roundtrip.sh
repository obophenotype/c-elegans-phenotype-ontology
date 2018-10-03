#!/bin/sh
# Little round trip experiment to make sure that the OWL serialisation of the original phenotype ontology does not loose any information

rm -rf roundtrip
mkdir roundtrip
# 1. Obtain latest release
wget -N http://purl.obolibrary.org/obo/wbphenotype.obo -O roundtrip/wbphenotype_orig.obo
# 2. Convert latest release to OWL using robot
./run.sh robot -vvv convert --input roundtrip/wbphenotype_orig.obo -o roundtrip/wbphenotype_orig.owl
# 3. Convert owl version into OBO
./run.sh robot -vvv convert --input roundtrip/wbphenotype_orig.owl -o roundtrip/wbphenotype_converted.obo
# 4. Compare the two to make sure nothing is lost (diff should be empty)
diff -u roundtrip/wbphenotype_orig.obo roundtrip/wbphenotype_converted.obo > roundtrip/diff.txt

if [ -s roundtrip/diff.txt ]
then
        echo 'Roundtrip unsuccessful!'
else
        echo 'Roundtrip successful!'
fi