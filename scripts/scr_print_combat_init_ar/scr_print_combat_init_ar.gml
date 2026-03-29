

function scr_print_combat_init_ar(){
	
	scr_add_str_to_dialogue_ar("\n");
	scr_add_str_to_dialogue_ar($"This is the order of the intiative queue for round {global.cur_combat_round}:");
	
	var ar_len = array_length(global.combat_initiative_ar);
	var char_struct_id;
	for(var i = 0; i < ar_len; i++) {
		
		char_struct_id = global.combat_initiative_ar[i];
		
		if char_struct_id.has_died_bool == false && char_struct_id.has_fled_combat_bool == false {
			
			var status_effects_list = scr_return_status_effects_str(char_struct_id,false);
			
			if status_effects_list != "" var status_effects_str = $" - {status_effects_list}";
			else var status_effects_str = "";
			
			scr_add_str_to_dialogue_ar($"{i}.) {char_struct_id.name}({char_struct_id.unique_id}){status_effects_str}");
		}
	}
}