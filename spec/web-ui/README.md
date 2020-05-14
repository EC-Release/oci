## Web-Ui
The web-ui runtime spec implemented the EC security ECOsys for the EC Connectivity management portal.
Web-UI is an admin console for EC components like - EC service, EC agent, etc.
This portal is used to perform CRUD operations on EC components. For more details of Web-UI [read this](https://github.com/Enterprise-connect/web-ui/blob/v1.1beta/README.md)

- Spec consists
    - webui frontend
    - webui binary
    - swagger ui
    - godoc for agent lib

#### Tags
#### [v1.1beta](https://hub.docker.com/repository/registry-1.docker.io/enterpriseconnect/webui) : this tag is for beta version of webui starting from version [v1.1beta.webui.0](https://github.com/Enterprise-connect/sdk/tree/v1.1beta.webui.0/dist/webui)

### How to use 
#### ENVs used
    - PORT : Set the value of port on which you want to run webui
    - EC_OAUTH_URL : Provide the url for ec-oauth2
    - EC_CID : Client id provided by xcalr
    - EC_CSC : Encrypted passphrase of your client id

#### Command to run
    ````
    docker run -d -e PORT=${PORT} -p ${PORT}:${PORT} \
    -e EC_OAUTH_URL=${EC_OAUTH_URL} \
    -e EC_CID=${EC_CID} \
    -e EC_CSC=${EC_CSC} enterpriseconnect/webui:v1.1beta
    ````

#### Launch web-ui
    - http(s)://${HOST}:${PORT}/v1.1beta/ec

#### Launch swagger-ui
    - https(s)://${HOST}:${PORT}/v1.1beta/assets/swagger-ui

#### Launch godoc
    - https(s)://${HOST}:${PORT}/v1.1beta/assets/godoc