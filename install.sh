#!/bin/bash

set -e

# 配置：架构 -> "仓库地址::压缩包名称"
declare -A ARCH_INFO_REPOS=(
    [d21x]="https://github.com/NLJie/toolchains.git::riscv64-linux-glibc-x86_64-V2.10.1.tar.gz"
    [rk3568]="https://github.com/NLJie/toolchains.git::riscv64-linux-glibc-x86_64-V2.10.1.tar.gz"
)

DARK_ROOT_DIR="$(cd "$(dirname "$PWD")" && pwd)"
TOOLCHAIN_DIR="$DARK_ROOT_DIR/dark_os_tools"
JSON_PATH="$TOOLCHAIN_DIR/toolchains.json"

mkdir -p "$TOOLCHAIN_DIR"

declare -A TOOLCHAIN_JSON_ENTRIES

log() {
    echo -e "\033[1;36m[INFO]\033[0m $1"
}

warn() {
    echo -e "\033[1;33m[WARN]\033[0m $1"
}

error() {
    echo -e "\033[1;31m[ERROR]\033[0m $1"
}

install_toolchain() {
    local arch="$1"
    local repo="$2"
    local tar_name="$3"

    local clone_dir="${TOOLCHAIN_DIR}/${arch}"
    local base_name="${tar_name%.tar.gz}"
    local target_dir="${TOOLCHAIN_DIR}/${base_name}"

    log "开始安装架构: $arch"

    if [ -z "$repo" ] || [ -z "$tar_name" ]; then
        error "未知架构或缺少参数：$arch"
        return 1
    fi

    if [ -d "$clone_dir/.git" ]; then
        log "更新仓库: $clone_dir"
        git -C "$clone_dir" pull --quiet
    else
        log "克隆仓库: $repo"
        git clone --depth=1 "$repo" "$clone_dir"
    fi

    local tar_path="${clone_dir}/${tar_name}"
    if [ ! -f "$tar_path" ]; then
        error "未找到压缩包：$tar_path"
        return 1
    fi

    mkdir -p "$target_dir"

    log "解压压缩包: $tar_path -> $target_dir"
    tar -xzf "$tar_path" -C "$target_dir" --strip-components=1

    log "✅ ${arch} 工具链安装完成"

    # 构建 JSON 项
    TOOLCHAIN_JSON_ENTRIES["$target_dir"]=$(cat <<EOF
{
  "version": "1.0",
  "path": "$target_dir",
  "features": ["core"],
  "targets": ["$arch"]
}
EOF
)
}

# === 主流程 ===

# 获取所有需要处理的架构
if [ $# -eq 0 ]; then
    log "未指定架构，默认安装全部：${!ARCH_INFO_REPOS[@]}"
    targets=("${!ARCH_INFO_REPOS[@]}")
else
    targets=("$@")
fi

# 安装工具链
for arch in "${targets[@]}"; do
    if [[ -z "${ARCH_INFO_REPOS[$arch]}" ]]; then
        warn "跳过未知架构: $arch"
        continue
    fi

    entry="${ARCH_INFO_REPOS[$arch]}"
    repo_url="${entry%%::*}"
    archive_name="${entry##*::}"

    install_toolchain "$arch" "$repo_url" "$archive_name"
done

JSON_PATH="${TOOLCHAIN_DIR}/toolchains.json"
log "写入工具链 JSON 文件: $JSON_PATH"

{
    echo "{"
    echo "  \"idfInstalled\": {"

    index=1
    total=${#TOOLCHAIN_JSON_ENTRIES[@]}

    # 打印调试信息
    echo "[DEBUG] 共计 JSON 条目数: $total" >&2

    for path in "${!TOOLCHAIN_JSON_ENTRIES[@]}"; do
        ((index++))

        echo "[DEBUG] 正在写入第 $index 条: $path" >&2
        echo "[DEBUG] 对应 JSON: ${TOOLCHAIN_JSON_ENTRIES[$path]}" >&2

        echo -n "    \"${path}\": ${TOOLCHAIN_JSON_ENTRIES[$path]}"
        if [ $index -lt $total ]; then
            echo ","
        else
            echo ""
        fi
    done

    echo "  }"
    echo "}"
} > "$JSON_PATH"


log "✅ 所有工具链安装完毕并生成 JSON 文件：$JSON_PATH"
