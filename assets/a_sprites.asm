#importonce
#import "../main.asm"
#import "../def/d_vic.asm"

.print "---------------------"
.print "---   A_SPRITES   ---"
.print "---------------------"

* = * "A_SPRITES LOST MEMORY"
//On aligne la mémoire au modulo 64
.var spr_load = *
.align $40 
.var spr_mem = *

* = * "A_SPRITES DATAS"

// on défini la position des données de sprite basé sur la memory bank
.var spr_startMem = * & (VIC.MEMORY_BANK_SIZE - 1)	
.var spr_memBank = floor(* / VIC.MEMORY_BANK_SIZE)
.var spr_firstId = (spr_startMem - spr_memBank * VIC.MEMORY_BANK_SIZE) / $40

//Import Binaire
.import binary "sprites.bin"

//Définition des IDs
.var spr_hit = spr_firstId

//Calcul de la taille
.var spr_lastId = floor((* - (spr_memBank * VIC.MEMORY_BANK_SIZE+1))/$40)
.var spr_nb = spr_lastId - spr_firstId + 1

//Affichage infos
.print "Loaded at       : "+spr_load
.print "reallocated at  : "+spr_mem
.print "lost memory     : "+(spr_mem - spr_load)+" octets"

.print "Memory Bank     : "+spr_memBank
.print "Start Memory    : "+spr_startMem
.print "First Sprite Id : "+spr_firstId
.print "Last Sprite Id  : "+spr_lastId
.print "Nb of sprites   : "+spr_nb

//Si le dernier ID de sprite est > 255 alors on lève une erreur
.if (spr_lastId>255) {
	.printnow "-----------------"
	.printnow "--- A_SPRITES ---"
	.printnow "-----------------"
	.printnow "First Sprite Id : "+spr_firstId
	.printnow "Last Sprite Id  : " + spr_lastId
	.error "ERROR ! memory bank overflow : max is 255 but Last Sprite Id is " + spr_lastId
}

.print "---------------------"
.print "--- END A_SPRITES ---"
.print "---------------------"
.print ""
