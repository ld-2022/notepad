## Linux SSH常用操作

### 仅限Debian 系列

### 1. 修改 SSH 默认端口的步骤如下：

1. 首先，打开 SSH 配置文件。使用以下命令：

    ```bash
    sudo nano /etc/ssh/sshd_config
    ```

2. 在打开的文件中找到 `#Port 22` 这一行，删除注释（也就是删除 '#' 符号），然后将 '22' 改为你希望设置的新端口号。例如，如果你想要将端口号改为 '2222'，那么修改后的这行内容应该看起来像这样：`Port 2222`。

3. 保存并关闭文件。在 `nano` 编辑器中，你可以按 `Ctrl + X`，然后按 `Y`，最后按 `Enter` 来保存并退出。

4. 重启 SSH 服务使更改生效。使用以下命令：

    ```bash
    sudo systemctl restart ssh
    ```

**注意事项**

- 修改 SSH 端口前，请确保您已添加了新端口到防火墙允许列表，否则可能会导致您无法通过 SSH 连接到您的服务器。

- 修改 SSH 端口后，以后每次连接都需要指定新的端口，比如 `ssh user@host -p 2222`。

- 注意不要选择已经被其他服务占用的端口。

- 建议选择1024以上的端口。因为 0-1023 是预留给特权服务的，所以非特权用户无法监听这些端口。

### 2. 开启密钥登录，并最后更新 SSH 配置以禁止密码登录。下面是具体步骤：

**第 1 步 — 在本地机器上生成新的 SSH 密钥**

在您的本地计算机上执行以下命令，然后按回车键接受默认位置(一般为 ~/.ssh/id_rsa)，或者您可以输入自定义路径。当系统提示您输入 passphrase（可选）时，如果你不想设置密钥暗号，直接回车即可。

```bash
ssh-keygen
```

**第 2 步 — 把 SSH 公钥复制到服务器**

我们需要将生成的公钥（id_rsa.pub）复制到服务器上。可以使用 `ssh-copy-id` 命令，如下所示：

```bash
ssh-copy-id username@your_server_ip
```

其中，username 是你的用户名，your_server_ip 是你的服务器 IP 地址。

如果没有 `ssh-copy-id` 命令，也可以手动复制。首先，显示并复制公钥内容：

```bash
cat ~/.ssh/id_rsa.pub
```

然后登陆到你的服务器，将公钥内容添加到 `~/.ssh/authorized_keys` 文件中。如果文件或目录不存在，需要创建它们。

**第 3 步 — 开启密钥登陆**

编辑 SSH 配置文件：

```bash
sudo nano /etc/ssh/sshd_config
```

找到以下这行：

```bash
PubkeyAuthentication no
```

取消注释并将 `no` 改为 `yes`：

```bash
PubkeyAuthentication yes
```
保存并关闭文件。

重启 SSH 服务以使更改生效：

```bash
sudo systemctl restart ssh
```

**第 4 步 — 禁用密码登录**

当确认可以通过 ssh 密钥登录后，为了提高安全性，我们可以禁用密码登录。编辑 SSH 配置文件：

```bash
sudo nano /etc/ssh/sshd_config
```

找到以下这行：

```bash
#PasswordAuthentication yes
```

取消注释并将 `yes` 改为 `no`：

```bash
PasswordAuthentication no
```

保存并关闭文件。

最后，重启 SSH 服务以使更改生效：

```bash
sudo systemctl restart ssh
```

此后，登录服务器时就需要使用 SSH 密钥进行身份验证。

**注意：** 在禁用密码登录之前，请确认你的公钥已经设置正确，并且能够通过密钥登录。否则你可能会被锁在服务器外面。

### 3. 启用登录日志，您需要编辑 sshd_config 配置文件并修改相应的设置。请遵循以下步骤：

1. 打开一个终端窗口。

2. 使用命令 `sudo nano /etc/ssh/sshd_config` 打开 sshd_config 文件。

3. 在其中找到 `#LogLevel INFO` 这一行（如果这一行不存在，就在任何地方添加它）。

4. 去掉 `#LogLevel INFO` 开头的 `#` 来取消注释，使其生效。

5. 按 Ctrl+X 退出编辑器，然后按 Y 保存更改，并按回车确认。

6. 通过运行 `sudo systemctl restart ssh` 命令重启 SSH 服务，使更改生效。

这样，SSH 就会开始记录详细的登录信息，包括所有尝试和成功的登录。这些信息将被写入 `/var/log/auth.log` 文件。你可以使用命令 `cat /var/log/auth.log` 查看此日志文件的内容。

请注意，对于 CentOS 和其他使用 rsyslog 的系统，可能需要查看 `/var/log/secure` 文件而不是 `/var/log/auth.log` 文件。