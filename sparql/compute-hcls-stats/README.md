# Compute [HCLS](https://www.w3.org/TR/hcls-dataset) statistics for a dataset

Query to compute and insert [HCLS statistics](https://www.w3.org/TR/hcls-dataset/#s6_6) about a graph in a triplestore (the statistics are added to the metadata graph of this dataset).

## Pull

Uses [data2services-sparql-operations](https://hub.docker.com/r/vemonet/data2services-sparql-operations) to execute multiple query (all `.rq` file in a folder or in a GitHub repository).

```shell
docker pull vemonet/data2services-sparql-operations
```

## Run

```shell
docker run -d \
  vemonet/data2services-sparql-operations \
  -f "https://github.com/MaastrichtU-IDS/data2services-transform-repository/tree/master/sparql/compute-hcls-stats" \
  -ep "http://graphdb.dumontierlab.com/repositories/test/statements" 
  -un MYUSERNAME -pw MYPASSWORD 
  -var inputGraph:https://w3id.org/data2services/graph/biolink/uniprot
```

## SPARQL query example

[Example of a SPARQL query](https://github.com/MaastrichtU-IDS/data2services-insert/blob/master/compute-hcls-stats/1_1_global_stats_counts.rq) to compute global statistics about a graph:

```SPARQL
# 6.6.1 To specify the number of triples in the dataset and compute global stats
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dctypes: <http://purl.org/dc/dcmitype/>
PREFIX dcat: <http://www.w3.org/ns/dcat#>
PREFIX void: <http://rdfs.org/ns/void#>
INSERT {
  GRAPH ?metadataGraph {
    ?distributionRdfUri void:triples ?triples ;
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
  GRAPH ?metadataGraph {
    ?distributionRdfUri a void:Dataset ;
      dcat:accessURL <?_inputGraph> . 
      # Only work when one dataset that has this URL as accessURL
  }

  GRAPH <?_inputGraph> {
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

