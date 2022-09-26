# SPDX-License-Identifier: GPL-2.0

ORG_NAME := hihg-um
PROJECT_NAME ?= perl
OS_BASE ?= ubuntu
OS_VER ?= 22.04

USER ?= `whoami`
USERID ?= `id -u`
USERGID ?= `id -g`

IMAGE_REPOSITORY :=
IMAGE := $(ORG_NAME)/$(USER)/$(PROJECT_NAME):latest
# Use this for debugging builds. Turn off for a more slick build log
DOCKER_BUILD_ARGS := --progress=plain

.PHONY: all build clean docker test tests

all: docker test

test:
		@docker run -it $(IMAGE) -v

clean:
	@docker rmi $(IMAGE)

docker:
	@docker build -t $(IMAGE) \
		$(DOCKER_BUILD_ARGS) \
		--build-arg BASE_IMAGE=$(OS_BASE):$(OS_VER) \
		--build-arg USERNAME=$(USER) \
		--build-arg USERID=$(USERID) \
		--build-arg USERGID=$(USERGID) \
		.

release:
	docker push $(IMAGE_REPOSITORY)/$(IMAGE)
