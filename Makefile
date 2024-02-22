# SPDX-License-Identifier: GPL-2.0

ORG_NAME ?= hihg-um
OS_BASE ?= ubuntu
OS_VER ?= 22.04

IMAGE_REPOSITORY :=

TOOLS :=

DOCKER_BUILD_ARGS :=
DOCKER_TAG ?= $(shell git describe --tags --broken --dirty --all --long | \
		sed "s,heads/,," | sed "s,tags/,," | \
		sed "s,remotes/pull/.*/,," \
		)_$(shell uname -m)_$(shell uname -s | \
		tr '[:upper:]' '[:lower:]')
DOCKER_BASE ?= $(patsubst docker-%,%,$(shell basename \
		`git remote --verbose | grep origin | grep fetch | \
		cut -f2 | cut -d ' ' -f1` | sed 's/.git//'))
DOCKER_IMAGES := $(TOOLS:=\:$(DOCKER_TAG))
SIF_IMAGES := $(TOOLS:=_$(DOCKER_TAG).sif)

IMAGE_TEST := /test.sh

.PHONY: apptainer_clean apptainer_test \
	docker_base docker_clean docker_test docker_release $(TOOLS)

help:
	@echo "Targets: all build clean test release"
	@echo "         docker docker_base docker_clean docker_test docker_release"
	@echo "         apptainer apptainer_clean apptainer_test"
	@echo
	@echo "Docker container(s):"
	@for f in $(DOCKER_IMAGES); do \
		printf "\t$$f\n"; \
	done
	@echo
	@echo "Apptainer(s):"
	@for f in $(SIF_IMAGES); do \
		printf "\t$$f\n"; \
	done
	@echo

all: clean build test

build: docker apptainer

clean: apptainer_clean docker_clean

release: docker_release

test: docker_test apptainer_test

docker: docker_base $(TOOLS)

test_docker:
	@echo "Testing docker image: $(IMAGE)"
	@docker run -it -v /mnt:/mnt $(IMAGE) -v

test_singularity: $(PROJECT_NAME).sif
	@echo "Testing singularity image: $(PROJECT_NAME).sif"
	@singularity run $(PROJECT_NAME).sif -v

clean:
	@docker rmi -f --no-prune $(IMAGE)
	@rm -f $(PROJECT_NAME).sif

docker:
	@docker build -t $(IMAGE) \
		$(DOCKER_BUILD_ARGS) \
		--target perl-libbio-db-hts-perl \
		--build-arg BASE_IMAGE=$(OS_BASE):$(OS_VER) \
		.

$(PROJECT_NAME).sif:
	@singularity build $(PROJECT_NAME).sif docker-daemon:$(IMAGE)

release:
	docker push $(IMAGE_REPOSITORY)/$(IMAGE)
