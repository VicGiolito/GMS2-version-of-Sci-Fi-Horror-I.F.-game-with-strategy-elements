
//returns one of the combat_concluded_result enums

function scr_check_combat_end(){
	
	if is_array(global.combat_initiative_ar) && array_length(global.combat_initiative_ar) > 0 {
	
		var ar_len = array_length(global.combat_initiative_ar);
		
		var char_struct_id, enemy_char_found = false, pc_char_found = false;
		for(var i = 0; i < ar_len; i++) {
			
			char_struct_id = global.combat_initiative_ar[i];
			
			if char_struct_id.has_fled_combat_bool == false && char_struct_id.has_died_bool == false {
				
				//We know this is a pc if they've gone berserk or treacherous - this will automatically include pcs that have gone berserk and become neutrals,
				//and pcs that have become treacherous and become enemies:
				if char_struct_id.char_team_enum == team_type.pc || char_struct_id.treacherous_count > 0 || char_struct_id.berserk_count > 0 
				{ 
					pc_char_found = true;	
				}
				
				if char_struct_id.char_team_enum == team_type.enemy {
					enemy_char_found = true;	
				}
			}
		}
		
		if !pc_char_found {
			return combat_concluded_result.enemies_won;
		}
		if !enemy_char_found {
			return combat_concluded_result.pcs_won;	
		}
		
		return combat_concluded_result.combat_continues;
	}
	
	//Failsafe, this should never trigger:
	d($"\nscr_check_combat_end: both pc_char_found and enemy_char_found returned false, and combat_initiative_ar was not an array, and/or its len == 0; something went wrong.");
	
	return combat_concluded_result.enemies_won;
}

/* I need to adapt this script so that 
