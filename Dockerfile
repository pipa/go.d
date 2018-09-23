# Create image from the official Go image¬
FROM golang:alpine
RUN apk add --update tzdata \
    bash wget curl git;
# create a working directory
WORKDIR /go/src/app
# install dep
RUN go get github.com/golang/dep/cmd/dep
# add Gopkg.toml and Gopkg.lock
ADD Gopkg.toml Gopkg.toml
ADD Gopkg.lock Gopkg.lock
# install packages
RUN dep ensure --vendor-only
# add source code
ADD . . 
# build the source
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main main.go
# strip and compress the binary
RUN strip --strip-unneeded main
RUN upx main

# use scratch (base for a docker image)
FROM scratch
# set working directory
WORKDIR /root
# copy the binary from builder
COPY --from=builder /go/src/app/main .
# run the binary
CMD ["./main"]
