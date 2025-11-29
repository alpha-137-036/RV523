#include <stdint.h>

uint32_t fib(uint32_t n) {
    if (n < 2) {
        return 1;
    } else {
        return fib(n-1) + fib(n-2);
    }
}

int main(void) {
    asm("li t0, 0x20000000\n"
        "li t1, 0xA5\n"
        "sb t1, 0(t0)\n"
        "li t1, 0xA6\n"
        "sb t1, 5(t0)\n"
        "li t1, 0xA7\n"
        "sb t1, 10(t0)\n"
        "li t1, 0xA8\n"
        "sb t1, 15(t0)\n"
        "lw t1, 0(t0)\n"
        "lw t1, 4(t0)\n"
        "lw t1, 8(t0)\n"
        "lw t1, 12(t0)\n"
        "lb t1, 0(t0)\n"
        "lb t1, 5(t0)\n"
        "lb t1, 10(t0)\n"
        "lb t1, 15(t0)\n"
        "lbu t1, 0(t0)\n"
        "lbu t1, 5(t0)\n"
        "lbu t1, 10(t0)\n"
        "lbu t1, 15(t0)\n"
        "lh  t1, 0(t0)\n"
        "lh  t1, 4(t0)\n"
        "lh  t1, 10(t0)\n"
        "lh  t1, 14(t0)\n"
        "lhu  t1, 0(t0)\n"
        "lhu  t1, 4(t0)\n"
        "lhu  t1, 10(t0)\n"
        "lhu  t1, 14(t0)\n"
        
        "li   t1, 0xfedc\n"
        "sh   t1, 16(t0)\n"
        "li   t1, 0xfeaa\n"
        "sh   t1, 22(t0)\n"
        "lw   t1, 16(t0)\n"
        "lw   t1, 20(t0)\n"
        "lh   t1, 16(t0)\n"
        "lh   t1, 22(t0)\n"
        "lhu   t1, 16(t0)\n"
        "lhu   t1, 22(t0)\n"
    );
    
    
    //return fib(7);
}