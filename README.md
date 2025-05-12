
# 📦 dark_os_sdk

## 🌟 项目亮点

## 🖼️ 效果预览

## 🛠️ 快速开始

git clone https://github.com/NLJie/dark_os_sdk.git
cd dark_os_sdk
git submodule update --init --recursive
./build.sh -p d21x -a P001_D21x_basic_demo


## 📂 项目结构

```
项目根目录/
├── Application         # 应用程序代码
│   ├── P001_xxxx       # 基础示例
├── build               # 编译过程代码，可以删除
├── build.sh            # 编译脚本
├── components          # 组件库
├── doc                 # 文档
├── libs                # 平台库文件
│   ├── D21x
├── scripts             # 构建脚本
├── source
│   ├── drivers
│   └── lvgl            # LVGL 子模块
└── tools
    └── toolchains      # 交叉编译工具 子模块
```