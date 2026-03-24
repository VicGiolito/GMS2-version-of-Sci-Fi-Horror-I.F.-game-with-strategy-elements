
/* 

	Uses the g.combat_init_ar, so should only be used when in combat.
	
	Determine the maximum weapon range of from every applicable character in the opposite team. We'll iterate through the combat_init_ar, 
	only checking chars that are not unconscious, dead, or fled. We iterate through the inv_ar (if a pc) or ability_ar (if a neutral). 
	If that item or ability max_range > our starting value of 0, it becomes the new highest value.
		We assign this value as longest_range_in_opposite_team.
	
	if min_or_max_bool == true, we're searching for the largest max_range; if false, the smallest max_range value.
*/

function scr_return_min_max_opposite_team_range(cur_char_id, min_or_max_bool){
	
	var max_or_min_range_in_opposite_team;
	
	if min_or_max_bool max_or_min_range_in_opposite_team = 0;
	else max_or_min_range_in_opposite_team = 100; //Some ludricously high value
	
	var enemy_checking = false;
	
	if cur_char_id.char_team_enum == team_type.enemy enemy_checking = true;
	
	var ar_len = array_length(global.combat_initiative_ar), char_id, char_team_type, item_struct_id;
	
	for(var i = 0; i < ar_len; i++) {
		
		char_id = global.combat_initiative_ar[i];
		
		char_team_type = char_id.char_team_enum;
		
		if char_id.has_died_bool == false && char_id.unconscious_bool == false && char_id.has_fled_combat_bool == false {
			
			if enemy_checking && (char_team_type == team_type.pc || char_team_type == team_type.neutral) {
				//Iterate through their inv_ar:
				if char_team_type == team_type.pc {
					if is_array(char_id.inv_ar) && array_length(char_id.inv_ar) > 0 {
						for(var yy = 0; yy < array_length(char_id.inv_ar); yy++) {
							
							item_struct_id = char_id.inv_ar[yy];
							
							if item_struct_id != -1 && is_struct(item_struct_id) && item_struct_id.struct_type_enum == struct_type.Item {
								if min_or_max_bool && item_struct_id.max_range > max_or_min_range_in_opposite_team {
									max_or_min_range_in_opposite_team = item_struct_id.max_range;
								}
								else if !min_or_max_bool && item_struct_id.max_range < max_or_min_range_in_opposite_team {
									max_or_min_range_in_opposite_team = item_struct_id.max_range;
								}
							}
						}
					}
				}
				//It's a neutral, iterate through their ability_ar instead:
				else if char_team_type == team_type.neutral {
					if is_array(char_id.ability_ar) && array_length(char_id.ability_ar) > 0 {
						for(var yy = 0; yy < array_length(char_id.ability_ar); yy++) {
							
							var abil_enum = char_id.ability_ar[yy];
							
							item_struct_id = global.item_reference_table[abil_enum];
							
							if item_struct_id != -1 && is_struct(item_struct_id) && item_struct_id.struct_type_enum == struct_type.Item {
								if min_or_max_bool && item_struct_id.max_range > max_or_min_range_in_opposite_team {
									max_or_min_range_in_opposite_team = item_struct_id.max_range;
								}
								else if !min_or_max_bool && item_struct_id.max_range < max_or_min_range_in_opposite_team {
									max_or_min_range_in_opposite_team = item_struct_id.max_range;
								}
							}
						}
					}	
				}
			}
			
			//Just check it's ability_ar:
			else if !enemy_checking && char_team_type == team_type.enemy {
				if is_array(char_id.ability_ar) && array_length(char_id.ability_ar) > 0 {
					for(var yy = 0; yy < array_length(char_id.ability_ar); yy++) {
							
						var abil_enum = char_id.ability_ar[yy];
							
						item_struct_id = global.item_reference_table[abil_enum];
							
						if item_struct_id != -1 && is_struct(item_struct_id) && item_struct_id.struct_type_enum == struct_type.Item {
							if min_or_max_bool && item_struct_id.max_range > max_or_min_range_in_opposite_team {
								max_or_min_range_in_opposite_team = item_struct_id.max_range;
							}
							else if !min_or_max_bool && item_struct_id.max_range < max_or_min_range_in_opposite_team {
								max_or_min_range_in_opposite_team = item_struct_id.max_range;
							}
						}
					}
				}
			}
		}	
	}
	
	return max_or_min_range_in_opposite_team;
}