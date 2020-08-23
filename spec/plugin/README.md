# plugin spec usage
### TLS Config
Beginning the TLS plugin usage by preparing an environment file e.g. ```ec.enc``` in the following example. For [the detail in the TLS setting here](https://github.com/EC-Release/sdk/tree/v1/plugins/tls#tls-plugin). 

The TLS plugin can only be launched by agents in "server" or "gw:server" mode.
```env
#server agent
conf.sst=https://sst0234.run.aws.ice.predix.io/v1/index/                                                                
conf.grp=default_group                                                                                                                             
conf.tkn=Fza3A4R29NZlk=                                             
conf.cps=0
conf.mod=server
...
...
#plugin type
plg.typ=tls
#tls                                                                                                                                                          
plg.tlc.scm=https                                                                                                                                             
plg.tlc.hst=yahoo.com                                                                                                                                         
plg.tls.prt=443                                                                                                                                               
plg.tls.lpt=7990
```
### VLAN Config
For VLAN, consider the following example. For [the detail of VLAN setting](https://github.com/EC-Release/sdk/tree/v1/plugins/vln#vlan-plugin)

The VLAN plugin can only be launched by agents in "client" or "gw:client" mode.
```env
#client agent
conf.sst=https://sst0234.run.aws.ice.predix.io/v1/index/                                                                
conf.grp=default_group                                                                                                                             
conf.tkn=Fza3A4R29NZlk=                                             
conf.cps=0
conf.mod=client
...
...
#plugin type
plg.typ=vln
#vln ip list                                                                                                                                     
plg.vln.ips=10.10.10.78/32,10.10.18.98/32
```
### Launch with docker
use the environment file created in the previous example and launch it via docker
```bash
docker run -it --env-file=<the env file. e.g. ec.env> enterpriseconnect/plugins:v1
```
