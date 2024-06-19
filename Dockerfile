# SPDX-License-Identifier: GPL-2.0
ARG BASE
FROM $BASE

# Install OS updates, security fixes and utils
RUN apt -y update -qq && apt -y upgrade && \
	DEBIAN_FRONTEND=noninteractive apt -y install \
	--no-install-recommends --no-install-suggests \
		ca-certificates \
		perl \
	&& \
	apt -y clean && rm -rf /var/lib/apt/lists/* /tmp/*

LABEL org.opencontainers.image.description="Perl 5 common base container"
