# Compute HCLS statistics for a dataset

Query to compute and insert [HCLS descriptive statistics](https://www.w3.org/TR/hcls-dataset) about a graph in a triplestore (the descritive statistics are added to the metadata graph of this dataset).

## Pull

Uses the docker image [vemonet/d2s-sparql-operations](https://hub.docker.com/r/umids/d2s-sparql-operations) to execute multiple SPARQL queries (all `.rq` file in a folder or in a GitHub repository).

```shell
docker pull umids/d2s-sparql-operations
```

## Run

This will execute [all SPARQL queries](https://github.com/MaastrichtU-IDS/d2s-scripts-repository/tree/master/sparql/compute-hcls-stats) to:

* Compute the HCLS descriptive statistics for a defined graph (e.g. class and property counts, relations between entities) 
* Insert them in the HCLS metadata that describes this graph in the triplestore

```shell
docker run -d \
  umids/d2s-sparql-operations \
  -f "https://github.com/MaastrichtU-IDS/d2s-scripts-repository/tree/master/sparql/compute-hcls-global" \
  -ep "https://graphdb.dumontierlab.com/repositories/test/statements" \
  -un MYUSERNAME -pw MYPASSWORD \
  --var-input https://w3id.org/d2s/graph/biolink/pathwaycommons
  --var-output https://w3id.org/d2s/metadata
```

> Example for the graph `https://w3id.org/d2s/graph/biolink/pathwaycommons`.

## Get HCLS statistics insights

Insights about the triplestore's graphs content can be obtained by querying the HCLS descriptive statistics. You can try on  the [ncats-red-kg](https://graphdb.dumontierlab.com/sparql) triplestore repository.

### Get all graph described using HCLS description 

```SPARQL
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX dctypes: <http://purl.org/dc/dcmitype/>
PREFIX dcat: <http://www.w3.org/ns/dcat#>
PREFIX void: <http://rdfs.org/ns/void#>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
SELECT DISTINCT ?graph ?description ?homepage ?dateGenerated ?statements ?entities ?properties ?classes
WHERE {
  GRAPH ?graph {
    [] ?dummyProp [] .
  }
  GRAPH ?metadataGraph {
    OPTIONAL {
      ?dataset a dctypes:Dataset ;
        dct:description ?description ;
        foaf:page ?homepage .
      ?version dct:isVersionOf ?dataset ;
        dcat:distribution ?graph .
    }
    OPTIONAL {
      ?graph a void:Dataset ;
        void:triples ?statements ;
        void:entities ?entities ;
        void:properties ?properties .
    }
    OPTIONAL {
      ?graph dct:created ?dateGenerated .
    }
    OPTIONAL {
      ?graph void:classPartition [
        void:class rdfs:Class ;
        void:distinctSubjects ?classes
      ] .
    }
  }
} ORDER BY DESC(?statements)
```

### Get all relations between classes in the different graphs

```SPARQL
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX bl: <http://w3id.org/biolink/vocab/>
PREFIX dctypes: <http://purl.org/dc/dcmitype/>
PREFIX idot: <http://identifiers.org/idot/>
PREFIX dcat: <http://www.w3.org/ns/dcat#>
PREFIX void: <http://rdfs.org/ns/void#>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX void-ext: <http://ldf.fi/void-ext#>
SELECT DISTINCT ?graph ?classCount1 ?class1 ?relationWith ?classCount2 ?class2
WHERE {
GRAPH ?metadataGraph {
  ?graph a void:Dataset .
  ?graph void:propertyPartition [
    void:property ?relationWith ;
    void:classPartition [
      void:class ?class1 ;
      void:distinctSubjects ?classCount1 ;
    ];
    void-ext:objectClassPartition [
    void:class ?class2 ;
    void:distinctObjects ?classCount2 ;
    ]] .
  }
} ORDER BY DESC(?classCount1)
```

## SPARQL insert HCLS query example

[Example of a SPARQL query](https://github.com/MaastrichtU-IDS/d2s-scripts-repository/blob/master/sparql/compute-hcls-stats/1_1_global_stats_counts.rq) to compute global statistics about a graph:

```SPARQL
# 6.6.1 To specify the number of triples in the dataset and compute global stats
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dctypes: <http://purl.org/dc/dcmitype/>
PREFIX dcat: <http://www.w3.org/ns/dcat#>
PREFIX void: <http://rdfs.org/ns/void#>
INSERT {
  GRAPH <?_output> {
    <?_input> a void:Dataset ;
      void:triples ?triples ;
      void:entities ?entities ;
      void:distinctSubjects ?distinctSubjects ;
      void:properties ?distinctProperties ;
      void:distinctObjects ?distinctObjects ;
      void:classPartition [
          void:class rdfs:Class ; # Number of unique classes
          void:distinctSubjects ?distinctClasses 
      ] ;
      void:classPartition [
          void:class rdfs:Literal ; # Number of unique literals
          void:distinctSubjects ?distinctLiterals 
      ] .
  }
    
} WHERE { 
  GRAPH <?_input> {
    { SELECT (COUNT(*) AS ?triples) { ?s ?p ?o  } } # count triples
    { SELECT (COUNT(DISTINCT ?s) AS ?entities) { ?s a [] } } # count unique entities
    { SELECT (COUNT(DISTINCT ?s) AS ?distinctSubjects) {  ?s ?p ?o } }
    { SELECT (COUNT(DISTINCT ?p) AS ?distinctProperties) { ?s ?p ?o } }
    { SELECT (COUNT(DISTINCT ?o ) AS ?distinctObjects) {  ?s ?p ?o  FILTER(!isLiteral(?o)) } }
    { SELECT (COUNT(DISTINCT ?o) AS ?distinctClasses) { ?s a ?o } }
    { SELECT (COUNT(DISTINCT ?o) AS ?distinctLiterals) {  ?s ?p ?o  filter(isLiteral(?o)) }  }
  }
}
```

