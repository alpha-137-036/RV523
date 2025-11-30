#include <stdint.h>
#include "printf/printf.h"

uint32_t fib(uint32_t n) {
    if (n < 2) {
        return 1;
    } else {
        return fib(n-1) + fib(n-2);
    }
}

typedef struct {
    volatile uint8_t out;
    uint8_t rfu[3];
} OUT_t;

#define OUT ((OUT_t*)0x40000000)

void putchar_(char c) {
    OUT->out = c;
}

int main(void) {
    printf_("Hello world: x = %d(0x%08X)", 42, 42);
}   
    //return fib(7);