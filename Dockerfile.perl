# SPDX-License-Identifier: GPL-2.0
ARG BASE_IMAGE
FROM $BASE_IMAGE

LABEL org.opencontainers.image.description="Perl 5 container"

ARG RUN_CMD

ARG TEST="/test.sh"
COPY --chmod=0555 src/test/$RUN_CMD.sh ${TEST}
