#!/bin/sh
# Restart the repo with the up to data OBO file

ROBOT="./run.sh robot -vvv"

rm -rf wb_reset
mkdir wb_reset

# 1. Obtain latest release
wget -N http://purl.obolibrary.org/obo/wbphenotype.obo -O wb_reset/wbphenotype_orig.obo
wget -N https://raw.githubusercontent.com/obophenotype/upheno/master/wbphenotype/wbphenotype-equivalence-axioms-edit.owl -O wb_reset/wbphenotype_eq.owl


# 2. Convert latest release to OWL using robot
$ROBOT convert --input wb_reset/wbphenotype_orig.obo -o wb_reset/wbphenotype_orig.owl
# 3. Merge the old ontologies into the edit file
$ROBOT merge --collapse-import-closure false --include-annotations true --input wbphenotype-edit.owl --input wb_reset/wbphenotype_orig.owl --input wb_reset/wbphenotype_eq.owl --output wb_reset/wbphenotype-edit.ofn
# Replace hasComponent (which is used everwhere to hang off the abnormal modifier by 'has modifier')
sed -i '' 's/RO_0002180/RO_0002573/g' wb_reset/wbphenotype-edit.owl
mv wb_reset/wbphenotype-edit.ofn wb_reset/wbphenotype-edit.owl
diff -u wbphenotype-edit.owl wb_reset/wbphenotype-edit.owl > wb_reset/diff.txt
