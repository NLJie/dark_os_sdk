#!/bin/bash

# 设置项目环境变量


# 设置项目根目录
export PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# 设置构建目录
export BUILD_DIR="${PROJECT_ROOT:-$(pwd)}/build"
export OUTPUT_DIR="${BUILD_DIR}/output"

D21x_TOOLCHAIN_PATH="${PROJECT_ROOT}/tools/toolchains/riscv64-linux-glibc-x86_64-V2.10.1.tar.gz"

# 根据平台设置工具链路径和编译器
setup_toolchain() {
    case "$PLATFORM" in
        arm)
            # ARM 工具链配置
            export TOOLCHAIN_PATH="${TOOLCHAIN_PATH:-/opt/arm-none-eabi}"
            export CC="arm-none-eabi-gcc"
            export CXX="arm-none-eabi-g++"
            export AR="arm-none-eabi-ar"
            export OBJCOPY="arm-none-eabi-objcopy"
            export SIZE="arm-none-eabi-size"
            ;;
        esp32)
            # ESP32 工具链配置
            # export TOOLCHAIN_PATH="${TOOLCHAIN_PATH:-${PROJECT_ROOT/tools/toolchains}/riscv64-linux-glibc-x86_64-V2.10.1}"
            export TOOLCHAIN_PATH="${TOOLCHAIN_PATH:-${PROJECT_ROOT}/tools/toolchains/riscv64-linux-glibc-x86_64-V2.10.1}"
            export CC="xtensa-esp32-elf-gcc"
            export CXX="xtensa-esp32-elf-g++"
            export AR="xtensa-esp32-elf-ar"
            export OBJCOPY="xtensa-esp32-elf-objcopy"
            export SIZE="xtensa-esp32-elf-size"
            ;;
        d21x)
            # D21x 工具链配置
            if [ -f "$D21x_TOOLCHAIN_PATH" ]; then
                print_info "工具链文件存在: $D21x_TOOLCHAIN_PATH"
                if [ ! -d "${PROJECT_ROOT}/tools/toolchains/riscv64-linux-glibc-x86_64-V2.10.1" ]; then
                    print_info "解压工具链..."
                    tar -xvf "$D21x_TOOLCHAIN_PATH" -C "${PROJECT_ROOT}/tools/toolchains/"
                fi
                print_success "工具链解压完成"
            else
                print_error "工具链文件不存在: $D21x_TOOLCHAIN_PATH"
                exit 1
            fi
        
            export TOOLCHAIN_PATH="${TOOLCHAIN_PATH:-${PROJECT_ROOT}/tools/toolchains/riscv64-linux-glibc-x86_64-V2.10.1}"
            export CC="riscv64-unknown-linux-gnu-gcc"
            export CXX="riscv64-unknown-linux-gnu-g++"
            export AR="riscv64-unknown-linux-gnu-ar"
            export OBJCOPY="riscv64-unknown-linux-gnu-objcopy"
            export SIZE="riscv64-unknown-linux-gnu-size"
            ;;
        riscv)
            # RISC-V 工具链配置
            export TOOLCHAIN_PATH="${TOOLCHAIN_PATH:-/opt/riscv64-unknown-elf}"
            export CC="riscv64-unknown-elf-gcc"
            export CXX="riscv64-unknown-elf-g++"
            export AR="riscv64-unknown-elf-ar"
            export OBJCOPY="riscv64-unknown-elf-objcopy"
            export SIZE="riscv64-unknown-elf-size"
            ;;
        x86)
            # x86 平台 (使用系统默认编译器)
            export TOOLCHAIN_PATH=""
            export CC="gcc"
            export CXX="g++"
            export AR="ar"
            export OBJCOPY="objcopy"
            export SIZE="size"
            ;;
        *)
            print_error "未知平台: $PLATFORM"
            exit 1
            ;;
    esac

    # 更新PATH环境变量
    if [ -n "$TOOLCHAIN_PATH" ]; then
        export PATH="$TOOLCHAIN_PATH/bin:$PATH"
    fi
}

# LVGL 相关配置
export LVGL_DIR="${PROJECT_ROOT}/source/lvgl"
export LVGL_CONFIG_FILE="${PROJECT_ROOT}/configs/lv_conf.h"

