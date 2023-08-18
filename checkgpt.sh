#!/bin/bash

# 检查端口8008上是否有进程在运行
if ! lsof -t -i:8008 > /dev/null 2>&1; then
    # 如果没有进程在8008端口上运行，执行脚本
    /bin/bash /app/myscript.sh
fi
