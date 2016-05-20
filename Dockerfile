FROM alpine:3.3

MAINTAINER marcielmj <https://github.com/marcielmj>

ENV GLIBC_VERSION="2.23-r1" \
    GLIBC_DOWNLOAD_URL="https://github.com/andyshinn/alpine-pkg-glibc/releases/download" \
    GLIBC_FILENAME="glibc-${GLIBC_VERSION}.apk" \
    GLIBC_BIN_FILENAME="glibc-bin-${GLIBC_VERSION}.apk" \
    GLIBC_I18N_FILENAME="glibc-i18n-${GLIBC_VERSION}.apk" \
    LANG=C.UTF-8

RUN apk upgrade --update && \
    apk add --no-cache bash wget ca-certificates && \
    wget -q -O "/etc/apk/keys/andyshinn.rsa.pub" "https://raw.githubusercontent.com/andyshinn/alpine-pkg-glibc/master/andyshinn.rsa.pub" && \
    wget -q -O "/tmp/${GLIBC_FILENAME}" "${GLIBC_DOWNLOAD_URL}/${GLIBC_VERSION}/${GLIBC_FILENAME}" && \
    wget -q -O "/tmp/${GLIBC_BIN_FILENAME}" "${GLIBC_DOWNLOAD_URL}/${GLIBC_VERSION}/${GLIBC_BIN_FILENAME}" && \
    wget -q -O "/tmp/${GLIBC_I18N_FILENAME}" "${GLIBC_DOWNLOAD_URL}/${GLIBC_VERSION}/${GLIBC_I18N_FILENAME}" && \
    ls /tmp/ && \
    apk add --no-cache "/tmp/${GLIBC_FILENAME}" \
        "/tmp/${GLIBC_BIN_FILENAME}" \
        "/tmp/${GLIBC_I18N_FILENAME}" && \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    rm -rf "/etc/apk/keys/andyshinn.rsa.pub" "/tmp/*" "/var/cache/apk/*"
