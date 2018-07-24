node('on-master') {
    env.PATH = "${env.PATH}:/usr/local/bin"
    def image

    stage('Clone') {
        checkout scm
    }

    stage('Build') {
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
