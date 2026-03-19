
//returns one of the combat_concluded_result enums

function scr_check_combat_end(){
	
	if is_array(global.combat_initiative_ar) && array_length(global.combat_initiative_ar) > 0 {
	
		var ar_len = array_length(global.combat_initiative_ar);
		
		var char_struct_id, enemy_char_found = false, pc_char_found = false;
		for(var i = 0; i < ar_len; i++) {
			
			char_struct_id = global.combat_initiative_ar[i];
			
			if char_struct_id.has_fled_combat_bool == false && char_struct_id.has_died_bool == false {
			
				if char_struct_id.char_team_enum == team_type.pc {
					pc_char_found = true;	
				}
				else if char_struct_id.char_team_enum == team_type.enemy {
					enemy_char_found = true;	
				}
			}
		}
		
		if !pc_char_found {
			global.combat_begun = false; //reset
			return combat_concluded_result.enemies_won;
		}
		if !enemy_char_found {
			global.combat_begun = false; //reset
			return combat_concluded_result.pcs_won;	
		}
		
		return combat_concluded_result.combat_continues;
	}
	
	//Failsafe, this should never trigger:
	d($"\nscr_check_combat_end: both pc_char_found and enemy_char_found returned false, and combat_initiative_ar was not an array, and/or its len == 0; something went wrong.");
	global.combat_begun = false; //reset
	return combat_concluded_result.enemies_won;
}