#!/bin/bash

# chatgpt token
# TOKEN_TMP=$(wget -q -O - https://down.xiaonuo.live/?url=https://raw.githubusercontent.com/danxiaonuo/gwf/main/chatgpt/chatgpt_token.txt)
# ACCESS_TOKEN="${ACCESS_TOKEN:=${TOKEN_TMP}}"
echo "${username},${password}" > /app/chatgpt/user.txt

# 运行chatgpt web
# echo "${ACCESS_TOKEN}" > /app/pandora/token.txt && cron && bash myscript.sh && cd /app/chatgpt && yarn start
cron && bash myscript.sh && cd /app/chatgpt && yarn start
