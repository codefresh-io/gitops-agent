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

package main

import (
	"context"
	"syscall"

	"github.com/codefresh-io/gitops-agent/cmd/root"
	"github.com/codefresh-io/pkg/helpers"
	"github.com/codefresh-io/pkg/log"
	"github.com/sirupsen/logrus"
)

func main() {
	ctx := context.Background()
	lgr := log.FromLogrus(logrus.NewEntry(logrus.StandardLogger()), &log.LogrusConfig{Level: "info"})
	ctx = log.WithLogger(ctx, lgr)
	log.SetDefault(lgr)
	ctx = helpers.ContextWithCancelOnSignals(ctx, syscall.SIGINT, syscall.SIGTERM)

	cmd := root.New()
	lgr.AddPFlags(cmd)

	defer func() {
		if err := recover(); err != nil {
			log.G(ctx).Fatal(err)
		}
	}()

	helpers.Die(cmd.ExecuteContext(ctx))
}
