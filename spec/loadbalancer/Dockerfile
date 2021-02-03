FROM nginx:1.19.6-alpine

RUN apk update && apk add --no-cache wget && apk add --no-cache bash

RUN ["/bin/bash", "-c", "wget -O /root/v1_index.sh https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/loadbalancer/v1_index.txt"]

RUN chmod +x /root/v1_index.sh

ENTRYPOINT ["/root/v1_index.sh"]
