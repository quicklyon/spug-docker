FROM debian:11-slim

LABEL maintainer="zhouyueqiu <zhouyueqiu@easycorp.ltd>"

ENV OS_NAME="debian-11" \
    HOME_PAGE="spug.cc"

COPY debian/prebuildfs /

ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive

RUN install_packages curl wget zip unzip s6 pwgen cron nginx ca-certificates netcat \
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

# Install render-template and mysql-client
SHELL ["/bin/bash", "-c"]
RUN if [[ $(arch) == "x86_64" ]];then export OS_ARCH="amd64"; else export OS_ARCH="arm64"; fi \
    && . /opt/easysoft/scripts/libcomponent.sh \
    && component_unpack "render-template" "1.0.5" \
    && component_unpack "mysql-client" "10.5.26"

# Patch spug api deploy max length of version field
RUN sed -r -i 's/(version = models\.CharField\(max_length)=100(, null=True\))/\1=500\2/' api/apps/deploy/models.py \
    && grep -E 'version = models\.CharField\(max_length=500' api/apps/deploy/models.py

# Copy nginx and spug config files
COPY debian/rootfs /

EXPOSE 80

# Persistence directory
VOLUME [ "/data"]

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
