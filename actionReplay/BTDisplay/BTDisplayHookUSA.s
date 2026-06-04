.arm
.global _start

.equ RNG_HI,        0x02108DE0
.equ RNG_LO,        0x02108DDC
.equ BG_TILE_BASE,  0x06007E00      @ tile 0x3F0 (start of glyphs)
.equ BLANK_TILE,    0x06007DE0      @ tile 0x3EF (blank tile)
.equ BG_MAP_BASE,   0x0600F000
.equ GLYPH_0,       0x01FF9838

@ NDS Hardware IRQ Vector and Default ITCM Return Address
.equ IRQ_VECTOR,    0x027E3FFC
.equ ORIG_IRQ,      0x01FF8000

_start:
    @ ====================================================
    @ INSTALLER (Hooked at 0x02188A90 in Overlay 14)
    @ ====================================================
    stmdb sp!, {r0-r12, lr}

    ldr r0, =IRQ_VECTOR
    ldr r1, [r0]
    ldr r2, =irq_handler
    cmp r1, r2
    beq exit_installer      @ If already installed, skip

    str r2, [r0]            @ Hijack IRQ vector

exit_installer:
    ldmia sp!, {r0-r12, lr}
    mov r7, r0              @ Original instruction replacement
    bx lr

irq_handler:
    @ ====================================================
    @ PAYLOAD (Per-frame)
    @ ====================================================
    sub sp, sp, #0x4          
    stmdb sp!, {r0-r12, lr}   

    @ --- INPUT HANDLING & TOGGLE ---
    ldr r0, =0x04000130
    ldrh r1, [r0]
    mvn r1, r1              
    ldr r2, =prev_keys
    ldr r3, [r2]
    str r1, [r2]            

    tst r1, #8
    beq check_toggle_state  
    tst r3, #8
    bne check_toggle_state  

    @ Start was just pressed -> Flip toggle state
    ldr r2, =toggle_state
    ldr r3, [r2]
    eor r3, r3, #1
    str r3, [r2]

    @ --- INITIALIZE IF TOGGLED ON ---
    cmp r3, #1
    bne check_toggle_state

    @ Refresh glyphs in VRAM and create blank tile
    bl convert_glyphs
    
