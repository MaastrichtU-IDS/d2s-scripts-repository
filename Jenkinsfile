pipeline {
  agent any

  parameters {
    string(name: 'GraphUri', defaultValue: 'https://w3id.org/data2services/graph/biolink/date', description: 'URI of the Graph to validate')
    string(name: 'UpdateRepositoryUri', defaultValue: 'http://graphdb.dumontierlab.com/repositories/public/statements', description: 'URI of the repository used to insert the computed statistics')
    string(name: 'ValidateRepositoryUri', defaultValue: 'http://graphdb.dumontierlab.com/repositories/public', description: 'URI of the repository used to validate the graph using PyShEx')
    string(name: 'TriplestoreUsername', defaultValue: 'import_user', description: 'Username for the triplestore')
    string(name: 'TriplestorePassword', defaultValue: 'changeme', description: 'Password for the triplestore')
  }

  //options { // using the timestamps plugin we can add timestamps to the console log
  //  timestamps()
  //}

  stages {
    stage('Build and install') {
      steps {
        sh "git clone --recursive https://github.com/vemonet/data2services-insert.git"
        sh 'docker build --rm -f "$WORKSPACE/data2services-insert/rdf4j-sparql-operations/Dockerfile" -t rdf4j-sparql-operations:latest $WORKSPACE/data2services-insert/rdf4j-sparql-operations'
        sh 'pip3.7 install pyshex'
      }
    }

    stage('Compute statistics') {
      steps {
        sh "docker run -t --rm --volumes-from jenkins-translator rdf4j-sparql-operations -rq '$WORKSPACE/data2services-insert/compute-statistics' -url '${params.UpdateRepositoryUri}' -un ${params.TriplestoreUsername} -pw ${params.TriplestorePassword} -var inputGraph:${params.GraphUri}"
      }
    }

    stage('ShEx validation') {
      steps {
        sh "shexeval -gn '' -ss -ut -sq 'select distinct ?item from <${params.GraphUri}> where{?item a <http://w3id.org/biolink/vocab/Gene>} LIMIT 100' ${params.ValidateRepositoryUri} https://github.com/biolink/biolink-model/raw/master/shex/biolink-modelnc.shex > shex_validation.txt"
      }
    }
    // shexeval -gn '' -ss -ut -sq 'select distinct ?item from <https://w3id.org/data2services/graph/biolink/date> where{?item a <http://w3id.org/biolink/vocab/Gene>} LIMIT 100' http://graphdb.dumontierlab.com/repositories/public/statements https://github.com/biolink/biolink-model/raw/master/shex/biolink-modelnc.shex
    /*stage('RDFUnit') {
      steps {
        sh 'docker run --rm -t --volumes-from jenkins-translator -v /data/translator:/data dqa-rdfunit  -o ttl -d "http://graphdb.dumontierlab.com/repositories/ncats-red-kg" \
        -e "http://graphdb.dumontierlab.com/repositories/ncats-red-kg" -f "$WORKSPACE/rdfunit" -s "https://raw.githubusercontent.com/biolink/biolink-model/master/ontology/biolink.ttl" -g "https://w3id.org/data2services/graph/biolink/date"'
      }
    }*/
  }
  post {
    always {
      // archive contents in results folder, only if the build is successful
      archiveArtifacts artifacts: '*/*', onlyIfSuccessful: true
      // delete all created directories and clean workspace
      deleteDir()
      cleanWs()
    }
  }
}