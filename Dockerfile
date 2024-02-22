# SPDX-License-Identifier: GPL-2.0
ARG BASE_IMAGE
FROM $BASE_IMAGE as base

# Install OS updates, security fixes and utils
RUN apt -y update -qq && apt -y upgrade && \
	DEBIAN_FRONTEND=noninteractive apt -y install \
		ca-certificates \
		curl \
		dirmngr \
		less \
		perl strace tabix wget

WORKDIR /app
ENTRYPOINT [ "perl" ]

FROM base as perl

RUN DEBIAN_FRONTEND=noninteractive apt -y install \
		libbio-db-hts-perl libmemory-usage-perl
