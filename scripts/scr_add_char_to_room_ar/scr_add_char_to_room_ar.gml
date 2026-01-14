
//if add_or_remove_boolean == true, add to corrseponding room ar

function scr_add_remove_char_room_ar(room_struct_id,char_struct_id,add_or_remove_boolean){
	
	var char_team = char_struct_id.char_team_enum;
	
	if char_team == team_type.pc {
		if add_or_remove_boolean {
			if !is_array(room_struct_id.pcs_in_room_ar) {
				room_struct_id.pcs_in_room_ar = [];	
			}
			array_push(room_struct_id.pcs_in_room_ar,char_struct_id);
		} 
		else {
			var val_deleted = scr_delete_val_from_ar(room_struct_id.pcs_in_room_ar,char_struct_id);
		}
	}
	
	else if char_team == team_type.enemy {
		if add_or_remove_boolean {
			if !is_array(room_struct_id.enemies_in_room_ar) {
				room_struct_id.enemies_in_room_ar = [];	
			}
			array_push(room_struct_id.enemies_in_room_ar,char_struct_id);
		} 
		else {
			var val_deleted = scr_delete_val_from_ar(room_struct_id.enemies_in_room_ar,char_struct_id);
		}
	}
	
	else if char_team == team_type.neutral {
		if add_or_remove_boolean {
			if !is_array(room_struct_id.neutrals_in_room_ar) {
				room_struct_id.neutrals_in_room_ar = [];	
			}
			array_push(room_struct_id.neutrals_in_room_ar,char_struct_id);
		} 
		else {
			var val_deleted = scr_delete_val_from_ar(room_struct_id.neutrals_in_room_ar,char_struct_id);
		}
	}

	if !add_or_remove_boolean && !val_deleted d($"scr_add_remove_char_room_ar: scr_delete_val_from_ar return false, which means we could not find the char_struct_id: {char_struct_id.name} in the corresponding room array for room: {room_struct_id.name}");
}