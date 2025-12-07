FROM node:alpine3.20

WORKDIR /tmp

COPY . .

EXPOSE 3000/tcp

# 核心修改部分
RUN apk update && apk upgrade &&\
    apk add --no-cache openssl curl gcompat iproute2 coreutils &&\
    apk add --no-cache bash &&\
    # 1. 创建一个 UID 为 10014 的用户
    # -D: 不需要密码
    # -u: 指定 UID
    # -h: 指定家目录 (可选，这里设为 /tmp 方便读写)
    adduser -D -u 10014 -h /tmp choreouser &&\
    chmod +x index.js &&\
    npm install &&\
    # 2. 将工作目录权限移交给这个新用户 ID
    chown -R 10014:10014 /tmp

# 3. 切换到该用户 ID
USER 10014

CMD ["node", "index.js"]
