FROM hub.qucheng.com/library/debian:11.3-slim

LABEL maintainer "zhouyueqiu <zhouyueqiu@easycorp.ltd>"

ENV OS_ARCH="amd64" \
    OS_NAME="debian-11" \
    HOME_PAGE="spug.cc"

COPY debian/prebuildfs /

ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive

RUN sed -i -r 's/(deb|security).debian.org/mirrors.cloud.tencent.com/g' /etc/apt/sources.list \
    && install_packages curl wget tzdata zip unzip s6 pwgen cron nginx ca-certificates \
                        libmariadb-dev-compat gcc python3-dev python3-pip python3-venv \
                        libsasl2-dev libldap2-dev python3 sshpass rsync sshfs git \
    && ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && dpkg-reconfigure --frontend noninteractive tzdata

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
    && pip3 install --upgrade --no-cache-dir pip -i https://pypi.doubanio.com/simple/ \
    && pip3 install --no-cache-dir -i https://pypi.doubanio.com/simple/  -r requirements.txt

# Install render-template
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-10" --checksum 5e410e55497aa79a6a0c5408b69ad4247d31098bdb0853449f96197180ed65a4

# Install mysql-client
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "mysql-client" "10.5.15" -c 31182985daa1a2a959b5197b570961cdaacf3d4e58e59a192c610f8c8f1968a8

# Install wait-for-port
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.01" -c 2ad97310f0ecfbfac13480cabf3691238fdb3759289380262eb95f8660ebb8d1

# Copy nginx and spug config files
COPY debian/rootfs /

EXPOSE 80

# Persistence directory
VOLUME [ "/data"]

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
