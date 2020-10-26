pipeline {
  agent none
  options { disableConcurrentBuilds() }
  stages {
    stage('Clean up old Docker images') {
      agent any
      steps {
        sh "docker system prune -f --filter LABEL=app=elx-docs"
      }
    }
    stage('Build content files') {
      agent { docker 'quay.io/elastx/ci-hugo:0.74.3' }
      steps {
        sh 'git submodule update --init --recursive'
        sh 'HUGO_ENV=production hugo -v'
        sh 'htmlproofer public --allow-hash-href --check-html --empty-alt-ignore --disable-external --file-ignore /revealjs/,/404.html/'
        stash includes: 'public/**', name: 'html'
      }
    }
    stage('Build Docker image') {
      agent any
      steps {
        unstash 'html'
        script {
          docker.withRegistry('https://quay.io', 'quay') {
            docker_image = docker.build("quay.io/elastx/elx-docs", "-f Dockerfile .")
            docker.image("quay.io/elastx/elx-docs").withRun("-p 10082:8080") { c ->
              timeout(time: 1, unit: 'MINUTES') {
                retry(5) {
                  sleep 5
                  sh "curl -sS localhost:10082 | grep 'ELASTX'"
                }
              }
            }
            if (env.BRANCH_NAME == 'master') {
              docker_image.push()
            }
          }
        }
      }
      post {
        always {
          sh "docker system prune -f --filter LABEL=app=elx-docs"
        }
      }
    }
    stage('Deploy - Kubernetes') {
      when { branch 'master' }
      agent {
        docker {
          image 'quay.io/elastx/ci-kubernetes:1.18.9'
          args '--entrypoint ""'
        }
      }
      environment {
        CICD_KUBECONFIG = credentials('cicd-kubeconfig')
      }
      steps {
        sh 'sed -i "s/GIT_COMMIT/${GIT_COMMIT}/g" ${WORKSPACE}/k8s/bases/elx-docs/deployment.yaml'
        sh 'kustomize build ${WORKSPACE}/k8s/bases/elx-docs | kubectl --kubeconfig=${CICD_KUBECONFIG} apply -f -'
      }
    }
  }
}
