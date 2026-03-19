/* We simply iterate through our global arrays, reset certain vars:



*/

function scr_post_combat_reset_vars(){
	
	var iterate_count = 0, char_id, global_ar;
	
	repeat(3) {
		
		if iterate_count == 0 global_ar = global.pc_char_ar;
		if iterate_count == 1 global_ar = global.enemy_char_ar;
		else global_ar = global.neutral_char_ar;
		
		if is_array(global_ar) && array_length(global_ar) {
			var ar_len = array_length(global_ar);
			for(var i = 0; i < ar_len; i++) {
				char_id = global_ar[i];
				
				if char_id.has_fled_combat_bool == true char_id.has_fled_combat_bool = false;
			}
		}
		
		iterate_count++;
	}
	
	
}