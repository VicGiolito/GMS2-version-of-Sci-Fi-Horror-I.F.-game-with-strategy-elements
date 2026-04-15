
//Used in conjuction with < or > in the combat prep phase:

function scr_return_next_char_in_ar_direction(increment_dir, ar_index, original_char_struct_id, ar_to_use){
	
	var pc_char_found = false, failsafe_val = 0, failsafe_max = array_length(ar_to_use)+1;
	var char_struct_id;
	do {
		
		//Increment:
		ar_index += increment_dir;
		
		//Cap:
		if ar_index < 0 ar_index = array_length(ar_to_use)-1;
		else if ar_index >= array_length(ar_to_use) ar_index = 0;
		
		char_struct_id = ar_to_use[ar_index];
		
		if is_struct(char_struct_id) && char_struct_id.struct_type_enum == struct_type.Character {
			if char_struct_id.has_died_bool == false && char_struct_id.has_fled_combat_bool == false
			&& char_struct_id.unconscious_bool == false && char_struct_id.stun_count <= 0 {
				if char_struct_id.char_team_enum == team_type.pc && char_struct_id != original_char_struct_id {
					pc_char_found = true;
					return char_struct_id;
				}
			}
		}
		
		failsafe_val++;
	}
	until(pc_char_found || failsafe_val >= failsafe_max);
	
	return -1;
}