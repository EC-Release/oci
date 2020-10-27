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

Steps to run locally

1. Steps...

```shell
docker run -e zon=<existing service zone-id> -it enterpriseconnect/service:v1beta ./deploy.sh
```
