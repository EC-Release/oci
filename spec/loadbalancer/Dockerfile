FROM nginx:1.19.6-alpine

RUN apk update && apk add --no-cache wget && apk add --no-cache bash sudo

RUN adduser -D ec \
        && echo "ec ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ec \
        && chmod 0440 /etc/sudoers.d/ec

USER ec

WORKDIR /home/ec

RUN ["/bin/bash", "-c", "wget -O ./v1_index.sh https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/loadbalancer/v1_index.txt"]

RUN chmod +x ./v1_index.sh

ENTRYPOINT ["./v1_index.sh"]

