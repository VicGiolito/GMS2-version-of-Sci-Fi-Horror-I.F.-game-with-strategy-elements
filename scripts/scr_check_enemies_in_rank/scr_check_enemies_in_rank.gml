

function scr_check_enemies_in_rank(rank_int_to_check){
	
	if is_array(global.combat_rank_ar[rank_int_to_check]) && array_length(global.combat_rank_ar[rank_int_to_check]) > 0 {
		
		var ar_len = array_length(global.combat_rank_ar[rank_int_to_check]);
		
		for(var i = 0; i < ar_len; i++) {
			if global.combat_rank_ar[rank_int_to_check][i].char_team_enum == team_type.enemy {
				return true;	
			}
		}
	}
	
	return false;
}