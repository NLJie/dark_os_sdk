#!/bin/bash

# 定义颜色代码
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# 打印欢迎头
print_welcome_header() {
    # Dark OS 风格配色
    DARK_OS_CYAN='\033[38;5;87m'    # 亮青色
    DARK_OS_MAGENTA='\033[38;5;207m' # 亮品红
    DARK_OS_GREEN='\033[38;5;83m'    # 酸橙绿
    DARK_OS_YELLOW='\033[38;5;221m'  # 明黄
    DARK_OS_BLUE='\033[38;5;33m'     # 亮蓝
    DARK_OS_PURPLE='\033[38;5;99m'   # 紫罗兰
    NC='\033[0m' # 重置颜色

    # 渐变色标题
    echo -e "${DARK_OS_CYAN}"
    echo "======================================================================"
    echo -e "${DARK_OS_GREEN}\t ____                   _         ___    ____  "
    echo -e "${DARK_OS_YELLOW}\t|  _ \    __ _   _ __  | | __    / _ \  / ___| "
    echo -e "${DARK_OS_BLUE}\t| | | |  / _| | | '__| | |/ /   | | | | \___ \ "
    echo -e "${DARK_OS_PURPLE}\t| |_| | | (_| | | |    |   <    | |_| |  ___) |"
    echo -e "${DARK_OS_CYAN}\t|____/   \__,_| |_|    |_|\_\    \___/  |____/ "
    echo -e "${DARK_OS_MAGENTA}                                              "
    echo "======================================================================"
    echo -e "${NC}"

    # 项目信息（使用亮色突出）
    echo -e "${DARK_OS_GREEN}项目:${DARK_OS_YELLOW} ${PROJECT_NAME} ${DARK_OS_GREEN}(版本:${DARK_OS_YELLOW} ${PROJECT_VERSION}${DARK_OS_GREEN})"
    echo -e "${DARK_OS_CYAN}构建系统已启动...${NC}"
}

# 打印信息消息
print_info() {
    echo -e "${YELLOW}[INFO] $1${NC}"
}

# 打印成功消息
print_success() {
    echo -e "${GREEN}[SUCCESS] $1${NC}"
}

# 打印错误消息并退出
print_error() {
    echo -e "${RED}[ERROR] $1${NC}"
    exit 1
}

# 检查命令是否存在
check_command() {
    if ! command -v "$1" &> /dev/null; then
        print_error "未找到必需的命令: $1"
        return 1
    fi
    return 0
}