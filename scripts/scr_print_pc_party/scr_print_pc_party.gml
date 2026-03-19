
//show_use_item_command_boolean and show_give_command_boolean are mutually exclusive; both cannot be true.

function scr_print_pc_party(show_give_command_boolean, show_use_item_command_boolean) {
	
	var ar_to_use = -1;
	
	var char_struct_id = undefined;
	if global.combat_begun == false char_struct_id = global.acting_char_struct_id;
	else if global.combat_begun char_struct_id = global.cur_combat_char;
	
	if !show_give_command_boolean {
		ar_to_use = global.pc_char_ar;
	}
	else if show_use_item_command_boolean {
		ar_to_use = global.acting_char_struct_id.cur_room_id.pcs_in_room_ar;
		scr_add_str_to_dialogue_ar("\n");
		scr_add_str_to_dialogue_ar($"Who will you use the {char_struct_id.using_item_struct_id.item_name} on?");
	}
	else{
		ar_to_use = global.acting_char_struct_id.cur_room_id.pcs_in_room_ar;
		scr_add_str_to_dialogue_ar("\n");
		scr_add_str_to_dialogue_ar($"Give the {char_struct_id.passing_item_struct_id.item_name} to who?\n");	
	}
	
	if is_array(ar_to_use) && array_length(ar_to_use) > 0 {
	
		var ar_len = array_length(ar_to_use);
	
		var char_struct_id;
		for(var i = 0; i < ar_len; i++) {
		
			char_struct_id = ar_to_use[i];
		
			scr_add_str_to_dialogue_ar($"{i}.) {char_struct_id.name}\n");
		}
		
		scr_add_str_to_dialogue_ar("\n");
		if !show_give_command_boolean && !show_use_item_command_boolean {
			scr_add_str_to_dialogue_ar($"Enter a character's corresponding number to change control to that character. You can also use '<' or '>' to iterate through characters in your party.\n",true);
		}
		else if show_give_command_boolean {
			scr_add_str_to_dialogue_ar($"Enter the corresponding number of the character who will receive the item.\n",true);	
		}
		else if show_use_item_command_boolean {
			scr_add_str_to_dialogue_ar($"Enter the corresponding number of the character you will use the item on.\n",true);
		}
	}
	else {
		scr_add_str_to_dialogue_ar($"scr_print_pc_party failed to print the correct array.");
	}
}