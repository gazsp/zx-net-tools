; Pushes A to ring buffer
pushRing
    ld   c, a                           ; Save byte in A to C
    ld   b, 32

    ; Copy bytes in buffer down one position
    ld   hl, ring_buffer + 1
    ld   de, ring_buffer
ringL
    ld   a, (hl)
    ld   (de), a
    inc  hl
    inc  de
    djnz ringL

    ld   a, c                           ; Get byte back from C
    ld   hl, ring_buffer + 31           ; Write byte to end of buffer
    ld   (hl), a
    ret

; HL - Compare string(null terminated)
; A - 0 NOT Found 
;     1 Found
searchRing:
    push hl

    ld   b, 0
    ld   de, ring_buffer + 32           ; Start at end of buffer
strlen:
    ld   a, (hl)                        ; Get the length of the string to compare
    inc  hl                             ; Count bytes in B until we get to a 0
    dec  de                             ; Move ring buffer search position back
    inc  b
    and  a
    jp   nz, strlen

    dec  b                              ; Don't count 0 string terminator
    inc  de

    pop  hl

strcmp:                                 ; B = strlen (without 0 terminator)
    ld   a, (de)
    cp   (hl)
    jp   nz, .failed
    inc  de
    inc  hl
    djnz strcmp

    ld   a, 1
    ret
.failed
    xor  a
    ret

clearRing:
    xor a
    ld hl, ring_buffer
    ld de, ring_buffer + 1
    ld bc, 32
    ld (hl), a
    ldir
    ret

ring_buffer dup 33
            defb 0
            edup
