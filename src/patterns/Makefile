SCHEMA := util/DOSDP_schema_full.yaml

test: $(SCHEMA)
	simple_pattern_tester.py *.yaml

clean:
	rm $(SCHEMA)

$(SCHEMA):
	wget --no-check-certificate https://raw.githubusercontent.com/dosumis/dead_simple_owl_design_patterns/master/spec/DOSDP_schema_full.yaml -O $@ && touch $@

pattern-files = $(shell ls ../patterns/dosdp-patterns/*.yaml)

query: $(pattern-files)

.PHONY: query $(pattern-files)

WB = wbphenotype_merged.owl

#$(ZP):
#	curl -L -O https://raw.githubusercontent.com/matentzn/ontologies/master/zp_newgen.owl

#https://raw.githubusercontent.com/obophenotype/upheno/master/src

$(pattern-files): $(WB)
	sh ../ontology/run.sh dosdp-tools query --ontology=../patterns/$(WB) --reasoner=elk --obo-prefixes=true --template=$@ --outfile=../patterns/$(basename $@).tsv
