/* Simply choose the nearest rank in the g.combat_rank_ar that contains a pc or neutral

if enemy_searching_bool == true, we're an enemy searching for pcs or neutrals;

if enemy_searching_bool == false, we're a pc or a neutral searching for enemies

*/

function scr_return_nearest_target_rank_pos(cur_combat_rank_pos, enemy_searching_bool = true){
	
	var target_found = false;
	
	var ar_len = array_length(global.combat_rank_ar), nested_ar_len, char_struct_id;
	
	//Iterate forwards first:
	for(var rank_i = cur_combat_rank_pos; rank_i < ar_len; rank_i++) {
		
		nested_ar_len = array_length(global.combat_rank_ar[rank_i]);
		
		for(var char_i = 0; char_i < nested_ar_len; char_i++) {
			
			char_struct_id = global.combat_rank_ar[rank_i][char_i];
			
			if enemy_searching_bool && char_struct_id.char_team_enum == team_type.pc || char_struct_id.char_team_enum == team_type.neutral {
				target_found = true;
				return rank_i;
			}
			else if !enemy_searching_bool && char_struct_id.char_team_enum == team_type.enemy {
				target_found = true;
				return rank_i;
			}
		}
	}
	
	//Iterate backwards if we didn't find anything:
	//Iterate forwards first:
	
	if cur_combat_rank_pos-1 >= 0 {
	
		for(var rank_i = cur_combat_rank_pos-1; rank_i >= 0; rank_i--) {
		
			nested_ar_len = array_length(global.combat_rank_ar[rank_i]);
		
			for(var char_i = 0; char_i < nested_ar_len; char_i++) {
			
				char_struct_id = global.combat_rank_ar[rank_i][char_i];
			
				if enemy_searching_bool && char_struct_id.char_team_enum == team_type.pc || char_struct_id.char_team_enum == team_type.neutral {
					target_found = true;
					return rank_i;
				}
				else if !enemy_searching_bool && char_struct_id.char_team_enum == team_type.enemy {
					target_found = true;
					return rank_i;
				} 
			}
		}
	}
	
	return -1; //No valid pc or neutral found
}