GOARCH = amd64

VERSION?=?
COMMIT=$(shell git rev-parse HEAD)
BRANCH=$(shell git rev-parse --abbrev-ref HEAD)

# Symlink into GOPATH
GITHUB_USERNAME=aaronchenwei
BUILD_DIR=${GOPATH}/src/github.com/${GITHUB_USERNAME}/grpc-go-helloworld
CURRENT_DIR=$(shell pwd)

# Setup the -ldflags option for go build here, interpolate the variable values
LDFLAGS = -ldflags "-X main.VERSION=${VERSION} -X main.COMMIT=${COMMIT} -X main.BRANCH=${BRANCH}"

# Build the project
all: clean protoc linux

protoc:
	protoc --go_out=. --go_opt=paths=source_relative \
    --go-grpc_out=. --go-grpc_opt=paths=source_relative \
    helloworld/helloworld.proto

linux:
	GOOS=linux GOARCH=${GOARCH} go build ${LDFLAGS} -o greeter_server-linux-${GOARCH} greeter_server/main.go
	GOOS=linux GOARCH=${GOARCH} go build ${LDFLAGS} -o greeter_client-linux-${GOARCH} greeter_client/main.go

fmt:
	cd ${BUILD_DIR}; \
	go fmt $$(go list ./... | grep -v /vendor/) ; \
	cd - >/dev/null

clean:
	-rm -f greeter_server-*
	-rm -f greeter_client-*

.PHONY: protoc linux fmt clean
