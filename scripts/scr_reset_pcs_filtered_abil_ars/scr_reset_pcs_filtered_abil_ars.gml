/* Pcs create a filtered array of abilities that they can or cannot use during combat every time we enter the 'abil'
command; it becomes filled with item struct ids from the g.item_reference_table. This deletes arrays and those ids references.



*/

function scr_reset_pcs_filtered_abil_ars(){
	
	for(var i = 0; i < array_length(global.pc_char_ar); i++) {
		global.pc_char_ar[i].filtered_abil_ar = -1;	
	}
}