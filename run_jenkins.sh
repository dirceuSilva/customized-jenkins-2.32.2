#!/bin/bash
mkdir -p $HOME/.ssh
ssh-keyscan bitbucket.org >> $HOME/.ssh/known_hosts
ssh-keyscan github.com >> $HOME/.ssh/known_hosts

/usr/local/bin/jenkins.sh
