## EC File Transfer Automation Spec

File transfer automation

#### How to use it

```shell script
docker run --env-file=env.env -v $(pwd)/ec-file-transfer.tfvars:/root/ec-file-transfer.tfvars enterpriseconnect/qa-ft:v1beta
```

Format of env file

```
ARM_CLIENT_ID={AZ client id}
ARM_CLIENT_SECRET={AZ client secret}
ARM_TENANT_ID={AZ tenant id}
ARM_SUBSCRIPTION_ID={AZ subscription id}
TF_VAR_ARM_CLIENT_ID={AZ client id}
TF_VAR_ARM_CLIENT_SECRET={AZ client secret}
TF_VAR_ARM_TENANT_ID={AZ tenant id}
TF_VAR_ARM_SUBSCRIPTION_ID={AZ subscription id}
AWS_ACCESS_KEY_ID={AWS Access Key}
AWS_SECRET_ACCESS_KEY={AWS Secret Key}
AWS_DEFAULT_REGION={AWS Region}
TF_VAR_AWS_ACCESS_KEY_ID={AWS Access Key}
TF_VAR_AWS_SECRET_ACCESS_KEY={AWS Secret Key}
TF_VAR_AWS_DEFAULT_REGION={AWS Region}
```