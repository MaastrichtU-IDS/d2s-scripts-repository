pipeline {
  agent any

  def projectName =  

  //environment { // What is it? To use in bash when executed? Or my variables?
    //KGX_GIT='https://github.com/NCATS-tangerine/kgx.git'
    //PYTHONPATH='$WORKSPACE/kgx'
  //}
  //options {
    // using the timestamps plugin we can add timestamps to the console log
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
        sh 'docker run -t --rm --volumes-from jenkins-translator rdf4j-sparql-operations -rq "$WORKSPACE/data2services-insert/compute-statistics" -url "http://graphdb.dumontierlab.com/repositories/public/statements" -un import_user -pw test -var inputGraph:https://w3id.org/data2services/graph/biolink/date'
      }
    }

    stage('ShEx validation') {
      steps {
        sh "shexeval -gn '' -ss -ut -sq 'select distinct ?item from <https://w3id.org/data2services/graph/biolink/date> where{?item a <http://w3id.org/biolink/vocab/Gene>} LIMIT 1000' http://graphdb.dumontierlab.com/repositories/ncats-red-kg https://github.com/biolink/biolink-model/raw/master/shex/biolink-modelnc.shex > shex_validation.txt"
      }
    }

    /*stage('RDFUnit') {
      steps {
        sh 'docker run --rm -t --volumes-from jenkins-translator -v /data/translator:/data dqa-rdfunit  -o ttl -d "http://graphdb.dumontierlab.com/repositories/ncats-red-kg" \
        -e "http://graphdb.dumontierlab.com/repositories/ncats-red-kg" -f "$WORKSPACE/rdfunit" -s "https://raw.githubusercontent.com/biolink/biolink-model/master/ontology/biolink.ttl" -g "https://w3id.org/data2services/graph/biolink/date"'
      }
    }*/

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
}