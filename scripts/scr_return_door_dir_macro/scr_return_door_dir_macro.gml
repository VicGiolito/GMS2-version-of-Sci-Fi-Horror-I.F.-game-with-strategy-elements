

function scr_return_door_dir_macro(check_dir_x,check_dir_y){
	
	var door_dir_macro;
	
	if check_dir_x == -1 && check_dir_y == 0 door_dir_macro = DOOR_DIR_W; //W
	else if check_dir_x == 0 && check_dir_y == -1 door_dir_macro = DOOR_DIR_N; //N
	else if check_dir_x == 1 && check_dir_y == 0 door_dir_macro = DOOR_DIR_E; //E
	else if check_dir_x == 0 && check_dir_y == 1 door_dir_macro = DOOR_DIR_S; //S
	
	return door_dir_macro;
}