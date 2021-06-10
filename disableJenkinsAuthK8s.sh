#!/bin/bash

namespace=$1
pod=$2
controller=$3
BASE_DIR="$(echo $(dirname $0))"

USERNAME=$4
JENKINS_TOKEN=$5
URL=$6

if [ -z $namespace ] || [ -z $pod ] || [ -z $controller ] || [ -z $USERNAME ] || [ -z $JENKINS_TOKEN ] || [ -z $URL ]
then
  echo "Execution parameters missing. Please provide namespace, pod name, and controller name as parameters.\nPlease also ensure Jenkins username, token and URL are passed as parameters."
  exit 1
fi

kubectl exec -it $pod -n $namespace -- /bin/sh -c " sed -i 's/<useSecurity>true/<useSecurity>false/' /var/jenkins_home/config.xml"

downloadJenkinsCLI(){
  [ ! -f $BASE_DIR/jenkins-cli.jar ] && curl -s -u ${USERNAME}:${JENKINS_TOKEN} \
       "$URL/cjoc/jnlpJars/jenkins-cli.jar" --create-dirs --output $BASE_DIR/jenkins-cli.jar

  [ -f $BASE_DIR/jenkins-cli.jar ] && echo "Successful download of jenkins-cli.jar from Operations Center" || (echo "Error: Failed download of jenkins-cli.jar from Operations Center" && exit 1)
}

downloadJenkinsCLI

java -jar jenkins-cli.jar -auth $USERNAME:$JENKINS_TOKEN -s $URL/cjoc/ managed-master-stop-and-deprovision "$controller"

echo "Wait 90 seconds for master stop" && sleep 90

java -jar jenkins-cli.jar -auth $USERNAME:$JENKINS_TOKEN -s $URL/cjoc/ managed-master-provision-and-start "$controller"
