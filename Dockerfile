ARG ONLYOFFICE_DIR=/var/www/onlyoffice/documentserver
ARG ONLYOFFICE_ADDON_FONTS_DIR=${ONLYOFFICE_DIR}/addon-fonts


# 安装字体
FROM storezhang/ubuntu:23.04.17 AS font


WORKDIR /opt


RUN apt update -y
RUN apt install git libcurl4-openssl-dev -y

# 克隆所有字体
ARG ONLYOFFICE_ADDON_FONTS_DIR
ARG CACHED_TIMES
RUN git clone --depth=1 https://gitee.com/storezhang/font.git ${ONLYOFFICE_ADDON_FONTS_DIR}





# 打包真正的镜像
FROM onlyoffice/documentserver:7.3.3.49


LABEL author="storezhang<华寅>" \
  email="storezhang@gmail.com" \
  qq="160290688" \
  wechat="storezhang" \
  description="Onlyoffice镜像，增加常用中文字体"


ARG ONLYOFFICE_DIR
ARG ONLYOFFICE_ADDON_FONTS_DIR
ARG ONLYOFFICE_CORE_FONTS_DIR=${ONLYOFFICE_DIR}/core-fonts

ARG ONLYOFFICE_WORD_APP_JS=/var/www/onlyoffice/documentserver/web-apps/apps/documenteditor/main/app.js
ARG ONLYOFFICE_EXCEL_APP_JS=/var/www/onlyoffice/documentserver/web-apps/apps/spreadsheeteditor/main/app.js

ARG ONLYOFFICE_REPLACE_FONT_SIZE="{value:8,displayValue:\"8\"}"
ARG CHINESE_FONT_SIZE="{value:5,displayValue:\"八号\"}"
ARG CHINESE_FONT_SIZE="${CHINESE_FONT_SIZE},{value:5.5,displayValue:\"七号\"}"
ARG CHINESE_FONT_SIZE="${CHINESE_FONT_SIZE},{value:6.5,displayValue:\"小六\"}"
ARG CHINESE_FONT_SIZE="${CHINESE_FONT_SIZE},{value:7.5,displayValue:\"六号\"}"
ARG CHINESE_FONT_SIZE="${CHINESE_FONT_SIZE},{value:9,displayValue:\"小五\"}"
ARG CHINESE_FONT_SIZE="${CHINESE_FONT_SIZE},{value:10.5,displayValue:\"五号\"}"
ARG CHINESE_FONT_SIZE="${CHINESE_FONT_SIZE},{value:12,displayValue:\"小四\"}"
ARG CHINESE_FONT_SIZE="${CHINESE_FONT_SIZE},{value:14,displayValue:\"四号\"}"
ARG CHINESE_FONT_SIZE="${CHINESE_FONT_SIZE},{value:15,displayValue:\"小三\"}"
ARG CHINESE_FONT_SIZE="${CHINESE_FONT_SIZE},{value:16,displayValue:\"三号\"}"
ARG CHINESE_FONT_SIZE="${CHINESE_FONT_SIZE},{value:18,displayValue:\"小二\"}"
ARG CHINESE_FONT_SIZE="${CHINESE_FONT_SIZE},{value:22,displayValue:\"二号\"}"
ARG CHINESE_FONT_SIZE="${CHINESE_FONT_SIZE},{value:24,displayValue:\"小一\"}"
ARG CHINESE_FONT_SIZE="${CHINESE_FONT_SIZE},{value:26,displayValue:\"一号\"}"
ARG CHINESE_FONT_SIZE="${CHINESE_FONT_SIZE},{value:36,displayValue:\"小初\"}"
ARG CHINESE_FONT_SIZE="${CHINESE_FONT_SIZE},{value:42,displayValue:\"初号\"}"
ARG CHINESE_FONT_SIZE="${CHINESE_FONT_SIZE},${ONLYOFFICE_REPLACE_FONT_SIZE}"

ENV FONTS_DIR /usr/share/fonts
ENV LOCAL_FONTS_DIR /usr/local/share/fonts
ENV GENERATE_FONTS false


# 复制字体
COPY --from=font ${ONLYOFFICE_ADDON_FONTS_DIR} ${ONLYOFFICE_ADDON_FONTS_DIR}


RUN set -ex \
  \
  \
  \
  # 安装字体
  && find ${FONTS_DIR} -regextype posix-egrep -regex ".*\.(ttf|otf)$" -type f -delete \
  && find ${LOCAL_FONTS_DIR} -regextype posix-egrep -regex ".*\.(ttf|otf)$" -type f -delete \
  \
  # 删除自带不常用字体
  && rm -rf ${ONLYOFFICE_CORE_FONTS_DIR}/* \
  # 将字体添加到核心字体为中
  && mv ${ONLYOFFICE_ADDON_FONTS_DIR}/* ${ONLYOFFICE_CORE_FONTS_DIR}/ \
  && rm -rf ${ONLYOFFICE_ADDON_FONTS_DIR} \
  # 增加中文字号
  && sed -i 's/{value:9,displayValue:"9"},//' ${ONLYOFFICE_WORD_APP_JS} \
  && sed -i 's/{value:12,displayValue:"12"},//' ${ONLYOFFICE_WORD_APP_JS} \
  && sed -i 's/{value:14,displayValue:"14"},//' ${ONLYOFFICE_WORD_APP_JS} \
  && sed -i 's/{value:16,displayValue:"16"},//' ${ONLYOFFICE_WORD_APP_JS} \
  && sed -i 's/{value:18,displayValue:"18"},//' ${ONLYOFFICE_WORD_APP_JS} \
  && sed -i 's/{value:22,displayValue:"22"},//' ${ONLYOFFICE_WORD_APP_JS} \
  && sed -i 's/{value:24,displayValue:"24"},//' ${ONLYOFFICE_WORD_APP_JS} \
  && sed -i 's/{value:26,displayValue:"26"},//' ${ONLYOFFICE_WORD_APP_JS} \
  && sed -i 's/{value:36,displayValue:"36"},//' ${ONLYOFFICE_WORD_APP_JS} \
  && sed -i 's/{value:8,displayValue:"8"}/'$CHINESE_FONT_SIZE'/' ${ONLYOFFICE_WORD_APP_JS} \
  && rm -f ${ONLYOFFICE_WORD_APP_JS}.gz \
  && gzip --keep ${ONLYOFFICE_WORD_APP_JS} \
  # 生成字体文件
  && documentserver-generate-allfonts.sh true \
  \
  \
  \
  # 清理镜像，减少无用包
  && rm -rf /var/lib/apt/lists/* \
  && apt autoremove -y \
  && apt autoclean