check_toggle_state:
    ldr r2, =toggle_state
    ldr r3, [r2]
    cmp r3, #0
    beq disable_display

    @ --- ENABLE DISPLAY ---
    ldr r0, =0x04000000
    ldrh r1, [r0]
    orr r1, r1, #0x0400     @ Enable BG2
    strh r1, [r0]

    @ Setup BG Palette 0 (Color 1: Black, Color 15: White)
    ldr r0, =0x05000000
    mov r1, #0
    strh r1, [r0, #2]   
    ldr r1, =0x7FFF
    strh r1, [r0, #30]  

    @ ====================================================
    @ Draw Current RNG seed (Top left)
    @ ====================================================
    ldr r0, =RNG_HI
    ldr r0, [r0]
    ldr r1, =BG_MAP_BASE
    bl draw_hex8            @ Row 0

    ldr r0, =RNG_LO
    ldr r0, [r0]
    ldr r1, =BG_MAP_BASE
    add r1, r1, #0x40       @ Row 1
    bl draw_hex8

    @ ====================================================
    @ Blank remainder of Rows 0 and 1 (Columns 8 to 31)
    @ ====================================================
    ldr r1, =BG_MAP_BASE
    add r1, r1, #16         @ Offset to Row 0, Column 8 (8 tiles * 2 bytes)
    ldr r3, =0x03EF         @ Blank tile index
    mov r2, #2              @ 2 rows (Row 0 and Row 1)

row01_blank_outer:
    mov r4, #24             @ 24 columns left to blank in the row (32 - 8 = 24)
row01_blank_inner:
    strh r3, [r1], #2       @ Store blank tile, advance to next column
    subs r4, r4, #1
    bne row01_blank_inner

    @ After 24 tiles (48 bytes), r1 is at Base + 16 + 48 = Base + 64 (0x40).
    @ This means r1 is currently pointing EXACTLY at Row 1, Column 0.
    @ Add 16 to skip the 8 RNG tiles we just drew on Row 1.
    add r1, r1, #16         

    subs r2, r2, #1         @ Check if both rows done
    bne row01_blank_outer

    @ ====================================================
    @ Blank Even Rows (> 0) (Rows 2, 4, 6... 22)
    @ ====================================================
    ldr r1, =BG_MAP_BASE
    add r1, r1, #0x80       @ Start at Row 2 offset (2 * 0x40 = 0x80)
    ldr r3, =0x03EF         @ Load the blank tile constant
    mov r2, #2              @ Initialize row counter at 2

even_rows_outer:
    mov r4, #32             @ 32 columns (tiles) to clear per row
even_rows_inner:
    strh r3, [r1], #2       @ Store blank tile and advance 2 bytes (1 column)
    subs r4, r4, #1
    bne even_rows_inner

    @ After the inner loop, r1 is pointing at the start of the next (odd) row.
    @ Add 0x40 (64 bytes) to r1 to skip that odd row and reach the next even row.
    add r1, r1, #0x40       

    add r2, r2, #2          @ Increment row counter by 2
    cmp r2, #24             @ NDS screen height is 24 rows (0 to 23)
    blt even_rows_outer

    @ ====================================================
    @ Draw Table Headers (Flicker-Free Gap Filling)
    @ ====================================================
    ldr r1, =BG_MAP_BASE
    add r1, r1, #0xC0       @ Start at Row 3 (3 * 0x40 = 0xC0)
    ldr r4, =0x03EF         @ Blank tile index constant

    @ 1. Make Row 3 Columns 0 and 1 blank
    strh r4, [r1], #2       @ Write Blank to Col 0, advance r1
    strh r4, [r1], #2       @ Write Blank to Col 1, advance r1

    @ (r1 is now pointing exactly at Row 3, Column 2)

    @ 2. Write 10 blocks of [Blank, Blank, Digit]
    mov r2, #0              @ Header digit counter (0 to 9)

row3_loop:
    @ Write the 2 blank tiles before the header
    strh r4, [r1]           @ Write Blank to 1st col of the block
    strh r4, [r1, #2]       @ Write Blank to 2nd col of the block

    @ Write the actual Header digit
    add r3, r2, #0x3F0      @ Calculate header tile (0x3F0 + digit)
    strh r3, [r1, #4]       @ Write Header digit to 3rd col of the block

    @ Advance and repeat
    add r1, r1, #6          @ Advance pointer by 3 columns (6 bytes)
    add r2, r2, #1
    cmp r2, #10
    blt row3_loop

    @ COLS 0 & 1 Constants (00, 10, ... 90) at rows 5, 7, 9...
    ldr r1, =BG_MAP_BASE
    add r1, r1, #0x140      @ Row 5 (5 * 0x40)
    mov r2, #0
cols_loop:    
    mov r4, r2              @ r4 = Tens digit (0, 1, 2...)
    
    @ 1. Handle the Tens Digit (Col 0)
    cmp r4, #0
    beq use_blank           @ If 0, jump to load blank
    
    @ Else case:
    add r3, r4, #0x3F0
    b store_tens            @ Jump over the blank-loading code

use_blank:
    ldr r3, =0x03EF         @ Load the constant safely using a literal pool

store_tens:
    strh r3, [r1]           @ Store in Tens column

    @ 2. Handle the Units Digit (Col 1)
    ldr r3, =0x3F0          @ Tile for '0'
    strh r3, [r1, #2]       @ Store in Units column

    @ 3. Advance and Loop
    add r1, r1, #0x80       @ Advance 2 rows
    add r2, r2, #1
    cmp r2, #10
    blt cols_loop

    @ ====================================================
    @ Calculate & Draw LCG Percentages (100 Seeds)
    @ ====================================================
    ldr r0, =RNG_HI
    ldr r9, [r0]            @ r9 = seed_hi
    ldr r0, =RNG_LO
    ldr r8, [r0]            @ r8 = seed_lo

    ldr r4, =BG_MAP_BASE
    ldr r3, =0x144          @ Load the offset into a temp register
    add r4, r4, r3          @ Add the register to the pointer
    
    mov r5, #0              @ Column counter (0-9)
    mov r10, #100         @ Total seeds loop counter

    ldr r11, =0x5D588B65    @ Multiplier High
    ldr r12, =0x6C078965    @ Multiplier Low

seed_loop:
    @ 1. Calculate percentage = (seed_hi * 100) >> 32
    mov r0, #100
    umull r1, r2, r9, r0    @ r2 = percentage (0 to 99)

    @ 2. Split into Tens and Units for drawing
    mov r3, #0              @ Tens counter
div10_loop:
    cmp r2, #10
    blt div10_done
    sub r2, r2, #10
    add r3, r3, #1
    b div10_loop
div10_done:
    ldr r0, =0x03EF
    strh r0, [r4]           @ Store Blank at Col 1 of this block

    @ Right Align Tens: If tens (r3) == 0, print space (0x3EF), else print digit
    cmp r3, #0
    ldreq r0, =0x03EF
    addne r0, r3, #0x3F0
    strh r0, [r4, #2]       @ Store Tens at Col 2 of this block

    add r0, r2, #0x3F0
    strh r0, [r4, #4]       @ Store Units at Col 3 of this block (always print)

    @ 3. Advance Map Pointer
    add r4, r4, #6          @ Col += 3 (3 tiles * 2 bytes = 6 bytes)
    add r5, r5, #1
    cmp r5, #10
    blt next_lcg
    
    @ Newline (reset col count, row += 2, rewind col back to 4)
    mov r5, #0
    add r4, r4, #0x80       @ Advance 2 rows (128 bytes)
    sub r4, r4, #60         @ Rewind 10 items * 3 cols * 2 bytes = 60 bytes

next_lcg:
    @ 4. Compute next LCG Seed (Do not store back to game memory)
    @ Res = (Seed * Multiplier) + Increment (all 64-bit)
    umull r0, r3, r8, r12   @ r0 = (seed_lo * mul_lo)_lo, r3 = carry
    mla r3, r8, r11, r3     @ r3 += seed_lo * mul_hi
    mla r3, r9, r12, r3     @ r3 += seed_hi * mul_lo
    
    ldr r1, =0x00269EC3     @ Increment
    adds r8, r0, r1         @ next_seed_lo = res_lo + inc
    adc r9, r3, #0          @ next_seed_hi = res_hi + carry

    subs r10, r10, #1
    bne seed_loop

    b payload_exit

disable_display:
    @ Turn off BG2 cleanly
    ldr r0, =0x04000000
    ldrh r1, [r0]
    bic r1, r1, #0x0400
    strh r1, [r0]

payload_exit:
    @ Restore state and return to original IRQ Vector
    ldmia sp!, {r0-r12, lr}
    add sp, sp, #0x4
    ldr pc, =ORIG_IRQ

@ ====================================================
@ draw_hex8
@ IN: r0 = value, r1 = BG map destination
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
@ convert_glyphs
@ Builds hex digits and an explicitly black tile
@ ====================================================
convert_glyphs:
    stmdb sp!, {r4-r7, lr}

    @ 1. Generate Blank Tile at 0x3EF (0x06007DE0)
    ldr r1, =BLANK_TILE
    ldr r5, =0x11111111     @ Fill with Color 1 (Black)
    mov r2, #8
blank_loop:
    str r5, [r1], #4
    subs r2, r2, #1
    bne blank_loop

    @ 2. Generate Hex Digits (0x3F0 - 0x3FF)
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

@ ====================================================
@ VARIABLES
@ ====================================================
.align 4
toggle_state: 
    .word 0
prev_keys:    
    .word 0
