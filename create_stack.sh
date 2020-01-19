
STACK_NAME=test20
CF_TEMPLATE_FILE=ELBWithLockedDownAutoScaledInstances.template

PARAM_AMI_ID=ami-0b8b10b5bf11f3a22    # tested on aws linux 2
PARAM_KEYNAME=lcs18Jan2020
PARAM_SUBNETS=subnet-c5a1d0a1,subnet-f00f7c86
PARAM_VPC_ID=vpc-949c29f0

aws cloudformation create-stack --stack-name $STACK_NAME --template-body "`cat $CF_TEMPLATE_FILE`"  --parameters ParameterKey=AMIID,ParameterValue=$PARAM_AMI_ID ParameterKey=KeyName,ParameterValue=$PARAM_KEYNAME ParameterKey=Subnets,ParameterValue=\"$PARAM_SUBNETS\" ParameterKey=VpcId,ParameterValue=$PARAM_VPC_ID
