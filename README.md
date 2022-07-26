# onlyoffice

基于官方`DocumentServer`，添加以下功能
- 字体
  - 仿宋
  - 雅黑
  - 方正
  - 楷体
  - 黑体

## 使用

使用方式非常简单，直接上代码

```shell
TAG="storezhang/vscode" && NAME="VSCode" && sudo docker pull ${TAG} && sudo docker stop ${NAME} ; sudo docker rm --force --volumes ${NAME} ; sudo docker run \
  --volume=你机器上数据目录:/config \
  --hostname=vscode \
  \
  \
  \
  --env=UID=用户编号所有容器里面的文件都会被设置成此用户 \
  --env=GID=组编号所有容器里面的文件都会被设置成此组 \
  \
  \
  \
  --env=PASSWORD=你想设置的密码 \
  --env=USER_PASSWORD=在控制台切换超级用户时的密码 \
  --env=DOMAIN=你的域名 \
  --env=WORKSPACE=/config/workspace \
  \
  \
  \
  --publish=想暴露的端口:8443 \
  --restart=always \
  --detach=true \
  --name=${NAME} \
  ${TAG}
```
