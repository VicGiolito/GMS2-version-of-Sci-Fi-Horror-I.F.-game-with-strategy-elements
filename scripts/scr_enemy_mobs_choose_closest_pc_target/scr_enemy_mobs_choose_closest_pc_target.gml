

function scr_enemy_mobs_choose_closest_pc_target(){
	
	if is_array(global.enemy_mob_ar) && array_length(global.enemy_mob_ar) > 0 {
		
		var ar_len = array_length(global.enemy_mob_ar);
		
		var enemy_mob_struct_id;
		//Iterate through the g.enemy_mob_ar:
		for(var i = 0; i < ar_len; i++) {
			
			enemy_mob_struct_id = global.enemy_mob_ar[i];
			
			//Check its step value in each grid:
			var pc_ar_len = array_length(global.pc_char_ar), pc_struct_id;
			//Initialize temp array to length of g.pc_char_ar:
			var step_val_ar = array_create(pc_ar_len,UNVISITED_STEP_VAL);
			
			//Iterate through g.pc_char_ar:
			for(var pc_char_i = 0; pc_char_i < pc_ar_len; pc_char_i++) {
				
				pc_struct_id = global.pc_char_ar[pc_char_i];
				
				var step_val = pc_struct_id.flood_fill_path_grid[# enemy_mob_struct_id.mob_grid_x, enemy_mob_struct_id.mob_grid_y ];
					
				step_val_ar[pc_char_i] = { path_grid_step_val: step_val, pc_index: pc_char_i };
			}
			
			//Bubble sort the step_val_ar:
			var new_step_val_ar = scr_bubble_sort_path_grid_ar(step_val_ar);
			
			var closest_pc_struct_target = global.pc_char_ar[new_step_val_ar[0].pc_index];
			
			enemy_mob_struct_id.chosen_path_grid = closest_pc_struct_target.flood_fill_path_grid;
			enemy_mob_struct_id.mob_dest_grid_x = closest_pc_struct_target.cur_grid_x;
			enemy_mob_struct_id.mob_dest_grid_y = closest_pc_struct_target.cur_grid_y;
		}
	}
}