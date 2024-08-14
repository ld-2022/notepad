## Ubuntu sudo免密码

#### 一、编辑/etc/sudoers文件
```shell
sudo visudo /etc/sudoers
```
#### 二、在%sudo ALL=(ALL:ALL) ALL 下面添加
```shell
blue ALL=(ALL) NOPASSWD:ALL
注：blue是我的用户名，改成你自己的，这行也可直接复制过去后修改用户名
```

#### 三、CTRL + X退出，提示是否保存选Y，回车

#### 四、重新打开一个终端测试