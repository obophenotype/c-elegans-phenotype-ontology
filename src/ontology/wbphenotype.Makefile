## Customize Makefile settings for wbphenotype
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

$(ONT)-simple.obo: $(ONT)-simple.owl
	$(ROBOT) convert --input $< --check false -f obo $(OBO_FORMAT_OPTIONS) -o $@.tmp.obo &&\
	grep -v ^owl-axioms $@.tmp.obo > $@.tmp &&\
	cat $@.tmp | perl -0777 -e '$$_ = <>; s/^name[:].*?\nname[:]/name:/g; print' | perl -0777 -e '$$_ = <>; s/def[:].*?\ndef[:]/def:/g; print' > $@
	rm -f $@.tmp.obo $@.tmp
	
$(ONT).obo: $(ONT)-simple.owl
	$(ROBOT) annotate --input $< --ontology-iri $(URIBASE)/$(ONT).owl --version-iri $(ONTBASE)/releases/$(TODAY)/$(ONT).owl convert --check false -f obo $(OBO_FORMAT_OPTIONS) -o $@.tmp.obo && grep -v ^owl-axioms $@.tmp.obo > $@ && rm $@.tmp.obo

#$(PATTERNDIR)/dosdp-patterns: .FORCE
#	echo "WARNING WARNING Skipped until fixed: delete from wbphenotype.Makefile"

labels.csv:
	robot query --use-graphs true -f csv -i $(SRC) --query ../sparql/term_table.sparql $@

# Make sure you first generate definitions.owl!
patternised_classes.txt: .FORCE
	$(ROBOT) query -f csv -i ../patterns/definitions.owl --query ../sparql/$(ONT)_terms.sparql $@
	sed -i 's/http[:][/][/]purl.obolibrary.org[/]obo[/]//g' $@
	sed -i '/^[^W]/d' $@

EQS=components/wbphenotype-equivalent-axioms-subq.owl

remove_patternised_classes: $(SRC) patternised_classes.txt
	sed -i -r "/^EquivalentClasses[(][<]http[:][/][/]purl[.]obolibrary[.]org[/]obo[/]($(shell cat patternised_classes.txt | xargs | sed -e 's/ /\|/g'))/d" $(SRC)
	sed -i -r "/^EquivalentClasses[(][<]http[:][/][/]purl[.]obolibrary[.]org[/]obo[/]($(shell cat patternised_classes.txt | xargs | sed -e 's/ /\|/g'))/d" $(EQS)
