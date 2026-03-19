



function scr_check_ar_for_opposite_team(acting_char_struct_id, ar_to_check){
	
	var acting_char_team = acting_char_struct_id.char_team_enum;
	var ar_len = array_length(ar_to_check), char_id;
	for(var i = 0; i < ar_len; i++) {
		
		char_id = ar_to_check[i];	
				
		if acting_char_team == team_type.enemy {
			if char_id.char_team_enum == team_type.pc || char_id.char_team_enum == team_type.neutral {
				return true;		
			}
		}
		else if acting_char_team == team_type.pc || acting_char_team == team_type.neutral {
			if char_id.char_team_enum == team_type.enemy {
				return true;	
			}
		}
	}
				
	return false;
}