#!/bin/bash
set -e

# 1. 打印日志，确认脚本在运行
echo "Starting deployment script..."

# 2. 将代码从“安全暂存区”(/app) 复制到 最终运行区(/tmp)
# -r: 递归复制
# -n: 不覆盖已存在的文件(可选，视情况而定)
echo "Copying files from /app to /tmp..."
cp -r /app/* /tmp/

# 3. 切换工作目录到 /tmp
cd /tmp

# 4. 执行 Dockerfile 里的 CMD 命令 (即 node index.js)
echo "Starting Node.js..."
exec "$@"
