

function scr_return_avail_directions_str(room_struct_id){
	
	var avail_directions_str = "The following directions are available to you:\n";
	
	var directional_struct_id, dir_str, door_str;
	for(var i = 0; i < array_length(room_struct_id.directional_ar); i++){
		
		directional_struct_id = room_struct_id.directional_ar[i];
		
		dir_str = "";
		door_str = "";
		
		if directional_struct_id.door_enum == door_state.wall continue; //We don't bother showing walls
		
		if i == DOOR_DIR_W dir_str = "WEST";
		else if i == DOOR_DIR_E dir_str = "EAST";
		else if i == DOOR_DIR_N dir_str = "NORTH";
		else if i == DOOR_DIR_S dir_str = "SOUTH";
		
		if directional_struct_id.door_enum == door_state.unlocked door_str = "UNLOCKED";
		else if directional_struct_id.door_enum == door_state.jammed door_str = "JAMMED";
		else if directional_struct_id.door_enum == door_state.destroyed door_str = "DESTROYED";
		else if directional_struct_id.door_enum == door_state.jammed door_str = "JAMMED";
		else if directional_struct_id.door_enum == door_state.locked door_str = "LOCKED";
		else if directional_struct_id.door_enum == door_state.unlocked door_str = "UNLOCKED";
		else if directional_struct_id.door_enum == door_state.open_space door_str = "OPEN SPACE";
		
		avail_directions_str += dir_str+" - "+door_str+"\n";
	}
	
	return avail_directions_str;
}