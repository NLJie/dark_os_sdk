#!/bin/bash

# 确保脚本在遇到错误时退出
set -e

# 获取当前脚本所在的目录
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# 定义 Python 脚本和配置文件的路径
PYTHON_SCRIPT="$SCRIPT_DIR/component_manager.py"
CONFIG_FILE="$SCRIPT_DIR/../components.yml"

# 检查 Python 脚本是否存在
if [ ! -f "$PYTHON_SCRIPT" ]; then
    echo "Error: Python script $PYTHON_SCRIPT not found."
    exit 1
fi

# 检查配置文件是否存在
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Configuration file $CONFIG_FILE not found."
    exit 1
fi

# 确保 Python 已安装
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is required but not installed."
    exit 1
fi

# 运行 Python 脚本
echo "Starting component management..."
python3 "$PYTHON_SCRIPT"

# 检查 Python 脚本的退出状态
if [ $? -eq 0 ]; then
    echo "Component management completed successfully."
else
    echo "Error: Component management failed."
    exit 1
fi