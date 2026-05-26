.arm
.global _start

.equ RNG_ADDR,      0x020EEE90
.equ BG_TILE_BASE,  0x06007E00
.equ BG_MAP_BASE,   0x0600F000
.equ GLYPH_0,       0x01FF9C18

@ NDS Hardware IRQ Vector and Default ITCM Return Address
.equ IRQ_VECTOR,    0x027E3FFC
.equ ORIG_IRQ,      0x01FF8000

_start:
    @ ====================================================
    @ INSTALLER (Hooked at 0x021898d4 in Overlay 14)
    @ ====================================================
    @ Save all registers and the new Link Register
    stmdb sp!, {r0-r12, lr}

    @ 1. Check if the IRQ vector is already hijacked
    ldr r0, =IRQ_VECTOR
    ldr r1, [r0]
    ldr r2, =irq_handler
    cmp r1, r2
    beq exit_installer      @ If already installed, skip

    @ 2. Install the IRQ hook (Overwrite vector with handler address)
    str r2, [r0]

exit_installer:
    @ Restore all registers
    ldmia sp!, {r0-r12, lr}

    @ 3. Re-execute the hijacked instruction and return
    mov r7, r0
    bx lr

irq_handler:
    @ ====================================================
    @ PAYLOAD (Per-frame)
    @ ====================================================
    @ Make a 4-byte gap on the stack, then save registers
    sub sp, sp, #0x4          
    stmdb sp!, {r0-r12, lr}   

    @ Enable BG2
    ldr r0, =0x04000000
    ldrh r1, [r0]
    orr r1, r1, #0x0400
    strh r1, [r0]

    @ Setup BG Palette 0 (Color 1: Black, Color 15: White)
    ldr r0, =0x05000000
    mov r1, #0
    strh r1, [r0, #2]   
    ldr r1, =0x7FFF
    strh r1, [r0, #30]  

    @ Refresh glyphs in VRAM (Safe in VBlank)
    bl convert_glyphs

    @ Load RNG
    ldr r0, =RNG_ADDR
    ldr r0, [r0]

    @ Preserve original RNG value
    mov r8, r0

    @ ====================================================
    @ Draw RNG seed (8 hex digits)
    @ ====================================================

    ldr r1, =BG_MAP_BASE
    mov r2, #8

draw_loop:
    @ ====================================================
    @ ROW 1: "A"
    @ ====================================================

    ldr r1, =BG_MAP_BASE
    add r1, r1, #0x40          @ row 1
    mov r0, #10                @ A
    add r0, r0, #0x3F0
    strh r0, [r1]

    @ ====================================================
    @ ROW 2: hex value @020EEE90
    @ ====================================================

    ldr r0, =0x020EEE90
    ldr r0, [r0]

    mov r8, r0          @ preserve original first

    ldr r1, =BG_MAP_BASE
    add r1, r1, #0x80

    bl draw_hex8

    @ ====================================================
    @ ROW 3: decimal derived value
    @ ((rng >> 16) & 0x7FFF)
    @ ====================================================

    mov r0, r8, lsr #16
    ldr r3, =0x7FFF
    and r0, r0, r3

    ldr r1, =BG_MAP_BASE
    add r1, r1, #0xC0          @ row 3

    ldr r2, =10000
    bl draw_decimal_digit

    ldr r2, =1000
    bl draw_decimal_digit

    ldr r2, =100
    bl draw_decimal_digit

    ldr r2, =10
    bl draw_decimal_digit

    add r0, r0, #0x3F0
    strh r0, [r1], #2

    @ ====================================================
    @ ROW 5: "B"
    @ ====================================================

    ldr r1, =BG_MAP_BASE
    add r1, r1, #0x140         @ row 5
    mov r0, #11                @ B
    add r0, r0, #0x3F0
    strh r0, [r1]

    @ ====================================================
    @ ROW 6: hex value @02108D24
    @ ====================================================

    ldr r0, =0x02108D24
    ldr r0, [r0]

    ldr r1, =BG_MAP_BASE
    add r1, r1, #0x180         @ row 6

    bl draw_hex8

    @ ====================================================
    @ ROW 7: hex value @02108D20
    @ ====================================================

    ldr r0, =0x02108D20
    ldr r0, [r0]

    ldr r1, =BG_MAP_BASE
    add r1, r1, #0x1C0         @ row 7

    bl draw_hex8

    @ ====================================================
    @ ROW 9: "C"
    @ ====================================================

    ldr r1, =BG_MAP_BASE
    add r1, r1, #0x240         @ row 9
    mov r0, #12                @ C
    add r0, r0, #0x3F0
    strh r0, [r1]

    @ ====================================================
    @ ROW 10: hex value @02385F10
    @ ====================================================

    ldr r0, =0x02385F10
    ldr r0, [r0]

    ldr r1, =BG_MAP_BASE
    add r1, r1, #0x280         @ row 10

    bl draw_hex8

    @ ====================================================
    @ ROW 11: hex value @02385F0C
    @ ====================================================

    ldr r0, =0x02385F0C
    ldr r0, [r0]

    ldr r1, =BG_MAP_BASE
    add r1, r1, #0x2C0         @ row 11

    bl draw_hex8

exit_irq:
    @ Write original IRQ address
    ldr r12, =ORIG_IRQ
    str r12, [sp, #56]          
    
    @ Pop registers, pulling the ORIG_IRQ address directly into the PC
    ldmia sp!, {r0-r12, lr, pc} 

@ ====================================================
@ draw_hex8
@
@ IN:
@   r0 = value
@   r1 = BG map destination
@ ====================================================

draw_hex8:
    stmdb sp!, {r2-r4, lr}

    mov r2, #8

hex_loop:
    mov r3, r0, lsr #28
    add r3, r3, #0x3F0
    strh r3, [r1], #2

    mov r0, r0, lsl #4

    subs r2, r2, #1
    bne hex_loop

    ldmia sp!, {r2-r4, pc}

@ ====================================================
@ draw_decimal_digit
@
@ IN:
@   r0 = remaining value
@   r1 = BG map ptr
@   r2 = divisor
@
@ OUT:
@   r0 = remainder
@   r1 advanced
@ ====================================================

draw_decimal_digit:
    stmdb sp!, {r3-r5, lr}

    mov r3, #0              @ digit counter

dec_loop:
    cmp r0, r2
    blt dec_done

    sub r0, r0, r2
    add r3, r3, #1
    b dec_loop

dec_done:
    add r4, r3, #0x3F0
    strh r4, [r1], #2

    ldmia sp!, {r3-r5, pc}

@ ====================================================
@ convert_glyphs
@ Source: 0x01FF9C18 + digit*8
@ Dest:   0x06007E00 + digit*32
@ ====================================================
convert_glyphs:
    stmdb sp!, {r4-r7, lr}
    mov r4, #0                  

glyph_loop:
    ldr r0, =GLYPH_0            
    add r0, r0, r4, lsl #3      
    
    ldr r1, =BG_TILE_BASE       
    add r1, r1, r4, lsl #5      
    
    mov r2, #8                  

row_loop:
    ldrb r3, [r0], #1           
    ldr r5, =0x11111111         

    tst r3, #0x01
    orrne r5, r5, #0x0000000E
    tst r3, #0x02
    orrne r5, r5, #0x000000E0
    tst r3, #0x04
    orrne r5, r5, #0x00000E00
    tst r3, #0x08
    orrne r5, r5, #0x0000E000
    tst r3, #0x10
    orrne r5, r5, #0x000E0000
    tst r3, #0x20
    orrne r5, r5, #0x00E00000
    tst r3, #0x40
    orrne r5, r5, #0x0E000000
    tst r3, #0x80
    orrne r5, r5, #0xE0000000

    str r5, [r1], #4            
    subs r2, r2, #1
    bne row_loop

    add r4, r4, #1
    cmp r4, #16
    blt glyph_loop

    ldmia sp!, {r4-r7, pc}
