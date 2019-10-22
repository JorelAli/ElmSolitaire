FROM node:10.16.0-stretch-slim

RUN npm install --unsafe-perm -g elm@latest-0.19.1

COPY . .
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
