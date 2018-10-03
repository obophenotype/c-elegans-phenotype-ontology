---
layout: ontology_detail
id: wbphenotype
title: C elegans Phenotype Ontology
jobs:
  - id: https://travis-ci.org/obophenotype/c-elegans-phenotype-ontology
    type: travis-ci
build:
  checkout: git clone https://github.com/obophenotype/c-elegans-phenotype-ontology.git
  system: git
  path: "."
contact:
  email: cjmungall@lbl.gov
  label: Chris Mungall
description: C elegans Phenotype Ontology is an ontology...
domain: stuff
homepage: https://github.com/obophenotype/c-elegans-phenotype-ontology
products:
  - id: wbphenotype.owl
  - id: wbphenotype.obo
dependencies:
 - id: iao
 - id: go
 - id: ro
 - id: pato
 - id: bfo
 - id: chebi
 - id: cl
 - id: wbbt
 - id: wbls
tracker: https://github.com/obophenotype/c-elegans-phenotype-ontology/issues
license:
  url: http://creativecommons.org/licenses/by/3.0/
  label: CC-BY
---

Enter a detailed description of your ontology here
