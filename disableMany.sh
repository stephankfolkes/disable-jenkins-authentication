#!/bin/bash

namespace=$1
USERNAME=$2
JENKINS_TOKEN=$3
URL=$4
controllerList=controllerList.csv

if [ -z $namespace ] || [ -z $USERNAME ] || [ -z $JENKINS_TOKEN ] || [ -z $URL ]
then
  echo "Execution parameters missing. Please provide namespace as a parameter.\nPlease also ensure Jenkins username, token and URL are passed as parameters."
  exit 1
fi

#Create log directory if not exists
mkdir -p /tmp/disableAuth/logs
echo "Read logs and progress in /tmp/disableAuth/logs"

while read -r controllerAssociation
do
  pod="$(echo $controllerAssociation | cut -d "," -f 1)"
  controller="$(echo $controllerAssociation | cut -d "," -f 2)"
  echo "Disabling Auth for $pod".

  bash disableJenkinsAuthK8s.sh "$namespace" "$pod" "$controller" "$USERNAME" "$JENKINS_TOKEN" "$URL" > "/tmp/disableAuth/logs/$pod.log" 2>&1 &
  sleep 10

done < $controllerList

echo "Disable Authentication scripts are running as background processes.\nWatch the logs and progress in /tmp/disableAuth/logs"
