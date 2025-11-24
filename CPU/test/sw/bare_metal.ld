ENTRY(_start)

SECTIONS {
  . = 0x00000000;   /* set desired start address */
  .text : {
    *(.text*)
  }
  
  
  . = 0x20000000;
  .data : {
    *(.data*)
    *(.bss*)
  }
}
