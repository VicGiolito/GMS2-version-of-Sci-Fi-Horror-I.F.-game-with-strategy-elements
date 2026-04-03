

//if only_print_ranks == true, pc_char_struct_id can  == -1

function scr_print_combat_ranks(pc_char_struct_id, only_print_ranks = false){
	
	//d($"Entering scr_print_combat_ranks: this is what the g.combat_rank_ar looks like:\n");
	for(var i = 0; i < array_length(global.combat_rank_ar); i++) {
		//d($"scr_print_combat_ranks: nested array at index: {i}: {global.combat_rank_ar[i]}\n");	
	}
	
	if global.combat_prep_phase {
		scr_add_str_to_dialogue_ar($"\nCombat Preparation Phase:");
	}
	
	scr_add_str_to_dialogue_ar($"\nIf you imagine a line dividing your half of the battlefield from the enemy's, this is what you see:");
	
	//Iterate through g.combat_ranks_ar:
	for(var i = 0; i < array_length(global.combat_rank_ar); i++) {
		
		var rank_str = "undefined";
		
		if i == 0 rank_str = "Enemy distant position";
		else if i == 1 rank_str = "Enemy middle position";
		else if i == 2 rank_str = "Enemy near position";
		else if i == 3 rank_str = "Player near position";
		else if i == 4 rank_str = "Player middle position";
		else if i == 5 rank_str = "Player distant position";
		
		rank_str += ":";
		
		//d($"scr_print_combat_ranks: iterating through g.combat_rank_ar at index: {i}: global.combat_rank_ar[{i}] == {global.combat_rank_ar[i]}");
		
		var combat_rank_str = scr_build_char_count_str_from_ar(global.combat_rank_ar[i]);
		
		rank_str += combat_rank_str;
		
		//Having done that, now we need to check the corresponding nested struct ar for our overwatch string:
			//PC overwatch array:
		if is_array(global.overwatch_rank_ar[i].player_overwatch_ar) && array_length(global.overwatch_rank_ar[i].player_overwatch_ar) > 0 {
			rank_str += " **FRIENDLY OVERWATCH**:";
			for(var overwatch_i = 0; overwatch_i < array_length(global.overwatch_rank_ar[i].player_overwatch_ar); overwatch_i++) {
				rank_str += $" {global.overwatch_rank_ar[i].player_overwatch_ar[overwatch_i].name}";
				//Add comma:
				if overwatch_i < array_length(global.overwatch_rank_ar[i].player_overwatch_ar)-1 {
					rank_str += ";";	
				}
			}
		}
			//Enemy overwatch array:
		if is_array(global.overwatch_rank_ar[i].enemy_overwatch_ar) && array_length(global.overwatch_rank_ar[i].enemy_overwatch_ar) > 0 {
			rank_str += " **ENEMY OVERWATCH**:";
			
			var enemy_overwatch_str = scr_build_char_count_str_from_ar(global.overwatch_rank_ar[i].enemy_overwatch_ar);
			
			rank_str += enemy_overwatch_str;
		}
		
		scr_add_str_to_dialogue_ar(rank_str);
	}
	
	//Print the cur char's relevant stats:
	if !only_print_ranks {
		var sanity_str = "";
		if pc_char_struct_id.morale_immune == false {
			sanity_str = $" Sanity: {pc_char_struct_id.sanity_cur}/{pc_char_struct_id.sanity_max}";	
		}
		var cur_char_str = $"You are {pc_char_struct_id.name}. You have the following stats: HP: {pc_char_struct_id.hp_cur}/{pc_char_struct_id.hp_max}{sanity_str} AP: {pc_char_struct_id.ability_points_cur}/{pc_char_struct_id.ability_points_max} Accuracy: {pc_char_struct_id.accuracy} Evasion: {pc_char_struct_id.evasion} Armor: {pc_char_struct_id.armor} Speed: {pc_char_struct_id.spd}\nYou have the following active status effects: {scr_return_status_effects_str(pc_char_struct_id, false)}\n";
	
		if global.combat_prep_phase {
			cur_char_str += "You can change the active character at any time by using the '<' or '>' keys.\nYou can access all of the standard inventory commands from this screen.\nThe following options are also available to you:\n'Abil'ity, 'V'iew Combat Order, 'S'tart combat.";
		} 
	
		else if !global.combat_prep_phase {
			cur_char_str += "You can access all of the standard inventory commands from this screen.\nThe following options are also available to you:\n'F'ight, 'Abil'ity, 'O'verwatch, 'E'vade, 'A'dvance, 'W'ithdraw, 'R'un {direction}, 'V'iew Combat Order.";
		}
		cur_char_str += " What will you do?";
		
		scr_add_str_to_dialogue_ar("\n"+cur_char_str,true);
	}
}