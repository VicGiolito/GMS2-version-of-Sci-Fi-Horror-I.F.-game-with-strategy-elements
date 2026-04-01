
function scr_check_rank_all_combat_immune(combat_rank_ar){
	
	var ar_len = combat_rank_ar, char_struct_id;
	
	for(var i = 0; i < ar_len; i++) {
		char_struct_id = combat_rank_ar[i];
		
		if char_struct_id.morale_immune == false return false;
	}
	
	return true;
}