

function scr_flood_fill_vacuum_or_gas(origin_grid_x, origin_grid_y, steps_grid_id, grid_to_check, cardinal_directions_only, spread_vac_boolean, called_from_str){
		
	
	d($"For scr_flood_fill_vacuum_or_gas: Called from: {called_from_str}")
	
	ds_grid_clear(steps_grid_id,UNVISITED_STEP_VAL);
	ds_grid_clear(global.visited_grid,UNVISITED_CELL);
	ds_priority_clear(global.frontier_queue);
	
	failsafe_val = 0;
	//We've already ensured that our character's grid dimensions are the same as our visited grid, so we can use that:
	var visited_grid_w = ds_grid_width(global.visited_grid), visited_grid_h = ds_grid_height(global.visited_grid);
	failsafe_max = (visited_grid_w * visited_grid_h) + 1;
	
	d($"Entering scr_perform_flood_fill_recursion: visited_grid_w = {visited_grid_w} and visited_grid_h = {visited_grid_h}, so max iterations == {failsafe_max}");
	
	//Add origin coordinates as first starting coordinates:
	ds_priority_add(global.frontier_queue, origin_grid_x + origin_grid_y * GRID_ENCODE, 0);
	
	steps_grid_id[# origin_grid_x, origin_grid_y] = 0;
	
	//Just start iterating outward until our pather can't move anymore:
	do {
		
		if ds_priority_empty(global.frontier_queue) {
			
			d($"scr_flood_fill_vacuum_or_gas: our frontier_queue is empty, our algorithm has finished. It required: {failsafe_val} iterations.");
			
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
		
		//Gather the room_struct_id for this CURRENT cell:
		var room_struct_id = grid_to_check[# pather_x,pather_y];
		
		//We don't even bother with 'rooms' that are already just the open vacuum of space:
		var invalid_room_found = false;
		
		//if scr_check_for_vacuum_room(room_struct_id) == true { invalid_room_found = true; }
		
		if !invalid_room_found {
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
					
					//If we've already visited this cell, we can skip it:
					if global.visited_grid[# checking_cell_x,checking_cell_y] == VISITED_CELL { continue; }
					
					//Get the corresponding door struct for this direction, we only check the corresponding cell if its door_struct enum
					// == open_space or destroyed.
					var door_struct_id = scr_return_door_struct_from_dir(room_struct_id, move_dir_x, move_dir_y);
					
					if door_struct_id != -1 && is_struct(door_struct_id) && door_struct_id.struct_type_enum == struct_type.Door {
					
						if door_struct_id.door_enum == door_state.destroyed || door_struct_id.door_enum == door_state.open_space {
							
							//We also need to check the door_state in the opposite direction of the cell we are CHECKING, to ensure that that door is also valid:
							var current_door_macro = scr_return_door_dir_macro(move_dir_x, move_dir_y);
							
							var adjoining_door_macro = scr_return_opposite_door_dir_macro(current_door_macro);
							
							var checking_cell_room_struct = grid_to_check[# checking_cell_x,checking_cell_y];
							
							var adjoining_door_struct_id = scr_return_door_struct_id(checking_cell_room_struct, adjoining_door_macro);
							
							if adjoining_door_struct_id.door_enum == door_state.destroyed || adjoining_door_struct_id.door_enum == door_state.open_space {
								
								var new_step_val = steps_grid_id[# pather_x, pather_y] + 1;
				
								//Make sure this is a valid cell to be checking:
								if steps_grid_id[# checking_cell_x, checking_cell_y] == UNVISITED_STEP_VAL
								|| new_step_val < steps_grid_id[# checking_cell_x, checking_cell_y] {
					
									//Set step val:
									steps_grid_id[# checking_cell_x, checking_cell_y] = new_step_val;
					
									ds_priority_add(global.frontier_queue, checking_cell_x + checking_cell_y * GRID_ENCODE, new_step_val);
							
									if is_array(grid_to_check[# checking_cell_x, checking_cell_y].hazard_ar) == false {
										grid_to_check[# checking_cell_x, checking_cell_y].hazard_ar = [];	
									}
									
									//Change the room struct hazard_ar at this location to include 'vacuum': 
									if spread_vac_boolean {
										//Add vacuum, if applicable:
										if scr_check_ar_for_val(grid_to_check[# checking_cell_x, checking_cell_y].hazard_ar, hazard_type.vacuum) == false {
											array_push(grid_to_check[# checking_cell_x, checking_cell_y].hazard_ar, hazard_type.vacuum);
										}
										//If applicable, clear them of fire and toxic gas:
										if scr_check_ar_for_val(grid_to_check[# checking_cell_x, checking_cell_y].hazard_ar, hazard_type.fire) == true {
											array_delete(grid_to_check[# checking_cell_x, checking_cell_y].hazard_ar, array_get_index(grid_to_check[# checking_cell_x, checking_cell_y].hazard_ar, hazard_type.fire),1);
										}
										if scr_check_ar_for_val(grid_to_check[# checking_cell_x, checking_cell_y].hazard_ar, hazard_type.toxic_gas) == true {
											array_delete(grid_to_check[# checking_cell_x, checking_cell_y].hazard_ar, array_get_index(grid_to_check[# checking_cell_x, checking_cell_y].hazard_ar, hazard_type.toxic_gas),1);
										}
									}
									
									else if !spread_vac_boolean {
										//Add gas, if applicable:
										if scr_check_ar_for_val(grid_to_check[# checking_cell_x, checking_cell_y].hazard_ar, hazard_type.toxic_gas) == false {
											array_push(grid_to_check[# checking_cell_x, checking_cell_y].hazard_ar, hazard_type.toxic_gas);
										}
									}
								}
							}
						} 
					}
				}
			}
		}
		
		failsafe_val++;
	}
	until failsafe_val >= failsafe_max;
	
	d($"scr_flood_fill_vacuum_or_gas: we moved past our recursion algorithm and priority queue never emptied, something went wrong, returning false.");
	return false;
}