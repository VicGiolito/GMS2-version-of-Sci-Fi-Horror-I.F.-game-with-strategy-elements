

//Returns the count of how many ranks the opposite team currently occupies.

function scr_return_opposite_team_occupied_ranks(cur_char_team){
	
	var checking_enemies = true;
	
	if cur_char_team == team_type.enemy checking_enemies = false;
	
	var occupied_ranks_count = 0;
	
	//Iterate through our outer arrays:
	var char_id;
	for(var rank_i = 0; rank_i < array_length(global.combat_rank_ar); rank_i++) {
		//Iterate through inner arrays:
		for(var i = 0; i < array_length(global.combat_rank_ar[rank_i]); i++) {
			
			char_id = global.combat_rank_ar[rank_i][i];
			
			if char_id.has_died_bool == false && char_id.has_fled_combat_bool == false {
				if checking_enemies && char_id.char_team_enum == team_type.enemy {
					occupied_ranks_count++;
					break;
				}
				else if !checking_enemies && (char_id.char_team_enum == team_type.pc || char_id.char_team_enum == team_type.neutral) {
					occupied_ranks_count++;
					break;
				}
			}
		}
	}
	
	return occupied_ranks_count;
}