package manifests

import (
	"context"

	v1 "github.com/codefresh-io/gitops-agent/pkg/apis/manifest/v1"
)

type Server struct {
	v1.UnimplementedManifestServiceServer
}

func (s *Server) Add(context.Context, *v1.AddRequest) (*v1.AddResponse, error) {
	return &v1.AddResponse{
		Path: "/foo/bar",
	}, nil
}
