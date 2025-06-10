#!/bin/bash

# Docker代理配置脚本
# 用于配置Docker的HTTP/HTTPS代理设置

set -e  # 遇到错误立即退出

# 显示使用帮助
show_help() {
    echo "用法: $0 [选项]"
    echo
    echo "选项:"
    echo "  -h, --help              显示此帮助信息"
    echo "  -H, --host HOST         代理主机地址 (默认: 127.0.0.1)"
    echo "  -p, --port PORT         代理端口 (默认: 7890)"
    echo "  -n, --no-proxy HOSTS    排除代理的主机列表，用逗号分隔"
    echo "                          (默认: localhost,127.0.0.1,docker-registry.example.com,.corp)"
    echo
    echo "示例:"
    echo "  $0                                    # 使用默认设置"
    echo "  $0 -H 192.168.1.100 -p 8080         # 使用自定义主机和端口"
    echo "  $0 -n 'localhost,127.0.0.1,.local'  # 自定义排除列表"
    echo
}

# 默认参数
DEFAULT_HOST="127.0.0.1"
DEFAULT_PORT="7890"
DEFAULT_NO_PROXY="localhost,127.0.0.1,docker-registry.example.com,.corp"

# 解析命令行参数
PROXY_HOST="$DEFAULT_HOST"
PROXY_PORT="$DEFAULT_PORT"
NO_PROXY="$DEFAULT_NO_PROXY"

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -H|--host)
            PROXY_HOST="$2"
            shift 2
            ;;
        -p|--port)
            PROXY_PORT="$2"
            shift 2
            ;;
        -n|--no-proxy)
            NO_PROXY="$2"
            shift 2
            ;;
        *)
            echo "未知参数: $1"
            echo "使用 $0 --help 查看帮助"
            exit 1
            ;;
    esac
done

# 构建代理URL
PROXY_HTTP="http://${PROXY_HOST}:${PROXY_PORT}"
PROXY_HTTPS="http://${PROXY_HOST}:${PROXY_PORT}"

echo "=== Docker代理配置脚本 ==="
echo "配置Docker使用代理:"
echo "  HTTP代理: ${PROXY_HTTP}"
echo "  HTTPS代理: ${PROXY_HTTPS}"
echo "  排除地址: ${NO_PROXY}"
echo

# 检查是否以root权限运行
if [[ $EUID -ne 0 ]]; then
   echo "错误: 此脚本需要root权限运行"
   echo "请使用: sudo $0 [选项]"
   exit 1
fi

echo "1. 配置 /etc/docker/daemon.json"

# 创建docker配置目录（如果不存在）
mkdir -p /etc/docker

# 备份现有的daemon.json（如果存在）
if [[ -f /etc/docker/daemon.json ]]; then
    echo "   备份现有的daemon.json文件..."
    cp /etc/docker/daemon.json /etc/docker/daemon.json.backup.$(date +%Y%m%d_%H%M%S)
fi

# 创建新的daemon.json配置
echo "   创建/更新daemon.json配置..."
cat > /etc/docker/daemon.json << EOF
{
  "proxies": {
    "http-proxy": "${PROXY_HTTP}",
    "https-proxy": "${PROXY_HTTPS}",
    "no-proxy": "${NO_PROXY}"
  }
}
EOF

echo "   ✓ daemon.json配置完成"
echo

echo "2. 配置systemd代理设置"

# 创建systemd配置目录
echo "   创建systemd配置目录..."
mkdir -p /etc/systemd/system/docker.service.d

# 创建http-proxy.conf配置文件
echo "   创建http-proxy.conf配置..."
cat > /etc/systemd/system/docker.service.d/http-proxy.conf << EOF
[Service]
Environment="HTTP_PROXY=${PROXY_HTTP}"
Environment="HTTPS_PROXY=${PROXY_HTTPS}"
Environment="NO_PROXY=${NO_PROXY}"
EOF

echo "   ✓ systemd代理配置完成"
echo

echo "3. 重启Docker服务"

# 重新加载systemd配置并重启Docker
echo "   重新加载systemd配置..."
systemctl daemon-reload

echo "   重启Docker服务..."
systemctl restart docker

# 检查Docker服务状态
if systemctl is-active --quiet docker; then
    echo "   ✓ Docker服务重启成功"
else
    echo "   ❌ Docker服务重启失败"
    exit 1
fi

echo
echo "=== 配置完成 ==="
echo "Docker代理设置已生效，配置信息："
echo "  HTTP代理: ${PROXY_HTTP}"
echo "  HTTPS代理: ${PROXY_HTTPS}"
echo "  排除地址: ${NO_PROXY}"
echo
echo "可以使用以下命令验证配置："
echo "  docker info | grep -i proxy"
echo "  systemctl show docker --property Environment" 