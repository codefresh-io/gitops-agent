#!/bin/sh

go build -ldflags=" \
    -X 'github.com/codefresh-io/go-template/pkg/store.binaryName=${BIN_NAME}' \
    -X 'github.com/codefresh-io/go-template/pkg/store.version=${VERSION}' \
    -X 'github.com/codefresh-io/go-template/pkg/store.gitCommit=${GIT_COMMIT}'" \
    -v -o ${OUT_DIR}/${BIN_NAME} .