FROM onlyoffice/documentserver


LABEL author="storezhang<华寅>"
LABEL email="storezhang@gmail.com"
LABEL qq="160290688"
LABEL wechat="storezhang"
LABEL description="Onlyoffice镜像，增加常用中文字体"


COPY docker /


RUN set -ex \
  \
  \
  \
  # && apt update -y --fix-missing \
  # && apt upgrade -y --fix-missing \
  # 安装字体
  && fc-cache -f -v \
  \
  \
  \
  # 清理镜像，减少无用包
  && rm -rf /var/lib/apt/lists/* \
  && apt autoremove -y \
  && apt autoclean
