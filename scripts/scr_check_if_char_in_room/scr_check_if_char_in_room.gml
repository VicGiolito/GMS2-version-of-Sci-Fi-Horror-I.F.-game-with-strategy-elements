

function scr_check_if_char_in_room(room_struct_id,char_to_check_struct_id){
	
	var ar_to_use = -1;
	
	if char_to_check_struct_id.char_team_enum == team_type.pc {
		ar_to_use = room_struct_id.pcs_in_room_ar;
	}
	else if char_to_check_struct_id.char_team_enum == team_type.neutral {
		ar_to_use = room_struct_id.neutrals_in_room_ar;
	}	
	else if char_to_check_struct_id.char_team_enum == team_type.enemy {
		ar_to_use = room_struct_id.enemies_in_room_ar;
	}
	
	if is_array(ar_to_use) && array_length(ar_to_use) > 0 {
	
		var ar_len = array_length(ar_to_use);
	
		var char_struct_id;
		for(var i = 0; i < ar_len; i++) {
		
			char_struct_id = ar_to_use[i];
			
			if char_struct_id == char_to_check_struct_id {
				return true;	
			}
		}
	}
	
	return false;
}