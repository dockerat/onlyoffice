ARG EXTRA_FONTS_DIR=/opt/fonts


# 安装字体
FROM storezhang/ubuntu AS font


WORKDIR /opt


RUN apt update -y
RUN apt install git libcurl4-openssl-dev -y

# 克隆所有字体
ARG EXTRA_FONTS_DIR
RUN git clone --depth=1 https://gitee.com/storezhang/font.git ${EXTRA_FONTS_DIR}





# 打包真正的镜像
FROM onlyoffice/documentserver


LABEL author="storezhang<华寅>"
LABEL email="storezhang@gmail.com"
LABEL qq="160290688"
LABEL wechat="storezhang"
LABEL description="Onlyoffice镜像，增加常用中文字体"


ARG EXTRA_FONTS_DIR
ENV FONTS_DIR /usr/share/fonts


# 复制字体
COPY --from=font ${EXTRA_FONTS_DIR} ${FONTS_DIR}


RUN set -ex \
  \
  \
  \
  # 安装字体
  && fc-cache -f -v  \
  \
  \
  \
  # 清理镜像，减少无用包
  && rm -rf /var/lib/apt/lists/* \
  && apt autoremove -y \
  && apt autoclean
