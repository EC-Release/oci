## EC Load Balancer Spec
### Design
[Lucidchar](https://www.lucidchart.com/invitations/accept/7bbe2eee-a21b-480c-bf7e-53a430fcbfd8)
[img](https://www.lucidchart.com/invitations/accept/7bbe2eee-a21b-480c-bf7e-53a430fcbfd8)

### How to use it
```sh
#TLS-enabled Load-Balancer
docker run \
-v path/to/tls/cert.pem:~/cert.pem \
-v path/to/private/key/key.pem:~/key.pem \
enterpriseconnect/lb:v1beta

#Non-TLS Load-Balancer
docker run enterpriseconnect/lb:v1beta
```

### Current Support Modes Matrix
Mode | Avaialble Releases | Watcher
--- | --- | ---
gateway | v1.1beta, v1.1 | Optional
client | v1.1beta, v1.1 | Optional
server | v1.1beta, v1.1 | Optional 
x:gateway | v1.1beta, v1.1 | Optional 
x:client | v1.1beta, v1.1 | Optional
x:server | v1.1beta, v1.1 | Optional
gw:server | v1.1beta, v1.1 | Optional
gw:client | v1.1beta, v1.1 | Optional

### Agent Configuration
```sh
./agent ... -hst <url/to/watcher/vm>
```
