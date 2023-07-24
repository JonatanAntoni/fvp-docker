FROM ubuntu:latest

ARG FVP_VERSION=11.22
ARG ARTIFACTORY_URL=artifactory.eu02.arm.com
ARG ARTIFACTORY_API_KEY
ARG USERNAME=root
ARG USERID=0

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y \
        curl \
        jq \
        libatomic1 \
        xterm

ARG FVP_ARCHIVE=fvp-${FVP_VERSION}-linux-x86_64.tar.gz
ARG ARTIFACTORY_CACHE_DIR=/var/cache/artifactory

RUN --mount=type=cache,target=${ARTIFACTORY_CACHE_DIR},sharing=locked \
    cd ${ARTIFACTORY_CACHE_DIR} && \
    if [ -f ${FVP_ARCHIVE} ]; then \
        CHECKSUM=$(curl -s -H "X-JFrog-Art-Api:${ARTIFACTORY_API_KEY}" https://${ARTIFACTORY_URL}/artifactory/api/storage/mcu.depot/ci/depot/${FVP_ARCHIVE} | jq -r '.checksums.sha256') \
        echo "${CHECKSUM} ${FVP_ARCHIVE}" | sha256sum -c --status || rm ${FVP_ARCHIVE}; \
    fi && \
    test -f ${FVP_ARCHIVE} || \
        curl -H "X-JFrog-Art-Api:${ARTIFACTORY_API_KEY}" -O https://${ARTIFACTORY_URL}/artifactory/mcu.depot/ci/depot/${FVP_ARCHIVE} && \
    mkdir -p /opt/fvp-${FVP_VERSION} && \
    tar -xf ${FVP_ARCHIVE} -C /opt/fvp-${FVP_VERSION} && \
    chown -R root:root /opt/fvp-${FVP_VERSION} && \
    chmod 0755 /opt/fvp-${FVP_VERSION} && \
    cd /opt/fvp-${FVP_VERSION} && \
    for model in $(find . -name "FVP_MPS2_*"); do ln -s ${model} "VHT_${model##./FVP_}"; done && \
    ln -s FVP_Corstone_SSE-300_Ethos-U55 VHT_Corstone_SSE-300

RUN test ${USERID} -ne 0 && groupadd -g ${USERID} ${USERNAME} && useradd -r -u ${USERID} -g ${USERNAME} ${USERNAME}

USER ${USERNAME}

ENV PATH=$PATH:/opt/fvp-${FVP_VERSION}
ENV LD_LIBRARY_PATH=/opt/fvp-${FVP_VERSION}

CMD ["/bin/bash"]
