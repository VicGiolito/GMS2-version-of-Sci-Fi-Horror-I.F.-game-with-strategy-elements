/* We simply iterate through our global arrays, reset certain vars:



*/

function scr_post_combat_reset_vars(){
	
	d($"\nEntering scr_post_combat_reset_vars...\n");
	
	var iterate_count = 0, char_id, global_ar;
	
	repeat(3) {
		
		if iterate_count == 0 { global_ar = global.pc_char_ar; }
		else if iterate_count == 1 { global_ar = global.enemy_char_ar; }
		else if iterate_count == 2 { global_ar = global.neutral_char_ar; }
		
		if is_array(global_ar) && array_length(global_ar) > 0 {
			
			var ar_len = array_length(global_ar);
			
			for(var i = 0; i < ar_len; i++) {
				
				char_id = global_ar[i];
				
				char_id.char_hiding_in_room = false; //Is only set to true when chars successfully hide in a room.
				
				if char_id.has_fled_combat_bool == true { char_id.has_fled_combat_bool = false; }
				
				char_id.char_fleeing_from_broken_morale = false;
				
				//Reset their broken_morale_ar:
				if is_array(char_id.permanent_broken_morale_ar) && array_length(char_id.permanent_broken_morale_ar) > 0 {
					char_id.broken_morale_ar = -1;
					char_id.broken_morale_ar = [];
					array_copy(char_id.broken_morale_ar,0,char_id.permanent_broken_morale_ar, 0, array_length(char_id.permanent_broken_morale_ar) );
				}
				
				scr_reset_status_effects(char_id,"scr_post_combat_reset_vars: which is itself called from o_con step event: init_combat game state: combat_begun == false.");
			}
		}
		
		iterate_count++;
	}
}