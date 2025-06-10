 # Docker 代理设置教程

本教程介绍如何使用自动化脚本为 Docker 配置 HTTP/HTTPS 代理，解决在网络受限环境下拉取镜像的问题。

## 简介

当你的服务器处于公司内网或网络访问受限的环境中时，Docker 拉取镜像可能会遇到网络连接问题。通过配置代理服务器，可以让 Docker 通过代理来访问外部镜像仓库。

## 脚本功能

该脚本可以自动完成以下配置：

- 配置 `/etc/docker/daemon.json` 文件
- 设置 systemd 代理环境变量
- 重启 Docker 服务使配置生效
- 支持自定义代理地址、端口和排除列表

## 远程使用方法

### 1. 下载脚本

```bash
# 方法一：使用 curl 下载
curl -O https://raw.githubusercontent.com/ld-2022/notepad/main/scripts/docker/setup-docker-proxy.sh

# 方法二：使用 wget 下载  
wget https://raw.githubusercontent.com/ld-2022/notepad/main/scripts/docker/setup-docker-proxy.sh
```

### 2. 添加执行权限

```bash
chmod +x setup-docker-proxy.sh
```

### 3. 运行脚本

#### 使用默认配置

```bash
sudo ./setup-docker-proxy.sh
```

默认配置：
- 代理地址：127.0.0.1:7890
- 排除地址：localhost,127.0.0.1,docker-registry.example.com,.corp

#### 自定义代理配置

```bash
# 指定代理服务器地址和端口
sudo ./setup-docker-proxy.sh -H 192.168.1.100 -p 8080

# 自定义排除代理的地址
sudo ./setup-docker-proxy.sh -n 'localhost,127.0.0.1,.local,.corp'

# 完整自定义配置
sudo ./setup-docker-proxy.sh -H 10.0.0.1 -p 3128 -n 'localhost,127.0.0.1,registry.internal'
```

## 参数说明

| 参数 | 长参数 | 描述 | 默认值 |
|------|--------|------|--------|
| -h | --help | 显示帮助信息 | - |
| -H | --host | 代理主机地址 | 127.0.0.1 |
| -p | --port | 代理端口 | 7890 |
| -n | --no-proxy | 排除代理的主机列表 | localhost,127.0.0.1,docker-registry.example.com,.corp |

## 配置验证

脚本执行完成后，可以使用以下命令验证配置是否生效：

```bash
# 查看 Docker 代理信息
docker info | grep -i proxy

# 查看 systemd 环境变量
systemctl show docker --property Environment

# 测试拉取镜像
docker pull hello-world
```

## 常见问题

### 1. 权限不足错误

**错误信息：** `错误: 此脚本需要root权限运行`

**解决方法：** 使用 `sudo` 运行脚本
```bash
sudo ./setup-docker-proxy.sh
```

### 2. Docker 服务重启失败

**解决方法：** 检查配置文件语法是否正确
```bash
# 检查 daemon.json 语法
sudo docker daemon --validate --config-file=/etc/docker/daemon.json

# 手动重启 Docker 服务
sudo systemctl restart docker
```

### 3. 代理无法连接

**解决方法：**
1. 确认代理服务器地址和端口正确
2. 检查防火墙设置
3. 测试代理连接：
```bash
curl -x http://代理地址:端口 https://www.docker.com
```

## 恢复配置

如果需要移除代理配置，可以手动操作：

```bash
# 删除 daemon.json 中的代理配置
sudo rm /etc/docker/daemon.json

# 恢复备份（如果有）
sudo cp /etc/docker/daemon.json.backup.* /etc/docker/daemon.json

# 删除 systemd 代理配置
sudo rm /etc/systemd/system/docker.service.d/http-proxy.conf

# 重启 Docker 服务
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## 脚本源码

完整的脚本源码可以在 GitHub 上查看：
[https://github.com/ld-2022/notepad/blob/main/scripts/docker/setup-docker-proxy.sh](https://github.com/ld-2022/notepad/blob/main/scripts/docker/setup-docker-proxy.sh)

## 注意事项

1. 该脚本需要 root 权限运行
2. 脚本会自动备份现有的 `daemon.json` 文件
3. 执行脚本前请确保代理服务器正常运行
4. 建议在测试环境中先验证配置的正确性

## 更新日志

- 支持命令行参数配置
- 自动备份现有配置文件
- 添加配置验证功能
- 优化错误处理和提示信息