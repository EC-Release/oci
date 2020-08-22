# plugin spec usage
### TLS Config
Beginning the TLS plugin by preparing an environment file e.g. ```ec.enc``` in following example
```env
#agent
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
plg.tls.cmd=./tls_linux_sys
```
### VLAN Config
For VLAN, consider the following example.
```env
#agent
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
plg.vln.cmd=./vln_linux_sys
```
### Launch with docker
```bash
docker run -it --env-file=<the env file. e.g. ec.env> enterpriseconnect/plugins:v1
```

