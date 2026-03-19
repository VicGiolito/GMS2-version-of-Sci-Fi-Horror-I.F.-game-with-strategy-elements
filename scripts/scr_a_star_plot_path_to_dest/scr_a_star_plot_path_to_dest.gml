

function scr_a_star_plot_path_to_dest(use_intercardinal_directions = false){
	
	//Setup/reset our init vars for first use:
	ds_priority_clear(global.frontier_queue);
	ds_grid_clear(global.steps_grid,UNVISITED_STEP_VAL);
	ds_grid_clear(global.visited_grid, UNVISITED_CELL);
	
	failsafe_val = 0;
	
	show_debug_message($"Entering scr_a_star_plot_path_to_dest: origin_x: {origin_x}, origin_y: {origin_y}, dest_x: {dest_x}, dest_y: {dest_y}");
	
	//Add first coordinate to our frontier queue:
	//ds_priority_add(global.frontier_queue,{ grid_x: origin_x, grid_y: origin_y },0);
	ds_priority_add(global.frontier_queue,origin_x + origin_y * GRID_ENCODE, 0);
			
	global.steps_grid[# origin_x,origin_y] = 0;
	
	var path_plotted = false;
	
	do {
		if ds_priority_empty(global.frontier_queue) {
			show_debug_message($"scr_a_star_plot_path_to_dest: we're still iterating within scr_a_star_plot_path_to_dest but our priority_queue is empty, something went wrong.");
			return false;
		}
		
		var encoded_val = ds_priority_delete_min(global.frontier_queue);
		
		pather_x = encoded_val mod GRID_ENCODE;
		pather_y = encoded_val div GRID_ENCODE;
		
		// Skip stale entries
		if global.visited_grid[# pather_x, pather_y] == VISITED_CELL {
		    failsafe_val++;
		    continue;
		}
	
		//Mark as visited:
		global.visited_grid[# pather_x,pather_y] = VISITED_CELL;
	
		//show_debug_message($"scr_a_star_plot_path_to_dest: Iteration: {failsafe_val}: pather_x = {pather_x}, pather_y = {pather_y}");
	
		//Check if we've reach end coordinates:
		if pather_x == dest_x && pather_y == dest_y {
			path_plotted = true;
			show_debug_message($"scr_a_star_plot_path_to_dest: reached dest coords. It required: {failsafe_val} iterations.");
			failsafe_val = 0; //Reset
			
			//Clear queue:
			ds_priority_clear(global.frontier_queue);
			
			//Reset visited grid:
			ds_grid_clear(global.visited_grid,UNVISITED_CELL);
			
			//Add first coordinates:
			ds_priority_add(global.frontier_queue,dest_x + dest_y * GRID_ENCODE, 0);
			
			global.visited_grid[# dest_x,dest_y] = VISITED_CELL;
		
			return true;
		}
		
		//Gather the room_struct_id for this current cell:
		var room_struct_id = global.cur_grid[# pather_x,pather_y];
	
		//Iterate through our directional ar, checking directions:
		var ar_len = array_length(directional_ar);
		var move_dir_x = 0, move_dir_y = 0, checking_cell_x, checking_cell_y;
		if use_intercardinal_directions == false ar_len = 4;
		for(var i = 0; i < ar_len; i++) {
			
			move_dir_x = directional_ar[i].check_dir_x;
			move_dir_y = directional_ar[i].check_dir_y;
			
			checking_cell_x = pather_x+move_dir_x;
			checking_cell_y = pather_y+move_dir_y;
		
			//Check within bounds:
			if checking_cell_x >= 0 && checking_cell_x < global.cur_grid_w && 
			checking_cell_y >= 0 && checking_cell_y < global.cur_grid_h {
				
				if scr_check_valid_door_dir(room_struct_id,move_dir_x,move_dir_y) {
				
					if global.visited_grid[# checking_cell_x,checking_cell_y] == VISITED_CELL { continue; }
					
					var new_step_val = global.steps_grid[# pather_x, pather_y] + 1;
				
					//Make sure this is a valid cell to be checking:
					if global.steps_grid[# checking_cell_x, checking_cell_y] == UNVISITED_STEP_VAL
					|| new_step_val < global.steps_grid[# checking_cell_x, checking_cell_y] {
					
						//Set step val:
						global.steps_grid[# checking_cell_x, checking_cell_y] = new_step_val;
					
						var dist_to_dest = scr_return_chebyshev_dist(checking_cell_x, checking_cell_y, dest_x, dest_y) * 1.001; //The '1.001' is included to implement 'heuristic tie breaking.' I have a note on this in scr_define_macros_and_enums
					
						//ds_priority_add(global.frontier_queue, { grid_x: checking_cell_x, grid_y: checking_cell_y }, new_step_val + dist_to_dest);
						ds_priority_add(global.frontier_queue,checking_cell_x + checking_cell_y * GRID_ENCODE, new_step_val + dist_to_dest);
					}
				}
			}
		}
	
		failsafe_val++;
	}
	until path_plotted || failsafe_val >= failsafe_max;
	
	//We've made it this far and didn't return true, something went wrong.
	return false;
}