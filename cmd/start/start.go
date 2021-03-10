package start

import (
	"github.com/spf13/cobra"

	"github.com/codefresh-io/gitops-agent/server"
)

type options struct {
	port int
}

func New() *cobra.Command {
	var opts options

	cmd := &cobra.Command{
		Use:   "start",
		Short: "start the gitops-agent",
		Run: func(cmd *cobra.Command, args []string) {
			start(cmd, &opts)
		},
	}

	cmd.Flags().IntVar(&opts.port, "port", 8086, "server listen port")

	return cmd
}

func start(cmd *cobra.Command, opts *options) {
	server.NewOrDie(cmd.Context(), &server.Options{
		Port: opts.port,
	}).Run()
}
