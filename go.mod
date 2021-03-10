module github.com/codefresh-io/gitops-agent

go 1.15

require (
	github.com/codefresh-io/pkg/helpers v0.0.2
	github.com/codefresh-io/pkg/log v0.0.2
	github.com/go-openapi/runtime v0.19.26
	github.com/grpc-ecosystem/go-grpc-middleware v1.0.0
	github.com/grpc-ecosystem/go-grpc-prometheus v1.2.0
	github.com/grpc-ecosystem/grpc-gateway/v2 v2.3.0
	github.com/magefile/mage v1.11.0 // indirect
	github.com/sirupsen/logrus v1.8.0
	github.com/soheilhy/cmux v0.1.4
	github.com/spf13/cobra v1.1.3
	golang.org/x/net v0.0.0-20210226172049-e18ecbb05110 // indirect
	golang.org/x/sys v0.0.0-20210304152209-afaa3650a925 // indirect
	google.golang.org/genproto v0.0.0-20210303154014-9728d6b83eeb
	google.golang.org/grpc v1.36.0
	google.golang.org/grpc/cmd/protoc-gen-go-grpc v1.1.0
	google.golang.org/grpc/examples v0.0.0-20210309220351-d5b628860d4e // indirect
	google.golang.org/protobuf v1.25.1-0.20201208041424-160c7477e0e8
	k8s.io/apimachinery v0.20.4
)
