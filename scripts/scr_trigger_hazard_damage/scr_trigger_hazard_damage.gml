/*

	if iterate_through_global_ars_boolean == true, we iterate through all of the global arrays, checking every single char_inst_id in the game.

	if iterate_through_global_ars_boolean == false, we need to define user_defined_ar, and we'll iterate through that instead.
*/

function scr_trigger_hazard_damage(iterate_through_global_ars_boolean, user_defined_ar = undefined){
	
	/* A note on resistences:
	multiplier = 1 - (resistance / 100)
	The key insight is that resistance / 100 converts the stat to a decimal, and subtracting from 1 flips it into a damage multiplier:
	
	so if a char is susceptible to electric: 
	1 - (res_electric(-50) / 100) = 
	1 - (-.5) =
	1.5 (the character will take 1.5 times the damage)
	
	or if a char is resistence to vacuum:
	1 - (res_vacuum(100) / 100) = 
	1 - (1) =
	0 (the character will take 0 times the damage, they are immune to it).
	
	*/
	
	//Define the 'array' we will be iterating through - this could even just be an array of one char_inst_id:
	var char_struct_id, ar_to_use, repeat_count = 1, repeat_loop = 0;
	
	if iterate_through_global_ars_boolean {
		ar_to_use = global.pc_char_ar;
		repeat_count = 3;	
	}
	else {
		if is_undefined(user_defined_ar) throw("scr_trigger_hazard_damage: user_defined_ar == undefined, but iterate_through_global_ars_boolean == false; user_defined_ar should have been defined.");
		ar_to_use = user_defined_ar;
		repeat_count = 1;
	}
	
	repeat(repeat_count) {
		if iterate_through_global_ars_boolean {
			if repeat_loop == 1 ar_to_use = global.neutral_char_ar;
			else if repeat_loop == 2 ar_to_use = global.enemy_char_ar;
		}
		
		if is_array(ar_to_use) && array_length(ar_to_use) > 0 {
			
			for(var i = 0; i < array_length(ar_to_use); i++) {
		
				char_struct_id = ar_to_use[i];
		
				if is_array(char_struct_id.cur_room_id.hazard_ar) && array_length(char_struct_id.cur_room_id.hazard_ar) > 0 {
					
					#region Fire:
					
					if scr_check_ar_for_val(char_struct_id.cur_room_id.hazard_ar,hazard_type.fire) {
						
						var base_fire_dmg = DOT_FIRE;
						
						//We need to cap our POSITIVE resistence at 100 so that values greater than that actually function as being 'immune':
						var char_res = char_struct_id.res_fire;
						if char_res > 100 char_res = 100;
						
						//Apply resistences:
						var multiplier = 1 - (char_res / 100);
						base_fire_dmg = floor(base_fire_dmg * multiplier);
						
						//PCS go unconscious
						if char_struct_id.char_team_enum == team_type.pc && char_struct_id.unconscious_bool == false {
							
							if base_fire_dmg != 0 {
							
								char_struct_id.hp_cur -= base_fire_dmg;
		
								scr_add_str_to_dialogue_ar($"\n{char_struct_id.name}({char_struct_id.unique_id}) is burning from the fire in the {char_struct_id.cur_room_id.room_name_str}! They have taken {base_fire_dmg} damage!");
								
								//We don't actually remove them from their room_array yet; they're not actually dead yet:
								if char_struct_id.hp_cur <= 0 {
									char_struct_id.unconscious_bool = true;
									scr_add_str_to_dialogue_ar($"\n{char_struct_id.name}({char_struct_id.unique_id}) has collapsed!");
								}
							}
						}
						//Neutrals and enemies die immediately:
						else if char_struct_id.char_team_enum != team_type.pc {
							
							if base_fire_dmg != 0 {
							
								char_struct_id.hp_cur -= base_fire_dmg;
								
								var hunting_str = "";
								
								if char_struct_id.char_team_enum == team_type.enemy {
									if char_struct_id.ai_movement_behavior != ai_movement_type.hunting {
										char_struct_id.ai_movement_behavior = ai_movement_type.hunting;
										hunting_str = "They have become enraged and are now hunting for blood!";
									}
								}
								
								scr_add_str_to_dialogue_ar($"\n{char_struct_id.name}({char_struct_id.unique_id}) is burning from the fire in the {char_struct_id.cur_room_id.room_name_str}! They have taken {base_fire_dmg} damage!{hunting_str}");
		
								if char_struct_id.hp_cur <= 0 {
									scr_add_remove_char_room_ar(char_struct_id.cur_room_id, char_struct_id, false);
									ar_to_use[i] = -1;
									scr_add_str_to_dialogue_ar($"\n{char_struct_id.name}({char_struct_id.unique_id}) has died!");
								}
							}
						}
					}
					
					#endregion
					
					#region Toxic gas:
					
					if scr_check_ar_for_val(char_struct_id.cur_room_id.hazard_ar,hazard_type.toxic_gas) {
						
						var base_gas_dmg = DOT_HAZARD_DMG_TOXIC_GAS;
						
						//We need to cap our POSITIVE resistence at 100 so that values greater than that actually function as being 'immune':
						var char_res = char_struct_id.res_gas;
						if char_res > 100 char_res = 100;
						
						//Apply resistences:
						var multiplier = 1 - (char_res / 100);
						base_gas_dmg = floor(base_gas_dmg * multiplier);
						
						//PCS go unconscious
						if char_struct_id.char_team_enum == team_type.pc && char_struct_id.unconscious_bool == false {
							
							if base_gas_dmg != 0 {
							
								char_struct_id.hp_cur -= base_gas_dmg;
		
								scr_add_str_to_dialogue_ar($"\n{char_struct_id.name}({char_struct_id.unique_id}) is choking from the toxic gas in the {char_struct_id.cur_room_id.room_name_str}! They have taken {base_gas_dmg} damage!");
		
								if char_struct_id.hp_cur <= 0 {
									char_struct_id.unconscious_bool = true;
									scr_add_str_to_dialogue_ar($"\n{char_struct_id.name}({char_struct_id.unique_id}) has collapsed!");
									scr_add_remove_char_room_ar(char_struct_id.cur_room_id, char_struct_id, false);
									scr_auto_reassign_neutrals_owner(char_struct_id);
								}
							}
						}
						//Neutrals and enemies die immediately:
						else if char_struct_id.char_team_enum != team_type.pc {
							
							if base_gas_dmg != 0 {
							
								char_struct_id.hp_cur -= DOT_HAZARD_DMG_TOXIC_GAS;
		
								scr_add_str_to_dialogue_ar($"\n{char_struct_id.name}({char_struct_id.unique_id}) is choking from the toxic gas in the {char_struct_id.cur_room_id.room_name_str}! They have taken {DOT_HAZARD_DMG_TOXIC_GAS} damage!");
		
								if char_struct_id.hp_cur <= 0 {
									scr_add_remove_char_room_ar(char_struct_id.cur_room_id, char_struct_id, false);
									ar_to_use[i] = -1;
									scr_add_str_to_dialogue_ar($"\n{char_struct_id.name}({char_struct_id.unique_id}) has died!!");
								}
							}
						}
					}
					
					#endregion
					
					#region Electric damage:
					
					//organics have a 25% chance of being stunned, cybernetics and synethics a 50%; cybernetics take double damage, synthetics take triple damage
					
					if scr_check_ar_for_val(char_struct_id.cur_room_id.hazard_ar,hazard_type.electric_current) {
						
						var base_electric_dmg = DOT_HAZARD_ELECTRIC_DMG;
						
						//We need to cap our POSITIVE resistence at 100 so that values greater than that actually function as being 'immune':
						var char_res = char_struct_id.res_electric;
						if char_res > 100 char_res = 100;
						
						//Apply resistences:
						var multiplier = 1 - (char_res / 100);
						base_electric_dmg = floor(base_electric_dmg * multiplier);
						
						//PCS go unconscious
						if char_struct_id.char_team_enum == team_type.pc && char_struct_id.unconscious_bool == false {
							
							if base_electric_dmg != 0 {
							
								char_struct_id.hp_cur -= base_electric_dmg;
							
								var stunned_str = "";
							
								//Perform stunned check:
								if char_struct_id.stun_immune_boolean == false {
									var ran_val = irandom_range(1,100);
							
									var threshold = 25;
							
									if (is_array(char_struct_id.passive_abil_ar) && scr_check_ar_for_val(char_struct_id.passive_abil_ar, passive_abil_type.cybernetic) ) ||
									(is_array(char_struct_id.passive_abil_ar) && scr_check_ar_for_val(char_struct_id.passive_abil_ar, passive_abil_type.synthetic) ) {
										threshold = 50;	
									}
							
									if ran_val <= threshold {
										char_struct_id.stun_count = true;	
										stunned_str = "They have also been stunned for 1 turn!";
									}
								}
		
								scr_add_str_to_dialogue_ar($"\n{char_struct_id.name}({char_struct_id.unique_id}) is being electrocuted from the exposed electrical hazard in the {char_struct_id.cur_room_id.room_name_str}! They have taken {base_electric_dmg} damage!{stunned_str}");
		
								if char_struct_id.hp_cur <= 0 {
									char_struct_id.unconscious_bool = true;
									scr_add_str_to_dialogue_ar($"\n{char_struct_id.name}({char_struct_id.unique_id}) has collapsed!");
									scr_add_remove_char_room_ar(char_struct_id.cur_room_id, char_struct_id, false);
									scr_auto_reassign_neutrals_owner(char_struct_id);
								}
							}
						}
						//Neutrals and enemies die immediately:
						else if char_struct_id.char_team_enum != team_type.pc {
							
							if base_electric_dmg != 0 {
							
								//Perform stunned check:
								if char_struct_id.stun_immune_boolean == false {
									var ran_val = irandom_range(1,100);
							
									var threshold = 25;
							
									if (is_array(char_struct_id.passive_abil_ar) && scr_check_ar_for_val(char_struct_id.passive_abil_ar, passive_abil_type.cybernetic) ) ||
									(is_array(char_struct_id.passive_abil_ar) && scr_check_ar_for_val(char_struct_id.passive_abil_ar, passive_abil_type.synthetic) ) {
										threshold = 50;	
									}
							
									if ran_val <= threshold {
										char_struct_id.stun_count = true;	
										stunned_str = "They have also been stunned for 1 turn!";
									}
								}
		
								scr_add_str_to_dialogue_ar($"\n{char_struct_id.name}({char_struct_id.unique_id}) is being electrocuted from the exposed electrical hazard in the {char_struct_id.cur_room_id.room_name_str}! They have taken {base_electric_dmg} damage!{stunned_str}");
		
								if char_struct_id.hp_cur <= 0 {
									scr_add_remove_char_room_ar(char_struct_id.cur_room_id, char_struct_id, false);
									ar_to_use[i] = -1;
									scr_add_str_to_dialogue_ar($"\n{char_struct_id.name}({char_struct_id.unique_id}) has died!");
								}
							}
						}
					}
					
					#endregion
					
					#region Vacuum:
					
					if scr_check_ar_for_val(char_struct_id.cur_room_id.hazard_ar,hazard_type.vacuum) {
						
						var base_vac_dmg = char_struct_id.hp_max * .5;
						
						//We need to cap our POSITIVE resistence at 100 so that values greater than that actually function as being 'immune':
						var char_res = char_struct_id.res_vacuum;
						if char_res > 100 char_res = 100;
						
						//Apply resistences:
						var multiplier = 1 - (char_res / 100);
						var vac_dmg = ceil(base_vac_dmg * multiplier);
						
						//PCS go unconscious
						if char_struct_id.char_team_enum == team_type.pc && char_struct_id.unconscious_bool == false {
							
							if vac_dmg != 0 {
							
								char_struct_id.hp_cur -= vac_dmg;
		
								scr_add_str_to_dialogue_ar($"\n{char_struct_id.name}({char_struct_id.unique_id}) has been exposed to to vacuum in the {char_struct_id.cur_room_id.room_name_str}! They have taken {vac_dmg} damage!");
		
								if char_struct_id.hp_cur <= 0 {
									char_struct_id.unconscious_bool = true;
									scr_add_str_to_dialogue_ar($"\n{char_struct_id.name}({char_struct_id.unique_id}) has collapsed!");
									scr_add_remove_char_room_ar(char_struct_id.cur_room_id, char_struct_id, false);
									scr_auto_reassign_neutrals_owner(char_struct_id);
								}
							}
						}
						//Neutrals and enemies die immediately:
						else if char_struct_id.char_team_enum != team_type.pc {
							
							if vac_dmg != 0 {
							
								char_struct_id.hp_cur -= vac_dmg;
		
								scr_add_str_to_dialogue_ar($"\n{char_struct_id.name}({char_struct_id.unique_id}) has been exposed to vacuum in the {char_struct_id.cur_room_id.room_name_str}! They have taken {vac_dmg} damage!");
		
								if char_struct_id.hp_cur <= 0 {
									scr_add_remove_char_room_ar(char_struct_id.cur_room_id, char_struct_id, false);
									ar_to_use[i] = -1;
									scr_add_str_to_dialogue_ar($"\n{char_struct_id.name}({char_struct_id.unique_id}) has died!!");
								}
							}
						}
					}
					
					#endregion
				}	
			}
			
			//Now iterate through again, weeding out -1 indices:
			var new_ar = [];
			for(var i = 0; i < array_length(ar_to_use); i++) {
		
				char_struct_id = ar_to_use[i];
				
				if char_struct_id != -1 && is_struct(char_struct_id) && char_struct_id.struct_type_enum == struct_type.Character {
					array_push(new_ar, char_struct_id);	
				}
			}
			
			//We don't care if we end up with an empty array, but we need to reassign our global arrays to the new array so they match:
			if iterate_through_global_ars_boolean {
				if repeat_loop == 0 global.pc_char_ar = new_ar;
				else if repeat_loop == 1 global.neutral_char_ar = new_ar;
				else if repeat_loop == 2 global.enemy_char_ar = new_ar;
			}
			//adjust our user_defined_array:
			else {
				ar_to_use = new_ar;	
			}
		}
		
		//Iterate:
		repeat_loop++;
	}
	
	if !iterate_through_global_ars_boolean return ar_to_use;
	
}