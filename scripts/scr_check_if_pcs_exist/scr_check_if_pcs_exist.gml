

function scr_check_if_pcs_exist(){
	
	var ar_len = array_length(global.pc_char_ar);
	var char_id;
	for(var i = 0; i < ar_len; i++) {
		char_id = global.pc_char_ar[i];
		
		if char_id.char_team_enum == team_type.pc {
			return true;	
		}
	}
	
	return false;
}