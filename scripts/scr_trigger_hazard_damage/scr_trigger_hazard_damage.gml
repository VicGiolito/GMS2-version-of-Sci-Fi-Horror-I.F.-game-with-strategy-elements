/*
 Functions like scr_trigger_dot(), except we don't check for death, that's done in that script instead.


*/

function scr_trigger_hazard_damage(){
	
	//Iterate through pc_char_ar and neutral_char_ar:
	var char_struct_id, repeat_loop = 0, ar_to_use = global.pc_char_ar;
	repeat(2) {
		if repeat_loop == 1 ar_to_use = global.neutral_char_ar;
		else if repeat_loop == 2 ar_to_use = global.enemy_char_ar;
		
		if is_array(ar_to_use) && array_length(ar_to_use) > 0 {
			for(var i = 0; i < array_length(ar_to_use); i++) {
		
				char_struct_id = ar_to_use[i];
		
				if is_array(char_struct_id.cur_room_id.hazard_ar) && array_length(char_struct_id.cur_room_id.hazard_ar) > 0 {
			
					if scr_check_ar_for_val(char_struct_id.cur_room_id.hazard_ar,hazard_type.fire) {
						
						//PCS go unconscious
						if char_struct_id.char_team_enum == team_type.pc && char_struct_id.unconscious_bool == false {
							
							char_struct_id.burning_count = FIRE_DURATION;
							
							char_struct_id.hp_cur -= DOT_FIRE;
		
							char_struct_id.burning_count--;
		
							scr_add_str_to_dialogue_ar($"\n{char_struct_id.name}({char_struct_id.unique_id}) is burning! They have taken {DOT_FIRE} damage!");
		
							if char_struct_id.hp_cur <= 0 
							Im working here
						}
						//Neutrals and enemies die immediately:
						else if char_struct_id.char_team_enum != team_type.pc {
							ar_to_use[i] = -1;	
						}
					}
				}	
			}
		}
		
		//Check to see if the array needs to be altered because chars were deleted:
		
		
		//Iterate:
		repeat_loop++;
	}
	
}