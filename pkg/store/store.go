package store

import (
	"fmt"
	"runtime"
)

var s Store

var (
	binaryName = "bin"
	buildDate  = ""
	version    = "v99.99.99"
	gitCommit  = ""
)

type Version struct {
	Version   string
	BuildDate string
	GitCommit string
	GoVersion string
	Platform  string
}

type Store struct {
	BinaryName string
	Version    Version
	BaseGitURL string
}

// Get returns the global store
func Get() *Store {
	return &s
}

func init() {
	s.BinaryName = binaryName

	s.Version.Version = version
	s.Version.BuildDate = buildDate
	s.Version.GitCommit = gitCommit
	s.Version.GoVersion = runtime.Version()
	s.Version.Platform = fmt.Sprintf("%s/%s", runtime.GOOS, runtime.GOARCH)
}
