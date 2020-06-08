
## Load balancer deployment automation
### Goal
Automation deployment scripts for EC gateway with load balancer

### Prerequisites
- [Terraform v0.12.24](https://www.terraform.io/downloads.html)
- [AWS CLI 2.0.7](https://aws.amazon.com/cli/)

**Note:** If you are using Cago tool for connecting to Corp Sandbox VPC, please use the instructions defined [here](https://devcloud.swcoe.ge.com/devspace/display/SBSF/Cagophilist+%28Cago%29+Quickstart)

### How to use it

Update the ```terraform.tfvars``` with corresponding configuration details 

- For Cago tool, refresh the profiles 
  ```hcl-terraform
  cago refresh-profiles
  ```

  It will generate a token and will be used for connecting to target cloud environment
- Initialize the terraform
  ```hcl-terraform
  terraform init
  ```

- Review the resource plan
  ```hcl-terraform
  terraform plan
  ```

- Apply to implement the plan
  ```hcl-terraform
  terraform apply -var-file="terraform.tfvars"
  ```
