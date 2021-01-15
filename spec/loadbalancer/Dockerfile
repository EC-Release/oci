FROM nginx:1.19.6-alpine

RUN ["/bin/bash", "-c", "wget -q --show-progress -O ~/v1_index.sh https://raw.githubusercontent.com/ramaraosrikakulapu/sdk/disty/scripts/loadbalancer/v1_index.txt"]

RUN chmod +x ~/v1_index.sh

ENTRYPOINT ["~/v1_index.sh"]
