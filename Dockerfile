ARG ONLYOFFICE_DIR=/var/www/onlyoffice/documentserver
ARG ONLYOFFICE_EXTRA_FONTS_DIR=${ONLYOFFICE_DIR}/extra-fonts


# 安装字体
FROM storezhang/ubuntu AS font


WORKDIR /opt


RUN apt update -y
RUN apt install git libcurl4-openssl-dev -y
RUN git clone --depth=1 https://gitee.com/storezhang/font.git ${ONLYOFFICE_EXTRA_FONTS_DIR}
RUN ls -al ${ONLYOFFICE_EXTRA_FONTS_DIR}





# 打包真正的镜像
FROM onlyoffice/documentserver


LABEL author="storezhang<华寅>"
LABEL email="storezhang@gmail.com"
LABEL qq="160290688"
LABEL wechat="storezhang"
LABEL description="Onlyoffice镜像，增加常用中文字体"


ARG ONLYOFFICE_DIR
ARG ONLYOFFICE_EXTRA_FONTS_DIR
ARG ONLYOFFICE_FONTS_DIR=${ONLYOFFICE_DIR}/fonts
ARG ONLYOFFICE_CORE_FONTS_DIR=${ONLYOFFICE_DIR}/core-fonts
ENV FONTS_DIR /usr/share/fonts
ENV LOCAL_FONTS_DIR /usr/local/share/fonts


# 复制字体
COPY --from=font ${ONLYOFFICE_EXTRA_FONTS_DIR} ${ONLYOFFICE_EXTRA_FONTS_DIR}


RUN set -ex \
  \
  \
  \
  # 安装字体
  && rm -rf ${FONTS_DIR}/*.ttf \
  && rm -rf ${FONTS_DIR}/*.otf \
  && rm -rf ${LOCAL_FONTS_DIR}/*.ttf \
  && rm -rf ${LOCAL_FONTS_DIR}/*.otf \
  && rm -rf ${ONLYOFFICE_CORE_FONTS_DIR}/* \
  && rm -rf ${ONLYOFFICE_FONTS_DIR}/* \
  && mv ${ONLYOFFICE_EXTRA_FONTS_DIR}/* ${ONLYOFFICE_CORE_FONTS_DIR}/ \
  && rm -rf ${ONLYOFFICE_EXTRA_FONTS_DIR} \
  \
  \
  \
  # 清理镜像，减少无用包
  && rm -rf /var/lib/apt/lists/* \
  && apt autoremove -y \
  && apt autoclean
