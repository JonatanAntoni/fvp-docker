FROM ubuntu:latest

ARG FVP_VERSION=11.21
ARG ARTIFACTORY_URL=artifactory.eu02.arm.com
ARG ARTIFACTORY_API_KEY

RUN apt-get update && apt-get install -y \
        curl \
        libatomic1 \
    && rm -rf /var/lib/apt/lists/*

RUN curl -H "X-JFrog-Art-Api:${ARTIFACTORY_API_KEY}" -O https://${ARTIFACTORY_URL}/artifactory/mcu.depot/ci/depot/fvp-${FVP_VERSION}-linux-x86_64.tar.gz && \
    mkdir -p /opt/fvp-${FVP_VERSION} && \
    tar -xf fvp-${FVP_VERSION}-linux-x86_64.tar.gz -C /opt/fvp-${FVP_VERSION} && \
    /opt/fvp-${FVP_VERSION}/armlm activate --server https://lls.arm.com --product HWSKT-EAC0 && \
    rm fvp-${FVP_VERSION}-linux-x86_64.tar.gz

ENV PATH=$PATH:/opt/fvp-${FVP_VERSION}
ENV LD_LIBRARY_PATH=/opt/fvp-${FVP_VERSION}

CMD ["/bin/bash"]
