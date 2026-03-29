
//if add_or_remove_boolean == true, add to corrseponding room ar;

//otherwise, remove ONLY ONE from the corresponding room array (the first value with the matching char_struct_id that we find in that array).

function scr_add_remove_char_room_ar(room_struct_id, char_struct_id, add_or_remove_boolean){
	
	var char_team = char_struct_id.char_team_enum;
	var ar_to_use;
	
	if char_team == team_type.pc {
		if !is_array(room_struct_id.pcs_in_room_ar) {
			room_struct_id.pcs_in_room_ar = [];	
		}
		ar_to_use = room_struct_id.pcs_in_room_ar;
	}
	else if char_team == team_type.neutral {
		if !is_array(room_struct_id.neutrals_in_room_ar) {
			room_struct_id.neutrals_in_room_ar = [];	
		}
		ar_to_use = room_struct_id.neutrals_in_room_ar;
	}
	else if char_team == team_type.enemy {
		if !is_array(room_struct_id.enemies_in_room_ar) {
			room_struct_id.enemies_in_room_ar = [];	
		}
		ar_to_use = room_struct_id.enemies_in_room_ar;
	}
	
	if add_or_remove_boolean == true {
		array_push(ar_to_use,char_struct_id);	
	}
	else {
		var ar_index = array_get_index(ar_to_use,char_struct_id);
		if ar_index == -1 throw($"scr_add_remove_char_room_ar: trying to remove {char_struct_id.name} from corresponding room array, but array_get_index returned -1, we want to know why they were not in the array.");
		array_delete(ar_to_use, ar_index, 1);		
	}
}