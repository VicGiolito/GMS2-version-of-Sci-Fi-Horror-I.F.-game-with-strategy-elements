

function scr_apply_broken_morale(char_struct_id){
	
	var results_str = "";
	
	//Because neutrals can theoretically end up here (if they are not morale_immune), we need to exclude them, if applicable:
	if is_array(char_struct_id.broken_morale_ar) && array_length(char_struct_id.broken_morale_ar) > 0 {
	
		results_str += $"The sanity of {scr_string_capitalize(char_struct_id.name)} has been broken!";
		
		//Choose random status effect from applicable options:
		var ran_broken_morale_struct = char_struct_id.broken_morale_ar[irandom_range(0,array_length(char_struct_id.broken_morale_ar)-1)];
		
		var ran_broken_morale_status_effect_enum = ran_broken_morale_struct.broken_morale_status_effect_enum;
	
		var immediate_dialogue_str = "";
	
		var status_effect_str = "";
	
		//Treacherous:
		if ran_broken_morale_status_effect_enum == broken_morale_status_effects.treacherous {
			status_effect_str = "--Treacherous--";
			
			char_struct_id.treacherous_count = TREACHEROUS_DURATION;
			
			char_struct_id.char_team_enum = team_type.enemy;
		
			//Set ai to ranged_stationary
			char_struct_id.combat_ai_preference = enemy_combat_ai.ranged_stationary; //choose(enemy_combat_ai.melee, enemy_combat_ai.ranged_coward);	
			
		
			immediate_dialogue_str = $"**{ran_broken_morale_struct.broken_morale_str}**\n";
		}
	
		//Berserk:
		if ran_broken_morale_status_effect_enum == broken_morale_status_effects.berserk {
			status_effect_str = "--Berserk--";
			
			char_struct_id.berserk_count = BERSERK_DURATION;
			
			char_struct_id.char_team_enum = team_type.neutral;
		
			char_struct_id.combat_ai_preference = enemy_combat_ai.melee;
		
			immediate_dialogue_str = $"**{ran_broken_morale_struct.broken_morale_str}**\n";
		}
	
		//Fleeing:
		if ran_broken_morale_status_effect_enum == broken_morale_status_effects.fleeing {
		
			status_effect_str = "--Fleeing--";	
		
			char_struct_id.fleeing_str = ran_broken_morale_struct.broken_morale_str;
		
			//Assign fleeing_dir_x and y; and if they can't flee, they will cower instead:
			var ran_flee_ar = [], valid_flee_dir_found = false;
			array_push(ran_flee_ar, { move_dir_x: -1, move_dir_y: 0 } ); //West
			array_push(ran_flee_ar, { move_dir_x: 0, move_dir_y: -1 } ); //North
			array_push(ran_flee_ar, { move_dir_x: 1, move_dir_y: 0 } ); //East
			array_push(ran_flee_ar, { move_dir_x: 0, move_dir_y: 1 } ); //South
			repeat(4) {
			
				if array_length(ran_flee_ar) > 0 {
			
					var ran_index = irandom_range(0,array_length(ran_flee_ar)-1);
					
					var ran_dir_struct = ran_flee_ar[ran_index];
				
					var move_x = ran_dir_struct.move_dir_x;
					var move_y = ran_dir_struct.move_dir_y;
			
					valid_flee_dir_found = scr_check_valid_door_dir(char_struct_id.cur_room_id, move_x, move_y);
			
					if valid_flee_dir_found {
						char_struct_id.fleeing_dir_x = move_x;
						char_struct_id.fleeing_dir_y = move_y;
						char_struct_id.char_fleeing_from_broken_morale = true;
						break;
					}
				
					array_delete(ran_flee_ar,ran_index,1);
				}
			}
		
			//Just assign this char to cowering, if there's no where it can flee to:
			if !valid_flee_dir_found {
				ran_broken_morale_status_effect_enum = broken_morale_status_effects.cowering;
			}
		}
	
		//Cowering:
		if ran_broken_morale_status_effect_enum == broken_morale_status_effects.cowering {
			status_effect_str = "--Cowering--";	
			
			char_struct_id.stun_count = COWERING_STUNNED_DURATION;
			char_struct_id.cowering_bool = true;
		
			//Since cowering behaves just like stun, cancel dodge, overwatch, cooper's smoke bomb, things like that, etc.:
			if char_struct_id.evading_boolean == true {
				char_struct_id.evading_boolean = false;
				char_struct_id.evasion -= EVADE_BONUS;
			}
			if char_struct_id.smoke_grenade_count > 0 {
				char_struct_id.smoke_grenade_count = 0;
				char_struct_id.evasion -= SMOKE_GRENADE_EVADE_BUFF;
			}
			scr_remove_char_from_overwatch_arrays(char_struct_id);
		}
		
		//Reduce/reset sanity after its ill effects have been triggered:
		char_struct_id.sanity_cur = floor(char_struct_id.sanity_max / 2); //Reset sanity to half max, if applicable:
	
		//Add to string:
		scr_add_str_to_dialogue_ar($"\n**{results_str} ({status_effect_str})**\n{immediate_dialogue_str}");	
	}
}