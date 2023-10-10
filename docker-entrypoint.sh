#!/bin/bash

# 输入账号信息
echo "${account}" > /app/chatgpt/user.txt

# 获取chatgpt token
# TOKEN_TMP=$(wget -q -O - https://down.xiaonuo.live/?url=https://raw.githubusercontent.com/danxiaonuo/gwf/main/chatgpt/chatgpt_token.txt)
bash myscript.sh
TOKEN_TMP=$(cat /app/chatgpt/chatgpt_token.txt)
ACCESS_TOKEN="${ACCESS_TOKEN:=${TOKEN_TMP}}"

# 运行chatgpt web
# echo "${ACCESS_TOKEN}" > /app/pandora/token.txt && cron && bash myscript.sh && cd /app/chatgpt && yarn start
echo "${ACCESS_TOKEN}" > /app/pandora/token.txt && cron && cd /app/chatgpt && yarn start
