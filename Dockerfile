#############################
#     设置公共的变量         #
#############################
ARG BASE_IMAGE_TAG=22.04
FROM ubuntu:${BASE_IMAGE_TAG}

# 作者描述信息
MAINTAINER danxiaonuo
# 时区设置
ARG TZ=Asia/Shanghai
ENV TZ=$TZ
# 语言设置
ARG LANG=zh_CN.UTF-8
ENV LANG=$LANG

# 镜像变量
ARG DOCKER_IMAGE=danxiaonuo/ubuntu
ENV DOCKER_IMAGE=$DOCKER_IMAGE
ARG DOCKER_IMAGE_OS=ubuntu
ENV DOCKER_IMAGE_OS=$DOCKER_IMAGE_OS
ARG DOCKER_IMAGE_TAG=22.04
ENV DOCKER_IMAGE_TAG=$DOCKER_IMAGE_TAG

# 环境设置
ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=$DEBIAN_FRONTEND

# 安装依赖包
ARG PKG_DEPS="\
    zsh \
    bash \
    bash-doc \
    bash-completion \
    dnsutils \
    iproute2 \
    net-tools \
    sysstat \
    ncat \
    git \
    vim \
    jq \
    lrzsz \
    tzdata \
    curl \
    wget \
    axel \
    lsof \
    zip \
    unzip \
    tar \
    rsync \
    iputils-ping \
    telnet \
    procps \
    libaio1 \
    numactl \
    xz-utils \
    gnupg2 \
    psmisc \
    libmecab2 \
    debsums \
    locales \
    iptables \
    python3 \
    python3-dev \
    python3-pip \
    language-pack-zh-hans \
    fonts-droid-fallback \
    fonts-wqy-zenhei \
    fonts-wqy-microhei \
    fonts-arphic-ukai \
    fonts-arphic-uming \
    ca-certificates"
ENV PKG_DEPS=$PKG_DEPS

# ***** 安装依赖 *****
RUN set -eux && \
   # 更新源地址
   sed -i s@http://*.*ubuntu.com@https://mirrors.aliyun.com@g /etc/apt/sources.list && \
   sed -i 's?# deb-src?deb-src?g' /etc/apt/sources.list && \
   # 解决证书认证失败问题
   touch /etc/apt/apt.conf.d/99verify-peer.conf && echo >>/etc/apt/apt.conf.d/99verify-peer.conf "Acquire { https::Verify-Peer false }" && \
   # 更新系统软件
   DEBIAN_FRONTEND=noninteractive apt-get update -qqy && apt-get upgrade -qqy && \
   # 安装依赖包
   DEBIAN_FRONTEND=noninteractive apt-get install -qqy --no-install-recommends $PKG_DEPS && \
   DEBIAN_FRONTEND=noninteractive apt-get -qqy --no-install-recommends autoremove --purge && \
   DEBIAN_FRONTEND=noninteractive apt-get -qqy --no-install-recommends autoclean && \
   rm -rf /var/lib/apt/lists/* && \
   # 更新时区
   ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime && \
   # 更新时间
   echo ${TZ} > /etc/timezone && \
   # 更改为zsh
   sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true && \
   sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd && \
   sed -i -e 's/mouse=/mouse-=/g' /usr/share/vim/vim*/defaults.vim && \
   locale-gen zh_CN.UTF-8 && localedef -f UTF-8 -i zh_CN zh_CN.UTF-8 && locale-gen && \
   /bin/zsh

# ***** 升级 setuptools 版本 *****
RUN set -eux && \
    pip3 config set global.index-url http://mirrors.aliyun.com/pypi/simple/ && \
    pip3 config set install.trusted-host mirrors.aliyun.com && \
    pip3 install --upgrade pip setuptools wheel pycryptodome lxml cython beautifulsoup4 requests && \
    ln -sf /usr/bin/pip3 /usr/bin/pip && \
    ln -sf /usr/bin/python3 /usr/bin/python && \
    rm -r /root/.cache

# ***** 安装 Node.js 和 yarn *****
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs && \
    npm install --global yarn && \
    yarn config set registry https://registry.npm.taobao.org

# 设置工作目录为 /app
WORKDIR /app

# 将当前目录的内容复制到容器的 /app 目录
COPY [".", "/app"]
COPY ["myscript.sh", "/app/myscript.sh"]
COPY ["docker-entrypoint.sh", "/usr/bin/docker-entrypoint.sh"]

# ***** 创建目录授权 *****
RUN set -eux && \
    cp -rf /root/.oh-my-zsh /app/.oh-my-zsh && \
    cp -rf /root/.zshrc /app/.zshrc && \
    sed -i '5s#/root/.oh-my-zsh#/app/.oh-my-zsh#' /app/.zshrc && \
    chmod a+x /usr/bin/docker-entrypoint.sh /app/myscript.sh

# 安装 pandora 项目
RUN git clone https://github.com/pengzhile/pandora.git && \
    cd pandora && \
    pip install .

# 下载和安装项目
RUN git clone https://github.com/danxiaonuo/chatgpt.git && \
    cd chatgpt && \
    yarn install && \
    git pull && \
    yarn build

#设置定时任务
RUN crontab -l | { cat; echo "0 0 */10 * * bash /app/myscript.sh"; } | crontab -

# 开放端口3000
EXPOSE 3000
# 开放端口8008
EXPOSE 8008

# 环境变量
ENV ACCESS_TOKEN="" CODE=""

# ***** 入口 *****
ENTRYPOINT ["docker-entrypoint.sh"]
