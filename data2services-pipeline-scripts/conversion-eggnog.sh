                                                     
# eggnog.tsv file in /data/data2services

docker run -it --rm -v /data/emonet/ncats:/data data2services-download --download-datasets eggnog

docker run -dit --rm -p 8047:8047 -p 31010:31010 --name drill -v /data:/data:ro apache-drill

docker run -it --rm --link drill:drill -v /data:/data autor2rml \
        -j "jdbc:drill:drillbit=drill:31010" -r \
        -o "/data/emonet/ncats/eggnog/mapping.trig" \
        -d "/data/emonet/ncats/eggnog" \
        -b "https://w3id.org/data2services/" \
        -g "https://w3id.org/data2services/graph/autor2rml/eggnog"

docker run -it --rm --link drill:drill \
  -v /data/emonet/ncats/eggnog:/data \
  r2rml /data/config.properties

# Load RDF file in GraphDB ncats-test repository

# Split ProteinsIds: http://graphdb.dumontierlab.com/resource?uri=https:%2F%2Fw3id.org%2Fdata2services%2Fdata%2Femonet%2Fncats%2Feggnog%2FNOG.members.tsv%2F100700
docker run -d --link graphdb:graphdb \
  vemonet/data2services-sparql-operations -op split \
  --split-property "https://w3id.org/data2services/model/Proteinids" \
  --split-class "https://w3id.org/data2services/data/emonet/ncats/eggnog/NOG.members.tsv" \
  --split-delimiter "," --split-delete \
  -ep "http://graphdb:7200" \
  -uep "bio2vec-test" \
  -un emonet -pw $PASSWORD \
  -var outputGraph:https://w3id.org/data2services/graph/autor2rml/eggnog 
# 874a6c3c73349049931973d94381e1fdbf9f5b7ec88e4801fd4586dfb4754f6a
# 1h:11m:23s and finish with org.eclipse.rdf4j.query.QueryEvaluationException: java.net.SocketException: Connection reset
# But delete seems to have work well


# Convert generic RDF to BioLink
docker run -d --link graphdb:graphdb data2services-sparql-operations -f "https://github.com/MaastrichtU-IDS/data2services-transform-repository/tree/master/sparql/insert-biolink/eggnog" -ep "http://graphdb:7200/repositories/bio2vec/statements" -un emonet -pw $PASSWORD -var serviceUrl:http://localhost:7200/repositories/bio2vec-test inputGraph:https://w3id.org/data2services/graph/autor2rml/eggnog outputGraph:https://w3id.org/data2services/graph/biolink/eggnog
# 2cfdd204ab551f8bffb3ea100ffafd3b842da8926d326c47ea4832d0d6c3a8c7


# Compute HCLS statistics
docker run -d --link graphdb:graphdb data2services-sparql-operations -f "https://github.com/MaastrichtU-IDS/data2services-transform-repository/tree/master/sparql/compute-hcls-stats" -ep "http://graphdb:7200/repositories/bio2vec/statements" -un emonet -pw $PASSWORD -var inputGraph:https://w3id.org/data2services/graph/biolink/eggnog
