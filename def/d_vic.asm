#importonce

* = * "D_VIC"

VIC:{
	.label MEMORY_BANK_SIZE = $4000

	.label BORDER_COLOR = $d020
	.label BACKGROUND_COLOR = $d021

	// 40 * 25 = 1000 aracctères sur l'écran...
	.label CHAR_WIDTH = 40
	.label CHAR_HEIGHT = 25
	.label SCREEN_HEIGHT = 200
	.label SCREEN_WIDTH = 320

	.label SCREEN_RAM = $0400
	.label COLOR_RAM = $d800
	
	.label RASTER = $d012
	.label RASTER_MSB = $d011 // bit #7
	// PAL => 50 images seconde... une ligne dessinée 50 fois par secondes...
	// écran = 312 lignes (0 à 311 = $0000 à $0137 - écran visible des lignes 50 à 249)

	.label JOY1 = $dc01	// %00000000             !!! la valeur 0 signifie ACTIF
	.label JOY2 = $dc00 //     ||||\--- joy up
						//     |||\---- joy down
						//     ||\----- joy left
						//     |\------ joy right
						//     \------- joy fire

	.label JOY_UP    = %00000001
	.label JOY_DOWN  = %00000010
	.label JOY_LEFT  = %00000100
	.label JOY_RIGHT = %00001000
	.label JOY_FIRE  = %00010000

	SCREEN_LINES_LO:
		.for(var i = 0; i<25; i++){
			.byte (SCREEN_RAM + i * 40)
		}
	SCREEN_LINES_HI:
		.for(var i = 0; i<25; i++){
			.byte ((SCREEN_RAM + i * 40)/256)
		}

}
