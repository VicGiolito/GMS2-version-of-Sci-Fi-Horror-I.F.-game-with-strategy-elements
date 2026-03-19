


function scr_return_status_effects_str(char_struct_id){
	
	if is_undefined(char_struct_id) throw("scr_return_status_effects_str: char_struct_id is undefined.");
	
	var status_effects_str = "Active Status Effects: ";
	
	var status_effect_found = false;
	
	with(char_struct_id) {	
		if infection_count > 0 {
			status_effect_found = true;	
			status_effects_str += $"Infected({infection_count})";
		}
		if burning_count > 0 {
			status_effect_found = true;	
			status_effects_str += $" Burning({burning_count})";
		}
		if poisoned_count > 0 {
			status_effect_found = true;	
			status_effects_str += $" Poisoned({poisoned_count})";
		}
		if bleeding_count > 0 {
			status_effect_found = true;	
			status_effects_str += $" Bleeding({bleeding_count})";
		}
		if unconscious_bool  {
			status_effect_found = true;	
			status_effects_str += $" Unconscious";
		}
		if inside_toxic_gas_boolean {
			status_effect_found = true;	
			status_effects_str += $" Gagging(toxic gas)";
		}
		if inside_vacuum_boolean {
			status_effect_found = true;	
			status_effects_str += $" Choking(vacuum)";
		}
		if healing_nanites_count > 0 {
			status_effect_found = true;	
			status_effects_str += $" Regenerating({healing_nanites_count})";
		}
		if adrenal_pen_count > 0 {
			status_effect_found = true;	
			status_effects_str += $" Adrenalized({healing_nanites_count})";
		}
		if suppressed_count > 0 {
			status_effect_found = true;	
			status_effects_str += $" Suppressed({suppressed_count})";
		}
		if stun_count > 0 {
			status_effect_found = true;	
			status_effects_str += $" Stunned({stun_count})";
		}
	}
	
	if !status_effect_found status_effects_str = "None";
	
	return status_effects_str;
}