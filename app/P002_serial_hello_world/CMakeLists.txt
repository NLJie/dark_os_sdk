cmake_minimum_required(VERSION 3.10)
project(my_serial_app C)

# 添加子模块/组件库
add_subdirectory(/home/nlj/workspace3/github_lvgl/dark_os_sdk/components/dark_serial dark_serial)

# 添加你的应用程序
add_executable(my_app main.c)
target_include_directories(my_app PRIVATE /home/nlj/workspace3/github_lvgl/dark_os_sdk/components/dark_serial/include)
target_link_libraries(my_app PRIVATE serial)
