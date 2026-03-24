
/* Is a nested struct array is located at the targeted position, then we return its id;

otherwise, we return -1

*/

function scr_check_overwatch_in_target_rank(char_struct_id, rank_int_to_check){
	
	var overwatch_ar_to_check;
	
	if is_array(global.overwatch_rank_ar) && array_length(global.overwatch_rank_ar) {
		
		if rank_int_to_check >= 0 && rank_int_to_check < array_length(global.overwatch_rank_ar) {
			
			//Enemies look for the player_overwatch_ar struct:
			if char_struct_id.char_team_enum == team_type.enemy && is_struct(global.overwatch_rank_ar[rank_int_to_check]) 
			&& is_array(global.overwatch_rank_ar[rank_int_to_check].player_overwatch_ar) {
				overwatch_ar_to_check = global.overwatch_rank_ar[rank_int_to_check].player_overwatch_ar;	
			}
			
			else if char_struct_id.char_team_enum != team_type.enemy && is_struct(global.overwatch_rank_ar[rank_int_to_check]) 
			&& is_array(global.overwatch_rank_ar[rank_int_to_check].enemy_overwatch_ar) {
				overwatch_ar_to_check = global.overwatch_rank_ar[rank_int_to_check].enemy_overwatch_ar;	
			}
			
			//If it's an array and has a length of at least 1, that means there's a char_struct_id in there that's been assigned to overwatch:
			if is_array(overwatch_ar_to_check) && array_length(overwatch_ar_to_check) > 0 {
				return overwatch_ar_to_check;	
			}
		}
	}
	
	return -1;
}