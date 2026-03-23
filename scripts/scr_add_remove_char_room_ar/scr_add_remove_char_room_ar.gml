
//if add_or_remove_boolean == true, add to corrseponding room ar;

//otherwise, remove ONLY ONE from the corresponding room array (the first value with the matching char_struct_id that we find in that array).

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
			room_struct_id.pcs_in_room_ar = scr_add_remove_val_from_ar(room_struct_id.pcs_in_room_ar,char_struct_id,true,false);
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
			room_struct_id.enemies_in_room_ar = scr_add_remove_val_from_ar(room_struct_id.enemies_in_room_ar,char_struct_id,true,false);
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
			room_struct_id.neutrals_in_room_ar = scr_add_remove_val_from_ar(room_struct_id.neutrals_in_room_ar,char_struct_id,true,false);
		}
	}
}