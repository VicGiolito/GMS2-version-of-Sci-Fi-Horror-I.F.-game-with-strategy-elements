

function scr_return_door_dir_str_from_macro(directional_macro){
	
	var directional_str;
	
	if directional_macro == DOOR_DIR_E directional_str = "eastern";
	else if directional_macro == DOOR_DIR_N directional_str = "northern";
	else if directional_macro == DOOR_DIR_W directional_str = "western";
	else if directional_macro == DOOR_DIR_S directional_str = "southern";
	
	return directional_str;
}