

function scr_return_door_struct_from_dir(room_struct_id, dir_x, dir_y){
	
	if is_struct(room_struct_id) && room_struct_id.struct_type_enum == struct_type.Room {
		
		//We can only check cardinal directions - one door at a time - so this code is valid:
		var directional_macro;
		if dir_x == -1 directional_macro = DOOR_DIR_W;
		else if dir_x == 1 directional_macro = DOOR_DIR_E;
		else if dir_y == -1 directional_macro = DOOR_DIR_N;
		else if dir_y == 1 directional_macro = DOOR_DIR_S;

		var door_struct_id = room_struct_id.directional_ar[directional_macro];
		
		return door_struct_id
	}
	
	return -1;
}