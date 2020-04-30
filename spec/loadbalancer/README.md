## EC Load Balancer Spec
### Design
The diagram illustrates the sequence of the connectivity model
![LB Seq. High Level](/doc/lb-sequence.png)


Overall connectivity model for the LBer.
![LB High Level](/doc/lb-model.png)



### How to use it
```sh
#TLS-enabled Load-Balancer
docker run \
-v path/to/tls/cert.pem:~/cert.pem \
-v path/to/private/key/key.pem:~/key.pem \
-p 8080:80 \
enterpriseconnect/loadbalancer:v1.1beta

#Non-TLS Load-Balancer
docker run -p 8080:80 enterpriseconnect/loadbalancer:v1.1beta
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
