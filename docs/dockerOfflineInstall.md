## Docker离线安装

### Ubuntu

#### 一、下载离线包

- [containerd.io](https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/containerd.io_1.6.33-1_amd64.deb)
- [docker-ce-cli](https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/docker-ce-cli_26.1.4-1~ubuntu.20.04~focal_amd64.deb)
- [docker-ce](https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/docker-ce_26.1.4-1~ubuntu.20.04~focal_amd64.deb)

#### 二、安装
```shell
sudo dpkg -i containerd.io_1.6.33-1_amd64.deb
sudo dpkg -i docker-ce-cli_26.1.4-1~ubuntu.20.04~focal_amd64.deb
sudo dpkg -i docker-ce_26.1.4-1~ubuntu.20.04~focal_amd64.deb
```
#### 三、启动
```shell
sudo systemctl start docker
```
#### 三、验证版本
```shell
sudo docker --version
```

#### 三、设置开机启动
```shell
sudo systemctl enable docker
```