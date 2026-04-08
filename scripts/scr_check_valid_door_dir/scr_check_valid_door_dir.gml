

function scr_check_valid_door_dir(room_struct_id, moving_dir_x, moving_dir_y){
	
	if is_struct(room_struct_id) && room_struct_id.struct_type_enum == struct_type.Room {
		//We can only check cardinal directions - one door at a time:
		var directional_macro;
		if moving_dir_x == -1 directional_macro = DOOR_DIR_W;
		else if moving_dir_x == 1 directional_macro = DOOR_DIR_E;
		else if moving_dir_y == -1 directional_macro = DOOR_DIR_N;
		else if moving_dir_y == 1 directional_macro = DOOR_DIR_S;

		var directional_struct = room_struct_id.directional_ar[directional_macro];
		
		if directional_struct.door_enum == door_state.unlocked || directional_struct.door_enum == door_state.destroyed || 
		directional_struct.door_enum == door_state.open_space {
			return true;	
		}
	}
	else {
		d($"scr_return_valid_door_dir: room_struct_id: {room_struct_id} was not a room struct or a not a room struct type; something went wrong.");
		
		return false;
	}
	
	return false;
}