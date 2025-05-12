# 基础案例工程

LV_USE_SYSMON 1
LV_USE_PERF_MONITOR 1

# 提升帧率的方法

## 匹配帧 buffer 大小

LV_LINUX_FBDEV_BUFFER_SIZE   1024

## 使用双 buffer

## 优化编译等级

这里使用Camek的编译方法，其他编译方法类似;

set(CMAKE_C_FLAGS "-Wall -O3")

set(CMAKE_CXX_FLAGS "-std=c++11 -Wall -O3")

## 设置屏幕刷新间隔

LV_DEF_REFR_PERIOD  16      /**< [ms]    1 / 0.016 ~= 62 fps max 62 max    */ 

| 截至优化到这里，纯软件绘制图形已经能达到很好的效果，到那时多元素，动图帧率还是很低，而且CPU占用率很高；

## ARM 指令集优化

## 添加硬件解码

ADD AIC_GE2D
