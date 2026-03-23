/* Simply choose the nearest rank in the g.combat_rank_ar that contains a pc or neutral

if enemy_searching_bool == true, we're an enemy searching for pcs or neutrals;

if enemy_searching_bool == false, we're a pc or a neutral searching for enemies

*/

function scr_return_nearest_target_rank_pos(cur_combat_rank_pos, enemy_searching_bool = true) {
	
	var ar_len = array_length(global.combat_rank_ar), nested_ar_len, char_struct_id;
	
	/*Iterate both up and down through the array, starting at our cur_combat_rank_pos:
	The bias: we search 'south' first, so if valid characters are found at equal distances from our cur_combat_rank_pos, 
	then the valid character south of us would be returned first. 
	*/
	var iterating_down_index = cur_combat_rank_pos, iterating_up_index = cur_combat_rank_pos;
	
	repeat(ar_len) {
		
		#region Check iterating down index first:
		
		nested_ar_len = array_length(global.combat_rank_ar[iterating_down_index]);
		
		//Iterate through the nested_ar, searching for applicable chars:
		for(var char_i = 0; char_i < nested_ar_len; char_i++) {
			
			char_struct_id = global.combat_rank_ar[iterating_down_index][char_i];
			
			//Only check at all if the char has not died or has fled...
			if char_struct_id.has_died_bool == false && char_struct_id.has_fled_combat_bool == false {
				
				if enemy_searching_bool && (char_struct_id.char_team_enum == team_type.pc || char_struct_id.char_team_enum == team_type.neutral) {
					//Enemies cannot target pcs that are already unconscious (neutrals will never be unconscious, they die instantly)
					if char_struct_id.unconscious_bool == false {
						return iterating_down_index;
					}
				}
				//PCs and neutrals can target enemies that are already stunned:
				else if !enemy_searching_bool && char_struct_id.char_team_enum == team_type.enemy {
					return iterating_down_index;
				}
			}
		}
		
		#endregion
		
		#region Check iterating up index next:
		
		nested_ar_len = array_length(global.combat_rank_ar[iterating_up_index]);
		
		//Iterate through the nested_ar, searching for applicable chars:
		for(var char_i = 0; char_i < nested_ar_len; char_i++) {
			
			char_struct_id = global.combat_rank_ar[iterating_up_index][char_i];
			
			//Only check at all if the char has not died or has fled...
			if char_struct_id.has_died_bool == false && char_struct_id.has_fled_combat_bool == false {
				
				if enemy_searching_bool && (char_struct_id.char_team_enum == team_type.pc || char_struct_id.char_team_enum == team_type.neutral) {
					//Enemies cannot target pcs that are already unconscious (neutrals will never be unconscious, they die instantly)
					if char_struct_id.unconscious_bool == false {
						return iterating_up_index;
					}
				}
				//PCs and neutrals can target enemies that are already stunned:
				else if !enemy_searching_bool && char_struct_id.char_team_enum == team_type.enemy {
					return iterating_up_index;
				}
			}
		}
		
		#endregion
		
		//Iterate down and up index:
		var valid_dir_found = false;
		
		if iterating_down_index + 1 < ar_len {
			valid_dir_found = true;
			iterating_down_index++;
		}
		
		if iterating_up_index - 1 >= 0 {
			iterating_up_index--;
			valid_dir_found = true;
		}
		
		if !valid_dir_found break;
	}
	
	return -1; //No index position found

}