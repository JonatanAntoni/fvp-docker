FROM ubuntu:latest

ARG FVP_VERSION=11.22.39
ARG FVP_ARCHIVE=avh-fvp-linux-${TARGETARCH}.tar.gz
ARG FVP_BASE_URL="https://artifacts.keil.arm.com/avh"
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

RUN curl -LO "${FVP_BASE_URL}/${FVP_VERSION}/${FVP_ARCHIVE}" && \
    mkdir -p /opt/avh-fvp-${FVP_VERSION} && \
    tar -xf ${FVP_ARCHIVE} --strip-components 1 -C /opt/avh-fvp-${FVP_VERSION} && \
    rm ${FVP_ARCHIVE}

RUN test ${USERID} -ne 0 && groupadd -g ${USERID} ${USERNAME} && useradd -r -u ${USERID} -g ${USERNAME} ${USERNAME}

USER ${USERNAME}

ENV PATH=$PATH:/opt/avh-fvp-${FVP_VERSION}/bin

CMD ["/bin/bash"]
