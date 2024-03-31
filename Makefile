VERSION = $(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
IMAGE_TAG = $(shell docker images --format "{{.ID}}" | head -n 1)
CONTAINER_TAG = $(shell docker ps -l -q)

format:
	gofmt -s -w ./

goget:
	go get

build: format goget
	CGO_ENABLED=0 go build -v -o kbot -ldflags "-X="github.com/33base/kbot/cmd.appVersion=$(VERSION)

linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -o kbot -ldflags "-X="github.com/33base/kbot/cmd.appVersion=$(VERSION)

arm:
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -v -o kbot -ldflags "-X="github.com/33base/kbot/cmd.appVersion=$(VERSION)

macos:
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -v -o kbot -ldflags "-X="github.com/33base/kbot/cmd.appVersion=$(VERSION)

windows:
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -v -o kbot -ldflags "-X="github.com/33base/kbot/cmd.appVersion=$(VERSION)

lint:
	golint

test:
	go test -v

clean:
	docker rm $(CONTAINER_TAG)
	docker rmi $(IMAGE_TAG)
