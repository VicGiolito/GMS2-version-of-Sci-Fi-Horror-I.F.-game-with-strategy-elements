

function scr_return_valid_team_chars_in_rank(rank_ar, team_type_enum_){
	
	var ar_to_return = [];
	
	if is_array(rank_ar) && array_length(rank_ar) > 0 {
		var ar_len = array_length(rank_ar), char_id;
		
		for(var i = 0; i < ar_len; i++) {
			
			char_id = rank_ar[i];
			
			if char_id.char_team_enum == team_type_enum_ && char_id.has_died_bool == false && char_id.has_fled_combat_bool == false {
				array_push(ar_to_return, char_id);	
			}
		}
	}
	
	d($"\nscr_return_valid_team_chars_in_rank: before returning the array, it looks like this...");
	
	for(var i = 0; i < array_length(ar_to_return); i++) {
		d($"\nAt index: {i}: {ar_to_return[i].name}")	
	}
	
	return ar_to_return;
}