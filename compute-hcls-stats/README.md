# Compute HCLS statistics for a dataset

Query to compute and insert [HCLS statistics](https://www.w3.org/TR/hcls-dataset/#s6_6) about a graph in a triplestore (the statistices are added to the metadata graph of this dataset).

## Clone

```shell
git clone --recursive https://github.com/MaastrichtU-IDS/data2services-insert
```

## Build

```shell
docker build -t rdf4j-sparql-operations ./data2services-insert/rdf4j-sparql-operations
```

## Run

```shell
docker run -d --rm --name compute-hcls-stats \
  -v "$PWD/data2services-insert/compute-hcls-stats":/data 
  rdf4j-sparql-operations -f "/data" 
  -ep "http://graphdb.dumontierlab.com/repositories/ncats-red-kg/statements" 
  -un username -pw password 
  -var inputGraph:https://w3id.org/data2services/graph/biolink/drugbank
```

