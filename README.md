
Hi

I sourced a cloudformation template from

  https://s3-ap-southeast-2.amazonaws.com/cloudformation-templates-ap-southeast-2/ELBWithLockedDownAutoScaledInstances.template

which implements the straightforeward architecture of an ELB/ALB backed by an ASG with EC2 instances. The given implementation uses httpd so it will be modified for ruby/sinatra.
This is just one of many designs that could be used to complete this task, for example docker containers (ie ECS or EKS).

I spent quite a bit of time initially trying to get the out of the box template working in my AWS account and learnt much about igw,NAT gateways, routing tables etc. These are things generally done for you in enterprise cloud environments.

Implementation Choices
=====================================

 * Use of Public/Private Subnets
   The template did not support different network config for the ELB and the EC2s so I made everytging private, ie it is more like an enterprise service than an internet service.   

 * Custom AMI bake or do everything in userdata
   Creating a custom AMI would have been preferable as I could have stored the application source files in the root EBS volume. As it stands they are cloned directly from gitgub in the userdata, not ideal.

 * iptables to redirect port
   This was a 50/50 call, I could have changed the targetgroup/sg to the default port for sintra (9292) rather than using iptables
 
Issues
======

* Getting a new enough ruby installed on AWS linux 2 that could run bundler was an issue.
* Originally I had the nohup that runs bundler exec in the cfn-init command along with the other setup commands, but it seems cfn-init keeps track of childprocesses and wont complete until those processes terminate. This caused problems with cloudformation failing due to not receiving the success signal from the EC2 in the allowed time.


How to run the stack create
============================

1) Ensure the AWS cli is available

2) edit the file create_stack.sh and modify the variables at the top of the script, set them to appropriate values for your AWS account. Make sure you run the script on a bastion host with an appropriate role or run aws configure with valid credntials.

3) run the script
     sh create_stack.sh

4) Check the stack executed ok in the AWS console

5) Curl the ALB dns endpoint
   This is handy 
     aws elbv2 describe-load-balancers --query "LoadBalancers[*].DNSName" --output table
  You should see this
    [ec2-user@ip-10-0-0-131 rea]$ curl http://internal-test2-Appli-QT7QE9OPP13-1769602785.ap-southeast-2.elb.amazonaws.com
    Hello World![ec2-user@ip-10-0-0-131 rea]$

Improvements
============

* Make the stack scale in and out based on some metrics
* Bake a custom ami containing the app source or copy from s3
* run ruby/sintra as a service (if the process dies the instance healthcheck fails, the instance is terminated and a new one created so not critical)
* dont run the app as root, generally a no-no in production as any exploits get root, in a cloud world less important as instances are not long lived and generally only do one thing.

cheers
lyndon

