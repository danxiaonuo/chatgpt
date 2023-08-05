#!/bin/bash

# chatgpt token
TOKEN_TMP=$(wget -q -O - https://down.xiaonuo.live/?url=https://raw.githubusercontent.com/danxiaonuo/gwf/main/chatgpt/chatgpt_token.txt)
ACCESS_TOKEN="${ACCESS_TOKEN:=${TOKEN_TMP}}"

# 运行chatgpt web
echo "${ACCESS_TOKEN}" > /app/pandora/token.txt && cd /app/pandora && pandora -s 0.0.0.0:8008 -t token.txt & cd /app/chatgpt && yarn start
