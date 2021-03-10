# change these:
VERSION=v0.0.1
BIN_NAME=gitops-agent
BUILD_DATE=$(shell date -u +'%Y-%m-%dT%H:%M:%SZ')

OUT_DIR=dist
GIT_COMMIT=$(shell git rev-parse HEAD)

ifndef GOPATH
$(error GOPATH is not set, please make sure you set your GOPATH correctly!)
endif

.PHONY: build
build:
	@ # add more stuff you want to be compiled with your binary
	@ OUT_DIR=$(OUT_DIR) \
		BIN_NAME=$(BIN_NAME) \
		VERSION=$(VERSION) \
		BUILD_DATE=$(BUILD_DATE) \
		GIT_COMMIT=$(GIT_COMMIT) \
		./hack/build.sh

.PHONY: install
install: build
	@rm /usr/local/bin/$(BIN_NAME) || true
	@ln -s $(shell pwd)/$(OUT_DIR)/$(BIN_NAME) /usr/local/bin/$(BIN_NAME)

.PHONY: image
image: IMAGE_NAME=codefresh-io/$(BIN_NAME):$(VERSION)
image:
	docker build \
		--build-arg BIN_NAME=$(BIN_NAME) \
		--build-arg OUT_DIR=$(OUT_DIR) \
		-t $(IMAGE_NAME) .
	docker run --rm -it $(IMAGE_NAME) version

.PHONY: lint
lint: $(GOPATH)/bin/golangci-lint
	@go mod tidy
	@echo linting go code...
	@golangci-lint run --fix --timeout 3m

.PHONY: test
test:
	./hack/test.sh

.PHONY: codegen 
codegen: $(GOPATH)/bin/mockery $(GOPATH)/bin/kitgen gen-protos
	go generate ./...

.PHONY: gen-protos
gen-protos: $(GOPATH)/bin/buf
	BIN_NAME=$(BIN_NAME) \
	VERSION=$(VERSION) \
	./hack/proto_generate.sh

.PHONY: pre-commit
pre-commit: lint build codegen test

.PHONY: clean
clean:
	@rm -rf dist || true
	@rm -rf vendor || true

$(GOPATH)/bin/mockery:
	@curl -L -o dist/mockery.tar.gz -- https://github.com/vektra/mockery/releases/download/v1.1.1/mockery_1.1.1_$(shell uname -s)_$(shell uname -m).tar.gz
	@tar zxvf dist/mockery.tar.gz mockery
	@chmod +x mockery
	@mkdir -p $(GOPATH)/bin
	@mv mockery $(GOPATH)/bin/mockery
	@mockery -version

$(GOPATH)/bin/golangci-lint:
	@curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b `go env GOPATH`/bin v1.36.0

$(GOPATH)/bin/buf: $(GOPATH)/bin/protoc-gen-grpc-gateway $(GOPATH)/bin/protoc-gen-openapiv2 $(GOPATH)/bin/protoc-gen-gogofast $(GOPATH)/bin/protoc-gen-go-grpc
	$(eval BUF_TMP := $(shell mktemp -d))
	cd $(BUF_TMP); GO111MODULE=on go get github.com/bufbuild/buf/cmd/buf@v0.39.1
	@rm -rf $(BUF_TMP)

$(GOPATH)/bin/protoc-gen-grpc-gateway:
	go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway

$(GOPATH)/bin/protoc-gen-openapiv2:
	go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2

$(GOPATH)/bin/protoc-gen-gogofast:
	go install github.com/gogo/protobuf/protoc-gen-gogofast

$(GOPATH)/bin/protoc-gen-go-grpc:
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc
