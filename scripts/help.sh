#!/bin/bash

# help.sh - 显示构建脚本的帮助信息

print_help() {
    echo -e "\n\033[34m${PROJECT_NAME} 构建系统帮助\033[0m"
    echo "版本: ${PROJECT_VERSION}"
    echo ""
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  -h, --help         显示此帮助信息"
    echo "  -p, --platform     指定目标平台 (arm, esp32, riscv, x86, d21x)"
    echo "                     默认: arm"
    echo "  -c, --clean        清理构建目录"
    echo "  -v, --verbose      启用详细输出"
    echo "  --toolchain PATH   指定工具链路径"
    echo "  -a, --application  指定应用程序名称"
    echo ""
    echo "示例:"
    echo "  $0                  使用默认平台(arm)构建"
    echo "  $0 -p esp32        使用ESP32平台构建"
    echo "  $0 -p d21x -a P001_basic_demo"
    echo "                     使用 D21x 平台构建, P001_basic_demo 应用程序"
    echo "  $0 -c              清理构建目录"
    echo "  $0 -v              使用详细输出构建"
    echo ""
    echo "环境变量:"
    echo "  PLATFORM           覆盖默认平台设置"
    echo "  TOOLCHAIN_PATH    覆盖默认工具链路径"
    echo ""
}