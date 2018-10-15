FROM node:alpine 

RUN npm install http-server -g


WORKDIR /app

COPY . .
ENTRYPOINT [ "http-server", "-p", "80"]