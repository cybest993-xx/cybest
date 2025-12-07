FROM node:alpine3.20

# 1. 构建时：先把代码放在 /app (安全区，不会被覆盖)
WORKDIR /app

COPY . .

# 复制刚才写的启动脚本
COPY entrypoint.sh /entrypoint.sh

EXPOSE 3000/tcp

# 2. 安装依赖
RUN apk update && apk upgrade &&\
    apk add --no-cache openssl curl gcompat iproute2 coreutils bash &&\
    # 创建用户
    adduser -D -u 10014 -h /tmp choreouser &&\
    # 给启动脚本执行权限
    chmod +x /entrypoint.sh &&\
    chmod +x index.js &&\
    npm install &&\
    # 3. 权限管理 (非常重要)
    # 确保用户 10014 能读取 /app (源文件)
    chown -R 10014:10014 /app &&\
    # 确保用户 10014 能写入 /tmp (目标文件)
    chown -R 10014:10014 /tmp &&\
    chown 10014:10014 /entrypoint.sh

# 设置 HOME 变量
ENV HOME=/tmp

# 切换用户
USER 10014

# 4. 【核心魔法】设置入口点
# 容器启动时，先运行这个脚本，而不是直接运行 node
ENTRYPOINT ["/entrypoint.sh"]

# 5. 脚本执行完后，默认执行的命令
CMD ["node", "index.js"]
