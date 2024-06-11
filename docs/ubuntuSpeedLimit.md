## Ubuntu限速设置

### Ubuntu

#### 一、查看当前规则
```shell
iptables -L OUTPUT -n -v
```

#### 二、设置规则
```shell
iptables -A OUTPUT -m hashlimit --hashlimit-name max_bandwidth --hashlimit-upto 2560kb/s --hashlimit-burst 5120kb --hashlimit-mode srcip,srcport -j ACCEPT
iptables -A OUTPUT -m hashlimit --hashlimit-name min_bandwidth --hashlimit-above 512kb/s --hashlimit-burst 1280kb --hashlimit-mode srcip,srcport -j REJECT
## 这个必须设置
iptables -A OUTPUT -j REJECT
```