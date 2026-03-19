
/* This script essentially just finds the g.cur_combat_char in the combat_initiative_ar, then returns the next char 
in the index position immediately after that, or -1 if we've reached the end of the array of the g.cur_combat_char could
not be found.

a return value of -1 indicates that either we've reached the end of initiative_ar (most likely), or it doesn't exist or it has a length of 0.

*/

function scr_defunct_return_next_combat_char_in_init_queue(){
	
	d($"\nEntering scr_return_next_combat_char_in_init_queue.... global.cur_combat_char.name == {global.cur_combat_char.name}, their index in the combat_init_ar == {array_get_index(global.combat_initiative_ar,global.cur_combat_char)} and the g.cur_combat_char_index == {global.cur_combat_char_index}. Our combat_init_ar looks like this: ...");
	
	var debug_char_id;
	for(var i = 0; i < array_length(global.combat_initiative_ar); i++) {
		debug_char_id = global.combat_initiative_ar[i];
		d($"At index: {i}, char: {debug_char_id.name}({debug_char_id.unique_id})");
	}
	
	//Reset some vars that are only reset when we've advanced to the point that 
	//we're choosing the next character in the intitiative queue:
	global.fleeing_combat_char_id = "reset by scr_return_next_combat_char_in_init_queue()";
	
	#region This method uses the g.cur_combat_char_index again, but this time, we don't remove chars from memory whenever they die or have fled - so it still works:
	
	if is_array(global.combat_initiative_ar) && array_length(global.combat_initiative_ar) > 0 {
		
		var ar_len = array_length(global.combat_initiative_ar);
		var char_struct_id, valid_char_found = true, failsafe_val = 0, failsafe_max = array_length(global.combat_initiative_ar)+1;
		
		do {
			//Advance:
			global.cur_combat_char_index++;
			
			if global.cur_combat_char_index < ar_len {
			
				char_struct_id = global.combat_initiative_ar[global.cur_combat_char_index];
			
				if char_struct_id.has_died_bool == false && char_struct_id.has_fled_combat_bool == false {
					valid_char_found = true;
					return global.combat_initiative_ar[global.cur_combat_char_index];
				}
			}
			else {
				global.cur_combat_char_index = 0;
				
				return -1;
			}
			
			failsafe_val++;
		}
		until(valid_char_found == true || failsafe_val >= failsafe_max);
		
		if failsafe_val >= failsafe_max throw("scr_return_next_combat_char_in_init_queue: failsafe_val >= failsafe_max after our do-until trying to determine our next_combat_char while advancing g.cur_combat_char_index -- this should never trigger");
	}
	
	#endregion
	
	d($"\nscr_return_next_combat_char_in_init_queue: Either we've exceeded the length of our g.combat_initiative_ar, or g.combat_initiative_ar didn't exist as an array, or its len was == 0, so we're returning -1");
	return -1;
}