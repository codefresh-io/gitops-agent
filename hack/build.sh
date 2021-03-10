#!/bin/sh

go build -ldflags=" \
    -X 'github.com/codefresh-io/gitops-agent/pkg/store.binaryName=${BIN_NAME}' \
    -X 'github.com/codefresh-io/gitops-agent/pkg/store.version=${VERSION}' \
    -X 'github.com/codefresh-io/gitops-agent/pkg/store.buildDate=${BUILD_DATE}' \
    -X 'github.com/codefresh-io/gitops-agent/pkg/store.gitCommit=${GIT_COMMIT}'" \
    -v -o ${OUT_DIR}/${BIN_NAME} .