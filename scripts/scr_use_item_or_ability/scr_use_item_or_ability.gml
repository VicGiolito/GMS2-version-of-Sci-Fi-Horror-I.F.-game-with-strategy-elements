
/* 

if item_struct_id_or_abil_enum is an ability


*/

function scr_use_item_or_ability(item_struct_id, target_char_struct_of_item, char_struct_using_item){
	
	var item_type_enum = item_struct_id.item_enum;
	
	//We've successfully used the item, we can modify our AP and/or sanity now, if applicable:
	if item_struct_id.ability_point_cost > 0 {
		char_struct_using_item.ability_points_cur -= item_struct_id.ability_point_cost;
	}
	if item_struct_id.sanity_cost > 0 {
		char_struct_using_item.sanity_cur += item_struct_id.sanity_cost;
	}
	if item_struct_id.scrap_cost > 0 {
		global.resources_scrap -= item_struct_id.scrap_cost;
	}
	
	if item_type_enum == item_type.medkit {
		
		target_char_struct_of_item.hp_cur += MEDKIT_HP_BOOST;
		
		//Cap:
		if target_char_struct_of_item.hp_cur > target_char_struct_of_item.hp_max { target_char_struct_of_item.hp_cur = target_char_struct_of_item.hp_max; }
		
		//Clear burning, poisoned, and bleeding:
		target_char_struct_of_item.burning_count = 0;
		target_char_struct_of_item.poisoned_count = 0;
		target_char_struct_of_item.bleeding_count = 0;
		
		scr_add_str_to_dialogue_ar($"\n**{char_struct_using_item.name} uses the {item_struct_id.item_name} on {target_char_struct_of_item.name}. (Their hit points have increased by {MEDKIT_HP_BOOST}; they now have {target_char_struct_of_item.hp_cur} hit points. They have also been cleared of any bleeding, poisoned, or burning status effects.)**");
		
		//Check to see if this char has revived:
		if target_char_struct_of_item.unconscious_bool == true && target_char_struct_of_item.hp_cur > 0 {
			target_char_struct_of_item.unconscious_bool = false;
			target_char_struct_of_item.unconscious_count = 0;
			scr_add_str_to_dialogue_ar($"**\n{target_char_struct_of_item.name} has woken up!**");
			if target_char_struct_of_item.sanity_cur <= 0 target_char_struct_of_item.sanity_cur = floor(target_char_struct_of_item.sanity_max / 2); //Reset sanity to half max, if applicable:
		}
	}
	
	else if item_type_enum == item_type.field_medicine {
		
		target_char_struct_of_item.hp_cur += FIELD_MEDICINE_HP_BOOST;
		
		//Cap:
		if target_char_struct_of_item.hp_cur > target_char_struct_of_item.hp_max { target_char_struct_of_item.hp_cur = target_char_struct_of_item.hp_max; }
		
		//Clear burning, poisoned, and bleeding:
		target_char_struct_of_item.burning_count = 0;
		target_char_struct_of_item.poisoned_count = 0;
		target_char_struct_of_item.bleeding_count = 0;
		
		scr_add_str_to_dialogue_ar($"\n**{char_struct_using_item.name} dresses the wounds of {target_char_struct_of_item.name} with their {item_struct_id.item_name}. ({scr_string_capitalize(target_char_struct_of_item.name)}'s hit points have been increased by {FIELD_MEDICINE_HP_BOOST}; they now have {target_char_struct_of_item.hp_cur} hit points.)**");
	
		//Check to see if this char has revived:
		if target_char_struct_of_item.unconscious_bool == true && target_char_struct_of_item.hp_cur > 0 {
			target_char_struct_of_item.unconscious_bool = false;
			target_char_struct_of_item.unconscious_count = 0;
			scr_add_str_to_dialogue_ar($"\n**{target_char_struct_of_item.name} has woken up!**");
			if target_char_struct_of_item.sanity_cur <= 0 target_char_struct_of_item.sanity_cur = floor(target_char_struct_of_item.sanity_max / 2); //Reset sanity to half max, if applicable:
		}
	}
	
	else if item_type_enum == item_type.improvised_medicine {
		
		target_char_struct_of_item.infection_count -= IMPROVISED_MEDICINE_INFECT_REMOVE_BUFF;
		
		//Cap:
		if target_char_struct_of_item.infection_count < 0  { target_char_struct_of_item.infection_count = 0; }
		
		scr_add_str_to_dialogue_ar($"\n**\"I have no idea what this is, so I really don't know how to treat it...\" With limited knowledge or supplies, {char_struct_using_item.name} does their best to treat the infection within {target_char_struct_of_item.name}. (-{IMPROVISED_MEDICINE_INFECT_REMOVE_BUFF} infection points.)**");
	}
	
	else if item_type_enum == item_type.anti_anxiety_meds {
		
		target_char_struct_of_item.sanity_cur -= ANTI_ANXIETY_SANITY_BUFF;
		
		//Cap:
		if target_char_struct_of_item.sanity_cur < 0  { target_char_struct_of_item.sanity_cur = 0; }
		
		scr_add_str_to_dialogue_ar($"\n**\"Here, these should take the edge off...\" {char_struct_using_item.name} passes {target_char_struct_of_item.name} a blister pack full of mysterious tablets. (-{ANTI_ANXIETY_SANITY_BUFF} sanity points.)**");
	}
	
	else if item_type_enum == item_type.regen_nanites {
		
		target_char_struct_of_item.healing_nanites_count = REGEN_NANITES_DURATION; //Does not stack.
		
		scr_add_str_to_dialogue_ar($"\n**{char_struct_using_item.name} injects {target_char_struct_of_item.name} with the {item_struct_id.item_name}. (Their hit points will increase by {REGEN_NANITES_HEAL_VAL} for {REGEN_NANITES_DURATION} turns.)**");
	}
	
	else if item_type_enum == item_type.energizing_stim_prick {
		
		target_char_struct_of_item.ability_points_cur += ENERGENIZING_AP_BOOST;
		
		//Cap:
		if target_char_struct_of_item.ability_points_cur > target_char_struct_of_item.ability_points_max { target_char_struct_of_item.ability_points_cur = target_char_struct_of_item.ability_points_max; } 
		
		scr_add_str_to_dialogue_ar($"\n**{char_struct_using_item.name} injects {target_char_struct_of_item.name} with the {item_struct_id.item_name}. (Their ability points have increased by {ENERGENIZING_AP_BOOST}.)**"); 
	}
	
	else if item_type_enum == item_type.smoke_grenade {
		
		//Boost the evasion of every ally in the combat_init_ar:
		
		var ar_len = array_length(global.combat_initiative_ar), char_id;
		for(var i = 0; i < ar_len; i++) {
			char_id = global.combat_initiative_ar[i];
			
			if (char_struct_using_item.char_team_enum == team_type.pc || char_struct_using_item.char_team_enum == team_type.neutral) 
			&& (char_id.char_team_enum == team_type.pc || char_id.char_team_enum == team_type.neutral) {
				char_id.smoke_grenade_count = SMOKE_GRENADE_DURATION;
				char_id.evasion += SMOKE_GRENADE_EVADE_BUFF;
			}
			else if char_struct_using_item.char_team_enum == team_type.enemy && char_id.char_team_enum == team_type.enemy {
				char_id.smoke_grenade_count = SMOKE_GRENADE_DURATION;
				char_id.evasion += SMOKE_GRENADE_EVADE_BUFF;	
			}
		}
		
		if char_struct_using_item.char_team_enum != team_type.enemy {
			scr_add_str_to_dialogue_ar($"\n**\"SMOKE OUT!\" {char_struct_using_item.name} tosses a smoke grenade on to the battle field. (+2 evasion to all allies for {SMOKE_GRENADE_DURATION} turns.)**");
		}
		else {
			scr_add_str_to_dialogue_ar($"\n**{scr_string_capitalize(char_struct_using_item.name)} fires a smoke grenade into the battle field. (+2 evasion to all allies for {SMOKE_GRENADE_DURATION} turns.)**");
		}
	}
	
	else if item_type_enum == item_type.personal_shield_generator {
		
		char_struct_using_item.armor += PERSONAL_SHIELD_ARMOR_BUFF;
		char_struct_using_item.evasion += PERSONAL_SHIELD_EVASION_BUFF;
		char_struct_using_item.shield_bubble_count = PERSONAL_SHIELD_DURATION;
		
		scr_add_str_to_dialogue_ar($"\n**{char_struct_using_item.name} activates their {item_struct_id.item_name}. (Cleared of suppression, +{PERSONAL_SHIELD_ARMOR_BUFF} armor, +{PERSONAL_SHIELD_EVASION_BUFF} evasion.)**");	
	
		//Clear suppression:
		if char_struct_using_item.suppressed_count > 0 {
			char_struct_using_item.suppressed_count = 0;
			char_struct_using_item.spd += SUPPRESSED_SPEED_DEBUFF;
			char_struct_using_item.evasion += SUPPRESSED_EVASION_DEBUFF;
		}
	}
	
	else if item_type_enum == item_type.adrenal_pen {
		
		target_char_struct_of_item.adrenal_pen_count = ADRENAL_PEN_DURATION;
		target_char_struct_of_item.spd += ADRENAL_PEN_SPD_BUFF;
		target_char_struct_of_item.accuracy += ADRENAL_PEN_ACC_BUFF;
		
		scr_add_str_to_dialogue_ar($"\n**{char_struct_using_item.name} injects {target_char_struct_of_item.name} with the {item_struct_id.item_name}. (+{ADRENAL_PEN_SPD_BUFF} speed, +{ADRENAL_PEN_ACC_BUFF} accuracy for {ADRENAL_PEN_DURATION} turns.)**"); 
	}
	
	else if item_type_enum == item_type.spawn_light_buzzsaw_droid || item_type_enum == item_type.spawn_light_flamer_droid || item_type_enum == item_type.spawn_light_sentinel_droid ||
	item_type_enum == item_type.spawn_light_sentry_gun || item_type_enum == item_type.spawn_light_shotgun_droid {
		
		var team_type_enum = team_type.neutral;
		
		if char_struct_using_item.char_team_enum == team_type.enemy team_type_enum = team_type.enemy;
		
		//(This will automatically add it to the appropriate room array)
		var newly_spawned_char_id = new global.Character(item_struct_id.char_spawn_enum,char_struct_using_item.cur_grid_x,char_struct_using_item.cur_grid_y,char_struct_using_item.cur_grid,team_type_enum,true);
		
		if global.combat_begun {
			//Add to the end of the g.combat_init_ar - this will not fuck up our g.cur_combat_char_index:
			array_push(global.combat_initiative_ar,newly_spawned_char_id);
		
			//Add to rank ar:
			array_push(global.combat_rank_ar[char_struct_using_item.cur_combat_rank],newly_spawned_char_id);
		}
		
		scr_add_str_to_dialogue_ar($"\n**{char_struct_using_item.name} has finished the construction of the {newly_spawned_char_id.name}. It is now ready to serve.**");
	
		//Add them to any locals mobs or, if none exist, create a new one and add it to it:
		if team_type_enum == team_type.enemy {
			var ar_of_mobs_in_room = [];
			ar_of_mobs_in_room = scr_return_mob_ar_at_coord(ar_of_mobs_in_room,char_struct_using_item.cur_grid_x,char_struct_using_item.cur_grid_y);
			
			if array_length(ar_of_mobs_in_room) > 0 {
				array_push(ar_of_mobs_in_room[0].enemies_in_mob_ar,newly_spawned_char_id); //Does it matter which mob it gets incorporated into? I don't see how.
			}
			else {
				//We need to create a new mob struct, and add this to it.
				array_push(global.enemy_mob_ar, new enemy_mob_struct(spawn_grid, char_struct_using_item.cur_grid_x, char_struct_using_item.cur_grid_y ) );
				//Add to enemies_in_mob_ar in the new mob_struct_id:
				array_push(global.enemy_mob_ar[array_length(global.enemy_mob_ar) - 1].enemies_in_mob_ar, newly_spawned_char_id);
			}
		}
		//Add them to the control of the char who spawned them:
		else if item_type_enum != item_type.spawn_light_sentry_gun { //Sentry guns are stationary and don't get added.
			if !is_array(char_struct_using_item.neutrals_following_this_char_ar) {
				char_struct_using_item.neutrals_following_this_char_ar = [];	
			}
			array_push(char_struct_using_item.neutrals_following_this_char_ar,newly_spawned_char_id);
		}
	}
}