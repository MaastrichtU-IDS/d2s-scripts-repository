#!/bin/bash

echo "Use arguments to provide GraphDB login and password: ./data2services_upload_datasets_metadata.sh my_login my_password"

LOGIN=$1
PASSWORD=$2

# BioLink transformation
docker run -it --rm -v "$PWD/insert-biolink":/data sparql-dataformer -rq "/data" -url "http://graphdb.dumontierlab.com/repositories/ncats-red-kg/statements" -un $LOGIN -pw $PASSWORD

# Insert datasets metadata 
docker run -it --rm -v "$PWD/insert-dataset_metadata/summary":/data sparql-dataformer -rq "/data" -url "http://graphdb.dumontierlab.com/repositories/ncats-red-kg/statements" -un $LOGIN -pw $PASSWORD
docker run -it --rm -v "$PWD/insert-dataset_metadata/distribution":/data sparql-dataformer -rq "/data" -url "http://graphdb.dumontierlab.com/repositories/ncats-red-kg/statements" -un $LOGIN -pw $PASSWORD
