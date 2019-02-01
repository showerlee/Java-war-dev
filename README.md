# Java-war-dev

The following is how to use jenkins CI/CD pipeline to build and release a java application.

The repo contains a Helllo World java application, a Jenkins pipeline script, an Ansible script and all related maven configurations 

####  Procedure
```
Checkout source code ==> VersionSet ==> Maven compile ==> Package ==> Upload war to Nexus ==> Check prerequsite ==> Ansible Deployment

```

Remember to proactive the prerequisite before rollout the pipeline.

#### Prerequisite:
```
Github ===> Git repo

Jenkins ===> CI/CD manager

Maven ===> Java Build tool(Setting the Nexus repo credential in "${maven_home}/conf/setting.xml")

Nexus ===> Package Repository Manager

Python ===> Ansible dependency

Ansible ===> Deploy tool

```

####  Runbook:

1. Build all prerequisites in a box or more boxes

2. Create a jenkins pipeline style job

3. Import the repo into pipeline job

4. Rock and roll
