string(ASCII 27 Esc)

set(R "${Esc}[0;31m")       #红色
set(G "${Esc}[0;32m")       #绿色
set(GY "${Esc}[1;32;47m")       #绿色
set(E "${Esc}[m" )          #结束颜色设置
set(B "${Esc}[1;34m")       #蓝色高亮
set(RB "${Esc}[1;31;40m")   #红色字体黑色背景


set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${BUILD_ROOT_DIR}/usr/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${BUILD_ROOT_DIR}/usr/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${BUILD_ROOT_DIR}/usr/lib)