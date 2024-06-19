# SPDX-License-Identifier: GPL-2.0
ARG BASE
FROM $BASE

ARG RUN_CMD

RUN apt -y update -qq && apt -y upgrade && \
	DEBIAN_FRONTEND=noninteractive apt -y install \
	--no-install-recommends --no-install-suggests \
		dirmngr \
		less \
	&& \
	apt -y clean && rm -rf /var/lib/apt/lists/* /tmp/*

COPY --chmod=0555 src/test/$RUN_CMD.sh /test.sh

WORKDIR /app
ENTRYPOINT [ "perl" ]

LABEL org.opencontainers.image.description="Perl 5 container"
