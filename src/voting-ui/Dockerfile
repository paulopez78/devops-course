FROM node:alpine 

COPY deps.sh .
RUN ./deps.sh main

WORKDIR /app

COPY . .
ENTRYPOINT [ "http-server", "-p", "80"]