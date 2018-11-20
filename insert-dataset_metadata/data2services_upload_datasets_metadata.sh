#!/bin/bash

# ./data2services_upload_datasets_metadata.sh my_login my_password
LOGIN=$1
PASSWORD=$2

docker run -it --rm -v "$PWD/summary":/data sparql-dataformer -rq "/data" -url "http://graphdb.dumontierlab.com/repositories/ncats-red-kg/statements" -un $LOGIN -pw $PASSWORD
docker run -it --rm -v "$PWD/distribution":/data sparql-dataformer -rq "/data" -url "http://graphdb.dumontierlab.com/repositories/ncats-red-kg/statements" -un $LOGIN -pw $PASSWORD