# 平台特定库配置
setup_platform_libs() {
    case "$PLATFORM" in
        arm)
            # ARM 平台特定库
            export LCD_LIB="${PROJECT_ROOT}/libs/arm/lcd"
            export INPUT_LIB="${PROJECT_ROOT}/libs/arm/input"
            ;;
        d21x)
            # D21x 平台特定库
            export ESP_IDF_PATH="${ESP_IDF_PATH:-/opt/esp/esp-idf}"
            export LCD_LIB="${PROJECT_ROOT}/libs/D21x/lcd"
            export INPUT_LIB="${PROJECT_ROOT}/libs/D21x/input"
            ;;
        esp32)
            # ESP32 平台特定库
            export ESP_IDF_PATH="${ESP_IDF_PATH:-/opt/esp/esp-idf}"
            export LCD_LIB="${PROJECT_ROOT}/libs/esp32/lcd"
            export INPUT_LIB="${PROJECT_ROOT}/libs/esp32/input"
            ;;
        riscv)
            # RISC-V 平台特定库
            export LCD_LIB="${PROJECT_ROOT}/libs/riscv/lcd"
            export INPUT_LIB="${PROJECT_ROOT}/libs/riscv/input"
            ;;
        x86)
            # x86 平台特定库
            export LCD_LIB="${PROJECT_ROOT}/libs/x86/lcd"
            export INPUT_LIB="${PROJECT_ROOT}/libs/x86/input"
            ;;
    esac
}

# 打印信息函数
print_info() {
    echo -e "\033[34m[INFO]\033[0m $1"
}

# 打印成功信息函数
print_success() {
    echo -e "\033[32m[SUCCESS]\033[0m $1"
}

# 打印错误信息函数
print_error() {
    echo -e "\033[31m[ERROR]\033[0m $1"
}

# 验证环境设置
verify_environment() {
    print_info "验证环境设置..."
    
    # 检查工具链是否存在
    if ! command -v $CC &> /dev/null; then
        print_error "未找到 $CC 编译器，请确保已安装 $PLATFORM 工具链并配置 PATH"
        exit 1
    fi
    
    # 检查 LVGL 子模块是否存在
    if [ ! -d "$LVGL_DIR" ]; then
        print_error "LVGL 子模块未找到，请先运行 git submodule update --init --recursive"
        exit 1
    fi
    
    # 检查平台特定库是否存在
    if [ ! -d "$LCD_LIB" ]; then
        print_error "平台特定 LCD 库未找到: $LCD_LIB"
        exit 1
    fi
    
    if [ ! -d "$INPUT_LIB" ]; then
        print_error "平台特定输入库未找到: $INPUT_LIB"
        exit 1
    fi
    
    print_success "环境验证通过"
}

# 初始化函数
initialize() {

    # 检查应用程序变量
    APP_DIR="${PROJECT_ROOT}/Application/${APPLICATION}"
    if [ -z "$APPLICATION" ]; then
        print_error "应用程序名称未设置，请使用 -a 选项指定应用程序"
        print_error "应用程序目录未找到: $APP_DIR"
        # 列出可用的应用程序目录
        echo "可用的应用程序目录:"
        find "${PROJECT_ROOT}/Application" -maxdepth 1 -type d | sed 's|.*/||' | grep -v '^.$'
        exit 1
    elif [ ! -d "$APP_DIR" ]; then
        print_error "应用程序目录未找到: $APP_DIR"
        # 列出可用的应用程序目录
        echo "可用的应用程序目录:"
        find "${PROJECT_ROOT}/Application" -maxdepth 1 -type d | sed 's|.*/||' | grep -v '^.$'
        exit 1
    fi
    # print_success "应用程序目录: $APP_DIR"

    # 创建构建目录
    mkdir -p "$BUILD_DIR"
    mkdir -p "$OUTPUT_DIR"
    print_info "============================================================="
    print_info "项目初始化完成"
    print_info "平台: $PLATFORM"
    print_info "工具链: $TOOLCHAIN_PATH"
    print_info "编译器: $CC"
    print_info "应用程序: $APP_DIR"
    print_info "构建目录: $BUILD_DIR"
    print_info "输出目录: $OUTPUT_DIR"
    print_info "============================================================="

    # 使用链接文件将应用程序目录链接到构建目录
    if [ -d "$BUILD_DIR/app" ]; then
        rm -rf "$BUILD_DIR/app"
    fi
    ln -sf "$APP_DIR" "$BUILD_DIR/app"
    
    

    # 链接 LVGL 目录到构建目录
    if [ -d "$BUILD_DIR/lvgl" ]; then
        rm -rf "$BUILD_DIR/lvgl"
    fi
    ln -sf "$LVGL_DIR" "$BUILD_DIR/lvgl"
    

}

# 主函数
main() {
    setup_toolchain
    setup_platform_libs
    verify_environment
    initialize
    
    print_success "构建环境准备完成，开始构建,请等待。。。。"
}

# 执行主函数
main


# 加载编译脚本
source "$(dirname "$0")/scripts/build_scripts.sh"

# 编译工程
build_project

# 运行测试
run_tests

# 打包产物
package_artifact
