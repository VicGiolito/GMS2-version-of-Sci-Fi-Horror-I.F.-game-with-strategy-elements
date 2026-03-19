

function scr_mid_combat_reset_or_reduce_char_combat_vars(char_struct_id){
	
	if char_struct_id.evading_boolean == true {
		char_struct_id.evading_boolean = false;
		char_struct_id.evasion -= 1;
	}
	
	char_struct_id.pc_is_combat_moving = false; //We use this bool var because pcs actually move in execute_combat game state
}