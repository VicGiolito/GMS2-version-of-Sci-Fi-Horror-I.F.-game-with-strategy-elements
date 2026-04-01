
function scr_print_char_ar(ar_to_use, show_target_with_ability_str, show_droid_change_ownership_str = false){
	
	if is_array(ar_to_use) && array_length(ar_to_use) > 0 {
	
		var ar_len = array_length(ar_to_use), char_struct_id;
	
		for(var i = 0; i < ar_len; i++) {
		
			char_struct_id = ar_to_use[i];
		
			scr_add_str_to_dialogue_ar($"{i}.) {char_struct_id.name} {scr_return_status_effects_str(char_struct_id,false)}\n");
		}
		
		if show_target_with_ability_str {
			scr_add_str_to_dialogue_ar("\nEnter a number to target a character with the ability or item.", true);	
		}
		if show_droid_change_ownership_str {
			scr_add_str_to_dialogue_ar("\nEnter the number of the droid if you want to change their owner. The droid will then follow that character until instructed otherwise. Press 'B' to return to the main game.", true);	
		}
	}
	else {
		scr_add_str_to_dialogue_ar($"scr_print_char_ar failed to print the correct array.");
	}
}