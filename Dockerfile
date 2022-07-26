FROM onlyoffice/documentserver


LABEL author="storezhang<华寅>"
LABEL email="storezhang@gmail.com"
LABEL qq="160290688"
LABEL wechat="storezhang"
LABEL description="Onlyoffice镜像，增加常用中文字体"


ENV FONTS_DIR /usr/share/fonts
ENV LOCAL_FONTS_DIR /usr/local/share/fonts
ENV ONLYOFFICE_DIR /var/www/onlyoffice/documentserver
ENV ONLYOFFICE_FONTS_DIR ${ONLYOFFICE_DIR}/fonts
ENV ONLYOFFICE_CORE_FONTS_DIR ${ONLYOFFICE_DIR}/core-fonts
ENV ONLYOFFICE_EXTRA_FONTS_DIR ${ONLYOFFICE_DIR}/extra-fonts


COPY docker /


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
