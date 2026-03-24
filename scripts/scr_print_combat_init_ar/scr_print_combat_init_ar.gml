

function scr_print_combat_init_ar(){
	
	scr_add_str_to_dialogue_ar("\n");
	scr_add_str_to_dialogue_ar($"This is the order of the intiative queue for round {global.cur_combat_round}:");
	
	var ar_len = array_length(global.combat_initiative_ar);
	var char_struct_id;
	for(var i = 0; i < ar_len; i++) {
		
		char_struct_id = global.combat_initiative_ar[i];
		
		if char_struct_id.has_died_bool == false && char_struct_id.has_fled_combat_bool == false {
			
			var collapsed_str = "";
			var plural_str = "";
			
			if char_struct_id.unconscious_bool == true {
				if UNCONSCIOUS_DURATION - char_struct_id.unconscious_count > 1 plural_str = "s";
				collapsed_str = $" (unconscious for {UNCONSCIOUS_DURATION - char_struct_id.unconscious_count} more turn{plural_str})";
			}
			
			scr_add_str_to_dialogue_ar($"{i}.) {char_struct_id.name}({char_struct_id.unique_id}){collapsed_str}.");
		}
	}
}