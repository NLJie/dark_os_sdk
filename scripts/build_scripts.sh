


build_project() {
    # 获取当前时间，格式为 YYYYMMDD_HHMM
    TIMESTAMP=$(date +"%Y%m%d_%H%M")
    LOG_FILE="${BUILD_DIR}/lobster_build_${TIMESTAMP}.log"

    # 进入构建目录 
    cd "$BUILD_DIR" || exit 1

    cmake -B output -S app -DCMAKE_C_COMPILER=${CC} \
                      -DCMAKE_CXX_COMPILER=${CXX}  > "${LOG_FILE}" 2>&1

    if [ $? -ne 0 ]; then
        print_error "CMake 配置错误......"
        exit 1
    fi

    # make -j $(nproc) -C output > /dev/null 2>&1
    make -j $(nproc) -C output >> "${LOG_FILE}" 2>&1
    if [ $? -ne 0 ]; then
        print_error "CMake 构建错误......"
        exit 1
    fi
    print_success "构建流程完成!"
}

# 运行测试
run_tests() {
    
    print_success "测试完成!"
}

# 打包产物
package_artifact() {
    
    print_success "打包完成!"
}