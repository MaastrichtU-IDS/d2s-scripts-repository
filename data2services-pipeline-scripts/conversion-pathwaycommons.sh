                                                     
# pathwaycommons JSON API file and SQL database files

docker run -it --rm -v /data/emonet/pathwaycommons:/data data2services-download --download-datasets pathwaycommons


# Load RDF file in GraphDB ncats-test repository

#docker run -d --link graphdb:graphdb data2services-sparql-operations -f "https://github.com/MaastrichtU-IDS/d2s-transform-repository/tree/master/sparql/insert-biolink/biopax-pathwaycommons" -ep "http://graphdb:7200/repositories/ncats-red-kg/statements" -un emonet -pw $PASSWORD -var serviceUrl:http://localhost:7200/repositories/ncats-test inputGraph:http://pathwaycommons.org/pc2/graph outputGraph:https://w3id.org/data2services/graph/biolink/pathwaycommons
docker run -d --link graphdb:graphdb vemonet/data2services-sparql-operations -f "https://github.com/MaastrichtU-IDS/d2s-transform-repository/tree/master/sparql/insert-biolink/biopax-pathwaycommons" -ep "http://graphdb:7200/repositories/ncats-red-kg/statements" -un emonet -pw $PASSWORD -var serviceUrl:http://localhost:7200/repositories/ncats-test inputGraph:http://pathwaycommons.org/pc2/graph outputGraph:https://w3id.org/data2services/graph/biolink/pathwaycommons
# 74fce7003b6c1366806390069b3f1fa870617ccdd7a956437c8432f469d78357
# 3m:46s

# Compute HCLS stats
docker run -d --link graphdb:graphdb vemonet/data2services-sparql-operations -f "https://github.com/MaastrichtU-IDS/d2s-transform-repository/tree/master/sparql/compute-hcls-stats" -ep "http://graphdb:7200/repositories/ncats-red-kg/statements" -un emonet -pw $PASSWORD -var inputGraph:https://w3id.org/data2services/graph/biolink/pathwaycommons
# 9f3c757a93579c66da388648d4b098b453f6c89aeaeaebbfc61f1f4dbcd77228
# 

docker run -d --link graphdb:graphdb vemonet/data2services-sparql-operations -f "https://github.com/MaastrichtU-IDS/d2s-transform-repository/tree/master/sparql/compute-hcls-stats" -ep "http://graphdb:7200/repositories/test-vincent/statements" -un emonet -pw $PASSWORD -var inputGraph:https://w3id.org/data2services/graph/biolink/pathwaycommons
# 24ff373de83775b3798dc95dc0771ca81a31f812343efb6a18a94a47891e3c25