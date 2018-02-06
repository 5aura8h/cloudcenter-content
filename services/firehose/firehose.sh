#!/bin/bash
. /utils.sh

# Print the env to the CCM UI for debugging. Remove this line for production.
# Ues with:
# sed -n '/718WPR53 ENV START/,/718WPR53 ENV END/p' /usr/local/cliqr/logs/gateway.log | \
# head -n-1 | tail -n+2 | grep '=' | grep -v '\\n' > envfile
echo "${parentJobName} ENV START"
env
echo "${parentJobName} ENV END"

cmd=$1
serviceStatus=""

if [ -n "${firehose_gitTag}" ]; then
    tag="${firehose_gitTag}"
else
    tag="firehose"
fi

error () {
    print_log "${1}"
    exit 1
}

print_log "Tag/branch for code pull set to ${tag}"

#Install AWS CLI
sudo wget -N "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip"
sudo unzip -o awscli-bundle.zip
sudo ./awscli-bundle/install -b /root/bin/aws

#Configure AWS CLI
sudo mkdir -p /root/.aws
echo "[default]" | sudo tee --append /root/.aws/config
echo "region=us-west-1" | sudo tee --append /root/.aws/config
echo "output=json" | sudo tee --append /root/.aws/config
echo "[default]" | sudo tee --append /root/.aws/credentials
echo "aws_access_key_id=${aws_access_key_id}" | sudo tee --append /root/.aws/credentials
echo "aws_secret_access_key=${aws_secret_access_key}" | sudo tee --append /root/.aws/credentials

cmd=$1 # Controls which part of this script is executed based on command line argument. Ex start, stop.

case ${cmd} in
    start)
        ;;
    stop)
        ;;
    update)
        ;;
    *)
        exit 127
        ;;
esac