  pipeline {
     agent {
        kubernetes {
          yaml '''
            apiVersion: v1
            kind: Pod
            spec:
              containers:
              - name: maven
                image: maven:alpine
                command:
                - cat
                tty: true
              - name: sonar
                image: sonarsource/sonar-scanner-cli
                command:
                - cat
                tty: true
                env:
                  - name: SONAR_HOST_URL
                    value: "http://a0185931b1aef443bbf58d9be7ce6af1-1311541991.ap-south-1.elb.amazonaws.com"
                  - name: SONAR_TOKEN
                    value: "sqa_858e5a8d6cbf37d5da83ce29758bb6a7dd1009bd"
              - name: docker
                image: docker:dind
                command: ["sh"]
                args: ["/usr/local/bin/dockerd-entrypoint.sh"]
                tty: true
                env:
                  - name: DOCKER_TLS_CERTDIR
                    value: ""
                  - name: DOCKER_HOST
                    value: tcp://localhost:2375
                securityContext:
                  privileged: true
                  runAsUser: 0
            '''
    }
  }


    stages {
        stage('Checkout') {
            steps {
                container('maven') {
                // Get some code from a GitHub repository
                git 'https://github.com/omkarp741/webapp.git'
                
                }
            }
        }
                
        stage('build'){
            steps {
                container('maven') {
                    // Run Maven on a Unix agent.
                sh "mvn clean install -DskipTests"
                }
            }
        }
        
        stage('code coverage'){
            steps {
                container('sonar') {
                    // Run Sonar CLI.
                sh "sonar-scanner -Dsonar.projectKey=webapp -Dsonar.sources=src/main/java/ -Dsonar.language=java -Dsonar.java.binaries=target/classes/com/visualpathit/account"
                }
            }
        }

        stage('Docker build & tag') {
            steps {
                container('docker') {
                // Build Docker image with Tag as Build number
                sh 'docker build -t omkarp741/web-app:$BUILD_NUMBER -f Dockerfile .'
                
                }
            }
        }
                
        stage('Docker login & push') {
            steps {
                container('docker') {
                 sh 'docker login -u omkarp741 -p dckr_pat_FkhKsHPuriVgi5-w9gNqLhQWd4o'

                // Push Docker image
                sh 'docker push omkarp741/web-app:$BUILD_NUMBER'
                sh 'docker tag omkarp741/web-app:$BUILD_NUMBER omkarp741/web-app:latest'
                sh 'docker push omkarp741/web-app:latest'
                }
            }
        }        


}
}
