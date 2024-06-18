## SSH开启远程登录

### 一、编辑【/etc/rc.conf】

- 添加一行sshd_enable="YES"

### 二、编辑【/etc/ssh/sshd_config】

- #PermitRootLogin no改为PermitRootLogin yes //允许root登陆

- #PasswordAuthentication no改为PasswordAuthenticationyes//使用系统PAM认证

- #PermitEmptyPasswords no改为PermitEmptyPasswords no//不允许空密码

### 三、重启SSH服务

- /etc/rc.d/sshd restart