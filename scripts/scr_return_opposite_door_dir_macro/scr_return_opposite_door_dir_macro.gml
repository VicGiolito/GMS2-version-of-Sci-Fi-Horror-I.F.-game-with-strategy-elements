

function scr_return_opposite_door_dir_macro(door_dir_macro){
	
	var door_dir_macro_to_return;
	
	if door_dir_macro == DOOR_DIR_E door_dir_macro_to_return = DOOR_DIR_W;
	if door_dir_macro == DOOR_DIR_W door_dir_macro_to_return = DOOR_DIR_E;
	if door_dir_macro == DOOR_DIR_N door_dir_macro_to_return = DOOR_DIR_S;
	if door_dir_macro == DOOR_DIR_S door_dir_macro_to_return = DOOR_DIR_N;
	
	return door_dir_macro_to_return;
}