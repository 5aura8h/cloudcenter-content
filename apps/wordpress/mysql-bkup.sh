#!/bin/bash -x
(
echo "Username: $(whoami)"
echo "Working Directory: $(pwd)"

. /usr/local/osmosix/etc/.osmosix.sh
. /usr/local/osmosix/etc/userenv
. /usr/local/osmosix/service/utils/cfgutil.sh

env

#Install S3
sudo wget "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip"
sudo unzip -o awscli-bundle.zip
./awscli-bundle/install -b ~/bin/aws

#Configure S3
mkdir -p ~/.aws
echo "[default]" > ~/.aws/config
echo "region=us-west-1" >> ~/.aws/config
echo "output=json" >> ~/.aws/config
echo "[default]" > ~/.aws/credentials
echo "aws_access_key_id=$aws_access_key_id" >> ~/.aws/credentials
echo "aws_secret_access_key=$aws_secret_access_key" >> ~/.aws/credentials


sudo su -c "mysqldump --all-databases -u root -pwelcome2cliqr > dbbak.sql"

~/bin/aws s3 cp dbbak.sql s3://$s3path/$CliqrDeploymentId/dbbak.sql

) 2>&1 | while IFS= read -r line; do echo "$(date) | $line"; done | tee -a /var/tmp/mysql-bkup_$$.log
