
function scr_print_passive_abils_list(cur_char_id, update_scroll_pos = true){
	
	scr_add_str_to_dialogue_ar($"\n{cur_char_id.name} has the following passive abilities:", false, update_scroll_pos);	
	
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
				abil_str += $"Healing Factor: Automatically heals {HEALING_FACTOR_HEAL_VAL} hit points or {HEALING_FACTOR_HEAL_VAL} infection points each turn, both in combat and outside of it. Does not heal infection during combat. Also has a 20% chance of removing permanent injuries at the start of every turn.";
			}
			else if abil_enum == passive_abil_type.cybernetic {
				abil_str += $"Cybernetic: Increased resistence to most status effects and hazards. Susceptible to electrical damage: all electrical damage sustained is doubled.";
			}
			else if abil_enum == passive_abil_type.synthetic {
				abil_str += $"Synthetic: Immune to most status effects and hazards. Immune to morale damage. +1 armor. Does not consume food. Must be 'r'epaired in order to regain hit points. Susceptible to electrical damage: all electrical damage sustained is tripled.";
			}
			else if abil_enum == passive_abil_type.child {
				abil_str += $"Child: Due to their small size, this character can't wield weapons and can't wear marine armor. This character does not automatically trigger combat with enemies while moving between rooms, but will still trigger combat with enemies at the start of each turn, if they are not hidden. Also is the only character small enough to traverse through ventillation shafts.";
			}
			
			//cybernetic //synthetic //child
			
			scr_add_str_to_dialogue_ar($"\n{abil_str}", false, update_scroll_pos);	
		}
	}
	//No items or abilities were present from scr_build_weps_or_abils_list:
	else {
		scr_add_str_to_dialogue_ar("None.", false, update_scroll_pos);	
	}

}