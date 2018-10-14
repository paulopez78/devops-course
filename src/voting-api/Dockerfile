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
ENV VOTING_API_PORT 80
COPY --from=builder /src/voting-api .
ENTRYPOINT ["./voting-api"]