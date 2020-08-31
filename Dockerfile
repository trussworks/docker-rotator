
# CircleCI docker image to run within
FROM cimg/base:stable
# Base image uses "circleci", to avoid using `sudo` run as root user
USER root

# install awscliv2, disable default pager (less)
ENV AWS_PAGER=""
ARG AWSCLI_VERSION=2.0.37
COPY sigs/awscliv2_pgp.key /tmp/awscliv2_pgp.key
RUN gpg --import /tmp/awscliv2_pgp.key
RUN set -ex && cd ~ \
    && curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip" -o awscliv2.zip \
    && curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip.sig" -o awscliv2.sig \
    && gpg --verify awscliv2.sig awscliv2.zip \
    && unzip awscliv2.zip \
    && ./aws/install --update \
    && aws --version \
    && rm -r awscliv2.zip awscliv2.sig aws

# install aws-nuke
ARG ROTATOR_VERSION=0.5.6
ARG ROTATOR_SHA256SUM=06db6d636b7419ae46c92c83c58e73b247686321163dd78bf55481c184f1dee6
RUN set -ex && cd ~ \
    && curl -sSLO https://github.com/chanzuckerberg/rotator/releases/download/v${ROTATOR_VERSION}/rotator_${ROTATOR_VERSION}_linux_amd64.tar.gz \
    && [ $(sha256sum rotator_${ROTATOR_VERSION}_linux_amd64.tar.gz | cut -f1 -d' ') = ${ROTATOR_SHA256SUM} ] \
    && tar xzf rotator_${ROTATOR_VERSION}_linux_amd64.tar.gz \
    && mv rotator /usr/local/bin \
    && rm -rf rotator_${ROTATOR_VERSION}_linux_amd64.tar.gz


# apt-get all the things
# Notes:
# - Add all apt sources first
# - groff and less required by AWS CLI
ARG CACHE_APT
RUN set -ex && cd ~ \
    && apt-get update \
    && : Install apt packages \
    && apt-get -qq -y install --no-install-recommends apt-transport-https less groff lsb-release \
    && : Cleanup \
    && apt-get clean \
    && rm -vrf /var/lib/apt/lists/*

USER circleci