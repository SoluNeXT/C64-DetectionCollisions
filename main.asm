#importonce

BasicUpstart2(main)

#import "def/d_vic.asm"
#import "def/d_sprites.asm"

#import "macros/m_vic.asm"

#import "assets/a_sprites.asm"

* = * "MAIN"

.var minPlayerX = 0
.var maxPlayerX = 172
.var minPlayerY = 29
.var maxPlayerY = 250
.label playerX = $02 // 0 => 172
.label playerY = $03 // 29 > 250 

.label wallChar = 160  // si >= $a0 alors on a une collision

.label fallingPointer = $0F
.label jumpingPointer = $10

.label charLeftFeet = $12
.label charRightFeet = $13
.label charOnLeft = $14
.label charOnRight = $15

main:
		jsr drawDecors
		jsr initPlayer



	loop:
		lda #0
		sta VIC.BORDER_COLOR

		:WaitRasterLine(260)

		lda #5
		sta VIC.BORDER_COLOR

		jsr getChars

	testCharsUnderPlayer:
		lda charLeftFeet
		cmp #wallChar
		bcs sol

		lda charRightFeet
		cmp #wallChar
		bcs sol

	testFalling:
		lda jumpingPointer
		cmp #0
		bne moving

		lda playerY
		clc
		adc #1
		cmp #maxPlayerY
		bcc yOk
		lda #minPlayerY
	yOk:
		sta playerY
		lda #1
		sta fallingPointer

		jmp moving

	sol:
		lda #0
		sta fallingPointer

	moving:
		ldx VIC.JOY2
		txa
	testGauche:
		and #VIC.JOY_LEFT
		bne testDroite

		lda charOnLeft
		cmp #wallChar
		bcs jump

		lda playerX
		sec
		sbc #1
		cmp #minPlayerX
		bne isNotMinX
		lda #maxPlayerX
	isNotMinX:	
		sta playerX
		jmp jump

	testDroite:
		txa
		and #VIC.JOY_RIGHT
		bne jump

		lda charOnRight
		cmp #wallChar
		bcs jump


		lda playerX
		clc
		adc #1
		cmp #maxPlayerX
		bne isNotMaxX
		lda #minPlayerX
	isNotMaxX:	
		sta playerX
		//jmp endJoy


	jump:
		lda fallingPointer
		cmp #0
		bne joyEnd

		lda jumpingPointer
		cmp #0
		bne joyEnd


		txa
		and #VIC.JOY_FIRE
		bne joyEnd

		lda #1
		sta jumpingPointer

	joyEnd:


	jumping:
		ldx jumpingPointer
		cpx #0
		beq noJump

		lda playerY
		sec
		sbc jumpValues-1,x
		sta playerY

		inx
		cpx #12
		bne endJump

		ldx #0

	endJump:
		stx jumpingPointer

	noJump:



		jsr drawPlayer

		jmp loop


jumpValues:
		.byte 5,5,4,3,2,2,1,1,1,0,0,0


getChars:
		lda playerY
		clc
		adc #20
		jsr calculerYScreen

		lda playerX
		jsr calculerXScreen

		jsr getCharAtPosXY
		sta charOnLeft

		lda playerX
		clc
		adc #10
		jsr calculerXScreen

		jsr getCharAtPosXY
		sta charOnRight

		lda playerY
		clc
		adc #21
		jsr calculerYScreen

		lda playerX
		clc
		adc #3
		jsr calculerXScreen

		jsr getCharAtPosXY
		sta charLeftFeet

		lda playerX
		clc
		adc #9
		jsr calculerXScreen

		jsr getCharAtPosXY
		sta charRightFeet

		rts

getCharAtPosXY:
		lda VIC.SCREEN_LINES_LO,y
		sta searchPointer
		lda VIC.SCREEN_LINES_HI,y
		sta searchPointer + 1

		lda searchPointer: $BEEF,x
		rts

calculerXScreen:
		lsr
		lsr
		cmp #3
		bcc offscreenLeft
		cmp #43
		bcs offscreenRight

		sec
		sbc #3
		tax
		rts

	offscreenLeft:
		ldx #0
		rts
	offscreenRight:
		ldx #39
		rts

