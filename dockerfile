FROM ubuntu:latest

ARG FVP_VERSION=11.22
ARG ARTIFACTORY_URL=artifactory.eu02.arm.com
ARG ARTIFACTORY_API_KEY
ARG USERNAME=root
ARG USERID=0

ARG DEBIAN_FRONTEND=noninteractive

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y \
        curl \        
        jq \
        libatomic1 \
        software-properties-common

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get install -y --no-install-recommends libpython3.9

ARG FVP_ARCHIVE=fvp-${FVP_VERSION}-linux-x86_64.tar.gz
ARG VHT_ARCHIVE=vht-${FVP_VERSION}-linux-x86_64.tar.gz
ARG ARTIFACTORY_CACHE_DIR=/var/cache/artifactory

RUN --mount=type=cache,target=${ARTIFACTORY_CACHE_DIR},sharing=locked \
    cd ${ARTIFACTORY_CACHE_DIR} && \
    if [ -f ${FVP_ARCHIVE} ]; then \
        CHECKSUM=$(curl -s -H "X-JFrog-Art-Api:${ARTIFACTORY_API_KEY}" "https://${ARTIFACTORY_URL}/artifactory/api/storage/mcu.depot/ci/depot/${FVP_ARCHIVE}" | jq -r '.checksums.sha256'); \
        echo "${CHECKSUM} ${FVP_ARCHIVE}" | sha256sum -c --status || rm ${FVP_ARCHIVE}; \
    fi && \
    test -f ${FVP_ARCHIVE} || \
        curl -H "X-JFrog-Art-Api:${ARTIFACTORY_API_KEY}" -O https://${ARTIFACTORY_URL}/artifactory/mcu.depot/ci/depot/${FVP_ARCHIVE} && \
    mkdir -p /opt/fvp-${FVP_VERSION} && \
    tar -xvf ${FVP_ARCHIVE} -C /opt/fvp-${FVP_VERSION} && \
    chown -R root:root /opt/fvp-${FVP_VERSION} && \
    chmod 0755 /opt/fvp-${FVP_VERSION} 

RUN --mount=type=cache,target=${ARTIFACTORY_CACHE_DIR},sharing=locked \
    cd ${ARTIFACTORY_CACHE_DIR} && \
    if [ -f ${VHT_ARCHIVE} ]; then \
        CHECKSUM=$(curl -s -H "X-JFrog-Art-Api:${ARTIFACTORY_API_KEY}" "https://${ARTIFACTORY_URL}/artifactory/api/storage/mcu.depot/ci/depot/${VHT_ARCHIVE}" | jq -r '.checksums.sha256'); \
        echo "${CHECKSUM} ${VHT_ARCHIVE}" | sha256sum -c --status || rm ${VHT_ARCHIVE}; \
    fi && \
    test -f ${VHT_ARCHIVE} || \
        curl -H "X-JFrog-Art-Api:${ARTIFACTORY_API_KEY}" -O https://${ARTIFACTORY_URL}/artifactory/mcu.depot/ci/depot/${VHT_ARCHIVE} && \
    mkdir -p /opt/vht-${FVP_VERSION} && \
    tar -xvf ${VHT_ARCHIVE} -C /opt/vht-${FVP_VERSION} && \
    chown -R root:root /opt/vht-${FVP_VERSION} && \
    chmod 0755 /opt/vht-${FVP_VERSION} 

RUN test ${USERID} -ne 0 && groupadd -g ${USERID} ${USERNAME} && useradd -r -u ${USERID} -g ${USERNAME} ${USERNAME}

USER ${USERNAME}

ENV PATH=$PATH:/opt/fvp-${FVP_VERSION}:/opt/vht-${FVP_VERSION}
ENV LD_LIBRARY_PATH=/opt/fvp-${FVP_VERSION}:/opt/vht-${FVP_VERSION}

CMD ["/bin/bash"]
