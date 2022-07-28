FROM onlyoffice/documentserver


LABEL author="storezhang<华寅>"
LABEL email="storezhang@gmail.com"
LABEL qq="160290688"
LABEL wechat="storezhang"
LABEL description="Onlyoffice镜像，增加常用中文字体"


ENV ONLYOFFICE_DIR /var/www/onlyoffice/documentserver
ENV ONLYOFFICE_ADDON_FONTS_DIR ${ONLYOFFICE_DIR}/addon-fonts
ENV ONLYOFFICE_CORE_FONTS_DIR ${ONLYOFFICE_DIR}/core-fonts

# 复制文件
COPY docker /


RUN set -ex \
  \
  \
  \
  # 安装字体
  && find ${FONTS_DIR} -regextype posix-egrep -regex ".*\.(ttf|otf)$" -type f -delete \
  && find ${LOCAL_FONTS_DIR} -regextype posix-egrep -regex ".*\.(ttf|otf)$" -type f -delete \
  && mv ${ONLYOFFICE_ADDON_FONTS_DIR}/* ${ONLYOFFICE_CORE_FONTS_DIR}/ \
  && rm -rf ${ONLYOFFICE_ADDON_FONTS_DIR} \
  && fc-cache -f -v \
  \
  \
  \
  # 清理镜像，减少无用包
  && rm -rf /var/lib/apt/lists/* \
  && apt autoremove -y \
  && apt autoclean
