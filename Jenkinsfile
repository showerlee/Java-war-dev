#!groovy

pipeline {
    agent{node {label 'master'}}
    
    environment {
        PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/etc/apache-maven/bin"
        JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.121-0.b13.el7_3.x86_64/jre/"
    }
    
    parameters {
        choice(
            choices: 'prod\ndev',
            description: 'choose deploy environment',
            name: 'deploy_env')
    }
    
    stages {
        stage("Checkout src from gitlab"){
            steps{
                echo "INFO:Checkout src from gitlab."
                dir ("${env.WORKSPACE}/Java-war-dev") {
                    git branch: 'deploy', url: 'git@git.showerlee.com:showerlee/Java-war-dev.git'
                }
            }
        }
    
        stage("Mvn compile"){
            steps{
                sh """
                echo "INFO:Maven compilation"
                cd ${env.WORKSPACE}/Java-war-dev
                mvn compile
                """
            }
        }
        
        stage("Unit test"){
            steps{
                sh """
                echo "INFO:Maven testing"
                cd ${env.WORKSPACE}/Java-war-dev
                mvn test
                """
            }
        }
        
        stage("Package"){
            steps{
                sh """
                echo "INFO:Maven pachage"
                cd ${env.WORKSPACE}/Java-war-dev
                mvn package
                """
            }
        }
    
        stage("Upload war to Nexus"){
            steps{
                sh """
                echo "INFO:Upload built war file to Nexus"
                cd ${env.WORKSPACE}/Java-war-dev
                mvn deploy
                """
            }
        }
        
        stage("Update version"){
            steps{
                echo "INFO:Increased maven snapshot version"
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
                
                echo "INFO:Updated ${env.APPNAME} version to ${env.SNAP_VER}"
                
                // Commit the version
                sh """
                cd ${env.WORKSPACE}/Java-war-dev
                git add pom.xml promote.properties
                git commit -m"update version to SNAPSHOT-${env.SNAP_VER}"
                git push origin deploy
                """
                echo "INFO:Committed ${env.APPNAME} version ${env.SNAP_VER} to repo"
            }
        }
        
        stage("Pull deploy code"){
            steps{
                echo "INFO:Pull ansible playbook"
                dir ("${env.WORKSPACE}/Ansible-showerlee") {
                    git branch: 'master', url: 'git@git.showerlee.com:showerlee/Ansible-showerlee.git'
                }
            }
        }
        
        stage("Deploy prerequsite"){
            steps{
                echo "INFO:Checking deployment env"
                sh """
                set +x
                source /home/deploy/.py3env/bin/activate
                . /home/deploy/.py3env/ansible/hacking/env-setup -q
                ansible --version
                python --version
                set -x
                """
                echo "INFO:Python and Ansibe Env is ready to go"
            }
        }
        
        stage("Ansible Deployment"){
            steps{
                //input "Are you ready?"
                echo "INFO:Start deploy war to the destination server"
                dir('./Ansible-showerlee/leon-playbook-java-war-dev1.0') {
                sh """
                set +x
                source /home/deploy/.py3env/bin/activate
                . /home/deploy/.py3env/ansible/hacking/env-setup -q
                ansible-playbook -i inventory/$deploy_env ./deploy.yml -e project=Java-war-dev -e war_path="${env.WORKSPACE}/Java-war-dev/target"
                set -x
                """
                echo "INFO:Anisble Deployment finished"
                }
            }
        }

    }

}