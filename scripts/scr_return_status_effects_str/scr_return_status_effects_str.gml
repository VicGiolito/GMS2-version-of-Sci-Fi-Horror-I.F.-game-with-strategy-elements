


function scr_return_status_effects_str(char_struct_id, print_active_title = true){
	
	if is_undefined(char_struct_id) throw("scr_return_status_effects_str: char_struct_id is undefined.");
	
	var status_effects_str = "";
	
	if print_active_title status_effects_str += "Active Status Effects: ";
	
	var status_effect_found = false;
	
	with(char_struct_id) {
		
		if char_hiding_in_room == true {
			status_effect_found = true;	
			status_effects_str += $"HIDING ";	
		}
		
		if treacherous_count > 0 {
			status_effect_found = true;	
			status_effects_str += $"TREACHEROUS [{treacherous_count}] ";
		}
		
		if berserk_count > 0 {
			status_effect_found = true;	
			status_effects_str += $"BERSERK [{berserk_count}] ";
		}
		
		if cowering_bool == true {
			status_effect_found = true;	
			status_effects_str += $"COWERING [{stun_count}] ";
		}
		
		if char_fleeing_from_broken_morale == true {
			status_effect_found = true;	
			status_effects_str += $"FLEEING ";
		}
		
		if infection_count > 0 {
			status_effect_found = true;	
			status_effects_str += $"Infected [{infection_count}/{char_max_infection}] ";
		}
		if burning_count > 0 {
			status_effect_found = true;	
			status_effects_str += $"Burning [{burning_count}] ";
		}
		if poisoned_count > 0 {
			status_effect_found = true;	
			status_effects_str += $"Poisoned [{poisoned_count}] ";
		}
		if bleeding_count > 0 {
			status_effect_found = true;	
			status_effects_str += $"Bleeding [{bleeding_count}] ";
		}
		if unconscious_bool {
			status_effect_found = true;
			var remaining_unconscious_duration = UNCONSCIOUS_DURATION - unconscious_count;
			var plural_str = "";
			if remaining_unconscious_duration > 1 plural_str = "s";
			status_effects_str += $"Unconscious [{remaining_unconscious_duration} more turn{plural_str}] ";
		}
		
		if smoke_grenade_count > 0 {
			status_effect_found = true;	
			status_effects_str += $"Smoke Grenade [+{SMOKE_GRENADE_EVADE_BUFF} evasion] ";		
		}
		
		if inside_toxic_gas_boolean {
			status_effect_found = true;	
			status_effects_str += $"Gagging [toxic gas] ";
		}
		if inside_vacuum_boolean {
			status_effect_found = true;	
			status_effects_str += $"Choking [vacuum] ";
		}
		if healing_nanites_count > 0 {
			status_effect_found = true;	
			status_effects_str += $"Regenerating [+{REGEN_NANITES_HEAL_VAL} hit points per turn.] ";
		}
		if adrenal_pen_count > 0 {
			status_effect_found = true;	
			status_effects_str += $"Adrenalized [+{ADRENAL_PEN_ACC_BUFF} accuracy, +{ADRENAL_PEN_SPD_BUFF} speed.] ";
		}
		if suppressed_count > 0 {
			status_effect_found = true;	
			status_effects_str += $"Suppressed [can't move, -{SUPPRESSED_EVASION_DEBUFF} evasion, -{SUPPRESSED_SPEED_DEBUFF} speed.] ";
		}
		
		if shield_bubble_count > 0 {
			status_effect_found = true;	
			status_effects_str += $"Personal Shield [+{PERSONAL_SHIELD_ARMOR_BUFF} armor, +{PERSONAL_SHIELD_EVASION_BUFF} evasion] ";	
		}
		
		//We don't also need to know that the character is stunned if they are already cowering - it is implied.
		if stun_count > 0 && cowering_bool == false {
			status_effect_found = true;	
			status_effects_str += $"Stunned [{stun_count}] ";
		}
	}
	
	//if !status_effect_found status_effects_str = "None";
	
	return status_effects_str;
}