/*

removes the char_struct_id from global ar and instance ar, if applicable

requires their .targeted_rank var to be defined and accurate.

*/

function scr_remove_char_from_overwatch_arrays(char_struct_id){
	
	var ar_index, ar_to_use;
	
	if is_array(global.overwatch_rank_ar) && array_length(global.overwatch_rank_ar) > 0 {
		if char_struct_id.targeted_rank >= 0 && char_struct_id.targeted_rank < array_length(global.overwatch_rank_ar) {
			if char_struct_id.char_team_enum != team_type.enemy {
				ar_to_use = global.overwatch_rank_ar[char_struct_id.targeted_rank].player_overwatch_ar; 
			}
			else if char_struct_id.char_team_enum == team_type.enemy {
				ar_to_use = global.overwatch_rank_ar[char_struct_id.targeted_rank].enemy_overwatch_ar;
			}
	
			if is_array(ar_to_use) && array_length(ar_to_use) > 0 {
				
				ar_index = array_get_index(ar_to_use,char_struct_id);
	
				if ar_index != -1 {
					array_delete(ar_to_use,ar_index,1);
				}
			}
		}
	}
	
	if is_array(o_con.overwatch_attackers_ar) && array_length(o_con.overwatch_attackers_ar) > 0 {
		o_con.overwatch_attackers_ar = scr_add_remove_val_from_ar(o_con.overwatch_attackers_ar,char_struct_id,true,false);	
	}
}