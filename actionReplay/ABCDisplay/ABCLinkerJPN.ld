OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(_start)

SECTIONS
{
    . = 0x020F9160;
    
    .text : {
        *(.text)
        *(.rodata)
        *(.data)
        *(.bss)
    }
}
