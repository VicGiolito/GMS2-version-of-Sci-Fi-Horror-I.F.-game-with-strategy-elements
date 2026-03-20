

function scr_return_opposite_team_combatant_count(cur_char_team){
	
	var checking_enemies = true;
	
	if cur_char_team == team_type.enemy checking_enemies = false;
	
	var opposite_combatant_count = 0;
	
	//Iterate through our outer arrays:
	var char_id;
	for(var rank_i = 0; rank_i < array_length(global.combat_rank_ar); rank_i++) {
		//Iterate through inner arrays:
		for(var i = 0; i < array_length(global.combat_rank_ar[rank_i]); i++) {
			
			char_id = global.combat_rank_ar[rank_i][i];
			
			if char_id.has_died_bool == false && char_id.has_fled_combat_bool == false {
				if checking_enemies && char_id.char_team_enum == team_type.enemy {
					opposite_combatant_count++;	
				}
				else if !checking_enemies && (char_id.char_team_enum == team_type.pc || char_id.char_team_enum == team_type.neutral) {
					opposite_combatant_count++;	
				}
			}
		}
	}
	
	return opposite_combatant_count;
}