ENTRY(_start)

SECTIONS {
  . = 0x00000000;   /* set desired start address */
  .text : {
    *(.text*)
  }
  
  . = 0x10000000;
  .rodata : {
    *(.rodata*)
  }

  . = 0x20000000;
  .data : {
    *(.data*)
    *(.bss*)
  }
}
