

function scr_print_skill_test(char_struct_id, skill_test_enum){
	
	if skill_test_enum == skill_tests.engineering {

		var char_engineering = char_struct_id.engineering;
		
		var base_skill_test = AVG_ENGINEERING_SKILL_TEST_BASE;
	
		var calc_result = base_skill_test + char_engineering;
	
		var chance_pct = (clamp(calc_result, MIN_SKILL_TEST_RAN_VAL, MAX_SKILL_TEST_RAN_VAL) - MIN_SKILL_TEST_RAN_VAL + 1) / (MAX_SKILL_TEST_RAN_VAL - MIN_SKILL_TEST_RAN_VAL + 1) * 100;
	
		scr_add_str_to_dialogue_ar($"Do you want {char_struct_id.name} to attempt this engineering skill test?\n\nChance of success is: ({base_skill_test}) + Engineering skill ({char_engineering}) = {chance_pct}%.\n\nEnter 'Y' or 'YES' to attempt the skill test and consume the item or ability's required resources, or 'N' or 'NO' to return to the previous game state.",true);
	}
	
	else if skill_test_enum == skill_tests.hide {
		var room_difficulty_val = char_struct_id.cur_room_id.room_hide_difficulty_val;
		var char_stealth = char_struct_id.stealth
		var enemy_count = 0;
		if is_array(char_struct_id.cur_room_id.enemies_in_room_ar) {
			enemy_count = array_length(char_struct_id.cur_room_id.enemies_in_room_ar);
		}
	
		var calc_result = room_difficulty_val + char_stealth - (enemy_count * ENEMY_HIDE_DIFFICULTY_PERCENT_VAL);
	
		var chance_pct = (clamp(calc_result, MIN_SKILL_TEST_RAN_VAL, MAX_SKILL_TEST_RAN_VAL) - MIN_SKILL_TEST_RAN_VAL + 1) / (MAX_SKILL_TEST_RAN_VAL - MIN_SKILL_TEST_RAN_VAL + 1) * 100;
	
		scr_add_str_to_dialogue_ar($"Do you want to try and hide in this room? Hidden characters do not automatically trigger combat with enemies in this room at the start of each new turn.\n\nChance to successfully hide in this room is Room difficulty level ({room_difficulty_val}) + Stealth ({char_stealth}) - (number of enemies in this room ({enemy_count}) * .5) = {chance_pct}%.\n\nEnter 'Y' or 'YES' to attempt to hide, or 'N' or 'NO' to return to the main game screen.",true);	
	}
}