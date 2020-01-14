# Copy input RDF file to the blazegraph directory
cp -r $1 /data/d2s-workspace/blazegraph/

# Download dataloader file
wget $2

# Send query to bulk load file to Blazegraph
curl -X POST --data-binary @dataloader.txt --header 'Content-Type:text/plain' \
http://blazegraph:8080/bigdata/dataloader