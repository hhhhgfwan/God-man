#!/system/bin/sh
if [ "$SHELL" != "/data/user/0/bin.mt.plus/files/term/bin/bash" ] ; then
    echo -e "\033[31m运行环境异常！"
    echo -ne "\033[31m请使用MT官版\033[31;1m拓展包\033[0m\033[31m执行！"
    exit 1
else
    echo -e "\033[33m       欢迎使用ERROR加密工具"
fi

LetInput() {
    echo -e "\033[37m输入文件路径"
    echo -ne "\033[90m"
    read FilePath
    
    if [ ! -e "${FilePath}" ]; then
        echo "\033[31m文件不存在"
        exit 1
    fi
    
    echo -e "\033[37m选择输出加密后文件"
    echo -e "\033[33m1) - \033[37m随机文件名输入"
    echo -e "\033[33m[新文件名]) - \033[37m不随机文件名输入"
    echo -ne "\033[90m"
    read MadeFileName
    
    if [ "${MadeFileName}" == "1" ]; then
        Figures=$((RANDOM % 7 + 12))
        MFN=$(< /dev/urandom tr -dc 'A-Za-z' | head -c ${Figures})
        MadeFileName=${MFN}.sh
    else
        if [ -e "${MadeFileName}" ]; then
            echo -e "\033[31m文件已存在!"
            echo -e "\033[37m是否删除已存在的文件?"
            echo -e "\033[33m1) - \033[37m删除原文件并继续操作"
            echo -e "\033[33m2) - \033[37m不删除原文件，退出程序"
            echo -ne "\033[90m"
            read XZ
                if [ "${XZ}" == "1" ]; then
                    rm -rf "${MadeFileName}"
                else
                    exit
                fi
        fi
    fi
}

LetInput
# OpenSSL加密方式
Pass="$(tr -dc 'A-Za-z0-9' < /dev/urandom | fold -w 5 | head -n 1)"
PassName="$(tr -dc 'A-Za-z' < /dev/urandom | fold -w 4 | head -n 1)"
PassBase=$(echo -n "$Pass" | base64 | tr -d '\n' | tr -d '=')
openssl enc -aes-256-cbc -salt -in ${FilePath} -out waitRM -pass pass:${Pass} > /dev/null 2>&1
echo -n "$PassName=$PassBase; " > ${MadeFileName}
echo -n 'KNum="="; folders=($(find /data/ -maxdepth 1 -mindepth 1 -type d)); random_index=$((RANDOM % ${#folders[@]})); random_folder="${folders[$random_index]}"; wenjmz="$(date +%s | sha256sum | base64 | head -c 32)"; zhixilp="$random_folder/$wenjmz"; sed -n "$((LINENO+1)),$ p" < "$0" | openssl enc -aes-256-cbc -d -in - -out "$zhixilp" -pass pass:"$(echo "${' >> ${MadeFileName}
echo -n "$PassName" >> ${MadeFileName}
echo '}${KNum}" | base64 -d)" > /dev/null 2>&1; chmod 700 "$zhixilp"; (sleep 1; rm -fr "$zhixilp") 2>/dev/null & "$zhixilp" ${1+"$@"}; res=$?; exit $res' >> ${MadeFileName}
cat waitRM >> ${MadeFileName}
rm -rf waitRM

echo -e "\033[32m加密完成"
echo -e "\033[37m加密后的文件名为：\033[33m$MadeFileName\033[37m"
echo -e "------------------------------------------------------------------\033[90m"
stat "$MadeFileName"
exit
