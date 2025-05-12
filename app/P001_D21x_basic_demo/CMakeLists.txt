# 1. 基础配置
cmake_minimum_required(VERSION 3.10)
project(P001_D21x_basic_demo)

set(CMAKE_C_STANDARD 99) # LVGL officially supports C99 and above
set(CMAKE_CXX_STANDARD 17) #C17

set(BUILD_ROOT_DIR "$ENV{PROJECT_ROOT}/build")
set(CMAKE_C_FLAGS "-Wall -O3")
set(CMAKE_CXX_FLAGS "-Wall -O3")
# set(CMAKE_BUILD_TYPE "Release")
set(CMAKE_BUILD_TYPE "Debug")

include(scripts/common_config.cmake)

message("${GY}==========> 开始编译工程：${PROJECT_NAME}${E}")
message("${GY}==========> 工程源文件目录: ${PROJECT_SOURCE_DIR}${E}")

# 2. 检查配置文件中的后端显示框架的配置
set(LV_CONF_PATH "${PROJECT_SOURCE_DIR}/lv_conf.h")
foreach(BACKEND_NAME "SDL" "LINUX_DRM" "LINUX_FBDEV" "X11" "WAYLAND" "OPENGLES" "EVDEV" "LINUX_DRAW_GE2D")
    execute_process(WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
                    COMMAND "scripts/backend_conf.sh" ${BACKEND_NAME} ${LV_CONF_PATH} OUTPUT_VARIABLE IS_BACKEND_ENABLED)
    set("LV_USE_${BACKEND_NAME}" ${IS_BACKEND_ENABLED})
endforeach()

if (LV_USE_LINUX_FBDEV)
    list(APPEND LV_LINUX_BACKEND_SRC lib/display_backends/fbdev.c)
    message("${GY}==========> Including FBDEV support${E}")
endif()

if (LV_USE_EVDEV)
    message("${GY}==========> Including EVDEV support${E}")
    list(APPEND LV_LINUX_BACKEND_SRC lib/indev_backends/evdev.c)
endif()

# 3. 添加子模块 lvgl
add_subdirectory("$ENV{PROJECT_ROOT}/build/lvgl" lvgl)
target_include_directories(lvgl PUBLIC ${PROJECT_SOURCE_DIR} ${PROJECT_SOURCE_DIR}/lib )

# # 4. 配置应用的源文件和头文件路径,并生成动态库
file(GLOB LV_LINUX_SRC lib/*.c)
set(LV_LINUX_INC lib/)

add_library(lvgl_linux STATIC ${LV_LINUX_SRC} ${LV_LINUX_BACKEND_SRC})
target_include_directories(lvgl_linux PRIVATE ${LV_LINUX_INC} ${PROJECT_SOURCE_DIR} ${BUILD_ROOT_DIR})

# 5. 添加可执行文件
add_executable(lvglsim main.c ${LV_LINUX_SRC} ${LV_LINUX_BACKEND_SRC})
target_link_libraries(lvglsim 
                    lvgl_linux 
                    lvgl 
                    lvgl::examples 
                    lvgl::demos 
                    lvgl::thorvg 
                    m pthread ${PKG_CONFIG_LIB})

target_include_directories(lvglsim PRIVATE ${LV_LINUX_INC} ${PROJECT_SOURCE_DIR} ${BUILD_ROOT_DIR})

# 6. 生成文件安装

install(TARGETS lvglsim
        RUNTIME DESTINATION ${BUILD_ROOT_DIR}/usr/bin
        LIBRARY DESTINATION ${BUILD_ROOT_DIR}/usr/lib
        ARCHIVE DESTINATION ${BUILD_ROOT_DIR}/usr/lib)

add_custom_command(
    TARGET lvglsim POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
            ${BUILD_ROOT_DIR}/output/lvgl/lib
            ${BUILD_ROOT_DIR}/usr/lib
    COMMENT "Copying library files after build"
)

# 7. 自定义部署

# 生成可执行文件
 
# 定义推送命令（在构建 my_app 后自动执行）
# add_custom_command(
#     TARGET lvglsim
#     POST_BUILD
#     COMMAND adb push $<TARGET_FILE:lvglsim> /root
#     COMMAND adb shell "pkill -f '/root/lvglsim'"
#     # COMMAND adb shell /root/lvglsim &
#     COMMENT "Pushing executable to Android device..."
# )