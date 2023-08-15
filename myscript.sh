# python /app/chatgpt/autorestart.py
kill -9 $(lsof -t -i:8008)
rm -rf /app/pandora/token.txt
wget --no-check-certificate https://down.xiaonuo.live/?url=https://raw.githubusercontent.com/danxiaonuo/gwf/main/chatgpt/chatgpt_token.txt -O /app/pandora/token.txt
cd /app/pandora
nohup pandora -s 0.0.0.0:8008 -t token.txt > output.log 2>&1 &
