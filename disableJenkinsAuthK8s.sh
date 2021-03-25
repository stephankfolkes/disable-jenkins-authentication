#!/bin/bash

namespace=$1
pod=$2

if [ -z $namespace ] || [ -z $pod ]
then
  echo "Execution parameters missing. Please provide namespace and pod name as parameters."
fi

kubectl exec -it $pod -n $namespace -- /bin/sh -c " sed -i 's/<useSecurity>true/<useSecurity>false/' /var/jenkins_home/config.xml && sed -i '/<authorizationStrategy/d' /var/jenkins_home/config.xml && sed -i '/<securityRealm/d' /var/jenkins_home/config.xml"
