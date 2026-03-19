
//if add_or_remove_boolean == true, add to corrseponding global ar;

//if false, remove from corresponding global ar:

function scr_add_remove_char_from_global_ar(char_struct_id,add_or_remove_boolean){
	
	var char_team = char_struct_id.char_team_enum;
	
	if char_team == team_type.pc {
		if add_or_remove_boolean {
			if !is_array(global.pc_char_ar) {
				global.pc_char_ar = [];	
			}
			array_push(global.pc_char_ar,char_struct_id);
		} 
		else {
			var val_deleted = scr_delete_val_from_ar(global.pc_char_ar,char_struct_id);
		}
	}
	
	else if char_team == team_type.enemy {
		if add_or_remove_boolean {
			if !is_array(global.enemy_char_ar) {
				global.enemy_char_ar = [];	
			}
			array_push(global.enemy_char_ar,char_struct_id);
		} 
		else {
			var val_deleted = scr_delete_val_from_ar(global.enemy_char_ar,char_struct_id);
		}
	}
	
	else if char_team == team_type.neutral {
		if add_or_remove_boolean {
			if !is_array(global.neutral_char_ar) {
				global.neutral_char_ar = [];	
			}
			array_push(global.neutral_char_ar,char_struct_id);
		} 
		else {
			var val_deleted = scr_delete_val_from_ar(global.neutral_char_ar,char_struct_id);
		}
	}

	if !add_or_remove_boolean && !val_deleted d($"scr_add_remove_char_room_ar: scr_delete_val_from_ar return false, which means we could not find the char_struct_id: {char_struct_id.name} in the corresponding global array.");

}