## EC File Transfer Automation Spec

File transfer automation

#### How to use it

- Get the AWS access key and secret key for a user with permissions with create access to EC2

- Install [AZ CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Get the ```subscriptionId``` from ```az login``` command 
- [Create Azure service principal](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli)

```shell script
az ad sp create-for-rbac --role="Owner" --scopes="/subscriptions/{subscriptionId}"
```
Output format - 
```shell script
{
  "appId": "xxxxxxx-xxx-xxxx-xxxx-xxxxxxxxxxx", => azuser
  "displayName": "azure-cli-2020-xx-xx-xx-xx-xx",
  "name": "http://azure-cli-2020-xx-xx-xx-xx-xx",
  "password": "xxxxxxxxxxxxxxxxxxxxx", => azpwd
  "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" => aztenantId
}
```

- Prepare env file

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

- Fill the details in tfvars file and run the ```docker run``` command
```shell script
docker run --env-file=env.env -v $(pwd)/ec-file-transfer.tfvars:/root/ec-file-transfer.tfvars enterpriseconnect/qa-ft:v1beta
```
