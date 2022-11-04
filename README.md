## Terraform Pipeline

This is a terraform project in charge of creating the IaC for an ECS cluster in aws the application hosted
in the cluster can be found in the following repository:

https://github.com/SalvadorM271/mern-app/tree/main

## AWS services and resources use:

- VPC
- Subnets
- Security groups
- Internet Gateway
- NAT gateway
- ECS cluster
- Application Load Balancer
- Autoscaling
- Cloudwatch logs

## How it works 

First we set up our VPC once the VPC is ready is time to create the subnets i have created two in two different avelability zones in the 
us-east-2 region one private subnet and one public, after that an internet gateway was created to gran internet access to the public
subnet with the help of a routing table, there is also a need for the private subnet to connect to the outside but not directly,
for that i use a NAT gateway one on each AZ because if one AZ falls and Im only using one NAT the whole infra is gonna fall so i decided to
use two i might me a bit more expensive but it gives the infrastructure more resiliency which is worth the price.

Once that is done is time to create an ECS cluster but before that an ECR repository with the application image is needed, i decided
to create the ECR manually because it migh cause problems at the momment of erasing the infrastructure since the images within will 
have to be erase first but beyond that the fact that the infrastructure is destroy does not necessarily means that we want to get rid
of the images two, so it might become an inconvenience to create it with terraform, I also decided to have one repository for each
environment image since is best to have each environment as separeted as possible to the point that sometimes they are done in differen region

Once we have the ECR is time to focus on the ECS cluster in order to host the application a task definition and a service were created
but there is also a need for a database for that I use a MongoDB Atlas cluster for this one im creating one cluster for each environment
with terraform since is best to have our environments as separated as possible.

After that there is a need to route the traffic that is comming from the outside to the application and since Im using two AZ is best two use
an application load balance two distribute the load between the replicas of the application taking care  of the inbound traffic, for the outbound
traffic the NATs are use, again i have one on each AZ for resiliency.

And finally i configure the autoscaling to increaae or lower the number of replicas base on the cpu and memmory usage of the FARGATE container
which are the serverless alternative to using EC2 instances on our ECS cluster also i use cloudflare in order to manage my domain and connect it to the load balancer.

## State

For managing the state of the infrastructure I dicided to use terraform cloud instead of an s3 bucked, since terraform cloud is free with up to 5
members which is more than enough in most cases, terraform cloud also allows to easily manage the workspaces for each environment leting us
have a set of variables specific for each enviroment and var sets that contains variables that can be use in multiple workspaces at once.


## IaC

IaC works like a normal application in the sense that since our application is configure completely as code it can be manage in the same
way as a normal application would be, for that i have decided to use Github Actions to implement the pipeline which is store in .github/workflows
and as for any pipeline all starts with commiting our code which can be done with the following steps:


first check if you are in the correct branch

`git branch`

then we must add the changes

`git add .`

after that we need to commit our changes

`git commit -m "example commit"`