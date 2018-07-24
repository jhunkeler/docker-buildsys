node('on-master') {
    //def DOCKER_HOST = "tcp://pldocker:2375"
    def DOCKER_HOST = "tcp://pldmscin1:2375"
    withEnv(["DOCKER_HOST=${DOCKER_HOST}"]) {
        def image

        stage('Clone') {
            checkout scm
        }

        stage('Docker') {
            sh "whoami"
            sh "id"
            sh "echo $PATH"
            sh "which docker"
            step('Build') {
                image = docker.build("astroconda/buildsys")
            }
            step('Test') {
                image.inside {
                    sh "printenv | sort"
                    sh "/opt/conda/bin/conda --version"
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
