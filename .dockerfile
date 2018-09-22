# Create image from the official Go image
FROM golang:alpine
RUN apk add --update tzdata \
    bash wget curl git;

# Create binary directory, install glide and fresh
RUN mkdir -p $$GOPATH/bin && \
    curl https://glide.sh/get | sh && \
    go get github.com/pilu/fresh

# define work directory
ADD . /go/src/go.d
WORKDIR /go/src/go.d

# serve the app
CMD glide update && fresh -c runner.conf main.go
