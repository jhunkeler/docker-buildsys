node('on-master') {
    def DOCKER_HOST = "tcp://pldocker:2375"
    withEnv(["DOCKER_HOST=${DOCKER_HOST}"]) {
        def image

        stage('Clone') {
            checkout scm
        }

        stage('Build') {
            sh "whoami"
            sh "id"
            sh "echo $PATH"
            sh "which docker"
            image = docker.build("astroconda/buildsys")
        }

        stage('Test') {
            image.inside {
                sh 'conda --info'
            }
        }

        /*
        stage('Push') {
            docker.withRegistry('https://registry.hub.docker.com', 'astroconda') {
                image.push("${env.BUILD_NUMBER}")
                image.push("latest")
            }
        }
        */
    }
}
