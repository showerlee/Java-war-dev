#!groovy

pipeline {
    agent{node {label 'master'}}
    
    environment {
        PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/data/apache-maven-3.6.0/bin"
    }
    
    parameters {
        choice(
            choices: 'dev\nprod',
            description: 'choose deploy environment',
            name: 'deploy_env')
    }
    
    stages {
        stage("Checkout code from github"){
            steps{
                echo "[INFO]:Checkout code from github."
                dir ("${env.WORKSPACE}/Java-war-dev") {
                    git branch: 'master', credentialsId: 'Github-credential', url: 'https://github.com/showerlee/Java-war-dev.git'
                }
            }
        }

        stage("VersionSet"){
            steps{
                echo "[INFO]:Increased maven snapshot version"
                sh """
                # POM Version addition. 
                cd ${env.WORKSPACE}/Java-war-dev
                echo "" | mvn release:update-versions
                
                # Grab promote properties
                sh SetPromoteProperties.sh
                """
                
                script {
                    def props = readProperties file: "${env.WORKSPACE}/Java-war-dev/promote.properties";
                    env['SNAP_VER'] = props['SNAP_VER'];
                    env['APPNAME'] = props['APPNAME'];
                }
                
                echo "[INFO]:Updated ${env.APPNAME} version to ${env.SNAP_VER}"
                
                // Commit the version
                withCredentials([usernamePassword(credentialsId: 'Github-credential', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')]) {
                    sh """
                    cd ${env.WORKSPACE}/Java-war-dev
                    git add pom.xml promote.properties
                    git commit -m"update version to SNAPSHOT-${env.SNAP_VER}"
                    git push https://${env.GIT_USERNAME}:${env.GIT_PASSWORD}@github.com/showerlee/Java-war-dev.git master
                    """
                }
                echo "[INFO]:Committed ${env.APPNAME} version ${env.SNAP_VER} to repo"
            }
        } 
    
        stage("Mvn compile"){
            steps{
                sh """
                echo "[INFO]:Maven compilation"
                cd ${env.WORKSPACE}/Java-war-dev
                mvn compile
                """
            }
        }
        
        stage("Package"){
            steps{
                sh """
                echo "[INFO]:Maven package"
                cd ${env.WORKSPACE}/Java-war-dev
                mvn package
                """
            }
        }
    
        stage("Upload war to Nexus"){
            steps{
                sh """
                echo "[INFO]:Upload built war file to Nexus"
                cd ${env.WORKSPACE}/Java-war-dev
                mvn deploy
                """
            }
        }

        stage("Env prerequsite"){
            steps{
                echo "[INFO]:Checking deployment env"
                sh """
                set +x
                echo "[INFO]:Checking Disk space:"
                df -h
                echo ""
                echo "[INFO]:Checking RAM space:"
                free -m
                set -x
                """
                echo "Env is ready to go..."
                input("Start deploying to ${deploy_env}?")
            }
        }

        stage("Ansible Deployment"){
            steps{
                echo "[INFO]:Start deploying war to the destination server"
                sh """
                set +x
                source /home/deploy/.py3env/bin/activate
                echo "[INFO]:Checking python version"
                python --version
                . /home/deploy/.py3env/ansible/hacking/env-setup -q
                echo "[INFO]:Checking ansible version"
                ansible --version
                echo "[INFO]:Start ansible deployment"
                cd ${env.WORKSPACE}/Java-war-dev/ansible/leon-playbook-java-war-dev1.0
                ansible-playbook -i inventory/$deploy_env ./deploy.yml -e project=Java-war-dev -e war_path="${env.WORKSPACE}/Java-war-dev/target"              
                set -x

                """
                echo "[INFO]:Congratulation, Anisble Deployment has been finished successfully :)"
            }
        }

    }

}
