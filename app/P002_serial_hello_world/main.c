#include <stdio.h>
#include <string.h>
#include <termios.h>   // <== 添加这个头文件
#include "serial.h"

int main() {
    int fd = serial_open("/dev/ttyUSB0", B9600);  // B9600 定义于 termios.h
    if (fd < 0) {
        perror("serial_open failed");
        return 1;
    }

    const char *msg = "Hello from app\n";
    serial_write(fd, msg, strlen(msg));

    char buf[100];
    int n = serial_read(fd, buf, sizeof(buf)-1);
    if (n > 0) {
        buf[n] = '\0';
        printf("Received: %s\n", buf);
    }

    serial_close(fd);
    return 0;
}
