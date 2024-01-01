## 代码签名

### Windows代码签名

- 手动签名
```
signtool sign /tr http://timestamp.comodoca.com /td sha256 /fd sha256 /a /v <filename>
```
- 自动签名

    - 自动输入密码工具【autoit】https://skynet-beijing.oss-cn-beijing.aliyuncs.com/resources/autoit-v3-setup.zip
        - 脚本AutoPin.au3
        ```
        $Caption = "Token Logon"

        While 1
            Local $hWnd = WinWait($Caption)
            WinActivate($hWnd)
            ControlSetText($hWnd, "", "Edit2", "密码")
            Sleep(500)
            ControlClick($hWnd, "", "Button1")
            WinWaitClose($Caption)
        Wend
        ```
    - 自动扫描目录并签名程序【code.signing】https://skynet-beijing.oss-cn-beijing.aliyuncs.com/resources/code.signing.exe
        - 打开后填写要签名的目录即可
### MacOS 签名

- 代码签名（APP、二进制文件）
```
# 签名
codesign -f --sign "Developer ID Application: 《证书ID》" --timestamp --options runtime 《xxx.app、二进制文件名》
# 检查签名
codesign -dv --verbose=4 《xxx.app、二进制文件名》
```
- 安装包签名（PKG）
```
# 签名
productsign --sign "Developer ID Installer: 《证书ID》" 《PKG文件》
# 检查签名
pkgutil --check-signature 《PKG文件》
```

- 公正（APP、二进制文件、PKG）
```
# 保存公正账号信息
xcrun notarytool store-credentials "notarytool-password" --apple-id "《APPLE-ID》" --team-id 《TEAM-ID》 --password 《notarytool专用密码》
# 开始公正
xcrun notarytool submit 《APP、二进制文件、PKG文件》 --keychain-profile "notarytool-password" --wait
# 下载公正日志
xcrun notarytool log 《上传ID》 --keychain-profile "notarytool-password" developer_log.json
```