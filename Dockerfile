# ---------- Stage 1: Download and extract SeaweedFS ----------
FROM alpine:3.20 AS seaweedfs-download

ARG SEAWEEDFS_VERSION
ARG TARGETARCH=amd64

ENV SEAWEEDFS_VERSION=${SEAWEEDFS_VERSION}
ENV TARGETARCH=${TARGETARCH}
ENV SEAWEEDFS_DIR=/seaweedfs

RUN apk add --no-cache ca-certificates wget tar

RUN case "${TARGETARCH}" in \
        amd64) SEAWEEDFS_ARCH="amd64" ;; \
        arm64) SEAWEEDFS_ARCH="arm64" ;; \
        arm) SEAWEEDFS_ARCH="arm" ;; \
        *) echo "unsupported target architecture: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    wget -qO- "https://github.com/seaweedfs/seaweedfs/releases/download/${SEAWEEDFS_VERSION}/linux_${SEAWEEDFS_ARCH}.tar.gz" \
    | tar -xz -C /tmp && \
    mkdir -p "${SEAWEEDFS_DIR}/bin" && \
    mv /tmp/weed "${SEAWEEDFS_DIR}/bin/weed" && \
    chmod +x "${SEAWEEDFS_DIR}/bin/weed"

# ---------- Stage 2: Final image ----------
FROM cgr.dev/usace-cwbi/chainguard-base-fips:latest

ENV SEAWEEDFS_DIR=/seaweedfs
ENV PATH="${SEAWEEDFS_DIR}/bin:${PATH}"

COPY --from=seaweedfs-download ${SEAWEEDFS_DIR} ${SEAWEEDFS_DIR}

WORKDIR /data
ENTRYPOINT ["weed"]
