if (env.BRANCH_NAME == 'master') {
    properties([
        pipelineTriggers([
            upstream(
                upstreamProjects: 'dockers/master',
                threshold: hudson.model.Result.SUCCESS,
            ),
        ]),
    ])
}


try {
    node('slave') {
        step([$class: 'WsCleanup'])
        stage('check-out-code') {
            checkout scm
        }
        stash 'build'
    }


    if (env.BRANCH_NAME == 'master') {
        def version = new Date().format("yyyy-MM-dd-'T'HH-mm-ss")
        withEnv([
            "DOCKER_REVISION=${version}",
        ]) {
            node('slave') {
                step([$class: 'WsCleanup'])
                unstash 'build'

                stage('cook-prod-image') {
                    sh 'make cook-image'
                }

                stash 'build'
            }

            node('deploy') {
                step([$class: 'WsCleanup'])
                unstash 'build'

                stage('push-to-registry') {
                    sh 'make push-image'
                }

                stage('deploy-to-prod') {
                    build job: 'marathon-deploy-app', parameters: [
                        [$class: 'StringParameterValue', name: 'app', value: 'metabase'],
                        [$class: 'StringParameterValue', name: 'version', value: version],
                    ]
                }
            }
        }
    } else {
        node('slave') {
            step([$class: 'WsCleanup'])
            unstash 'build'
            stage('test-cook-image') {
                sh 'make cook-image'
            }
        }
    }

} catch (err) {
    def subject = "${env.JOB_NAME} - Build #${env.BUILD_NUMBER} - Failure!"
    def message = "${env.JOB_NAME} (#${env.BUILD_NUMBER}) failed: ${env.BUILD_URL}"

    if (env.BRANCH_NAME == 'master') {
        slackSend color: '#FF0000', message: message
        mail to: 'root@ocf.berkeley.edu', subject: subject, body: message
    } else {
        mail to: emailextrecipients([
            [$class: 'CulpritsRecipientProvider'],
            [$class: 'DevelopersRecipientProvider']
        ]), subject: subject, body: message
    }

    throw err
}

// vim: ft=groovy