calculerYScreen:
		sec
		sbc #SPRITES.MARGIN_TOP
		lsr
		lsr
		lsr
		tay
		cpy #25  // Attention, max = 24
		bcc ok
		ldy #24
	ok:
		rts


drawPlayer:
		lda playerY
		sta SPRITES.Y0

		lda playerX      // %10000001
		asl				 // %00000010 >> retenue = 1
		tax
		lda SPRITES.XMSB
		bcs setMSB
	delMSB:
		and #%11111110
		jmp putMSB

	setMSB:
		ora #%00000001

	putMSB:
		sta SPRITES.XMSB
		stx SPRITES.X0

		rts


initPlayer:
		lda #12+4*15
		sta playerX
		lda #50+8*3
		sta playerY

		lda #spr_hit
		sta SPRITES.INDEX0

		lda #1
		sta SPRITES.ENABLE
		sta SPRITES.MULTICOLOR
		sta SPRITES.COLOR0

		rts

drawDecors:
		ldx #0
		stx $02
	!:
		lda VIC.SCREEN_RAM,x
		sta VIC.SCREEN_RAM + 4 * 40,x
		sta VIC.SCREEN_RAM + 8 * 40,x
		sta VIC.SCREEN_RAM + 12 * 40,x
		sta VIC.SCREEN_RAM + 16 * 40,x
		sta VIC.SCREEN_RAM + 20 * 40,x

		clc
		lda $02
		adc #1
		ora #8
		and #15
		sta VIC.COLOR_RAM,x
		adc #1
		ora #8
		and #15
		sta VIC.COLOR_RAM + 4*40,x
		adc #1
		ora #8
		and #15
		sta VIC.COLOR_RAM + 8*40,x
		adc #1
		ora #8
		and #15
		sta VIC.COLOR_RAM + 12*40,x
		adc #1
		ora #8
		and #15
		sta VIC.COLOR_RAM + 16*40,x
		adc #1
		ora #8
		and #15
		sta VIC.COLOR_RAM + 20*40,x

		sta $02

		inx
		cpx #160
		bne !-

		ldx #0
	!:
		lda #wallChar
		sta VIC.SCREEN_RAM + 25 + 40 * 5,x
		sta VIC.SCREEN_RAM + 18 + 40 * 11,x
		sta VIC.SCREEN_RAM + 0 + 40 * 13,x
		sta VIC.SCREEN_RAM + 30 + 40 * 13,x
		sta VIC.SCREEN_RAM + 17 + 40 * 16,x
		sta VIC.SCREEN_RAM + 4 + 40 * 19,x
		sta VIC.SCREEN_RAM + 14 + 40 * 18,x
		sta VIC.SCREEN_RAM + 29 + 40 * 19,x
		sta VIC.SCREEN_RAM + 11 + 40 * 23,x
		sta VIC.SCREEN_RAM + 22 + 40 * 23,x


		lda #1
		sta VIC.COLOR_RAM + 25 + 40 * 5,x
		sta VIC.COLOR_RAM + 18 + 40 * 11,x
		sta VIC.COLOR_RAM + 0 + 40 * 13,x
		sta VIC.COLOR_RAM + 30 + 40 * 13,x
		sta VIC.COLOR_RAM + 17 + 40 * 16,x
		sta VIC.COLOR_RAM + 4 + 40 * 19,x
		sta VIC.COLOR_RAM + 14 + 40 * 18,x
		sta VIC.COLOR_RAM + 29 + 40 * 19,x
		sta VIC.COLOR_RAM + 11 + 40 * 23,x
		sta VIC.COLOR_RAM + 22 + 40 * 23,x

		inx
		cpx #10
		bne !-

		lda #161
		sta VIC.SCREEN_RAM + 24 + 40 * 10
		sta VIC.SCREEN_RAM + 4 + 40 * 18
		sta VIC.SCREEN_RAM + 4 + 40 * 17
		sta VIC.SCREEN_RAM + 4 + 40 * 16
		sta VIC.SCREEN_RAM + 4 + 40 * 15



		lda #10
		sta VIC.COLOR_RAM + 24 + 40 * 10
		sta VIC.COLOR_RAM + 4 + 40 * 18
		sta VIC.COLOR_RAM + 4 + 40 * 17
		sta VIC.COLOR_RAM + 4 + 40 * 16
		sta VIC.COLOR_RAM + 4 + 40 * 15
		rts


