#!/bin/bash

# Install go and related
cd /tmp; wget https://dl.google.com/go/go1.13.9.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.13.9.linux-amd64.tar.gz
rm -rf go1.13.9.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
sudo apt-get install -y protobuf-compiler libprotobuf-dev
GO111MODULE="on" go get google.golang.org/protobuf/cmd/protoc-gen-go@v1.26
GO111MODULE="on" go get google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1
GO111MODULE="on" go get github.com/smartystreets/goconvey@v1.6.7

