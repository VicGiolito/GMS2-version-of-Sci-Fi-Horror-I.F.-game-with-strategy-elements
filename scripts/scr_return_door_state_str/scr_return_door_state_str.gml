


function scr_return_door_state_str(door_struct_id){
	
	var door_state_str;
	
	var door_enum_ = door_struct_id.door_enum;
	
	if door_enum_ == door_state.destroyed door_state_str = "destroyed";
	else if door_enum_ == door_state.unlocked door_state_str = "unlocked";
	else if door_enum_ == door_state.locked door_state_str = "locked";
	else if door_enum_ == door_state.open_space door_state_str = "open space";
	else if door_enum_ == door_state.jammed door_state_str = "jammed";
	else if door_enum_ == door_state.wall door_state_str = "wall";
	
	return door_state_str;
}