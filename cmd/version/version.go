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

package version

import (
	"github.com/codefresh-io/gitops-agent/pkg/store"
	"github.com/codefresh-io/pkg/log"
	"github.com/spf13/cobra"
)

type options struct {
	long bool
}

func New() *cobra.Command {
	var opts options

	cmd := &cobra.Command{
		Use:   "version",
		Short: "show version",
		Run: func(cmd *cobra.Command, args []string) {
			showVersion(&opts)
		},
	}

	cmd.Flags().BoolVar(&opts.long, "long", false, "display full version information")

	return cmd
}

func showVersion(opts *options) {
	version := store.Get().Version

	if opts.long {
		log.G().Printf("Version: %s", version.Version)
		log.G().Printf("BuildDate: %s", version.BuildDate)
		log.G().Printf("GitCommit: %s", version.GitCommit)
		log.G().Printf("GoVersion: %s", version.GoVersion)
		log.G().Printf("Platform: %s", version.Platform)
	} else {
		log.G().Printf("%s", version.Version)
	}
}
