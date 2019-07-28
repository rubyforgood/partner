#! /usr/bin/env bash

openssl aes-256-cbc -k $DEPLOY_KEY -in config/deploy_id_rsa_enc_travis -d -a -out config/deploy_id_rsa -d
chmod 600 config/deploy_id_rsa
eval `ssh-agent -s`
ssh-add config/deploy_id_rsa
bundle exec cap production deploy
ssh-agent -k