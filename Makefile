SHELL = /bin/bash

AWS_DEVOPS_PROFILE=default
AWS_PROD_PROFILE=michi.prod
AWS_REGION ?= eu-central-1

DEVOPS_ACCOUNT_ID=147376585776
WORKLOAD_ACCOUNT_ID=496106771575

deployPipeline:
	@echo "Creating the Pipeline Stack..."
	@aws cloudformation create-stack \
		--stack-name baseInfrastructurePipeline \
		--template-body file://build/pipeline.yaml \
		--parameters \
        			ParameterKey="Project",ParameterValue="aws-cicd-prototyp" \
        			ParameterKey="Repository",ParameterValue="base-infrastructure" \
	    			ParameterKey="Suffix",ParameterValue="customSuffix" \
        			ParameterKey="Branch",ParameterValue="master" \
        			ParameterKey="Stage",ParameterValue="prod" \
	      			ParameterKey="RemotePreviewAccount",ParameterValue="169093882879" \
        			ParameterKey="RemoteDeliveryAccount",ParameterValue="496106771575" \
        			ParameterKey="ArtifactBucket",ParameterValue="ci-cd-bootstrap-devopsbasedelivery-artifactstore-1lttxt4rg1a4w" \
        			ParameterKey="PipelineKmsKeyArn",ParameterValue="arn:aws:kms:eu-central-1:147376585776:key/76da54a3-6d7e-4b18-ab60-47bdb1ea5dea" \
        			ParameterKey="PipelineServiceRoleArn",ParameterValue="arn:aws:iam::147376585776:role/CI-CD-Bootstrap-PipelineRolesD-PipelineServiceRole-7PEE7V5KVHUI" \
        			ParameterKey="DynamicPipelineCleanupLambdaArn",ParameterValue="arn:aws:lambda:eu-central-1:147376585776:function:CI-CD-Bootstrap-DevOpsLam-DynamicPipelineCleanupLa-B1TEUINGML5I" \
        			ParameterKey="CreteForDelivery",ParameterValue="true" \
		--profile ${AWS_DEVOPS_PROFILE} \
		--capabilities CAPABILITY_NAMED_IAM \
		--region ${AWS_REGION}

	@echo "Waiting till all resources have been created... this can take some minutes"
	@aws cloudformation wait stack-create-complete \
		--stack-name baseInfrastructurePipeline \
		--profile ${AWS_DEVOPS_PROFILE} \
		--region ${AWS_REGION}
	@echo "successful created!"


#ONLY FOR TESTs:
deployInfrastructureBuild:
	@echo "Creating the Pipeline Stack..."
	@aws cloudformation create-stack \
		--stack-name infrastructureBuild \
		--template-body file://build/infrastructureBuild.yaml \
		--parameters \
        			ParameterKey="BaseStack",ParameterValue="bootstrapBase" \
		--profile ${AWS_DEVOPS_PROFILE} \
		--capabilities CAPABILITY_NAMED_IAM \
		--region ${AWS_REGION}

	@echo "Waiting till all resources have been created... this can take some minutes"
	@aws cloudformation wait stack-create-complete \
		--stack-name infrastructureBuild \
		--profile ${AWS_DEVOPS_PROFILE} \
		--region ${AWS_REGION}
	@echo "successful created!"
