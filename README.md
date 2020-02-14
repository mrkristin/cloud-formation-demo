# cloud-formation-demo
## Helpful Commands
ssh ec2 connection string

`ssh -i </path/to/key-pair>.pem ec2-user@<IP Address>`

s3 commands

`www`
## 0. Notes
In step 1 of the demo some assets and resources are going to be created so they can be used in other steps.
These artifacts include:

* an s3 bucket
* an executable program
* a startup shell script
* an IAM role
* a security group (used in section 2 only)

The first three items are a manual process to create an application and store it's executable. If this build was automated the executable could be stored in an s3 bucket.

## 1. Console & Instance CLI

1. launch an instance
    1. change the security group name to something more meaningful
    1. make sure you have access to a key pair
1. ssh into new instance
1. cheat and get a root shell (`sudo sh`)
1. update the installed software (`yum update -y`)
1. create our api server (manually act like a pipeline)
    1. install go tools (`yum install go -y`)
    1. create the /var/go directory (`mkdir /var/go`)
    1. move into the new directory (`cd /var/go`)
    1. download the needed source files
        ```shell script
        sudo curl https://raw.githubusercontent.com/mrkristin/cloud-formation-demo/master/start-demo.sh > start-demo.sh
        sudo curl https://raw.githubusercontent.com/mrkristin/cloud-formation-demo/master/demo.go > demo.go
       ```
    1. compile the go program (`go build /var/go/demo`)
    1. create a script to run the executable
        ```shell script
        #!/bin/bash
        cd /var/go
        nohup /var/go/demo &
        date  >> /var/go/user.data.log
        echo "^^ just started go demo via start.sh ^^" >> /var/go/user.data.log
        ```
1. start and test the api server
    1. add security group entry for http (stateful)
1. create a cron job to make sure api is always running
1. save the script to S3
    1. create an s3 bucket (`aws s3 mb <bucket>`)
    1. create IAM role to access s3 (read/write)
    1. add IAM role to instance (stateful)
    1. send executable and script to s3 bucket
    1. remove write access from role
    1. try to read and write from s3
1. terminate the server

## 2. Console with Bootstrap Script
1. configure and launch a new instance
    1. use the security group defined in step 1
    1. add this script to the user data section
        ```shell script
        #!/bin/bash
        mkdir /var/go
        aws s3 cp  s3://mrk2019-demo/go /var/go/ --recursive
        chmod 0755 /var/go/demo /var/go/start.sh
        (crontab -l 2>/dev/null; echo "* * * * * ps -ef | grep -v grep | grep var/go/demo > /dev/null || /var/go/start.sh") | crontab -
        ```
    1. attempt to explain crontab line
    1. use the IAM role defined in step 1 (to read S3)

    
## 3. Cloud Formation
imagine the bucket, executable, and start script are part of a CI/CD pipeline ... this is a demo :)

In section 1 a security group, role, and server were manually created.

In section 2 some of the configuration was automated by using a bootstrap script and previously created elements

1. Introduce Cloud Formation
1. Create a Role
1. Create an EC2 instance
1. connect together
1. add bootstrap script
1. create a stack
1. what happened
1. add a security group
1. create a delta
1. all is good
1. delete the stack

create a DEV stack
create a QA stack

## 4. Docker

1. go over basic dockerfile
    * `docker -t demo-go .`
    * show file size when built locally
1. go over slim docker file
    * CGO & GOOS ???
    * `docker -t demo-go-slim .`
    * show file size when built locally
    * mention ECR and costs
    * 

## 5 resources and articles

* [crontab](https://en.wikipedia.org/wiki/Cron)
* [Go Docker Image (callicoder)](https://www.callicoder.com/docker-golang-image-container-example/)
* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
* [Deploy Python to ECR (towardsdatascience)](https://towardsdatascience.com/how-to-deploy-a-docker-container-python-on-amazon-ecs-using-amazon-ecr-9c52922b738f)

#### CGO & GOOS

* [GOOS: go operating system ?](https://golang.org/cmd/go/)
* [CGO_ENABLED: C GO](https://golang.org/cmd/cgo/)
 
