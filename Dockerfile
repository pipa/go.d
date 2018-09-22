FROM golang:1.11beta2-alpine3.8 AS build-env

# Allow Go to retrive the dependencies for the build step
RUN apk add --no-cache git

# Secure against running as root
RUN adduser -D -u 10000 gouser
RUN mkdir /pipa/ && chown gouser /pipa/
USER gouser

WORKDIR /pipa/
ADD . /pipa/

# Compile the binary, we don't want to run the cgo resolver
RUN CGO_ENABLED=0 go build -o /pipa/ago .

# final stage
FROM alpine:3.8

# Secure against running as root
RUN adduser -D -u 10000 gouser
USER gouser

WORKDIR /
COPY --from=build-env /pipa/certs/docker.localhost.* /
COPY --from=build-env /pipa/ago /

EXPOSE 8080

CMD ["/ago"]
