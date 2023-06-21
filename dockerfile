FROM ubuntu:latest

ARG FVP_VERSION=11.21
ARG ARTIFACTORY_URL=artifactory.eu02.arm.com
ARG ARTIFACTORY_API_KEY
ARG USERNAME=root
ARG USERID=0

RUN apt-get update && apt-get install -y \
        curl \
        libatomic1 \
    && rm -rf /var/lib/apt/lists/*

RUN curl -H "X-JFrog-Art-Api:${ARTIFACTORY_API_KEY}" -O https://${ARTIFACTORY_URL}/artifactory/mcu.depot/ci/depot/fvp-${FVP_VERSION}-linux-x86_64.tar.gz && \
    mkdir -p /opt/fvp-${FVP_VERSION} && \
    tar -xf fvp-${FVP_VERSION}-linux-x86_64.tar.gz -C /opt/fvp-${FVP_VERSION} && \
    chown -R root:root /opt/fvp-${FVP_VERSION} && \
    chmod 0755 /opt/fvp-${FVP_VERSION} && \
    rm fvp-${FVP_VERSION}-linux-x86_64.tar.gz

RUN test ${USERID} -ne 0 && groupadd -g ${USERID} ${USERNAME} && useradd -r -u ${USERID} -g ${USERNAME} ${USERNAME}

USER ${USERNAME}

ENV PATH=$PATH:/opt/fvp-${FVP_VERSION}
ENV LD_LIBRARY_PATH=/opt/fvp-${FVP_VERSION}

CMD ["/bin/bash"]
