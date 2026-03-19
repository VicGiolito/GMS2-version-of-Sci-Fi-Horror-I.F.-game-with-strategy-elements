
//if print_weapon_list_bool == false, we print the char's abil list instead

function scr_print_weapon_or_abil_list(print_weapon_list_bool, accessed_from_combat_state){
	
	scr_add_str_to_dialogue_ar("\n");
	
	if print_weapon_list_bool {
		scr_add_str_to_dialogue_ar("You have the following weapon's equipped:");
	}
	
	else {
		scr_add_str_to_dialogue_ar("You have access to the following skills and abilities:");	
	}
	
	if is_array(avail_weps_or_abils_list) && array_length(avail_weps_or_abils_list) > 0 {
		var ar_len = array_length(avail_weps_or_abils_list);
		
		for(var i = 0; i < ar_len; i++) {
			scr_add_str_to_dialogue_ar($"{i}.) {avail_weps_or_abils_list[i].item_name}");	
		}
	}
	//No items or abilities were present from scr_build_weps_or_abils_list:
	else {
		scr_add_str_to_dialogue_ar("None.");	
	}
	
	scr_add_str_to_dialogue_ar("\n");
	scr_add_str_to_dialogue_ar("Enter the corresponding weapon or ability number, or enter 'B' or 'BACKUP' to return to the previous game state.", true);
}