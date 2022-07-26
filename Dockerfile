FROM onlyoffice/documentserver


LABEL author="storezhang<华寅>"
LABEL email="storezhang@gmail.com"
LABEL qq="160290688"
LABEL wechat="storezhang"
LABEL description="Onlyoffice镜像，增加常用中文字体"


ENV FONTS_DIR /usr/share/fonts
ENV LOCAL_FONTS_DIR /usr/local/share/fonts


COPY docker /


RUN set -ex \
  \
  \
  \
  # 安装字体
  && rm -rf ${FONTS_DIR}/*.ttf \
  && rm -rf ${LOCAL_FONTS_DIR}/*.ttf \
  && mv /opt/local/share/fonts/* ${LOCAL_FONTS_DIR} \
  && fc-cache -f -v \
  && documentserver-generate-allfonts.sh \
  # 清理镜像，减少无用包
  && rm -rf /var/lib/apt/lists/* \
  && apt autoremove -y \
  && apt autoclean


# 不要重复生成字体
ENV GENERATE_FONTS false
