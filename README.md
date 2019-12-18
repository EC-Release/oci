# EC OCI Specs
EC Agent OCI image usage spec avaialble in several compute environments.

### Docker Tags
- [```v1```](https://github.com/Enterprise-connect/oci/blob/v1/spec/agt.Dockerfile)
- [```v1beta```](https://github.com/Enterprise-connect/oci/blob/v1beta/spec/agt.Dockerfile)

### How to run
In this container spec example, the pre-defined agent image is launched by using docker. The agent flags in this example are converted into several environment variables that are required based on the ```<path/to/this/repo>/spec/<agent-mode>.yml``` for a EC usage. For instance, to launch a client-mode agent container, it is required to ingest env vars EC_AID, EC_TID, EC_HST, etc. 
  
The variables will be replaced by a relevant flag as it is shown in the example yaml file.
```shell
docker run --env-file client.list \
  enterpriseconnect/agent:v1beta
```


