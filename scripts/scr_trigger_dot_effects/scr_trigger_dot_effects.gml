


function scr_trigger_dot_effects(char_struct_id){
	
	/* Status type effects that still need to be implemented:
		
        infection_count = 0;
        
		Hazards:
        inside_toxic_gas_boolean = false;
        inside_vacuum_boolean = false;
		electric damage
		fire hazard damage
	*/
	
	var char_still_alive_bool = true;
	
	var dot_result_str = "", collapsed_bool = false;
	var char_name_str = char_struct_id.name;
	
	//In any case, this char is starting their new turn, they need to remove their id from the corresponding overwatch rank, if applicable:
	scr_remove_char_from_overwatch_arrays(char_struct_id);
	
	//In any case, pc_is_combat_moving is only triggered through assign_pc_command, and considering this is the start of a new char's turn,
	//this var needs to be reset:
	char_struct_id.pc_is_combat_moving = false;
	
	if char_struct_id.evading_boolean == true {
		char_struct_id.evasion -= EVADING_BUFF;	
		char_struct_id.evading_boolean = false;
	}
	
	if char_struct_id.treacherous_count > 0 {
		char_struct_id.treacherous_count--;
		
		if char_struct_id.treacherous_count == 0 {
			char_struct_id.char_team_enum = char_struct_id.origin_team;
			dot_result_str += $"**{scr_string_capitalize(char_name_str)} has come to their senses and is no longer TREACHEROUS.**\n";
			d($"****{char_struct_id.name} is NO LONGER TREACHEROUS, their team changed to pc.****");
			/*We need to manually change next_combat_game_state to combat assign pc command here, the reason being that when scr_evaluate_combat_conclusion() 
			was initially called for this character at the end the last combat_execute_action state, this character was still a enemy or a neutral, and
			therefore execute action was chosen; so now we need to manually assign this char to combat_assign_pc_command instead.
			*/
			next_combat_game_state = game_state.combat_assign_pc_command;
		}
	}
	
	if char_struct_id.berserk_count > 0 {
		char_struct_id.berserk_count--;
		
		if char_struct_id.berserk_count == 0 {
			char_struct_id.char_team_enum = team_type.pc;
			dot_result_str += $"**{scr_string_capitalize(char_name_str)} has come to their senses and is no longer BERSERK.**\n";
			d($"****{char_struct_id.name} is NO LONGER BERSERK, their team changed to pc.****");
			/*We need to manually change next_combat_game_state to combat assign pc command here, the reason being that when scr_evaluate_combat_conclusion() 
			was initially called for this character at the end the last combat_execute_action state, this character was still a enemy or a neutral, and
			therefore execute action was chosen; so now we need to manually assign this char to combat_assign_pc_command instead.
			*/
			next_combat_game_state = game_state.combat_assign_pc_command;
		}
	}
	
	if char_struct_id.stun_count > 0 {
		
		var plural_str = "";
		
		if char_struct_id.stun_count > 1 plural_str = "s";
		
		//Show cowering string:
		if char_struct_id.cowering_bool == true {
			
			dot_result_str +=$"**{char_struct_id.current_broken_morale_str}**\n\n**{char_struct_id.name} is cowering!**\n";
		}
		
		else dot_result_str += $"**{char_name_str}({char_struct_id.unique_id}) is stunned, reeling in pain...**\n";
		
		char_struct_id.stun_count--;
		
		char_still_alive_bool = false; //While the char is still technically alive, we want this script to return false 
		//so that the stunned char is 'skipped' and doesn't get to perform an action on their turn.
		
		//Show 'revived' string:
		if char_struct_id.cowering_bool == false && char_struct_id.stun_count <= 0 {
			dot_result_str += $"**... But they soon recover.**\n";	
		}
		//Reset bool, show string:
		else if char_struct_id.cowering_bool == true && char_struct_id.stun_count <= 0 {
			char_struct_id.cowering_bool = false;
			dot_result_str += $"\n**{scr_string_capitalize(char_name_str)} has come to their senses and is no longer COWERING.**\n";	
		}
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
			char_struct_id.accuracy -= ADRENAL_PEN_ACC_BUFF;
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
			
			//Infection is healed first:
			if char_struct_id.infection_count > 0 { 
				char_struct_id.infection_count -= HEALING_FACTOR_HEAL_VAL; 
				dot_result_str += $"**{char_name_str}({char_struct_id.unique_id}) has healed {HEALING_FACTOR_HEAL_VAL} infection point{hp_plural_str}, thanks to their healing factor.**\n";
			}
			
			else if char_struct_id.hp_cur < char_struct_id.hp_max {
				
				char_struct_id.hp_cur += HEALING_FACTOR_HEAL_VAL;
				
				//Cap:
				if char_struct_id.hp_cur > char_struct_id.hp_max { char_struct_id.hp_cur = char_struct_id.hp_max; }
				
				var hp_plural_str = "";
				if HEALING_FACTOR_HEAL_VAL > 1 hp_plural_str = "s";
				
				dot_result_str += $"**{char_name_str}({char_struct_id.unique_id}) has healed {HEALING_FACTOR_HEAL_VAL} hit point{hp_plural_str}, thanks to their healing factor.**\n";
				
				//It's possible that any of the DOT damage from above could have triggered the 'collapsed_bool' to switch to true,
				//then healing effects brought their hp above zero again; in this case, we need simply reset the bool again:
				if collapsed_bool == true && char_struct_id.hp_cur > 0 { collapsed_bool = false; }
				
				//Check to see if this char has revived:
				if char_struct_id.unconscious_bool == true && char_struct_id.hp_cur > 0 {
					char_struct_id.unconscious_bool = false;
					char_struct_id.unconscious_count = 0;
					var ogre_revived_str = "";
					if char_struct_id.char_type_enum == character.ogre {
						ogre_revived_str = char_struct_id.revived_dialogue_str_ar[irandom_range(0,array_length(char_struct_id.revived_dialogue_str_ar)-1)];
					}
					dot_result_str += $"**{char_name_str} has woken up!**\n**{ogre_revived_str}**\n";
					
					//Reset sanity to half max, if applicable:
					if char_struct_id.sanity_cur >= char_struct_id.sanity_max { char_struct_id.sanity_cur = floor(char_struct_id.sanity_max / 2); }
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
			
			var plural_str = "";
			if REGEN_NANITES_HEAL_VAL > 1 plural_str = "s";
			
			dot_result_str += $"**{char_name_str}({char_struct_id.unique_id}) has healed {REGEN_NANITES_HEAL_VAL} hit point{plural_str}, thanks to the regeneration nanites in their blood stream.**\n";
			
			//It's possible that any of the DOT damage from above could have triggered the 'collapsed_bool' to switch to true,
			//then healing effects brought their hp above zero again; in this case, we need simply reset the bool again:
			if collapsed_bool == true && char_struct_id.hp_cur > 0 { collapsed_bool = false; }
			
			//Check to see if this char has revived:
			if char_struct_id.unconscious_bool == true && char_struct_id.hp_cur > 0 {
				char_struct_id.unconscious_bool = false;
				char_struct_id.unconscious_count = 0;
				var ogre_revived_str = "";
				if char_struct_id.char_type_enum == character.ogre && is_array(char_struct_id.revived_dialogue_str_ar) && array_length(char_struct_id.revived_dialogue_str_ar) > 0 {
						ogre_revived_str = char_struct_id.revived_dialogue_str_ar[irandom_range(0,array_length(char_struct_id.revived_dialogue_str_ar)-1)];
				}
				dot_result_str += $"{char_name_str}({char_struct_id.unique_id}) has woken up!\n**{ogre_revived_str}**\n";
				
				//Reset sanity to half max, if applicable:
				if char_struct_id.sanity_cur >= char_struct_id.sanity_max { char_struct_id.sanity_cur = floor(char_struct_id.sanity_max / 2); }
				collapsed_bool = false;
			}
		}	
	}
	
	//Show collapsed message, apply unconscious count:
	if collapsed_bool {
		if char_struct_id.char_team_enum == team_type.pc || char_struct_id.berserk_count > 0 || char_struct_id.treacherous_count > 0  {
			dot_result_str += $"**{char_name_str}({char_struct_id.unique_id}) has collapsed!**\n";
			char_struct_id.unconscious_bool = true;
			//Reset all of their revelant status effect counts - pcs do not continue to take dot damage after collapsing:
			scr_reset_status_effects(char_struct_id,$"scr_trigger_dot_effects for char_struct_id.name: {char_struct_id.name}");
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
			
			//Drop all of their inventory:
			scr_drop_all_char_inv(char_struct_id, false);
			
			//Reassign their neutrals, if necessary; even though this code is in scr_delete_combat_chars(), scr_trigger_dot_effects() also triggers from
			//the main game state, so we need to include it here as well:
			scr_auto_reassign_neutrals_owner(char_struct_id);
		}
		
		//Show message:
		else {
			dot_result_str += $"**{char_name_str}({char_struct_id.unique_id}) is unconscious with {char_struct_id.hp_cur} hit points. You have {UNCONSCIOUS_DURATION-char_struct_id.unconscious_count} more turns to restore their hit points above zero, otherwise they will die...**\n";
		}
	}
	
	if dot_result_str != "" {
		scr_add_str_to_dialogue_ar("\n"+dot_result_str);
	}
	
	//Our finale:
	
	#region Fleeing code:
				
	if char_struct_id.char_fleeing_from_broken_morale == true {
					
		//Show their 'fleeing' string:
		scr_add_str_to_dialogue_ar($"\n**{char_struct_id.fleeing_str}**")
					
		//Choose the enemy character as the 'next_combat_char' that will get a free hit on this char, if any:
		/*pseudo code:
			--Iterate through the combat_rank_ar in both directions (starting north), searching for enemies. 
			--Each enemy we find, create a temporary array or list that is a copy of their ability_ar. Randomize the index 
			positions in it. Then iterate through that list, checking each weapon to see if its max range is within range
			of the fleeing character id. If it is, then we choose this character as the 'next_combat_char', and this
			weapon as their chosen weapon. Then we jump to execute action.
			--At the end of execute action, if the fleeing character hasn't been killed, then we remove them from combat,
			and check the end combat game state (script that).
			--Make all of this robust enough so that this code could be performed from the perspective of a fleeing
			pc, enemy, or neutral. It would be cool to have pcs and neutrals that can force enemies to run, and vice verssa.
		*/
					
		var valid_attacker_found = false; //Set to default
					
		var char_id, applicable_char_found = false;
		var cur_char_rank = char_struct_id.cur_combat_rank, iterate_count = 0;
		var rank_i = cur_char_rank, failsafe_val = 0, failsafe_max = array_length(global.combat_rank_ar);
					
		//First repeat loop we iterate 'north' (up); second time, we iterate south (down):
		repeat(2) {
			
			if valid_attacker_found break;
					
			//Reset between loops of iterating north or south:
			rank_i = cur_char_rank;
			
			failsafe_val = 0;
					
			//Iterate through up or down through g.combat_rank:
			do {
				//Iterate through nested_array:
				for(var i = 0; i < array_length(global.combat_rank_ar[rank_i]); i++) {
					
					applicable_char_found = false //reset
												
					//Assign char_id we are checking:
					char_id = global.combat_rank_ar[rank_i][i]; 
												
					//Same character, unconscious, dead, fled, or stunned chars cannot perform opportunity attack:
					if char_id != char_struct_id && char_id.unconscious_bool == false && char_id.stun_count <= 0 && char_id.has_died_bool == false && char_id.has_fled_combat_bool == false {
													
						//If this is a pc or a neutral fleeing, check to see if this is a enemy:
						if (char_struct_id.char_team_enum == team_type.pc || char_struct_id.char_team_enum == team_type.neutral) && char_id.char_team_enum == team_type.enemy {
							applicable_char_found = true;
						}
													
						//If this is a enemy fleeing, check to see if this is a pc or a neutral:
						else if char_struct_id.char_team_enum == team_type.enemy && (char_id.char_team_enum == team_type.pc || char_id.char_team_enum == team_type.neutral) {
							applicable_char_found = true;	
						}
					}
								
					//The char_id we're iterating over is a valid candidate - whether they are a traitorous pc acting as an enemy or not,
					//either way, if they don't have an applicable ability in their ability ar, they won't be considered as an opportunity attacker.
					if applicable_char_found {
													
						//We'll iterate once through ability_ar, then again through inv_ar, if applicable:
						var i_count = 0, ar_to_use;
						repeat(2) {
							//Define ar_to_use:
							if i_count == 0 ar_to_use = char_id.ability_ar;
							else if i_count == 1 ar_to_use = char_id.inv_ar;
														
							if is_array(ar_to_use) && array_length(ar_to_use) > 0 {
													
								var temp_wep_ar = [];
								temp_wep_ar = scr_shuffle_ar(ar_to_use);
							
								for(var item_i = 0; item_i < array_length(temp_wep_ar); item_i++) {
								
									var item_struct_or_enum = temp_wep_ar[item_i];
																
									if item_struct_or_enum == -1 continue; //This is just an empty inventory position.
																
									var item_struct_id;
																
									if is_struct(item_struct_or_enum) && item_struct_or_enum.struct_type_enum == struct_type.Item {
										item_struct_id = item_struct_or_enum;
									}
									else if !is_struct(item_struct_or_enum) {
										item_struct_id = global.item_reference_table[item_struct_or_enum];	
									}
														
									//Skip invalid abilities - this will only apply to pc or neutral characters that have a treacherous count > 0:
									if item_struct_id.use_context != abil_use_context.combat_only continue;
														
									var item_range = item_struct_id.max_range;
								
									var dist = abs(cur_char_rank-rank_i);
															
									d($"\nscr_trigger_dot_effects(): fleeing code: the rank we are checking (rank_i) == {rank_i}, our cur rank we are checking from (cur_char_rank) == {cur_char_rank}, the char we are checking == {char_id.name}, the item_name == {item_struct_id.item_name}, its range == {item_struct_id.max_range}, and dist between the target and our self == {dist}.\n");
															
									if dist <= item_range {
																
										d($"\nscr_trigger_dot_effects(): fleeing code: char_id.name= {char_id.name}, this WAS A VALID OPPORTUNITY ATTACKER.\n");
																
										valid_attacker_found = true;
														
										d($"\nscr_trigger_dot_effects(): a valid opportunity-of-attack char was found, it is: {char_id.name}, using a weapon: {item_struct_id.item_name} with a range of: {item_struct_id.max_range}; the dist between this char and the fleeing char was: {dist}.");
																
										break;
									}
								}
							}
							if valid_attacker_found break;
							i_count++;
						}
					}
						
					if valid_attacker_found break;
				} //End of iterating through the nested array.
				if valid_attacker_found break;
						
				if iterate_count == 0 {
					rank_i--;
					if rank_i < 0 break;
				}
				else {
					rank_i++;	
					if rank_i >= array_length(global.combat_rank_ar) break;
				}
				
				failsafe_val++;
			} //End of repeat(diff), iterating one way or the other through g.combat_rank_ar.
			until (failsafe_val > failsafe_max || valid_attacker_found == true);
			
			iterate_count++;
		} //ENd of repeat(2), changing iteration direction each time.
					
		//Immediately advance to execute action, which will pick up the next_combat_char as the attacker, and then when scr_evaluate_combat_end is called at the end of execute_action,
		//it will pick up using the next g.cur_combat_char_index, which never changed; it will manually assign the defender_id = global.fleeing_combat_char_id, and will set num_attacks = 1.
		if valid_attacker_found {
							
			//Assign vars for the fleeing char - note: fleeing_dir_x and y we're already assigned in scr_apply_broken_morale_effects:
			global.fleeing_combat_char_id = char_struct_id;
									
			global.char_is_fleeing_bool = true;
			
			global.cur_game_state = game_state.combat_execute_action; //Our char_is_fleeing_bool and global.fleeing_combat_char_id vars will do the rest for us in execute_action.
			
			scr_add_str_to_dialogue_ar($"\n{scr_string_capitalize(char_struct_id.name)} is attempting to flee through enemies that are within range--an enemy has been offered an attack of opportunity!");
			
			//Change control to the opporunity attacker, assign vars:
			global.cur_combat_char = char_id;
			global.cur_combat_char.chosen_weapon = item_struct_id;
			global.cur_combat_char.targeted_rank = cur_char_rank; //Why does targeted rank matter at all in this case, if we're using global.fleeing_combat_char_id to define our target, and num_attacks will == 1? Just to ensure that scr_return_filtered_abil_ar doesnt throw an error, really.
					
			d($"\nscr_triggger_dot_effects(): fleeing code for char: {char_struct_id.name} - a valid opportunity-of-attack char was found, it is: {global.cur_combat_char.name}, using a weapon: {global.cur_combat_char.chosen_weapon.item_name} with a range of: {global.cur_combat_char.chosen_weapon.max_range}; the dist between this char and the fleeing char was: {dist}.");
		}
					
		//The pc gets to escape unmolested:
		else if !valid_attacker_found {
			scr_add_str_to_dialogue_ar($"\n{char_struct_id.name} successfully escapes the room unscathed; there were no enemies in range to attack them. They have taken with them any droids or clones that were following them.");
									
			//Update bool var:
			char_struct_id.has_fled_combat_bool = true;
			
			//Reset certain status effects:
			scr_reset_status_effects_from_fleeing(char_struct_id);
			
			//Now update vars to reflect room change; fleeing_dir_x and y were defined in scr_apply_broken_morale()
			//Update char x and y vars:
			char_struct_id.cur_grid_x += char_struct_id.fleeing_dir_x;
			char_struct_id.cur_grid_y += char_struct_id.fleeing_dir_y;
										
			//Update vars for any neutrals in this char's neutrals_following_this_char_ar, if applicable:
			scr_update_neutrals_movement_vars(char_struct_id.neutrals_following_this_char_ar,char_struct_id.cur_grid_x,char_struct_id.cur_grid_y);	
								
			//Remove from cur room ar:
			scr_add_remove_char_room_ar(char_struct_id.cur_room_id,char_struct_id,false);
				
			//Update cur_room_id:
			char_struct_id.cur_room_id = global.cur_grid[# char_struct_id.cur_grid_x,char_struct_id.cur_grid_y];
										
			//Add to next room array:
			scr_add_remove_char_room_ar(char_struct_id.cur_room_id,char_struct_id,true);
										
			//Re-position it's sprite vars:
			scr_update_char_sprite_position_vars(char_struct_id);
										
			//Add room to tilemap, if it hasn't already been done:
			if char_struct_id.cur_room_id.explored_boolean == false {
				scr_add_cell_to_tilemap(global.tile_main_lay_id,char_struct_id.cur_room_id.room_enum,char_struct_id.cur_grid_x,char_struct_id.cur_grid_y);
			}
			//Add doors to room, if it hasn't already been done:
			if char_struct_id.cur_room_id.doors_already_added_boolean == false {
				scr_add_doors_to_tilemap(global.tile_doors_lay_id,char_struct_id.cur_grid_x,char_struct_id.cur_grid_y);
			}
				
			//Update the room's boolean vars:
			char_struct_id.cur_room_id.explored_boolean = true;
			char_struct_id.cur_room_id.doors_already_added_boolean = true;
			
			//Call scr_reset_visibility(), then update visibility:
			scr_reset_visibility();
			scr_update_visibility();
									
			//Most important: reset our var that permits pcs to trigger combat again:
			char_struct_id.participated_in_new_turn_battle = false;
									
			//Also reset var that forbids pcs from fleeing again the same turn:
			char_struct_id.already_fled_this_turn_boolean = true;
										
			//reset this var; this char is escaping immediately, and we won't need it in the 
			//execute action game state; we won't even be going to that game state:
			global.char_is_fleeing_bool = false;
		}
	}
				
	#endregion
	
	return char_still_alive_bool;
}