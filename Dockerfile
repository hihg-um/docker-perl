ARG BASE_IMAGE
FROM $BASE_IMAGE as base

# SPDX-License-Identifier: GPL-2.0

# user data provided by the host system via the make file
# without these, the container will fail-safe and be unable to write output
ARG USERNAME
ARG USERID
ARG USERGNAME
ARG USERGID

# Put the user name and ID into the ENV, so the runtime inherits them
ENV USERNAME=${USERNAME:-nouser} \
	USERID=${USERID:-65533} \
	USERGNAME=${USERGNAME:-users} \
	USERGID=${USERGID:-nogroup}

# match the building user. This will allow output only where the building
# user has write permissions
RUN groupadd -g $USERGID $USERGNAME && \
        useradd -m -u $USERID -g $USERGID -g "users" $USERNAME && \
        adduser $USERNAME $USERGNAME

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
# we map the user owning the image so permissions for input/output will work
USER $USERNAME

FROM base as perl-libbio-db-hts-perl

RUN DEBIAN_FRONTEND=noninteractive apt -y install \
		libbio-db-hts-perl libmemory-usage-perl

USER $USERNAME
