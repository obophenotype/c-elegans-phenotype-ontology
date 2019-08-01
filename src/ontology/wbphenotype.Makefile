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
	$(ROBOT) convert --input $< --check false -f obo $(OBO_FORMAT_OPTIONS) -o $@.tmp.obo && grep -v ^owl-axioms $@.tmp.obo > $@ && rm $@.tmp.obo

#$(PATTERNDIR)/dosdp-patterns: .FORCE
#	echo "WARNING WARNING Skipped until fixed: delete from wbphenotype.Makefile"

labels.csv:
	robot query --use-graphs true -f csv -i $(SRC) --query ../sparql/term_table.sparql $@

