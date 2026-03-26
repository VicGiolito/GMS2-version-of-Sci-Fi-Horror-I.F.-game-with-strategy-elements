

function scr_update_neutrals_movement_vars(neutral_ar, new_grid_x, new_grid_y){
	
	var ar_len = array_length(neutral_ar), neutral_char_id;
	
	for(var i = 0; i < ar_len; i++) {
		
		neutral_char_id = neutral_ar[i];
		
		/*Update:
		--cur_grid x and y
		--remove from room arrays in previous cur_room_id.
		--update cur_room_id.
		--add to room arrays in new room id.
		*/
		
		//Update cur_grid_x and y:
		neutral_char_id.cur_grid_x = new_grid_x;
		neutral_char_id.cur_grid_y = new_grid_y;
		
		//remove from previous cur_room_id room arrays:
		scr_add_remove_char_room_ar(neutral_char_id.cur_room_id,neutral_char_id,false);
		
		//Update cur_room_id:
		neutral_char_id.cur_room_id = neutral_char_id.cur_grid[# neutral_char_id.cur_grid_x, neutral_char_id.cur_grid_y];
		
		scr_add_remove_char_room_ar(neutral_char_id.cur_room_id,neutral_char_id,true);
	}
}