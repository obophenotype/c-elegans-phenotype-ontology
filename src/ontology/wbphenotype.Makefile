## Customize Makefile settings for wbphenotype
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

$(ONT)-simple.obo: $(ONT)-simple.owl
	$(ROBOT) convert --input $< --check false -f obo $(OBO_FORMAT_OPTIONS) -o $@.tmp.obo &&\
	grep -v ^owl-axioms $@.tmp.obo > $@.tmp &&\
	cat $@.tmp | perl -0777 -e '$$_ = <>; s/^name[:].*?\nname[:]/name:/g; print' | perl -0777 -e '$$_ = <>; s/def[:].*?\ndef[:]/def:/g; print' > $@
	rm -f $@.tmp.obo $@.tmp
	
simple_seed.txt: $(SRC) $(ONTOLOGYTERMS) #prepare_patterns
	$(ROBOT) query --use-graphs false -f csv -i $< --query ../sparql/object-properties.sparql $@.tmp &&\
	cat $@.tmp $(ONTOLOGYTERMS) | sort | uniq >  $@ &&\
	echo "http://www.geneontology.org/formats/oboInOwl#SubsetProperty" >> $@ &&\
	echo "http://www.geneontology.org/formats/oboInOwl#SynonymTypeProperty" >> $@
	rm -f $@.tmp

non_native_classes.txt: $(SRC)
	$(ROBOT) query --use-graphs true -f csv -i $< --query ../sparql/non-native-classes.sparql $@.tmp &&\
	cat $@.tmp | sort | uniq >  $@
	rm -f $@.tmp

$(ONT)-simple.owl: $(SRC) #$(OTHER_SRC) simple_seed.txt non_native_classes.txt $(ONTOLOGYTERMS)
	$(ROBOT) merge --input $< $(patsubst %, -i %, $(OTHER_SRC)) --collapse-import-closure true \
		reason --reasoner ELK \
		relax \
		remove --axioms equivalent \
		relax \
		filter --term-file simple_seed.txt --trim true --select "annotations ontology anonymous parents object-properties self" --preserve-structure false \
		reduce -r ELK \
		annotate --ontology-iri $(ONTBASE)/$@ --version-iri $(ONTBASE)/releases/$(TODAY)/$@ --output $@.tmp.owl && mv $@.tmp.owl $@

# TODO PUT THIS BACK: 		remove --term-file non_native_classes.txt \


$(ONT).obo: $(ONT)-simple.owl
	$(ROBOT) convert --input $< --check false -f obo $(OBO_FORMAT_OPTIONS) -o $@.tmp.obo && grep -v ^owl-axioms $@.tmp.obo > $@ && rm $@.tmp.obo

$(PATTERNDIR)/dosdp-patterns: .FORCE
	echo "WARNING WARNING Skipped until fixed: delete from wbphenotype.Makefile"
	