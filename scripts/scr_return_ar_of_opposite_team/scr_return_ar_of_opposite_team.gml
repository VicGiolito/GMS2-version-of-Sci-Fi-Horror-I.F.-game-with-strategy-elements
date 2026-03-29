
//Currently only used in combat_execute_action game_state and that should be considered when using this script:

function scr_return_ar_of_opposite_team(acting_char_struct_id, ar_to_check){
	
	var ar_to_return = [];
	
	var acting_char_team = acting_char_struct_id.char_team_enum;
	var ar_len = array_length(ar_to_check), char_id;
	for(var i = 0; i < ar_len; i++) {
		
		char_id = ar_to_check[i];	
		
		if char_id.has_died_bool == false && char_id.has_fled_combat_bool == false {
			
			if acting_char_team == team_type.enemy && char_id.unconscious_bool == false {
				//Enemies don't target unconscious players; neutrals will never be unconscious.
				if char_id.char_team_enum == team_type.pc || char_id.char_team_enum == team_type.neutral {
					array_push(ar_to_return,char_id);		
				}
			}
			else if acting_char_team == team_type.pc || acting_char_team == team_type.neutral {
				if char_id.char_team_enum == team_type.enemy {
					array_push(ar_to_return,char_id);	
				}
			}
		}
	}
				
	return ar_to_return;
}