

function scr_delete_char_from_global_and_room_ar(char_id_to_delete){
	
	d($"\nEntering scr_delete_char_from_global_and_room_ar for char_id_to_delete: {char_id_to_delete.name}. They will be deleted from their respective global and room team arrays.\n");
	
	var room_ar = undefined, global_ar = undefined;
	
	if char_id_to_delete.char_team_enum == team_type.enemy {
		room_ar = char_id_to_delete.cur_room_id.enemies_in_room_ar;
		global_ar = global.enemy_char_ar;
	}
	else if char_id_to_delete.char_team_enum == team_type.pc {
		room_ar = char_id_to_delete.cur_room_id.pcs_in_room_ar;
		global_ar = global.pc_char_ar;	
	}
	else if char_id_to_delete.char_team_enum == team_type.neutral {
		room_ar = char_id_to_delete.cur_room_id.neutrals_in_room_ar;
		global_ar = global.neutral_char_ar;
	}
							
	//Delete from room ar:
	var defender_index = array_get_index(room_ar,char_id_to_delete);
	if defender_index != -1 { //because we're calling scr_delete_char_from_global_and_room_ar() in multiple places in scr_delete_combat_chars, it's possible this char was deleted already, so their index may not exist.
		array_delete(room_ar,defender_index,1); 
	}
							
	//Delete from global ar:
	var defender_index = array_get_index(global_ar,char_id_to_delete);
	if defender_index != -1 { //because we're calling scr_delete_char_from_global_and_room_ar() in multiple places in scr_delete_combat_chars, it's possible this char was deleted already, so their index may not exist.
		array_delete(global_ar,defender_index,1);
	}
}