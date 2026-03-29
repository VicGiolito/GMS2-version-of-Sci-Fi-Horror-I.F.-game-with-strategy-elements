

function scr_update_neutrals_movement_vars(neutral_ar, new_grid_x, new_grid_y){
	
	if is_array(neutral_ar) && array_length(neutral_ar) > 0 {
	
		var ar_len = array_length(neutral_ar), neutral_char_id;
	
		for(var i = 0; i < ar_len; i++) {
		
			neutral_char_id = neutral_ar[i];
		
			if neutral_char_id.unconscious_bool == false && neutral_char_id.has_died_bool == false && neutral_char_id.has_fled_combat_bool == false {
				
				if neutral_char_id.stationary_neutral_bool == false { //Those with this value == true never leave the room they spawn in.
				
					//Update cur_grid_x and y:
					neutral_char_id.cur_grid_x = new_grid_x;
					neutral_char_id.cur_grid_y = new_grid_y;
		
					//remove from previous cur_room_id room arrays:
					scr_add_remove_char_room_ar(neutral_char_id.cur_room_id,neutral_char_id,false);
		
					//Update cur_room_id:
					neutral_char_id.cur_room_id = neutral_char_id.cur_grid[# neutral_char_id.cur_grid_x, neutral_char_id.cur_grid_y];
				
					//Add to next room array:
					scr_add_remove_char_room_ar(neutral_char_id.cur_room_id,neutral_char_id,true);
				
					//Remove from combat arrays:
					if global.combat_begun {
						//Flag as fled:
						neutral_char_id.has_fled_combat_bool = true;
					}
				}
			}
		}
	}
}