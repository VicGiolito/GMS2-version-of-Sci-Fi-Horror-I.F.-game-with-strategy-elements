

function scr_check_skill_test(char_struct_id, skill_test_enum){
	
	if skill_test_enum == skill_tests.engineering {
		
		var char_engineering = char_struct_id.engineering;
		
		var base_skill_test = AVG_ENGINEERING_SKILL_TEST_BASE;
	
		var threshold = base_skill_test + char_engineering;
		
		//Cap threshold so there is a never a guranteed fail:
		threshold = clamp(threshold, MIN_SKILL_TEST_RAN_VAL, MAX_SKILL_TEST_RAN_VAL);
		
		var ran_val = irandom_range(MIN_SKILL_TEST_RAN_VAL, MAX_SKILL_TEST_RAN_VAL);
	
		var success = (ran_val <= threshold);
	}
	
	else if skill_test_enum == skill_tests.hide {
		var enemies_in_room_count = 0;
	
		if is_array(char_struct_id.cur_room_id.enemies_in_room_ar) {
			enemies_in_room_count = array_length(char_struct_id.cur_room_id.enemies_in_room_ar);
		}
	
		var room_hide_difficulty_val = char_struct_id.cur_room_id.room_hide_difficulty_val;
	
		//Cap, so it's technically possible to hide even in a crowded room:
		if enemies_in_room_count > 10 enemies_in_room_count = 10;
	
		var ran_val = irandom_range(MIN_SKILL_TEST_RAN_VAL, MAX_SKILL_TEST_RAN_VAL);
	
		var threshold = room_hide_difficulty_val + char_struct_id.stealth - (enemies_in_room_count * ENEMY_HIDE_DIFFICULTY_PERCENT_VAL);
		
		//Cap threshold so there is a never a guranteed fail:
		threshold = clamp(threshold, MIN_SKILL_TEST_RAN_VAL, MAX_SKILL_TEST_RAN_VAL);

		var success = (ran_val <= threshold);
	
		return success;	
	}
}