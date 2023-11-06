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