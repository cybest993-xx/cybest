FROM node:alpine3.20

# 1. 把代码构建在安全目录 /app
WORKDIR /app
COPY . .

EXPOSE 3000/tcp

# 2. 安装环境、创建用户、设置权限
RUN apk update && apk upgrade &&\
    apk add --no-cache openssl curl gcompat iproute2 coreutils bash &&\
    adduser -D -u 10014 -h /tmp choreouser &&\
    chmod +x index.js &&\
    npm install &&\
    # 确保用户拥有源目录和目标目录的权限
    chown -R 10014:10014 /app &&\
    chown -R 10014:10014 /tmp

# 3. 设置 HOME 变量，防止 Node 访问 /root
ENV HOME=/tmp

# 4. 切换到非 Root 用户
USER 10014

# 5. 【终极解决方案】启动时：复制 /app -> /tmp，然后运行
CMD ["/bin/sh", "-c", "cp -r /app/. /tmp/ && cd /tmp && node index.js"]
