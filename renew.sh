#!/bin/bash

read -p "请输入地址: " address
read -p "请输入用户名: " username
read -p "请输入密码: " password
read -p "请输入执行间隔 (默认为259200秒): " interval

# 如果用户没有输入执行间隔，则默认值为259200秒
interval=${interval:-259200}

cat > auto-renew.sh <<EOF
#!/bin/bash

while true; do
  sshpass -p '$password' ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -tt $username@$address "exit" &
  sleep $interval  # 默认30天为259200秒
done
EOF

echo "已创建自动续订脚本 auto-renew.sh。"

# 检查是否安装了 pm2
if pm2 -v >/dev/null 2>&1; then
    echo "正在使用 pm2 启动脚本..."
    chmod +x auto-renew.sh && pm2 start ./auto-renew.sh
else
    echo "未检测到 pm2。请访问以下网址安装 pm2:"
    echo "https://github.com/giturass/cloudflared_freebsd/blob/main/install.sh"
fi
