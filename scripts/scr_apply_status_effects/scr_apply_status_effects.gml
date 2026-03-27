

function scr_apply_status_effects(item_struct_id, target_char_id){
	
	var status_effect_result_str = "";
	
	if item_struct_id.burn_chance > 0 {
		var total_status_chance = item_struct_id.burn_chance - target_char_id.res_fire;
		d($"Burn chance == {item_struct_id.burn_chance}, target res == {target_char_id.res_fire}, total_status_chance == {total_status_chance} ");
		if total_status_chance > 0 {
			var ran_val = irandom_range(1,100);
			
			//Apply status effect:
			if ran_val <= total_status_chance {
				d("THIS STATUS EFFECT WAS APPLIED!");
				//Apply effect, add message:
				target_char_id.burning_count = FIRE_DURATION; //Does not stack, but can be reapplied
				status_effect_result_str += $"**{target_char_id.name}({target_char_id.unique_id}) has caught fire! ({DOT_FIRE} damage per turn, does not stack.)**\n";
			}
		}		
	}
	
	if item_struct_id.poison_chance > 0 {
		var total_status_chance = item_struct_id.poison_chance - target_char_id.res_poison;
		d($"Poison chance == {item_struct_id.poison_chance}, target res == {target_char_id.res_poison}, total_status_chance == {total_status_chance} ");
		if total_status_chance > 0 {
			var ran_val = irandom_range(1,100);
			
			//Apply status effect:
			if ran_val <= total_status_chance {
				d("THIS STATUS EFFECT WAS APPLIED!");
				//Apply effect, add message:
				target_char_id.poisoned_count += POISON_DURATION; //Can stack
				var poison_percent_str = string(POISON_PERCENT_VAL*100);
				status_effect_result_str += $"**{target_char_id.name}({target_char_id.unique_id}) has been poisoned! ({poison_percent_str}% of maximum hit points as damage per turn, can stack.)**\n";
			}
		}		
	}
	
	if item_struct_id.bleed_chance > 0 {
		var total_status_chance = item_struct_id.bleed_chance - target_char_id.res_bleed;
		d($"Bleed chance == {item_struct_id.bleed_chance}, target res == {target_char_id.res_bleed}, total_status_chance == {total_status_chance} ");
		if total_status_chance > 0 {
			var ran_val = irandom_range(1,100);
			
			//Apply status effect:
			if ran_val <= total_status_chance {
				d("THIS STATUS EFFECT WAS APPLIED!");
				//Apply effect, add message:
				target_char_id.bleeding_count += BLEED_DURATION; //Can stack
				var bleed_percent_str = BLEED_PERCENT_VAL*100;
				status_effect_result_str += $"**{target_char_id.name}({target_char_id.unique_id}) is bleeding! ({bleed_percent_str}% of maximum hit points as damage per turn, can stack.)**\n";
			}
		}		
	}
	
	if item_struct_id.stun_chance > 0 {
		var total_status_chance = item_struct_id.stun_chance - target_char_id.res_stun;
		d($"Stun chance == {item_struct_id.stun_chance}, target res == {target_char_id.res_stun}, total_status_chance == {total_status_chance} ");
		if total_status_chance > 0 {
			var ran_val = irandom_range(1,100);
			
			//Apply status effect:
			if ran_val <= total_status_chance {
				d("ran_val <= total_status_chance, now checking to see if target is stun immune and if their stun count == 0.");
				//Already stunned chars can't get re-stunned, and stun immune chars are ignored entirely:
				if target_char_id.stun_count <= 0 && target_char_id.stun_immune_boolean == false {
					d("THIS STATUS EFFECT WAS APPLIED!");
					//Apply effect, add message:
					target_char_id.stun_count = 1; //Does not stack
					status_effect_result_str += $"**{target_char_id.name}({target_char_id.unique_id}) has been stunned! (Skips next turn, does not stack.)**\n";
					//Cancel dodge, overwatch, cooper's smoke bomb, things like that, etc.:
					if target_char_id.evading_boolean == true {
						target_char_id.evading_boolean = false;
						target_char_id.evasion -= EVADE_BONUS;
					}
					scr_remove_char_from_overwatch_arrays(target_char_id);
				}
			}
		}		
	}
	
	if item_struct_id.suppress_chance > 0 {
		var total_status_chance = item_struct_id.suppress_chance - target_char_id.res_suppress;
		d($"Suppress chance == {item_struct_id.suppress_chance}, target res == {target_char_id.res_suppress}, total_status_chance == {total_status_chance} ");
		if total_status_chance > 0 {
			var ran_val = irandom_range(1,100);
			
			//Apply status effect:
			if ran_val <= total_status_chance {
				d("ran_val <= total_status_chance, now checking to see if target is suppress immune");
				//Suppress immune chars are ignored entirely:
				if target_char_id.suppress_immune_boolean == false {
					d("THIS STATUS EFFECT WAS APPLIED!");
					
					//Actually apply suppressed effects, but only if this char was not already suppressed:
					if target_char_id.suppressed_count <= 0 {
						target_char_id.evasion -= SUPPRESSED_EVASION_DEBUFF;
						target_char_id.spd -= SUPPRESSED_SPEED_DEBUFF;
					}
					
					//Apply effect, add message:
					target_char_id.suppressed_count = 2; //Does not stack, but can be reapplied
					
					var plural_str = "";
					if SUPPRESS_DURATION > 1 plural_str = "s";
					status_effect_result_str += $"**{target_char_id.name}({target_char_id.unique_id}) has been suppressed! (Can't move, -{SUPPRESSED_EVASION_DEBUFF} evasion, -{SUPPRESSED_SPEED_DEBUFF} speed for {SUPPRESS_DURATION} turn{plural_str}. Does not stack.)**\n";
				}
			}
		}		
	}
	
	if item_struct_id.infection_chance > 0 {
		var total_status_chance = item_struct_id.infection_chance - target_char_id.res_infect;
		d($"Infect chance == {item_struct_id.infection_chance}, target res == {target_char_id.res_infect}, total_status_chance == {total_status_chance} ");
		if total_status_chance > 0 && target_char_id.infection_immune == false {
			var ran_val = irandom_range(1,100);
			
			//Apply status effect:
			if ran_val <= total_status_chance {
				d("THIS STATUS EFFECT WAS APPLIED!");
				//Apply effect, add message:
				target_char_id.infection_count += 1; //Can stack
				status_effect_result_str += $"**{target_char_id.name}({target_char_id.unique_id}) has been infected! (If their current infection of {target_char_id.infection_count} becomes greater than or equal to {target_char_id.char_max_infection}, they will transform into an enemy at the start of their next turn. Outside of combat, infection increases by 1 each turn.)**\n";
			}
		}		
	}
	
	//Print message:
	if status_effect_result_str != "" {
		scr_add_str_to_dialogue_ar(status_effect_result_str);
	}
}