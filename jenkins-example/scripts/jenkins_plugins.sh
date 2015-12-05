#!/bin/bash

download_cli() {
  wget http://localhost:8080/jnlpJars/jenkins-cli.jar
  while [ $? -ne 0 ];
  do
    echo "Waiting for Jenkins to start..."
    sleep 10
    wget http://localhost:8080/jnlpJars/jenkins-cli.jar
  done
}

install_plugin() {
  java -jar jenkins-cli.jar \
    -s http://localhost:8080/ \
    install-plugin \
    http://updates.jenkins-ci.org/download/plugins/$1/$2/$1.hpi
}

# Install Git
sudo apt-get install -y git

# Download Jenkins CLI
download_cli

# git plugin dependencies
install_plugin credentials 1.24
install_plugin git-client 1.19.0
install_plugin scm-api 1.0
install_plugin mailer 1.16
install_plugin "matrix-project" 1.6
install_plugin ssh-credentials 1.11

# git plugin
install_plugin git 2.4.0

sudo java -jar jenkins-cli.jar -s http://localhost:8080/ safe-restart
