.org 0x00000000

_start:
.global _start
    li sp, 0x20000400
    
    call main
    
    ebreak
    
.end
