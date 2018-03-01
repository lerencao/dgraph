GOPATH ?= $(shell go env GOPATH)

# Ensure GOPATH is set before running build process.
ifeq "$(GOPATH)" ""
  $(error Please set the environment variable GOPATH before running `make`)
endif

CURDIR := $(shell pwd)
path_to_add := $(addsuffix /bin,$(subst :,/bin:,$(GOPATH)))
export PATH := $(path_to_add):$(PATH)

GO        := go
GOBUILD   := $(GO) build $(BUILD_FLAG)
GOTEST    := $(GO) test -p 3
GOVERALLS := goveralls

ARCH      := "`uname -s`"
LINUX     := "Linux"
MAC       := "Darwin"
#PACKAGES  := $$(go list ./...| grep -vE "vendor|contrib|wiki")
#FILES     := $$(find . -name "*.go" | grep -vE "vendor|contrib|wiki")
#TOPDIRS   := $$(ls -d */ | grep -vE "vendor|contrib|wiki")

LDFLAGS += -X "github.com/dgraph-io/dgraph/x.dgraphVersion=$(shell git describe --tags --dirty)"
LDFLAGS += -X "github.com/dgraph-io/dgraph/x.gitBranch=$(shell git rev-parse --abbrev-ref HEAD)"
LDFLAGS += -X "github.com/dgraph-io/dgraph/x.lastCommitSHA=$(shell git rev-parse HEAD)"
LDFLAGS += -X "github.com/dgraph-io/dgraph/x.lastCommitTime=$(shell git show -s --format=%ci)"
LDFLAGS += -X "github.com/dgraph-io/dgraph/dgraph/cmd/bluk.MaxThreads=50000"

default: build

TARGET=""
build:
ifeq ($(TARGET), "")
	$(GOBUILD) -ldflags '$(LDFLAGS)' -o bin/dgraph dgraph/main.go
else
	$(GOBUILD) -ldflags '$(LDFLAGS)' -o '$(TARGET)' dgraph/main.go
endif
