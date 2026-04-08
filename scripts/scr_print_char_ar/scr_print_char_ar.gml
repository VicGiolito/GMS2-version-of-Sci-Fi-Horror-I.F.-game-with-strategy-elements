
function scr_print_char_ar(ar_to_use, use_case_enum){
	
	if is_array(ar_to_use) && array_length(ar_to_use) > 0 {
	
		var ar_len = array_length(ar_to_use), char_struct_id;
		
		if use_case_enum == use_case_for_print_char_ar.target_neutral_for_ownership_change {
			scr_add_str_to_dialogue_ar("\nThis a list of the droids in your current room:\n");
		}
		
		if use_case_enum == use_case_for_print_char_ar.target_char_for_item_pass {
			scr_add_str_to_dialogue_ar("\nThis a list of the characters in your same combat position that you can pass this item to:\n");	
		}
	
		for(var i = 0; i < ar_len; i++) {
		
			char_struct_id = ar_to_use[i];
			
			if use_case_enum != use_case_for_print_char_ar.target_neutral_for_ownership_change {
			
				scr_add_str_to_dialogue_ar($"{i}.) {char_struct_id.name}({char_struct_id.unique_id}) {scr_return_status_effects_str(char_struct_id,false)}\n");
			}
			else if use_case_enum == use_case_for_print_char_ar.target_neutral_for_ownership_change {
				
				if char_struct_id.char_team_enum == team_type.neutral {
				
					var stationary_str = "", owner_str = "";
				
					if char_struct_id.stationary_neutral_bool == true stationary_str = "(stationary, no owner)";
					
					//Define the owner of this neutral char:
					else {
						if is_array(global.acting_char_struct_id.cur_room_id.pcs_in_room_ar) && array_length(global.acting_char_struct_id.cur_room_id.pcs_in_room_ar) > 0 {
							var owner_id = scr_return_neutral_owner_id_or_ar(global.acting_char_struct_id.cur_room_id.pcs_in_room_ar, char_struct_id, false);
							owner_str = owner_id.name;
						}
					}
				
					scr_add_str_to_dialogue_ar($"\n{i}.) {char_struct_id.name}({char_struct_id.unique_id}){stationary_str}: {owner_str}");
				}
			}
		}
		
		if use_case_enum == use_case_for_print_char_ar.target_char_for_abil_or_item {
			scr_add_str_to_dialogue_ar("\nEnter the corresponding number of the character you want to target with the ability or item, or enter 'B' or 'BACKUP' to return to the previous screen.", true);	
		}
		else if use_case_enum == use_case_for_print_char_ar.target_neutral_for_ownership_change {
			scr_add_str_to_dialogue_ar("\nEnter the number of the droid to change their owner. The droid will then follow their new owner until instructed otherwise. Press 'B' or 'BACKUP' to return to the main game.", true);	
		}
		else if use_case_enum == use_case_for_print_char_ar.target_pc_for_new_neutral_follower {
			scr_add_str_to_dialogue_ar("\nEnter the number of the character who will become the droid's new owner. The droid will then follow that character until instructed otherwise. Press 'B' or 'BACKUP' to return to the main game.", true);	
		}
		else if use_case_enum == use_case_for_print_char_ar.target_char_for_item_pass {
			scr_add_str_to_dialogue_ar("\nEnter the number of the character you will pass the item to.", true); 	
		}
	}
	else {
		scr_add_str_to_dialogue_ar($"scr_print_char_ar failed to print the correct array.");
	}
}