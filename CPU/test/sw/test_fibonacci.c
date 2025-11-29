#include <stdint.h>

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

void printString(const char* s) {
    while (1) {
        char c = *s;
        if (c == 0) break;
        OUT->out = c;
        s++;
    }
}

int main(void) {
    printString("Hello world");
}   
    //return fib(7);