# Get started

This repository stores transformation scripts used in the [data2services-pipeline](https://github.com/MaastrichtU-IDS/data2services-pipeline) to build Data2Services knowledge graphs (SPARQL insert queries, RML mapping files).

SPARQL queries are usually executed by repositories using the [data2services-sparql-operations](https://github.com/MaastrichtU-IDS/data2services-sparql-operations) docker image.

## Clone

*Optional*, see below: SPARQL queries can be run using [data2services-sparql-operations](https://hub.docker.com/r/vemonet/data2services-sparql-operations) by directly providing a GitHub repository URL.

```shell
git clone --recursive https://github.com/MaastrichtU-IDS/d2s-transform-repository
cd d2s-transform-repository
```

## Pull

Uses [data2services-sparql-operations](https://hub.docker.com/r/vemonet/data2services-sparql-operations) to execute multiple query (all `.rq` file in a folder or in a GitHub repository).

```shell
docker pull vemonet/data2services-sparql-operations
```

## Run

Execute all SPARQL Insert queries at a GitHub repository URL. See [data2services-sparql-operations](https://github.com/MaastrichtU-IDS/data2services-sparql-operations) GitHub for more documentation.

```shell
# Command to load UniProt organisms and Human proteins as BioLink
docker run -it --link graphdb:graphdb vemonet/data2services-sparql-operations -f "https://github.com/MaastrichtU-IDS/d2s-transform-repository/tree/master/sparql/insert-biolink/uniprot" -ep "http://graphdb:7200/repositories/test/statements" -un MYUSERNAME -pw MYPASSWORD --var-output https://w3id.org/data2services/graph/biolink/uniprot
```

## Other examples

Transform datasets from generic RDF generated by the [Data2Services pipeline](https://github.com/MaastrichtU-IDS/data2services-pipeline) to the [BioLink](https://github.com/biolink/biolink-model) model (e.g. Drugbank or HGNC). 

```shell
# DrugBank conversion from xml2rdf generic RDF
docker run -it --link graphdb:graphdb \
  vemonet/data2services-sparql-operations \
  -f "https://github.com/MaastrichtU-IDS/d2s-transform-repository/tree/master/sparql/insert-biolink/drugbank" \
  -ep "http://graphdb:7200/repositories/test/statements" \
  -un MYUSERNAME -pw MYPASSWORD \
  --var-service http://localhost:7200/repositories/test --var-input https://w3id.org/data2services/graph/xml2rdf --var-output https://w3id.org/data2services/biolink/drugbank

# HGNC conversion from AutoR2RML generic RDF
docker run -it --link graphdb:graphdb \
  vemonet/data2services-sparql-operations \
  -f "https://github.com/MaastrichtU-IDS/d2s-transform-repository/tree/master/sparql/insert-biolink/hgnc" \
  -ep "http://graphdb:7200/repositories/test/statements" \
  -un MYUSERNAME -pw MYPASSWORD \
  --var-service http://localhost:7200/repositories/test --var-input https://w3id.org/data2services/graph/autor2rml --var-output https://w3id.org/data2services/biolink/hgnc
```

* N.B.: remove `\` and put the command as one line for Windows PowerShell.

# Use SPARQL for conversion

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

* Needs to know really well the BioLink model (or any other model you want to convert to)
  * Can be hard to find some matching concepts in BioLink
  * What to do if no matching concept in BioLink?

* We can't build one big construct query. It needs to be divided in little construct queries with a focused goal
  * E.g.: getting targets infos
  * We need to avoid having too much query getting different arrays (result is a cartesian product)
* Problem: we first get all the hasChild and then filter on the type
  * **Why not putting the XPath directly in the predicate?**
* We can't split one statement value into multiple ("apple, orange" to "apple" and "orange")

### Enhancement

Also generating a generic construct query when generating the generic RDF (with AutoR2RML and xml2rdf) 

Then we "just" have to match it with the right bioentity class

* Automatically generate SPARQL query

The programs that do the generic RDF transformation should generate a file formally describing the data structure that is then used to generate the SPARQL construct query 

* Recommend class from an existing datamodel
  * Based on attribute name in the original file
  * Based on data 



# Using [RML](http://rml.io/) for conversion

### [RMLStreamer](https://github.com/RMLio/RMLStreamer)

Scala implementation, require to stream files to [Flink](https://flink.apache.org/) using [Kafka](https://kafka.apache.org/).

Documentation about running on Docker will be released soon.

### [RMLMapper](https://github.com/RMLio/rmlmapper-java)

Java implementation, not used because of scalability issues.

```shell
# Build
mvn clean package -DskipTests
# Run
java -jar /data/rmlmapper-java/target/rmlmapper-4.1.0-r55-jar-with-dependencies.jar -c /data/drugbank/drugbank_config.properties
```

### [RocketRML](https://github.com/semantifyit/RocketRML)

[NodeJS](https://nodejs.org/en/) implementation focusing on XML and JSON conversion.