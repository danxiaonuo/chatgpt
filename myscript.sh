#!/bin/bash

# chatgpt token
TOKEN_TMP=$(wget -q -O - https://down.xiaonuo.live/?url=https://raw.githubusercontent.com/danxiaonuo/gwf/main/chatgpt/chatgpt_token.txt)
ACCESS_TOKEN="${ACCESS_TOKEN:=${TOKEN_TMP}}"

python3 /app/chatgpt/autorestart.py

kill -9 $(lsof -t -i:8008)

# 运行 pandora
# TOKEN_TMP=$(cat /app/chatgpt/chatgpt_token.txt)
ACCESS_TOKEN="${ACCESS_TOKEN:=${TOKEN_TMP}}"
echo "${ACCESS_TOKEN}" > /app/pandora/token.txt
cd /app/pandora
/usr/bin/nohup /usr/bin/python3 /usr/local/bin/pandora -s 0.0.0.0:8008 -t /app/pandora/token.txt > /app/pandora/output.log 2>&1 &
