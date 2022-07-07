ARG BASE_IMAGE
FROM $BASE_IMAGE

# SPDX-License-Identifier: GPL-2.0

# user data provided by the host system via the make file
# without these, the container will fail-safe and be unable to write output
ARG USERNAME
ARG USERID
ARG USERGID

# Put the user name and ID into the ENV, so the runtime inherits them
ENV USERNAME=${USERNAME:-nouser} \
        USERID=${USERID:-65533} \
        USERGID=${USERGID:-nogroup}

# match the building user. This will allow output only where the building
# user has write permissions
RUN useradd -m -u $USERID -g $USERGID $USERNAME

# Install OS updates, security fixes and utils
RUN apt -y update -qq && apt -y upgrade && \
	DEBIAN_FRONTEND=noninteractive apt -y install \
		ca-certificates \
		curl \
		dirmngr \
		less \
		perl \
		strace wget

# we map the user owning the image so permissions for input/output will work
USER $USERNAME

ENTRYPOINT [ "perl" ]
