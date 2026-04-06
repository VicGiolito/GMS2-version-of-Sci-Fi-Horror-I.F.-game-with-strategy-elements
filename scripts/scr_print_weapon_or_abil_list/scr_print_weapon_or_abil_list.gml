
//if print_weapon_list_bool == false, we print the char's abil list instead

function scr_print_weapon_or_abil_list(print_weapon_list_bool, cur_char_id, update_scroll_pos = true){
	
	if print_weapon_list_bool {
		scr_add_str_to_dialogue_ar("\nYou have the following weapon's equipped:", false, update_scroll_pos);
	}
	
	else {
		scr_add_str_to_dialogue_ar($"\n{cur_char_id.name} has access to the following skills and abilities:\n", false, update_scroll_pos);	
	}
	
	if is_array(cur_char_id.filtered_abil_ar) && array_length(cur_char_id.filtered_abil_ar) > 0 {
		var item_struct_id;
		var ar_len = array_length(cur_char_id.filtered_abil_ar);
		
		var abil_points, num_targets, stun, burn, suppress, bleed, infect, poison;
		
		for(var i = 0; i < ar_len; i++) {
			
			var abil_str = "";
			item_struct_id = cur_char_id.filtered_abil_ar[i];
			
			//This is a weapon-type ability-item; they all share similar use and so we can define them here:
			if item_struct_id.non_attack_ability_boolean == false {
			
				abil_points = item_struct_id.ability_point_cost;
			
				var abil_point_plural_str = "";
				if abil_points > 1 abil_point_plural_str = "s";
			
				abil_str += $"\n{i}.) {item_struct_id.item_name}: Spend {abil_points} A.P.: Deal {item_struct_id.dmg_min}-{item_struct_id.dmg_max} damage. Total targets: ";
				
				//Define total targets string:
				num_targets = item_struct_id.aoe_count;
				var total_targets_str;
				if num_targets == -1 total_targets_str = "all enemies";
				else total_targets_str = num_targets;
				abil_str += $"{total_targets_str}.";
				
				//Define range string:
				abil_str += $" Range: {item_struct_id.max_range}."
				
				//Define status effects:
				stun = item_struct_id.stun_chance;
				if stun > 0 abil_str += $" Stun: {stun}%";
				if item_struct_id.item_enum == item_type.headbutt abil_str += " (25% chance to stun self)";
				
				burn = item_struct_id.burn_chance;
				if burn > 0 abil_str += $" Burn: {burn}%";
				
				suppress = item_struct_id.suppress_chance;
				if suppress > 0 abil_str += $" Suppress: {suppress}%";
				
				bleed = item_struct_id.bleed_chance;
				if bleed > 0 abil_str += $" Bleed: {bleed}%";
				
				infect = item_struct_id.infection_chance;
				if infect > 0 abil_str += $" Infect: {infect}%";
				
				poison = item_struct_id.poison_chance;
				if poison > 0 abil_str += $" Poison: {poison}%";
			}
			//Spawns, buffs, debuffs - these abilities all behave so wildly differently that it's worth it to just use its custom string:
			else if item_struct_id.non_attack_ability_boolean == true {
				abil_str = $"\n{i}.) {item_struct_id.item_name}: "+string(item_struct_id.ability_cost_str);	
			}
			
			scr_add_str_to_dialogue_ar($"{abil_str}\n", false, update_scroll_pos);
			
			//$"Spend {ability_point_cost} AP: Deal {dmg_min}-{dmg_max} to up to {aoe_count} enemies. Range: {max_range}. Burn: {burn_chance}% Bleed: {bleed_chance}% Suppress: {suppress_chance}% Stun: {stun_chance}%";
		}
	}
	//No items or abilities were present from scr_build_weps_or_abils_list:
	else {
		scr_add_str_to_dialogue_ar("None.", false, update_scroll_pos);	
	}
	
	if global.cur_game_state != game_state.choose_chars scr_add_str_to_dialogue_ar("\nEnter the corresponding weapon or ability number, or enter 'B' or 'BACKUP' to return to the previous game state.", true, update_scroll_pos);
}