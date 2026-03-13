FROM scratch AS ctx

COPY build_files /build
COPY system_files /files

FROM quay.io/fedora/fedora-bootc:43
LABEL ostree.bootable=true
LABEL org.opencontainers.image.source=https://github.com/zpeppler/electrumos

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=tmpfs,dst=/run \
    --mount=type=bind,from=ctx,source=/boot,target=/boot \
    --mount=type=cache,dst=/var/cache/libdnf5/ \
    /ctx/build/00-base-pre.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=tmpfs,dst=/boot \
    --mount=type=tmpfs,dst=/run \
    --mount=type=cache,dst=/var/cache/libdnf5/ \
    /ctx/build/00-base.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=tmpfs,dst=/boot \
    --mount=type=tmpfs,dst=/run \
    --mount=type=cache,dst=/var/cache/libdnf5/ \
    /ctx/build/01-git-bins.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    --mount=type=tmpfs,dst=/boot \
    --mount=type=tmpfs,dst=/run \
    --network=none \
    /ctx/build/02-setup.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    /ctx/build/99-cleanup.sh

RUN bootc container lint