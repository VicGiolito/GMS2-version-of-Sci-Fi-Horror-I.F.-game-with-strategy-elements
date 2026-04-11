

function scr_spread_vacuum(){
	
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
						
						var valid_room_type = true;
						
						//We don't check rooms that are already vacuum; edit: we are for now, as this gives us the behavior we desire (all vacuum rooms are vacuum generators);
						//however if this increases iterations by too much, we can include this restriction again:
							//if scr_check_for_vacuum_room(room_struct_id) == true { valid_room_type = false; }
						
						if valid_room_type && is_array(room_struct_id.hazard_generator_ar) && scr_check_ar_for_val(room_struct_id.hazard_generator_ar, hazard_generator_types.vacuum) == true {
							
							//We need to perform a flood fill from this location:
							scr_perform_flood_fill_recursion_for_vacuum_spread(room_struct_id.grid_x, room_struct_id.grid_y, global.steps_grid, room_struct_id.location_grid, true);
						}
					}
				}
			}
		}
	}
}