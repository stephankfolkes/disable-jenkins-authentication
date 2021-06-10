# Disable Jenkins Authentication
This repository contains scripts that enable the disabling of Authentication for CloudBees CI managed controller instances.
It follows the process outlined in documentation: https://www.jenkins.io/doc/book/system-administration/security/#disabling-security

## RUN
`./disableJenkinsAuthK8s.sh [namespace] [pod-0] [Pod] [USERNAME] [USER-TOKEN] [URL (https://example-domain.com)]`

## RUN for multiple controllers
Populate [controllerList.csv](controllerList.csv) configuration file with a list of pods and controllers. E.g.
```
pod-0,Pod
example-controller-0,example-controller
```
Execute script:
`./disableMany.sh [namespace] [USERNAME] [USER-TOKEN] [URL (https://example-domain.com)]`
