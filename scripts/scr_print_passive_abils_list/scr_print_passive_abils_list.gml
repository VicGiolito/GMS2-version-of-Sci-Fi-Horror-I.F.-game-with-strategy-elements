
function scr_print_passive_abils_list(cur_char_id){
	
	scr_add_str_to_dialogue_ar($"\n{cur_char_id.name} has the following passive abilities:\n");	
	
	if is_array(cur_char_id.passive_abil_ar) && array_length(cur_char_id.passive_abil_ar) > 0 {
		
		var abil_enum, ar_len = array_length(cur_char_id.passive_abil_ar);

		for(var i = 0; i < ar_len; i++) {
			
			var abil_str = "";
			abil_enum = cur_char_id.passive_abil_ar[i];
			
			if abil_enum == passive_abil_type.thick_hide {
				abil_str += $"Thick Hide: +{PASSIVE_THICK_HIDE_ARMOR_BUFF} armor.";
			}
			else if abil_enum == passive_abil_type.hardened_skin {
				abil_str += $"Hardened Frame: +{PASSIVE_HARDENED_FRAME_ARMOR_BUFF} armor.";
			}
			else if abil_enum == passive_abil_type.giant {
				abil_str += $"Giant Mutant: -{CRAGOS_ACC_DEBUFF} accuracy with ranged weapons, -{CRAGOS_EVASION_DEBUFF} evasion, +{GIANT_MELEE_DMG_BUFF} damage in melee. Increased resistence to most status effects. Can't hide from enemies.";
			}
			else if abil_enum == passive_abil_type.healing_factor {
				abil_str += $"Healing Factor: Automatically heals {HEALING_FACTOR_HEAL_VAL} hit points or {HEALING_FACTOR_HEAL_VAL} infection points at the start of each turn, both in combat and outside of it. Infection points are removed first. Also has a 20% chance of removing permanent injuries at the start of every turn.";
			}
			else if abil_enum == passive_abil_type.cybernetic {
				abil_str += $"Cybernetic: Increased resistence to most status effects and hazards. Increased to electrical hazard damage by 50%.";
			}
			else if abil_enum == passive_abil_type.synthetic {
				abil_str += $"Synthetic: Immune to most status effects and hazards. Immune to morale damage. Increased electrical hazard damage by 100%. +1 armor.";
			}
			else if abil_enum == passive_abil_type.child {
				abil_str += $"Child: Due to her small size, can't wield weapons and can't wear marine armor. +{PASSIVE_CHILD_STEALTH_BUFF} to stealth skill tests when hiding in rooms. Is the only character small enough to traverse through the ventillation shafts on the ship.";
			}
			
			//cybernetic //synthetic //child
			
			scr_add_str_to_dialogue_ar($"{abil_str}\n");	
		}
	}
	//No items or abilities were present from scr_build_weps_or_abils_list:
	else {
		scr_add_str_to_dialogue_ar("None.");	
	}

}