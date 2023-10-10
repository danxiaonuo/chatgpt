#!/bin/bash

# 输入账号信息
echo "${username} ${password}" > /app/chatgpt/user.txt

# 获取chatgpt token
bash myscript.sh
TOKEN_TMP=$(cat /app/chatgpt/chatgpt_token.txt)
TOKEN_TMP=$(wget -q -O - https://down.xiaonuo.live/?url=https://raw.githubusercontent.com/danxiaonuo/gwf/main/chatgpt/chatgpt_token.txt)
ACCESS_TOKEN="${ACCESS_TOKEN:=${TOKEN_TMP}}"
echo "${ACCESS_TOKEN}" > /app/pandora/token.txt

# 运行chatgpt web
cron && cd /app/chatgpt && yarn start
