.PHONY: format get lint test build image push clean

APP := $(shell basename $(shell git remote get-url origin))
REGISTRY := gcr.io/dark-wharf-419217
VERSION := $(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS := linux
TARGETARCH := amd64
#TARGETOS := darwin
#TARGETARCH := amd64
#TARGETOS := windows
#TARGETARCH := amd64
#TARGETOS := linux
#TARGETARCH := arm64

format:
	gofmt -s -w ./

get:
	go get

lint:
	golint

test:
	go test -v

build: format
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X 'github.com/GRYz1n/kbot/cmd.appVersion=$(VERSION)'" .

image:
	docker build . -t ${REGESTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGESTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot
	docker rmi $(REGISTRY)/$(APP):$(VERSION)-$(TARGETARCH)