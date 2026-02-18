

function scr_add_doors_to_tilemap(tile_lay_id,grid_x,grid_y){
	
	//First, find the matching room struct id for that grid cell:
	var room_struct_id = global.cur_grid[# grid_x,grid_y];
	
	//Adjust - we * by 3 because our door tile layer is 3 times as large as our tile_main layer; then we add 1
	//to give us our corresponding center door tile in the middle of the room tile - then we offset from there:
	grid_x *= 3;
	grid_y *= 3;
	grid_x += 1;
	grid_y += 1;
	
	//Then iterate through the structs in its directional_ar:
	for(var i = 0; i < array_length(room_struct_id.directional_ar); i++) {
		var directional_struct_id = room_struct_id.directional_ar[i];
		var door_tile_enum = directional_struct_id.door_enum;
		if door_tile_enum != door_state.wall && door_tile_enum != door_state.open_space {
			//Add corresponding tile to corresponding cell:
			var offset_cell_x = 0, offset_cell_y = 0;
			if i == DOOR_DIR_W offset_cell_x = -1;
			else if i == DOOR_DIR_N offset_cell_y = -1;
			else if i == DOOR_DIR_E offset_cell_x = 1;
			else if i == DOOR_DIR_S offset_cell_y = 1;
			
			//Add to tilemap:
			if tilemap_set(tile_lay_id,door_tile_enum,grid_x+offset_cell_x,grid_y+offset_cell_y) == true {
				d($"scr_add_doors_to_tilemap: success: set door tile with door_tile_enum: {door_tile_enum} for grid_cell_x: {grid_x}, y: {grid_y}; offset_cell_x = {offset_cell_x}, offset_cell_y = {offset_cell_y}");	
			}
			else {
				d($"scr_add_doors_to_tilemap: FAILED to set door tile with door_tile_enum: {door_tile_enum} for grid_cell_x: {grid_x}, y: {grid_y}; offset_cell_x = {offset_cell_x}, offset_cell_y = {offset_cell_y}");	
			}
		}
	}
	
	/*
	//Macros for door directions:
	#macro DOOR_DIR_W 0
	#macro DOOR_DIR_N 1
	#macro DOOR_DIR_E 2
	#macro DOOR_DIR_S 3
	*/
}