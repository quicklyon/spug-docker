FROM debian:11.8-slim

LABEL maintainer "zhouyueqiu <zhouyueqiu@easycorp.ltd>"

ENV OS_ARCH="amd64" \
    OS_NAME="debian-11" \
    HOME_PAGE="spug.cc"

COPY debian/prebuildfs /

ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive

RUN install_packages curl wget zip unzip s6 pwgen cron nginx ca-certificates \
                     libmariadb-dev-compat gcc python3-dev python3-pip python3-venv \
                     libsasl2-dev libldap2-dev python3 sshpass rsync sshfs git pkg-config

ARG VERSION
ENV APP_VER=${VERSION}
ENV EASYSOFT_APP_NAME="Spug $APP_VER"

WORKDIR /apps/spug
RUN mkdir tmp \
    && curl -sL https://github.com/openspug/spug/releases/download/v${APP_VER}/web_v${APP_VER}.tar.gz | tar xvz -C tmp \
    && mv tmp/build web \
    && curl -sL https://github.com/openspug/spug/archive/refs/tags/v${APP_VER}.tar.gz | tar xvz -C tmp \
    && mv tmp/spug-${APP_VER}/spug_api api \
    && rm -rf tmp \
    && cd api \
    # Add gunicorn and mysqlclient to requirements.txt
    && sed -i "1i gunicorn\nmysqlclient\n" requirements.txt \
    && pip3 install --upgrade --no-cache-dir pip -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com \
    && pip3 install --no-cache-dir -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com -r requirements.txt

# Install render-template
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-10" --checksum 5e410e55497aa79a6a0c5408b69ad4247d31098bdb0853449f96197180ed65a4

# Install mysql-client
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "mysql-client" "10.5.15-20220817" -c c4f82cb5b66724dd608f0bafaac400fc0d15528599e8b42be5afe8cedfd16488

# Install wait-for-port
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.01" -c 2ad97310f0ecfbfac13480cabf3691238fdb3759289380262eb95f8660ebb8d1

# Copy nginx and spug config files
COPY debian/rootfs /

EXPOSE 80

# Persistence directory
VOLUME [ "/data"]

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
