

function scr_spread_vacuum_or_gas(vacuum_boolean){
	
	d($"Entering scr_spread_vacuum_or_gas....");
	
	//Start iterating through our map grids...
	var master_ar_len = array_length(global.level_ar);
	
	var grid_id;
	for(var i = 0; i < master_ar_len; i++){
		
		grid_id = global.level_ar[i];
		
		if ds_exists(grid_id, ds_type_grid) {
			
			var grid_w = ds_grid_width(grid_id), grid_h = ds_grid_height(grid_id), room_struct_id;
			
			//Reset our steps_grid and visited_grid to match this grid:
			scr_reset_pathing_grids_to_match_grid(grid_id)
			
			for(var xx = 0; xx < grid_w; xx++) {
				for(var yy = 0; yy < grid_h; yy++) {
					room_struct_id = grid_id[# xx,yy];
					
					if is_struct(room_struct_id) && room_struct_id.struct_type_enum == struct_type.Room {
						
						if vacuum_boolean && is_array(room_struct_id.hazard_generator_ar) && scr_check_ar_for_val(room_struct_id.hazard_generator_ar, hazard_generator_types.vacuum) == true {
							
							//We need to perform a flood fill from this location:
							scr_perform_flood_fill_recursion_for_vacuum_or_gas_spread(room_struct_id.grid_x, room_struct_id.grid_y, global.steps_grid, room_struct_id.location_grid, true, true, "called from: scr_spread_vacuum_or_gas, which itself was called from global.cur_game_state == game_state.spread_hazards in our o_con step event");
						}
						
						else if !vacuum_boolean && is_array(room_struct_id.hazard_generator_ar) && scr_check_ar_for_val(room_struct_id.hazard_generator_ar, hazard_generator_types.toxic_gas) == true {
							
							//We need to perform a flood fill from this location:
							scr_perform_flood_fill_recursion_for_vacuum_or_gas_spread(room_struct_id.grid_x, room_struct_id.grid_y, global.steps_grid, room_struct_id.location_grid, true, false,"called from: scr_spread_vacuum_or_gas, which itself was called from global.cur_game_state == game_state.spread_hazards in our o_con step event");
						}
					}
				}
			}
		}
	}
}