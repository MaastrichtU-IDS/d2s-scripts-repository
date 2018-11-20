http://docs.rdf4j.org/programming/#_accessing_a_sparql_endpoint_2

http://docs.rdf4j.org/programming/#_evaluating_a_graph_query

# insert-data2services

## Build

Uses https://github.com/vemonet/sparql-dataformer/

```shell
# Build sparql-dataformer using git and docker
git clone https://github.com/vemonet/sparql-dataformer.git
docker build -t sparql-dataformer sparql-dataformer/
```

## Run

Transform datasets to BioLink (e.g.: Drugbank or HGNC)

```shell
./data2services-transform-biolink.sh graphdb_login graphdb_password
```



## ShEx validation

### ShEx Java

http://shexjava.lille.inria.fr/

```shell
# Start the UI
java -jar shexjapp-0.0.1.jar

# Commandline
mvn exec:java -Dexec.classpathScope=test -Dexec.mainClass="fr.inria.lille.shexjava.commandLine.Validate" -Dexec.args="-s ../../shexTest/schemas/1dotSemi.shex -d file:///home/jdusart/Documents/Shex/workspace/shexTest/validation/Is1_Ip1_Io1.ttl -l http://a.example/S1 -f http://a.example/s1 -a recursive"
```



### Shex js

NOT WORKING. 40 tests fail

```shell
# Install and test
npm install --save shex
npm explore shex 'npm install'

# Tests (failing)
npm explore shex 'npm test'
```



## KGX validate

```shell
cd ~/sandbox/kgx
source env/bin/activate
kgx validate /home/vemonet/sandbox/data-constructor/resources/biogrid_test.ttl
```



### OBO used in biogrid

* predicates
  * OBO:RO_0002558: hasEvidence

* objects
  * OBO:ECO_0000068: 



## Valid BioLink

- Valid prefix for CURIE

https://github.com/monarch-initiative/dipper/blob/master/dipper/curie_map.yaml

- Spec

https://docs.google.com/document/d/1TrvqJPe_HwmRJ5HCwZ7fsi9_mwGcwLOZ53Fnjo8Sh4E/edit

Required for nodes: id, name, category



# RML

* Build

```shell
mvn clean package -DskipTests
```

* Run

```shell
# HGNC
java -jar /home/vemonet/sandbox/rmlmapper-java/target/rmlmapper-4.1.0-r55-jar-with-dependencies.jar -c /data/drugbank/drugbank_config.properties

# DrugBank. Java heap space outOfMemory error (for 900M)
java -jar /home/vemonet/sandbox/rmlmapper-java/target/rmlmapper-4.0.0-r50-jar-with-dependencies.jar -c /home/vemonet/sandbox/rml_vs_sparql/rml/drugbank_config.properties
```



# SPARQL

Generating 2 types of generic SPARQL:

* From tabular (csv, tsv, RDBMS)
* From complex structure (XML, JSON, YAML)

### How we do

* For each attribute/node extracted we look for corresponding classes in BioLink Ontology

https://biolink.github.io/biolink-model/

https://raw.githubusercontent.com/biolink/biolink-model/master/ontology/biolink.ttl

https://bioportal.bioontology.org/ontologies/BLM

* TSV
  * Opening TSV file with calc and looking for concept matching columns in BioLink ontology
  * Opening  the Mapping file to get the exact URI of the column
* XML: using the schema printed by xml2rdf and the original XML file to look for matching concepts in BioLink ontology



### Limitations

* Needs to know really well the BioLink model
  * Can be hard to find some matching concepts in BioLink
  * What to do if no matching concept in BioLink?

* We can't build one big construct query. It needs to be divided in little construct queries with a focused goal
  * E.g.: getting targets infos
  * We need to avoid having too much query getting different arrays (result is a cartesian product)
* Problem: we first get all the hasChild and then filter on the type
  * **Why not putting the XPath directly in the predicate?**

### Enhancement

Also generating a generic construct query when generating the generic RDF (with AutoR2RML and xml2rdf) 

Then we "just" have to match it with the right bioentity class



* Automatically generate SPARQL query

The programs that do the generic RDF transformation should generate a file formally describing the data structure that is then used to generate the SPARQL construct query 



* Recommend class from an existing datamodel
  * Based on attribute name in the original file
  * Based on data 



* Create new nodes from the values? Example: Status in HGNC
  * Translate to ConfidenceLevel https://biolink.github.io/biolink-model/docs/ConfidenceLevel.html
  * We need to create 3 ConfidenceLevel for genes: Approved, Symbol Withdrawn, Entry Withdrawn. And then point the gene to this level with bioentity:related_to 









































