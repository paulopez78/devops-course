# build stage
FROM golang:alpine AS builder

RUN apk add --no-cache git

WORKDIR /src
COPY deps .
RUN ./deps

COPY . .
RUN go build -o voting-api

# final stage
FROM alpine
COPY --from=builder /src/voting-api .
ENTRYPOINT ["./voting-api"]