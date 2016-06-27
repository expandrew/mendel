#! /bin/bash
# deploy.sh

SHA1=$1
EB_ENVIRONMENT=$2

EB_BUCKET=andrew-mendel-deployment
EB_APPLICATION=andrew-mendel
SOURCE_BUNDLE=$SHA1-source.zip

# Create Source Bundle Zip
zip $CIRCLE_ARTIFACTS/$SOURCE_BUNDLE -r .ebextensions/

# Create new Elastic Beanstalk version
aws s3 cp $CIRCLE_ARTIFACTS/$SOURCE_BUNDLE s3://$EB_BUCKET/$SOURCE_BUNDLE
aws elasticbeanstalk create-application-version --application-name $EB_APPLICATION \
  --version-label $SHA1 --source-bundle S3Bucket=$EB_BUCKET,S3Key=$SOURCE_BUNDLE

# Update Elastic Beanstalk environment to new version
aws elasticbeanstalk update-environment --environment-name $EB_ENVIRONMENT \
  --version-label $SHA1