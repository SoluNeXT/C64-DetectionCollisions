#importonce

* = * "M_VIC"

.macro WaitRasterLine(rasterLine){
// valeur = 0 => 311 (312 lignes)

	.if(rasterLine>311)
	{
		.error "Raster line max value is 311"
	}
	.if(rasterLine<0)
	{
		.error "Raster line min value is 0"
	}



	lda #rasterLine
	.if(rasterLine>255)  // 256 => 311
	{
			pha
			txa
			pha
			!:
			ldx VIC.RASTER_MSB
			bpl !-

			cmp VIC.RASTER
			bne !-
			pla
			tax
			pla
	}
	else .if(rasterLine<56) // 312 - 256 = 56
	{
			pha
			txa
			pha
		!:
			ldx VIC.RASTER_MSB
			bmi !-

			cmp VIC.RASTER
			bne !-
			pla
			tax
			pla
	}
	else
	{
			pha
		!:
			cmp VIC.RASTER
			bne !-
			pla
	}
	


}