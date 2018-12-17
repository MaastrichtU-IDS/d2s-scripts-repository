#!/bin/bash

echo "Use arguments to provide GraphDB login and password: ./data2services_upload_datasets_metadata.sh my_login my_password"

LOGIN=$1
PASSWORD=$2

# BioLink transformation
docker run -it --rm -v "$PWD/insert-biolink/drugbank":/data rdf4j-sparql-operations -rq "/data" -url "http://graphdb.dumontierlab.com/repositories/ncats-red-kg/statements" -un $LOGIN -pw $PASSWORD -var inputGraph:http://data2services/graph/xml2rdf outputGraph:http://data2services/biolink/drugbank

docker run -it --rm -v "$PWD/insert-biolink/hgnc":/data rdf4j-sparql-operations -rq "/data" -url "http://graphdb.dumontierlab.com/repositories/ncats-red-kg/statements" -un $LOGIN -pw $PASSWORD -var inputGraph:http://data2services/graph/autor2rml outputGraph:http://data2services/biolink/hgnc
