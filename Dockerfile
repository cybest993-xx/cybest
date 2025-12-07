FROM node:alpine3.20

# 1. 把构建过程放在 /app (安全区)
WORKDIR /app

# 2. 复制代码到 /app
COPY . .

EXPOSE 3000/tcp

# 3. 安装依赖 & 设置权限
RUN apk update && apk upgrade &&\
    apk add --no-cache openssl curl gcompat iproute2 coreutils bash &&\
    # 创建用户 10014
    adduser -D -u 10014 -h /tmp choreouser &&\
    chmod +x index.js &&\
    npm install &&\
    # 关键：把 /app (源代码) 和 /tmp (运行地) 的权限都给 10014
    chown -R 10014:10014 /app &&\
    chown -R 10014:10014 /tmp

# 4. 设置环境变量
ENV HOME=/tmp

# 5. 切换用户
USER 10014

# 6. 【核心修复】使用 Shell 组合命令
# 逻辑：启动瞬间 -> 把 /app 下的所有文件拷贝到 /tmp -> 进入 /tmp -> 启动 Node
CMD ["/bin/sh", "-c", "cp -r /app/. /tmp/ && cd /tmp && node index.js"]
