
/*enemies_in_room_count should be a int

enemies_in_room_count = array_length(cur_room_id.enemies_in_room_ar)

room_hide_difficulty_val = cur_room_id.room_hide_difficulty_val

//Combining this into just scr_check_skill_test

*/

function scr_defunct_check_hide_skill_test(char_struct_id){
	
	var enemies_in_room_count = 0;
	
	if is_array(char_struct_id.cur_room_id.enemies_in_room_ar) {
		enemies_in_room_count = array_length(char_struct_id.cur_room_id.enemies_in_room_ar);
	}
	
	var room_hide_difficulty_val = char_struct_id.cur_room_id.room_hide_difficulty_val;
	
	//Cap, so it's technically possible to hide even in a crowded room:
	if enemies_in_room_count > 10 enemies_in_room_count = 10;
	
	var ran_val = irandom_range(1, 10);
	
	var threshold = room_hide_difficulty_val + char_struct_id.stealth - (enemies_in_room_count * ENEMY_HIDE_DIFFICULTY_PERCENT_VAL);
	
	threshold = clamp(threshold, 1, 10);

	var success = (ran_val <= threshold);
	
	return success;
}