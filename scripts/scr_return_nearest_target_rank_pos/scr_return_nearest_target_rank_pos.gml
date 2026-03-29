/* Simply choose the nearest rank in the g.combat_rank_ar that contains a pc or neutral

if enemy_searching_bool == true, we're an enemy searching for pcs or neutrals;

if enemy_searching_bool == false, we're a pc or a neutral searching for enemies

*/

function scr_return_nearest_target_rank_pos(cur_combat_rank_pos, cur_char_struct_id) {
	
	var ar_len = array_length(global.combat_rank_ar), nested_ar_len, char_struct_id;
	
	/*Iterate both up and down through the array, starting at our cur_combat_rank_pos:
	The bias: we search 'south' first, so if valid characters are found at equal distances from our cur_combat_rank_pos, 
	then the valid character south of us would be returned first. 
	*/
	var iterating_down_index = cur_combat_rank_pos, iterating_up_index = cur_combat_rank_pos;
	
	repeat(ar_len) {
		
		#region Check iterating down index first:
		
		if iterating_down_index < array_length(global.combat_rank_ar) {
		
			nested_ar_len = array_length(global.combat_rank_ar[iterating_down_index]);
		
			//Iterate through the nested_ar, searching for applicable chars:
			for(var char_i = 0; char_i < nested_ar_len; char_i++) {
			
				char_struct_id = global.combat_rank_ar[iterating_down_index][char_i];
			
				//Only check at all if the char has not died, fled, or is not unconscious... Stunned characters can be targeted for attack:
				if char_struct_id.has_died_bool == false && char_struct_id.has_fled_combat_bool == false && char_struct_id.unconscious_bool == false {
				
					if cur_char_struct_id.char_team_enum == team_type.enemy &&
					(char_struct_id.char_team_enum == team_type.pc || char_struct_id.char_team_enum == team_type.neutral) {
						return iterating_down_index;	
					}
					//PCs and neutrals could theoretically target enemies that are already unconscious - but enemies and neutrals never become unconscious - they die instantly:
					else if (cur_char_struct_id.char_team_enum == team_type.pc || cur_char_struct_id.char_team_enum == team_type.neutral) && 
					char_struct_id.char_team_enum == team_type.enemy {
						return iterating_down_index;
					}
				}
			}
		}
		
		#endregion
		
		#region Check iterating up index next:
		
		if iterating_up_index >= 0 {
		
			nested_ar_len = array_length(global.combat_rank_ar[iterating_up_index]);
		
			//Iterate through the nested_ar, searching for applicable chars:
			for(var char_i = 0; char_i < nested_ar_len; char_i++) {
			
				char_struct_id = global.combat_rank_ar[iterating_up_index][char_i];
			
				//Only check at all if the char has not died, fled, or is not unconscious... Stunned characters can be targeted for attack:
				if char_struct_id.has_died_bool == false && char_struct_id.has_fled_combat_bool == false && char_struct_id.unconscious_bool == false  {
				
					if cur_char_struct_id.char_team_enum == team_type.enemy && 
					(char_struct_id.char_team_enum == team_type.pc || char_struct_id.char_team_enum == team_type.neutral) {
						return iterating_up_index;
					
					}
					else if (cur_char_struct_id.char_team_enum == team_type.pc || cur_char_struct_id.char_team_enum == team_type.neutral) && 
					char_struct_id.char_team_enum == team_type.enemy {
						return iterating_up_index;
					}
				}
			}
		}
		
		#endregion
		
		//So long as we can iterate in one direction or another, we can continue:
		
		var valid_iterate = false;
		
		//Iterate down and up index:
		if iterating_down_index + 1 < ar_len {
			iterating_down_index++;
			valid_iterate = true;
		}
		
		if iterating_up_index - 1 >= 0 {
			iterating_up_index--;
			valid_iterate = true;
		}
		
		if !valid_iterate break;
	}
	
	return -1; //No index position found; a valid char could not be found. For enemies, this means that all valid targets are probably unconscious; this should never trigger for pcs, as enemies and neutrals (with the exception of Nikano) generally do not become unconscious when they 'die'

}