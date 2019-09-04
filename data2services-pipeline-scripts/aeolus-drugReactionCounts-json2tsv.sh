#!/bin/bash


#echo -e "nreports\toutcome_concept_id\tdrug_concept_id\tndrugreports" > aeolus_flattened.tsv

# Iterates over pages in the API
for (( i=0; i <= 631743; ++i )) ; do
  echo $i
  #json=$(wget -O input.json "https://www.nsides.io/api/v1/aeolus/drugReactionCounts?q=0" --no-check-certificate --header  "accept: */*")
  json=$(curl -s -X GET "https://www.nsides.io/api/v1/aeolus/drugpairReactionCounts?q=$i" -H "accept: */*")
  
  # The json variable is full, but for a mysterious reason jq says it is null.
  # jq: error (at <stdin>:1): Cannot iterate over null (null)
  echo $json
  for row in $(echo "${json}" | jq -r '.[0].result[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }
   echo -e "$(_jq '.nreports')\t$(_jq '.outcome_concept_id')\t$(_jq '.drug_concept_id')\t$(_jq '.ndrugreports')" >> aeolus_flattened.tsv
  done
done


# For shell string variable:
#for row in $(echo "${sample}" | jq -r '.[0].result[] | @base64'); do

# For file:  
#for row in $(jq -r '.[0].result[] | @base64' sample.json ) ; do
#    _jq() {
#     echo ${row} | base64 --decode | jq -r ${1}
#    }
#   echo -e "$(_jq '.nreports')\t$(_jq '.outcome_concept_id')\t$(_jq '.drug_concept_id')\t$(_jq '.ndrugreports')" >> aeolus_flattened.tsv
#done