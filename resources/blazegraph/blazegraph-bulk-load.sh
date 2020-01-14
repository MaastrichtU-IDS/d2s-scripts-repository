# Copy input RDF file to the blazegraph directory
cp -r $1 /data/d2s-workspace/blazegraph/

# Download dataloader file
wget https://raw.githubusercontent.com/MaastrichtU-IDS/d2s-scripts-repository/master/resources/blazegraph/dataloader.txt

# Send query to bulk load file to Blazegraph
curl -X POST --data-binary @dataloader.txt --header 'Content-Type:text/plain' \
http://blazegraph:8080/bigdata/dataloader