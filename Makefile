VERSION = v.1.0.1
IMAGE_TAG = $(shell docker images --format "{{.ID}}" | head -n 1)
CONTAINER_TAG = $(shell docker ps -l -q)
APP = $(shell basename $(shell git remote get-url origin))
TARGETOS = linux
REGISTRY = 33base
TARGETARC = arm64

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

image:
	docker build -t $(REGISTRY)/$(APP):$(VERSION)-$(TARGETARC) .

push:
	docker push $(REGISTRY)/$(APP):$(VERSION)-$(TARGETARC)

clean:
#	docker rm $(CONTAINER_TAG)
	docker rmi $(REGISTRY)/$(APP):$(VERSION)-$(TARGETARC)
	
