

function scr_print_skill_test(char_struct_id, skill_test_enum){
	
	if skill_test_enum == skill_tests.engineering {

		var char_engineering = char_struct_id.engineering;
		
		var base_skill_test = AVG_ENGINEERING_SKILL_TEST_BASE;
	
		var calc_result = base_skill_test + char_engineering;
	
		var chance_pct = (clamp(calc_result, MIN_SKILL_TEST_RAN_VAL, MAX_SKILL_TEST_RAN_VAL) - MIN_SKILL_TEST_RAN_VAL + 1) / (MAX_SKILL_TEST_RAN_VAL - MIN_SKILL_TEST_RAN_VAL + 1) * 100;
	
		scr_add_str_to_dialogue_ar($"Do you want {char_struct_id.name} to attempt this engineering skill test?\n\nChance of success is: ({base_skill_test}) + Engineering skill ({char_engineering}) = {chance_pct}%.\n\nEnter 'Y' or 'YES' to attempt the skill test and consume the item or ability's required resources, or 'N' or 'NO' to return to the previous game state.",true);
	}
}