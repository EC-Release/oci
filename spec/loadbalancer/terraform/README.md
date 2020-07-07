![Terraform](https://github.com/Enterprise-connect/oci/workflows/Terraform/badge.svg)

## Load balancer deployment automation
### Goal
Automation deployment scripts for EC gateway with load balancer

### Prerequisites
- [Terraform v0.12.24](https://www.terraform.io/downloads.html)
- [AWS CLI 2.0.7](https://aws.amazon.com/cli/)

**Note:** If you are using Cago tool for connecting to Corp Sandbox VPC, please use the instructions defined [here](https://devcloud.swcoe.ge.com/devspace/display/SBSF/Cagophilist+%28Cago%29+Quickstart)

### How to use it

Update the ```terraform.tfvars``` with corresponding configuration details 

- Connect to the target cloud environment.
  - For Cago tool, refresh the profiles 
    ```hcl-terraform
    cago refresh-profiles
    ```
    It will generate a token and will be used for connecting to target cloud environment.
  - For aws cli, configure the environment by running the command
    ```hcl-terraform
    aws configure
    ```

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

### How to run integration test cases

- Install ```go lang``` from [golang.org](https://golang.org/dl/)
 
    *Note*: Test case was tested on ```go version go1.13 darwin/amd64``` version
- Run below commands to initiate and run the test case

    ```bash
    go mod init test
    go test -v ./...
    ```