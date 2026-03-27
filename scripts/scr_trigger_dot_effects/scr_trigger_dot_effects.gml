


function scr_trigger_dot_effects(char_struct_id){
	
	/* Status type effects that still need to be implemented:
		
        infection_count = 0;
        
        inside_toxic_gas_boolean = false;
        inside_vacuum_boolean = false;
	*/
	
	var char_still_alive_bool = true;
	
	var dot_result_str = "", collapsed_bool = false;
	var char_name_str = char_struct_id.name;
	
	if char_struct_id.treacherous_count > 0 {
		char_struct_id.treacherous_count--;
		
		if char_struct_id.treacherous_count == 0 {
			char_struct_id.char_team_enum = team_type.pc;
			dot_result_str += $"**{scr_string_capitalize(char_name_str)} has come to their senses and is no longer TREACHEROUS.**\n";
		}
	}
	
	if char_struct_id.berserk_count > 0 {
		char_struct_id.berserk_count--;
		
		if char_struct_id.berserk_count == 0 {
			char_struct_id.char_team_enum = team_type.pc;
			dot_result_str += $"**{scr_string_capitalize(char_name_str)} has come to their senses and is no longer BERSERK.**\n";
		}
	}
	
	if char_struct_id.stun_count > 0 {
		
		var plural_str = "";
		
		if char_struct_id.stun_count > 1 plural_str = "s";
		
		//Show cowering string:
		if char_struct_id.cowering_bool == true {
			var broken_morale_status_effect_struct = scr_return_broken_status_effect_struct(char_struct_id, broken_morale_status_effects.cowering);
			
			dot_result_str +=$"**{broken_morale_status_effect_struct.broken_morale_str}**\n";
		}
		
		else dot_result_str += $"**{char_name_str}({char_struct_id.unique_id}) is stunned, reeling in pain...**\n";
		
		char_struct_id.stun_count--;
		
		char_still_alive_bool = false; //While the char is still technically alive, we want this script to return false 
		//so that the stunned char is 'skipped' and doesn't get to perform an action on their turn.
		
		//Show 'revived' string:
		if char_struct_id.cowering_bool == false && char_struct_id.stun_count <= 0 {
			dot_result_str += $"**... But they soon recover.**\n";	
		}
		
		if char_struct_id.stun_count <= 0 { char_struct_id.cowering_bool = false; } //Reset
	}
	
	if char_struct_id.burning_count > 0 {
		
		char_struct_id.hp_cur -= DOT_FIRE;
		
		char_struct_id.burning_count--;
		
		dot_result_str += $"{char_name_str}({char_struct_id.unique_id}) is burning! They have taken {DOT_FIRE} damage!\n";
		
		if char_struct_id.unconscious_bool == false && char_struct_id.hp_cur <= 0 collapsed_bool = true;
	}
	
	if char_struct_id.poisoned_count > 0 {
		
		var poison_dmg = max(1, floor(char_struct_id.hp_max * POISON_PERCENT_VAL) );
		
		char_struct_id.hp_cur -= poison_dmg;
		
		char_struct_id.poisoned_count--;
		
		dot_result_str += $"{char_name_str}({char_struct_id.unique_id}) feels the poison coursing through their veins! They have taken {poison_dmg} damage!\n";
		
		if char_struct_id.unconscious_bool == false && char_struct_id.hp_cur <= 0 collapsed_bool = true;
	}
	
	if char_struct_id.bleeding_count > 0 {
		
		var bleed_dmg = max(1, floor(char_struct_id.hp_max * BLEED_PERCENT_VAL) );
		
		char_struct_id.hp_cur -= bleed_dmg;
		
		char_struct_id.bleeding_count--;
		
		dot_result_str += $"{char_name_str}({char_struct_id.unique_id}) is bleeding out! They have taken {bleed_dmg} damage!\n";
		
		if char_struct_id.unconscious_bool == false && char_struct_id.hp_cur <= 0 collapsed_bool = true;
	}
	
	if char_struct_id.suppressed_count > 0 {
		
		char_struct_id.suppressed_count--;
		
		if char_struct_id.suppressed_count <= 0 {
			dot_result_str += $"{char_name_str}({char_struct_id.unique_id}) is no longer suppressed! (+{SUPPRESSED_SPEED_DEBUFF} speed, +{SUPPRESSED_EVASION_DEBUFF} evasion.)\n";
			char_struct_id.spd += SUPPRESSED_SPEED_DEBUFF;
			char_struct_id.evasion += SUPPRESSED_EVASION_DEBUFF;
		}
	}
	
	if char_struct_id.adrenal_pen_count > 0 {
		
		char_struct_id.adrenal_pen_count--;
		
		if char_struct_id.adrenal_pen_count <= 0 {
			dot_result_str += $"{char_name_str}({char_struct_id.unique_id}) is no longer adrenalized. They feel the world speed up. (-{ADRENAL_PEN_SPD_BUFF} speed, -{ADRENAL_PEN_ACC_BUFF} accuracy.)\n";
			char_struct_id.spd -= ADRENAL_PEN_SPD_BUFF;
			char_struct_id.accuracy_bonus -= ADRENAL_PEN_ACC_BUFF;
		}
	}
	
	//Smoke grenade:
	if char_struct_id.smoke_grenade_count > 0 {
		
		char_struct_id.smoke_grenade_count--;
		
		if char_struct_id.smoke_grenade_count <= 0 {
			dot_result_str += $"{char_name_str}({char_struct_id.unique_id}) is no longer affected by the smoke grenade. (-{SMOKE_GRENADE_EVADE_BUFF} evasion.)\n";
			char_struct_id.evasion -= SMOKE_GRENADE_EVADE_BUFF;
		}
	}
	
	//Personal shield:
	if char_struct_id.shield_bubble_count > 0 {
		
		char_struct_id.shield_bubble_count--;
		
		if char_struct_id.shield_bubble_count <= 0 {
	
			char_struct_id.armor -= PERSONAL_SHIELD_ARMOR_BUFF;
			char_struct_id.evasion -= PERSONAL_SHIELD_EVASION_BUFF;
			
			dot_result_str += $"{char_name_str}({char_struct_id.unique_id})'s PERSONAL SHIELD GENERATOR flickers off. (-{PERSONAL_SHIELD_ARMOR_BUFF} armor, -{PERSONAL_SHIELD_EVASION_BUFF} evasion.)\n";
		}
	}
	
	//Healing factor:
	if char_struct_id.healing_factor_boolean == true {
		
		char_struct_id.healing_factor_cd++;
		
		if char_struct_id.healing_factor_cd >= HEALING_FACTOR_CD_VAL {
			
			char_struct_id.healing_factor_cd = 0; //Reset
			
			if char_struct_id.hp_cur < char_struct_id.hp_max {
				
				char_struct_id.hp_cur += HEALING_FACTOR_HEAL_VAL;
				
				//Cap:
				if char_struct_id.hp_cur > char_struct_id.hp_max { char_struct_id.hp_cur = char_struct_id.hp_max; }
				
				var hp_plural_str = "";
				if HEALING_FACTOR_HEAL_VAL > 1 hp_plural_str = "s";
				
				dot_result_str += $"**{char_name_str}({char_struct_id.unique_id}) has healed {HEALING_FACTOR_HEAL_VAL} hit point{hp_plural_str}, thanks to their healing factor.**\n";
				
				//Check to see if this char (the ogre has revived):
				if char_struct_id.unconscious_bool == true && char_struct_id.hp_cur > 0 {
					char_struct_id.unconscious_bool = false;
					char_struct_id.unconscious_count = 0;
					var ogre_revived_str = "";
					if char_struct_id.char_type_enum == character.ogre {
						ogre_revived_str = char_struct_id.revived_dialogue_str_ar[irandom_range(0,array_length(char_struct_id.revived_dialogue_str_ar)-1)];
					}
					dot_result_str += $"**{char_name_str} has woken up!**\n**{ogre_revived_str}**\n";
					if char_struct_id.sanity_cur <= 0 char_struct_id.sanity_cur = floor(char_struct_id.sanity_max / 2); //Reset sanity to half max, if applicable:
					collapsed_bool = false;
				}
			}
		}
	}
	
	//Healing nanites:
	if char_struct_id.healing_nanites_count > 0 {
		
		char_struct_id.healing_nanites_count--;
		
		if char_struct_id.hp_cur < char_struct_id.hp_max {
				
			char_struct_id.hp_cur += REGEN_NANITES_HEAL_VAL;
			
			//Cap:
			if char_struct_id.hp_cur > char_struct_id.hp_max { char_struct_id.hp_cur = char_struct_id.hp_max; }
			
			var hp_plural_str = "";
			if REGEN_NANITES_HEAL_VAL > 1 hp_plural_str = "s";
			
			dot_result_str += $"**{char_name_str}({char_struct_id.unique_id}) has healed {REGEN_NANITES_HEAL_VAL} hit point{plural_str}, thanks to the regeneration nanites in their blood stream.**\n";
				
			//Check to see if this char (the ogre has revived):
			if char_struct_id.unconscious_bool == true && char_struct_id.hp_cur > 0 {
				char_struct_id.unconscious_bool = false;
				char_struct_id.unconscious_count = 0;
				var ogre_revived_str = "";
				if char_struct_id.char_type_enum == character.ogre && is_array(char_struct_id.revived_dialogue_str_ar) && array_length(char_struct_id.revived_dialogue_str_ar) > 0 {
						ogre_revived_str = char_struct_id.revived_dialogue_str_ar[irandom_range(0,array_length(char_struct_id.revived_dialogue_str_ar)-1)];
				}
				dot_result_str += $"{char_name_str}({char_struct_id.unique_id}) has woken up!\n**{ogre_revived_str}**\n";
				
				if char_struct_id.sanity_cur == 0 char_struct_id.sanity_cur = floor(char_struct_id.sanity_max / 2); //Reset sanity to half max, if applicable:
				collapsed_bool = false;
			}
		}	
	}
	
	//Show collapsed message, apply unconscious count:
	if collapsed_bool {
		if char_struct_id.char_team_enum == team_type.pc {
			dot_result_str += $"**{char_name_str}({char_struct_id.unique_id}) has collapsed!**\n";
			char_struct_id.unconscious_bool = true;
			//Reset all of their revelant status effect counts - pcs do not continue to take dot damage after collapsing:
			scr_reset_status_effects(char_struct_id);
		}
		else {
			dot_result_str += $"**{char_name_str}({char_struct_id.unique_id}) has died!**\n";
			char_struct_id.has_died_bool = true;
			char_still_alive_bool = false;
		}
	}
	
	//Unconscious logic:
	if char_struct_id.char_team_enum == team_type.pc && char_struct_id.unconscious_bool == true && char_struct_id.has_died_bool == false {
		
		char_struct_id.unconscious_count++;
		
		//Switch boolean, show death message:
		if char_struct_id.unconscious_count >= UNCONSCIOUS_DURATION {
			dot_result_str += $"**{char_name_str}({char_struct_id.unique_id}) has gasped their last breath!**\n";
			char_struct_id.has_died_bool = true;
			char_still_alive_bool = false;
		}
		
		//Show message:
		else {
			dot_result_str += $"**{char_name_str}({char_struct_id.unique_id}) is unconscious with {char_struct_id.hp_cur} hit points. You have {4-char_struct_id.unconscious_count} more turns to restore their hit points above zero, otherwise they will die...**\n";
		}
	}
	
	if dot_result_str != "" {
		scr_add_str_to_dialogue_ar("\n"+dot_result_str);
	}
	
	return char_still_alive_bool;
}