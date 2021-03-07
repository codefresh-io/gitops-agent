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
		log.G().Printf("GitCommit: %s", version.GitCommit)
		log.G().Printf("GoVersion: %s", version.GoVersion)
		log.G().Printf("Platform: %s", version.Platform)
	} else {
		log.G().Printf("%s", version.Version)
	}
}
