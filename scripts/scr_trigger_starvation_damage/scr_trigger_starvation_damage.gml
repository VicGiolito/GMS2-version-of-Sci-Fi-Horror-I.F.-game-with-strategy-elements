

function scr_trigger_starvation_damage(){
	
	if global.resources_food <= 0 {
	
		if is_array(global.pc_char_ar) && array_length(global.pc_char_ar) > 0 {
	
			var ar_len = array_length(global.pc_char_ar), pc_char_id;
		
			for(var i = 0; i < ar_len; i++) {
				
				pc_char_id = global.pc_char_ar[i];
				
				if is_struct(pc_char_id) && pc_char_id.struct_type_enum == struct_type.Character {
				
					if pc_char_id.unconscious_bool == false {
						
						if scr_check_ar_for_val(pc_char_id.passive_abil_ar, passive_abil_type.synthetic) == false {
						
							pc_char_id.hp_cur -= STARVING_HP_LOSS;	
						
							scr_add_str_to_dialogue_ar($"\n{pc_char_id.name} is starving! Their hit points have been reduced by {STARVING_HP_LOSS}.");
						
							if pc_char_id.hp_cur <= 0 {
								pc_char_id.unconscious_bool = true;
								scr_add_str_to_dialogue_ar($"\n{pc_char_id.name} has collapsed!");	
							}
						}
					}
				}
			}
		}
	}
}