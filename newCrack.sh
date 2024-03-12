#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
LANG=en_US.UTF-8

lines=78

if [ $(id -u) != "0" ]; then
    echo "$(tput setaf 1)请使用sudo权限执行改脚本！"
    exit 1
fi

echo "+------------------------------------------------------------------------+"
echo "| Burp Suite Professional for Linux (64-bit) Install, Written by zcbxxx1 |"
echo "+------------------------------------------------------------------------+"
echo "|      一个在Linux上手动离线激活和安装Burp Suite Professional的工具      |" # 不知道为什么偏移
echo "+------------------------------------------------------------------------+"
echo "|       有关更多信息，请访问 https://github.com/zcbxxx1/BrupLinux-crack  |"
echo "+------------------------------------------------------------------------+"
echo "|   请注意：此脚本仅供学习和研究使用，请于下载后24h删除。否则与作者无关！|"

# 初始化Burp Suite Pro的安装目录和文件名
BURP_DIR="/ot/BurpSuitePro/"
BURP="BurpSuitePro"

# 使用循环检测BurpSuitePro文件是否存在
while true; do
    if [ -f "${BURP_DIR}${BURP}" ]; then
        echo "已检测到 ${BURP_DIR}${BURP}"
        break # 如果找到文件，则退出循环
    else
        echo "未检测到 ${BURP_DIR} 下的 BurpSuitePro 安装。"
        echo "请输入你的安装路径，如 ~/BurpSuitePro (留空即为没有安装):"
        read -r USER_INPUT
        BURP_DIR="${USER_INPUT%/}/" # 删除末尾的斜杠（如果有），然后再添加一个斜杠
        # echo $BURP_DIR
            if [ -z "$USER_INPUT" ]; then
            echo "目前没有安装"
            break
        fi
    fi
done

while true; do
    if [ -f "$BpName" ]; then
        echo "检测到安装包，是否立即安装？[Y/n]"
        read -r INSTALL_CHOICE
        if [ "$INSTALL_CHOICE" = "n" ] || [ "$INSTALL_CHOICE" = "N" ]; then
            echo "取消安装，脚本退出！"
            exit 1
        fi
        if [ -z "$INSTALL_CHOICE" ] || [ "$INSTALL_CHOICE" = "Y" ] || [ "$INSTALL_CHOICE" = "y" ]; then
            chmod +x "$BpName"
            sudo ./"$BpName"
            break
        fi
    else
        Version=$(curl -L -s -H 'Accept: application/json' "https://portswigger.net/burp/releases/data?previousLastId=-1&lastId=-1&pageSize=3" | sed -n 's/.*"ProductPlatformLabel":"Linux (x64)".*"Version":"\([^"]*\)".*/\1/p')
        echo "当前最新版本为 $Version，正在尝试下载"
        Link="https://portswigger-cdn.net/burp/releases/download?product=pro&version=$Version&type=Linux"
	    # echo ${Link}
        Version=${Version//./_}
        BpName="burpsuite_pro_linux_v$Version.sh"
        curl "$Link" -o "$BpName"
        # wget "$Link" -O "$BpName" --quiet --show-progress
    fi
done


PS3='输入您的选择: '
foods=("官方下载" "官方安装" "网盘安装" "破解补丁" "运行注册机" "设置英文版" "设置汉化版" "退出安装..")
select fav in "${foods[@]}"; do
    case $fav in
    "官方下载")
        echo "$fav ...."
        Version=$(curl -L -s -H 'Accept: application/json' "https://portswigger.net/burp/releases/data?previousLastId=-1&lastId=-1&pageSize=1" | sed -e 's/.*"version":"\([^"]*\)".*/\1/')
        Link="https://portswigger-cdn.net/burp/releases/download?product=pro&version=$Version&type=Linux"
        wget "$Link" -O burpsuite_pro_linux.sh --quiet --show-progress
        sleep 2
        ;;
    "官方安装")
        echo "$fav ...."
        chmod +x burpsuite_pro_linux.sh
        sudo ./burpsuite_pro_linux.sh
        ;;
    "网盘安装")
        echo "$fav ...."
        chmod +x burpsuite_pro_linux_v2022_11.sh
        sudo ./burpsuite_pro_linux_v2022_11.sh
        ;;
    "破解补丁")
        echo "$fav ...."
        tail -n +"$lines" "$0" >/tmp/sfx_archive.tar.gz
        tar zxf /tmp/sfx_archive.tar.gz
        sudo cp -r sfx_archive/* /opt/BurpSuitePro/
        sudo chmod 644 /opt/BurpSuitePro/ja-netfilter.jar
        sudo chmod 755 /opt/BurpSuitePro/plugins
        sudo chmod 755 /opt/BurpSuitePro/config
        sudo rm -rf /tmp/sfx_archive.tar.gz sfx_archive
        ls -lah /opt/BurpSuitePro/
        ;;
    "运行注册机")
        echo "$fav ...."
        (/opt/BurpSuitePro/jre/bin/java --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED -jar /opt/BurpSuitePro/ja-netfilter.jar -r) >/dev/null 2>&1 &
        sleep 1s
        ;;
    "设置英文版")
        echo "$fav ...."
        sudo sed -i '10,18d' /opt/BurpSuitePro/BurpSuitePro.vmoptions
        sudo echo -e "\n--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED\n--add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED\n-javaagent:ja-netfilter.jar" | sudo tee -a /opt/BurpSuitePro/BurpSuitePro.vmoptions
        ;;
    "设置汉化版")
        echo "$fav ...."
        sudo sed -i '10,18d' /opt/BurpSuitePro/BurpSuitePro.vmoptions
        sudo echo -e "--add-opens=java.desktop/javax.swing=ALL-UNNAMED\n--add-opens=java.base/java.lang=ALL-UNNAMED\n--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED\n--add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED\n--add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED\n-javaagent:burpsuitloader-3.7.17-all.jar=loader,han\n-Xmx2048m" | sudo tee -a /opt/BurpSuitePro/BurpSuitePro.vmoptions
        ;;
    "退出安装..")
        echo "$fav ...."
        exit
        ;;
    *) echo "无效选项 $REPLY" ;;
    esac
done
exit 0