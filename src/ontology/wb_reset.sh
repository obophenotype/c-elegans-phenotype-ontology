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
$ROBOT merge --collapse-import-closure false --include-annotations true --input wbphenotype-edit.owl --input wb_reset/wbphenotype_orig.owl --output wb_reset/wbphenotype-edit.ofn
# Replace hasComponent (which is used everwhere to hang off the abnormal modifier by 'has modifier')
sed -i '' 's/RO_0002180/RO_0002573/g' wb_reset/wbphenotype-edit.owl
cp wb_reset/wbphenotype-edit.ofn wbphenotype-edit.owl
./run.sh make prepare_release
# robot remove --input obi.owl --term OBI:0000070 --select descendants
# used my method extract_defined_classes.py in odk_utils
mkdir wb_reset/defined
sh /ws/odk_utils/extract_defined_classes.sh /ws/odk_utils/extract_defined_classes.py /ws/c-elegans-phenotype-ontology/src/patterns/data/manual/ /ws/c-elegans-phenotype-ontology/src/ontology/wb_reset/defined/ 
TF=wb_reset/defined_classes.txt
rm $TF
cat wb_reset/defined/*definedclasses.txt | sort | uniq > $TF
cp wb_reset/wbphenotype_eq.owl wb_reset/wbphenotype_eq_stripped.owl 
# Following while robot does not work, replace immediately when it does
while read CONC; do grep -v "$CONC" wb_reset/wbphenotype_eq_stripped.owl > wb_reset/temp.tmp && mv wb_reset/temp.tmp wb_reset/wbphenotype_eq_stripped.owl; done < wb_reset/defined_classes.txt

cp wb_reset/wbphenotype_eq_stripped.owl wbphenotype_eq_do_no_edit.owl

#$ROBOT remove --input wb_reset/wbphenotype_eq.owl --term-file $TF --select "parents equivalents" --select anonymous --output wb_reset/wbphenotype_eq_stripped.owl

