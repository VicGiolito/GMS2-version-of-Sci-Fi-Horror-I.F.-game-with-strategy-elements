
function scr_a_star_plot_path_to_start(use_intercardinal_directions = false){
	
	var path_to_start_plotted = false;
	var temp_pp_ar = [];
	
	do {
	
		if ds_priority_empty(global.frontier_queue) {
			show_debug_message($"scr_a_star_plot_path_to_start: we're still trying to call scr_a_star_plot_path_to_start but our priority_queue is empty, something went wrong.");
			return false;
		}
		
		var encoded_val = ds_priority_delete_min(global.frontier_queue);
		
		pather_x = encoded_val mod GRID_ENCODE;
		pather_y = encoded_val div GRID_ENCODE;
		
		//Add to our path_points_ar:
		array_push(temp_pp_ar,{ room_x: pather_x*global.cell_size+global.half_c, room_y: pather_y*global.cell_size+global.half_c} );
	
		show_debug_message($"scr_a_star_plot_path_to_start: Iteration: {failsafe_val}: pather_x = {pather_x}, pather_y = {pather_y}");
	
		//Check if we've reach end coordinates:
		if pather_x == origin_x && pather_y == origin_y {
			
			global.plotting_path = false;
			
			ds_priority_clear(global.frontier_queue);
			
			path_to_start_plotted = true;
		
			path_points_ar = array_reverse(temp_pp_ar);
		
			show_debug_message($"scr_a_star_plot_path_to_start: reached start coords. It required: {failsafe_val} iterations.");
		
			global.path_successful = true;
			
			return true;
		}
		
		//Gather the room_struct_id for this current cell:
		var room_struct_id = global.cur_grid[# pather_x,pather_y];
	
		//Iterate through our directional ar, checking directions:
		var ar_len = array_length(directional_ar);
		if use_intercardinal_directions == false ar_len = 4;
		var move_dir_x = 0, move_dir_y = 0, checking_cell_x, checking_cell_y;
		for(var i = 0; i < ar_len; i++) {
			
			move_dir_x = directional_ar[i].check_dir_x;
			move_dir_y = directional_ar[i].check_dir_y;
		
			checking_cell_x = pather_x+move_dir_x;
			checking_cell_y = pather_y+move_dir_y;
		
			//Check within bounds:
			if checking_cell_x >= 0 && checking_cell_x < global.cur_grid_w && 
			checking_cell_y >= 0 && checking_cell_y < global.cur_grid_h {
			
				if scr_check_valid_door_dir(room_struct_id,move_dir_x,move_dir_y) {
				
					//Make sure this is a valid cell to be checking:
					if global.visited_grid[# checking_cell_x,checking_cell_y] == UNVISITED_CELL && global.steps_grid[# checking_cell_x,checking_cell_y] != UNVISITED_STEP_VAL {
					
						//Mark as visited:
						global.visited_grid[# checking_cell_x,checking_cell_y] = VISITED_CELL;
					
						//Add to priority_queue:
						//ds_priority_add(global.frontier_queue,{ grid_x: checking_cell_x, grid_y: checking_cell_y },global.steps_grid[# checking_cell_x,checking_cell_y]);
						ds_priority_add(global.frontier_queue,checking_cell_x + checking_cell_y * GRID_ENCODE,global.steps_grid[# checking_cell_x,checking_cell_y]);
					}
				}
			}
		}
	
		failsafe_val++;
	}
	until path_to_start_plotted || failsafe_val >= failsafe_max;
	
	return false;
}