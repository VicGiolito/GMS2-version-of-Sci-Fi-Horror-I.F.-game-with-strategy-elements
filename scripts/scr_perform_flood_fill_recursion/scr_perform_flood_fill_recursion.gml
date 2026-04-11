

function scr_perform_flood_fill_recursion(char_struct_id, steps_grid_id, cardinal_directions_only = true){
	
	ds_grid_clear(steps_grid_id,UNVISITED_STEP_VAL);
	ds_grid_clear(global.visited_grid,UNVISITED_CELL);
	ds_priority_clear(global.frontier_queue);
	
	failsafe_val = 0;
	//We've made sure that our visited_grid matches whatever grid we're using for this algorithm, we so we can use its dimensions:
	var visited_grid_w = ds_grid_width(global.visited_grid), visited_grid_h = ds_grid_height(global.visited_grid);
	failsafe_max = (visited_grid_w * visited_grid_h) + 1;
	
	d($"Entering scr_perform_flood_fill_recursion: global.cur_grid_w = {visited_grid_w} and global.cur_grid_h = {visited_grid_h}, so max iterations == {failsafe_max}");
	
	//Add this char's current cell as first starting coordinates:
	ds_priority_add(global.frontier_queue, char_struct_id.cur_grid_x + char_struct_id.cur_grid_y * GRID_ENCODE, 0);
	
	steps_grid_id[# char_struct_id.cur_grid_x,char_struct_id.cur_grid_y] = 0;
	
	//Just start iterating outward until our pather can't move anymore:
	do {
		
		if ds_priority_empty(global.frontier_queue) {
			
			d($"scr_perform_flood_fill_recursion: our frontier_queue is empty, our algorithm has finished. It required: {failsafe_val} iterations.");
			
			return true;
		}
		
		var encoded_val = ds_priority_delete_min(global.frontier_queue);
		
		pather_x = encoded_val mod GRID_ENCODE;
		pather_y = encoded_val div GRID_ENCODE;
		
		//d($"scr_perform_flood_fill_recursion: iteration: {failsafe_val} -- pather_x: {pather_x}, pather_y: {pather_y}");
		
		// Skip stale entries
		if global.visited_grid[# pather_x, pather_y] == VISITED_CELL {
		    failsafe_val++;
		    continue;
		}
	
		//Mark as visited:
		global.visited_grid[# pather_x,pather_y] = VISITED_CELL;
		
		//Gather the room_struct_id for this current cell:
		var room_struct_id = global.cur_grid[# pather_x,pather_y];
	
		//Iterate through our directional ar, checking directions:
		var ar_len = array_length(directional_ar);
		var move_dir_x = 0, move_dir_y = 0, checking_cell_x, checking_cell_y;
		if cardinal_directions_only ar_len = 4;
		
		for(var i = 0; i < ar_len; i++) {
			
			move_dir_x = directional_ar[i].check_dir_x;
			move_dir_y = directional_ar[i].check_dir_y;
			
			checking_cell_x = pather_x+move_dir_x;
			checking_cell_y = pather_y+move_dir_y;
		
			//Check within bounds:
			if checking_cell_x >= 0 && checking_cell_x < visited_grid_w && 
			checking_cell_y >= 0 && checking_cell_y < visited_grid_h {
				
				if scr_check_valid_door_dir(room_struct_id,move_dir_x,move_dir_y) {
				
					if global.visited_grid[# checking_cell_x,checking_cell_y] == VISITED_CELL { continue; }
					
					var new_step_val = steps_grid_id[# pather_x, pather_y] + 1;
				
					//Make sure this is a valid cell to be checking:
					if steps_grid_id[# checking_cell_x, checking_cell_y] == UNVISITED_STEP_VAL
					|| new_step_val < steps_grid_id[# checking_cell_x, checking_cell_y] {
					
						//Set step val:
						steps_grid_id[# checking_cell_x, checking_cell_y] = new_step_val;
					
						ds_priority_add(global.frontier_queue,checking_cell_x + checking_cell_y * GRID_ENCODE, new_step_val);
					}
				} 
			}
		}
		
		failsafe_val++;
	}
	until failsafe_val >= failsafe_max;
	
	d($"scr_perform_flood_fill_recursion: we moved past our recursion and priority queue never emptied, something went wrong, returning false.");
	return false;
}