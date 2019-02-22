FROM openjdk:8-jdk-alpine

ENV KM_VERSION=1.3.3.22 KM_CONFIGFILE="conf/application.conf"

RUN \
    apk add --no-cache git unzip bash wget && \
    mkdir -p /tmp && \
    cd /tmp && \
    git clone --branch ${KM_VERSION} https://github.com/yahoo/kafka-manager && \
    cd /tmp/kafka-manager && \
    ./sbt clean dist && \
    unzip  -d / ./target/universal/kafka-manager-${KM_VERSION}.zip && \
    printf '#!/bin/sh\nexec ./bin/kafka-manager -Dconfig.file=${KM_CONFIGFILE} "${KM_ARGS}" "${@}"\n' > /kafka-manager-${KM_VERSION}/km.sh && \
    chmod +x /kafka-manager-${KM_VERSION}/km.sh && \
    apk del git unzip wget && \
    rm -fr /tmp/* /root/.sbt /root/.ivy2 /var/cache/apk/*

WORKDIR /kafka-manager-${KM_VERSION}

EXPOSE 9000
ENTRYPOINT ["./km.sh"]
