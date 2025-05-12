#!/bin/bash

export PLATFORM=arm  # 默认平台
export VERBOSE=0
export CLEAN=0

source "$(dirname "$0")/scripts/help.sh"

# 加载工具函数
source "$(dirname "$0")/scripts/utils.sh"

clean() {
    rm -rf build
    echo ""
    print_success "已清理构建目录和输出目录"
    echo ""
}

# 解析命令行参数
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) print_help; exit 0 ;;
        -p|--platform) PLATFORM="$2"; shift ;;
        -a|--application) APPLICATION="$2"; shift ;;
        -c|--clean) clean; exit 0 ;;
        -v|--verbose) VERBOSE=1 ;;
        --toolchain) TOOLCHAIN_PATH="$2"; shift ;;
        *) echo "未知参数: $1"; exit 1 ;;
    esac
    shift
done


# 显示欢迎头
print_welcome_header

# 加载环境配置
source "$(dirname "$0")/scripts/env_setup.sh"
