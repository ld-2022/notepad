## Ubuntu设置静态IP

### 仅限22.04.3

#### 一、进入【/etc/netplan】目录

#### 二、修改【00-xxx-config.yaml】文件
```shell
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      addresses:
        - 192.168.1.111/24
      routes:
        - to: default
          via: 192.168.1.1
      nameservers:
        addresses: [192.168.1.1,8.8.8.8,8.8.4.4]
```

#### 三、如果需要设置旁路由上网修改192.168.1.1为旁路由地址即可

#### 四、重启系统生效