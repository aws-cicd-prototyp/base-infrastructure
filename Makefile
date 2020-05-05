SHELL = /bin/bash

AWS_DEVOPS_PROFILE=default
AWS_PROD_PROFILE=michi.prod
AWS_REGION ?= eu-central-1

DEVOPS_ACCOUNT_ID=147376585776
WORKLOAD_ACCOUNT_ID=496106771575

deployCrossAccountRoles:
	@echo "Creating the baseCrossAccountRoles Stack..."
	@aws cloudformation create-stack \
		--stack-name baseInfraCrossAccountRoles \
		--template-body file://build/cross-account-roles.yaml \
		--parameters \
                	ParameterKey="ArtifactBucket",ParameterValue="codepipeline-artifacts-test-bcadd1a0" \
                	ParameterKey="DevOpsAccount",ParameterValue="147376585776" \
                	ParameterKey="PipelineKmsKeyArn",ParameterValue="arn:aws:kms:eu-central-1:147376585776:key/0a85b8c2-4280-48e9-97c7-5c5917144b23" \
        --capabilities CAPABILITY_NAMED_IAM \
		--profile ${AWS_PROD_PROFILE} \
		--region ${AWS_REGION}

	@echo "Waiting till all resources have been created... this can take some minutes"
	@aws cloudformation wait stack-create-complete \
		--stack-name baseInfraCrossAccountRoles \
		--profile ${AWS_PROD_PROFILE} \
		--region ${AWS_REGION}
	@echo "successful created!"

deployPipeline:
	@echo "Creating the Pipeline Stack..."
	@aws cloudformation create-stack \
		--stack-name baseInfrastructurePipeline \
		--template-body file://build/pipeline.yaml \
		--parameters \
        			ParameterKey="RemoteAccount",ParameterValue="496106771575" \
        			ParameterKey="Project",ParameterValue="aws-cicd-prototyp" \
        			ParameterKey="Repository",ParameterValue="base-infrastructure" \
        			ParameterKey="PipelineKmsKeyArn",ParameterValue="arn:aws:kms:eu-central-1:147376585776:key/0a85b8c2-4280-48e9-97c7-5c5917144b23" \
        			ParameterKey="ArtifactBucket",ParameterValue="codepipeline-artifacts-test-bcadd1a0" \
        			ParameterKey="Branch",ParameterValue="master" \
        			ParameterKey="Stage",ParameterValue="prod" \
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
