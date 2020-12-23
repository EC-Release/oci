## service in containers
#### pull example
```docker pull enterpriseconnect/service:v1beta```

#### Tag usage
- ```v1``` refers to service ```#146``` .
- ```v1beta``` referrs to service ```#1080``` .

### How to run

Steps to run locally

1. Create a EC service in cf or use existing service

2. Extract ENVs of service using command ```cf e <zone-id>```

3. Substitute the values from service to [env.list](https://github.com/EC-Release/oci/blob/v1beta_svc_oci_spec_update_dockerfile/spec/service/env.list.sample)

4. Run following command

```shell
docker run --env-file env.list enterpriseconnect/service:v1beta
```

### Deploy in Cloud Foundry

Command to update service on cloud foundry

```shell
docker run -e CF_USR=<cf-system-username> \
-e CF_PWD=<cf-system-pwd> \
-e ORG=<cf-service-org> \
-e SPACE=<cf-service-space> \
-e CF_API=<cf-api> \
-e EC_PRVT_ADM=<admin-hash> \
-e IMAGE_TAG=<v1beta/v1> \
-e ZONE=<existing service zone-id> -it enterpriseconnect/service:v1beta
```
