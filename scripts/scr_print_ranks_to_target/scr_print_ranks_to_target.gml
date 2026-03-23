
function scr_print_ranks_to_target(cur_char_struct_id){
	
	var cur_rank_int = cur_char_struct_id.cur_combat_rank;
	var cur_range_int = cur_char_struct_id.chosen_weapon.max_range;
	
	var dist_from_rank;
	
	scr_add_str_to_dialogue_ar("\n");
	
	//Iterate through g.combat_ranks_ar:
	for(var i = 0; i < array_length(global.combat_rank_ar); i++) {
		
		var rank_str = "undefined";
		
		if i == 0 rank_str = $"{i}.) Enemy distant position";
		else if i == 1 rank_str = $"{i}.) Enemy middle position";
		else if i == 2 rank_str = $"{i}.) Enemy near position";
		else if i == 3 rank_str = $"{i}.) Player near position";
		else if i == 4 rank_str = $"{i}.) Player middle position";
		else if i == 5 rank_str = $"{i}.) Player distant position";
		
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
		
		dist_from_rank = abs(cur_rank_int - i);
		
		if dist_from_rank > cur_range_int rank_str += " ** BEYOND WEAPON'S RANGE**";
		
		scr_add_str_to_dialogue_ar(rank_str);
	}
	
	scr_add_str_to_dialogue_ar("\n");
	var game_state_str = "attack";
	if global.overwatch_mode_enabled game_state_str = "overwatch";
	scr_add_str_to_dialogue_ar($"Choose a rank to target for {game_state_str}. You may also enter 'B' or 'BACKUP' to return to the previous screen.",true);
}