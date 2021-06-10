// Copyright 2021 The Codefresh Authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package server

import (
	"context"
	"fmt"
	"net"
	"net/http"

	"k8s.io/apimachinery/pkg/util/wait"

	"github.com/codefresh-io/pkg/log"
)

type Server struct {
	Options

	log        log.Logger
	httpServer *http.Server
	stopChan   <-chan struct{}
}

type Options struct {
	Port                     int
	AccessControlAllowOrigin string
}

func NewOrDie(ctx context.Context, opts *Options) *Server {
	if opts == nil {
		panic(fmt.Errorf("nil options"))
	}

	s := &Server{
		Options:  *opts,
		log:      log.G(ctx),
		stopChan: ctx.Done(),
	}

	s.httpServer = s.newHTTPServer(ctx)

	return s
}

func (s *Server) Run() {
	var (
		lis       net.Listener
		listerErr error
	)

	// Start listener
	address := fmt.Sprintf(":%d", s.Port)

	err := wait.ExponentialBackoff(defaultBackoff, func() (bool, error) {
		lis, listerErr = net.Listen("tcp", address)
		if listerErr != nil {
			s.log.Warnf("failed to listen: %v", listerErr)
			return false, nil
		}
		return true, nil
	})
	if err != nil {
		s.log.Fatalf("failed to create listener: %s", err)
	}

	s.log.WithField("address", address).Info("handling grpc and http requests")

	go func() { s.checkServerErr(s.httpServer.Serve(lis)) }()

	<-s.stopChan
}

func (s *Server) newHTTPServer(ctx context.Context) *http.Server {
	addr := fmt.Sprintf(":%d", s.Port)
	mux := http.NewServeMux()

	return &http.Server{Addr: addr, Handler: mux}
}

func (s *Server) checkServerErr(err error) {
	if err != nil {
		open := false
		select {
		case _, open = <-s.stopChan:
		default:
		}

		if open {
			s.log.Fatalf("server listen error: %s", err)
		}

		s.log.Infof("graceful shutdown: %v", err)
	}
}
