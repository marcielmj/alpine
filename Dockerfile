FROM alpine:3.5

MAINTAINER marcielmj <https://github.com/marcielmj>

ENV GLIBC_VERSION="2.25-r0"

ENV GLIBC_DOWNLOAD_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download"
ENV GLIBC_FILENAME="glibc-${GLIBC_VERSION}.apk"
ENV GLIBC_BIN_FILENAME="glibc-bin-${GLIBC_VERSION}.apk"
ENV GLIBC_I18N_FILENAME="glibc-i18n-${GLIBC_VERSION}.apk"

ENV LANG=C.UTF-8

RUN apk upgrade --update && \
    apk add --no-cache bash wget ca-certificates && \
    wget -q -O "/etc/apk/keys/sgerrand.rsa.pub" "https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub" && \
    wget -q -O "/tmp/${GLIBC_FILENAME}" "${GLIBC_DOWNLOAD_URL}/${GLIBC_VERSION}/${GLIBC_FILENAME}" && \
    wget -q -O "/tmp/${GLIBC_BIN_FILENAME}" "${GLIBC_DOWNLOAD_URL}/${GLIBC_VERSION}/${GLIBC_BIN_FILENAME}" && \
    wget -q -O "/tmp/${GLIBC_I18N_FILENAME}" "${GLIBC_DOWNLOAD_URL}/${GLIBC_VERSION}/${GLIBC_I18N_FILENAME}" && \
    apk add --no-cache "/tmp/${GLIBC_FILENAME}" "/tmp/${GLIBC_BIN_FILENAME}" "/tmp/${GLIBC_I18N_FILENAME}" && \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    mkdir -p /opt/ && \
    rm -rf /etc/apk/keys/sgerrand.rsa.pub /tmp/* /var/cache/apk/*
