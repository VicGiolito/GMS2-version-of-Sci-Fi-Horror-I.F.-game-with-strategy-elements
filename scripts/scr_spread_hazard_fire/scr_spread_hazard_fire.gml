
//We do this for EVERY grid in our global.level_ar

function scr_spread_hazard_fire() {
	
	/*Note: Each index in the coords_to_ignite_ar array contains a struct which contains grid coordinates of the cells that we will turn to fire 
	AFTER we've iterated through our grid; this will ensure that we're only spreading our fire cells one cell at a tiem, and we're not causing a cascade effect
	that could spread the fire really far in one turn; note: multiple entries of the same coordinate can be added to this array. While redundant and slow,
	this isn't really an issue, at least for our purposes right now.
	*/
	
	d("\n!!!!ENTERING scr_spread_hazard_fire NOW!!!!\n");
	
	//Start iterating through our map grids...
	var master_ar_len = array_length(global.level_ar);
	
	var grid_id;
	for(var level_i = 0; level_i < master_ar_len; level_i++){
		
		grid_id = global.level_ar[level_i];
		
		if ds_exists(grid_id, ds_type_grid) {
			
			var coords_to_ignite_ar = -1;
			coords_to_ignite_ar = [];
			
			var grid_w = ds_grid_width(grid_id), grid_h = ds_grid_height(grid_id), room_struct_id;
			
			//Reset our steps_grid and visited_grid to match this grid:
			scr_reset_pathing_grids_to_match_grid(grid_id)
			
			for(var xx = 0; xx < grid_w; xx++) {
				for(var yy = 0; yy < grid_h; yy++) {
					
					room_struct_id = grid_id[# xx,yy];
					
					if is_struct(room_struct_id) && room_struct_id.struct_type_enum == struct_type.Room {
						
						var valid_room_type = true;
						
						//We don't check 'vacuum' rooms:
						if scr_check_for_vacuum_room(room_struct_id) == true { valid_room_type = false; }
						
						if valid_room_type { 
							
							//We only check if there's a fire hazard here or a fire generator here:
							if (is_array(room_struct_id.hazard_ar) && scr_check_ar_for_val(room_struct_id.hazard_ar, hazard_type.fire) == true ) || 
							(is_array(room_struct_id.hazard_generator_ar) && scr_check_ar_for_val(room_struct_id.hazard_generator_ar, hazard_generator_types.fire) == true ) {
							
								//We don't check if this room has vacuum hazard or a vacuum generator:
								var invalid_cell = false;
								
								//Edit: we actually want fire to spread to vacuum rooms, just to destroy the doors; we won't actually apply fire there.
								/*
								if is_array(room_struct_id.hazard_ar) && scr_check_ar_for_val(room_struct_id.hazard_ar, hazard_type.vacuum) == true {
									invalid_cell = true;	
								}
								if is_array(room_struct_id.hazard_generator_ar) && scr_check_ar_for_val(room_struct_id.hazard_generator_ar, hazard_generator_types.vacuum) == true {
									invalid_cell = true;	
								}
								*/
									
								if invalid_cell == false {
									//We've made it this far, check each direction to make sure it's still valid within our grid:
									var check_dir_x, check_dir_y;
									
									for(var dir = 0; dir <= 3; dir++) {
										//West
										if dir == 0 { check_dir_x = -1; check_dir_y = 0; }
										//East:
										else if dir == 1 { check_dir_x = 1; check_dir_y = 0; }
										//North:
										else if dir == 2 { check_dir_x = 0; check_dir_y = -1; }
										//South:
										else if dir == 3 { check_dir_x = 0; check_dir_y = 1; }
										
										//Gather vars:
										var cur_grid_x = room_struct_id.grid_x;
										var cur_grid_y = room_struct_id.grid_y;
										
										var checking_grid_x = cur_grid_x+check_dir_x;
										var checking_grid_y = cur_grid_y+check_dir_y;
										
										//Make sure we're within grid bounds:
										if checking_grid_x >= 0 && checking_grid_x < grid_w && checking_grid_y >= 0 && checking_grid_y < grid_h {
											
											//Define room struct id of the cell we are checking:
											var checking_room_struct = grid_id[# checking_grid_x, checking_grid_y];
											
											//We do in fact check to spread to rooms that already have fire - we do this to ensure that all doors will become broken in a room,
											//regardless of the direction the fire is spreading in; we simply won't double apply the fire there
											/*
											if (is_array(checking_room_struct.hazard_ar) && scr_check_ar_for_val(checking_room_struct.hazard_ar, hazard_type.fire) == true) ||
											(is_array(checking_room_struct.hazard_generator_ar) && scr_check_ar_for_val(checking_room_struct.hazard_generator_ar, hazard_generator_types.fire) == true) {
												continue;	
											}
											*/
											
											//Walls are the only thing our fire doesn't move through; check for them now:
											var valid_dir = true;
											
											var cur_door_macro = scr_return_door_dir_macro(check_dir_x, check_dir_y);
											var adjoining_door_macro = scr_return_opposite_door_dir_macro(cur_door_macro);
											
											var cur_door_struct_id = scr_return_door_struct_id(room_struct_id, cur_door_macro);
											var adjoining_door_struct_id = scr_return_door_struct_id(checking_room_struct, adjoining_door_macro);
											
											if cur_door_struct_id.door_enum == door_state.wall || adjoining_door_struct_id.door_enum == door_state.wall {
												valid_dir = false;	
											}
											
											if valid_dir {
			
												//Make sure the cell we are checking is not a vacuum cell or a vacuum generator cell:
												var invalid_cell = false;
												
												//Edit: we actually don't care if the adjoining room has a vacuum hazard or generator, we still want to destroy the doors leading to there;
												//we simply won't double apply the fire hazard.
												/*
												if is_array(checking_room_struct.hazard_ar) && scr_check_ar_for_val(checking_room_struct.hazard_ar, hazard_type.vacuum) == true {
													invalid_cell = true;	
												}
												if is_array(checking_room_struct.hazard_generator_ar) && scr_check_ar_for_val(checking_room_struct.hazard_generator_ar, hazard_generator_types.vacuum) == true {
													invalid_cell = true;	
												}
												*/
											
												//Add to our coords_to_ignite_ar, add door struct ids so they can be destroyed later:
												if !invalid_cell {
													
													//Finally, a ran_val test; we don't won't fires spreading ALL of the time, they can get out of control very quickly that way:
													var ran_val = irandom_range(1,100);
													
													if ran_val <= FIRE_SPREAD_THRESHOLD_VAL {
													
														//Add to arr:
														array_push(coords_to_ignite_ar, { 
															grid_x: checking_grid_x, 
															grid_y: checking_grid_y,
															original_door: cur_door_struct_id,
															adjoining_door: adjoining_door_struct_id
														});
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			} //End of iterating through our individual grid
			
			//Now iterate through our coords_to_ignite_ar (each one is a custom stuct), applying fire hazard
			if array_length(coords_to_ignite_ar) > 0 {
				for(var z = 0; z < array_length(coords_to_ignite_ar); z++) {
					
					//Gather coords from our custom struct:
					var grid_coord_x = coords_to_ignite_ar[z].grid_x;
					var grid_coord_y = coords_to_ignite_ar[z].grid_y;
					
					//Gather room_struct_id for the room:
					var room_struct_to_ignite_id = grid_id[# grid_coord_x, grid_coord_y];
					
					//We always 'Destroy' the doors of the door structs...
					if coords_to_ignite_ar[z].original_door.door_enum != door_state.wall {
						coords_to_ignite_ar[z].original_door.door_enum = door_state.destroyed;
					}
					if coords_to_ignite_ar[z].adjoining_door.door_enum != door_state.wall {
						coords_to_ignite_ar[z].adjoining_door.door_enum = door_state.destroyed;
					}
					
					//We don't apply fire to rooms with vacuum or vacuum generators:
					if is_array(room_struct_to_ignite_id.hazard_ar) && scr_check_ar_for_val(room_struct_to_ignite_id.hazard_ar, hazard_type.vacuum) == true {
						continue;	
					}
					if is_array(room_struct_to_ignite_id.hazard_generator_ar) && scr_check_ar_for_val(room_struct_to_ignite_id.hazard_generator_ar, hazard_generator_types.vacuum) == true {
						continue;	
					}
					
					//... But we never 'reapply' the hazard:
					if is_array(room_struct_to_ignite_id.hazard_ar) && scr_check_ar_for_val(room_struct_to_ignite_id.hazard_ar, hazard_type.fire) == true {
						continue;	
					}
					
					//Apply hazard:
					if !is_array(room_struct_to_ignite_id.hazard_ar) {
						room_struct_to_ignite_id.hazard_ar = [];	
					}
					
					array_push(room_struct_to_ignite_id.hazard_ar, hazard_type.fire);
					
					//Show message to alert the player - but only if there's anyone in there (we don't care what state they are in):
					if (is_array(room_struct_to_ignite_id.pcs_in_room_ar) && array_length(room_struct_to_ignite_id.pcs_in_room_ar) > 0 ) ||
					(is_array(room_struct_to_ignite_id.neutrals_in_room_ar) && array_length(room_struct_to_ignite_id.neutrals_in_room_ar) > 0 ) {
						scr_add_str_to_dialogue_ar($"\nFire has spread into the {room_struct_to_ignite_id.room_name_str}!");	
					}
				}
			}
			
		} //End of if this is a grid
		
	} //End of iterating through our level ar
	
	
}