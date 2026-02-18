

function scr_add_cell_to_tilemap(tile_lay_id,tile_enum,grid_x,grid_y){
	
	if tilemap_set(tile_lay_id,tile_enum,grid_x,grid_y) == true {
		//d($"scr_add_cell_to_tilemap: success: set tile with tile_enum: {tile_enum} for grid_cell_x: {grid_x}, y: {grid_y} ");	
	}
	else {
		d($"scr_add_cell_to_tilemap: FAILED to set tile with tile_enum: {tile_enum} for grid_cell_x: {grid_x}, y: {grid_y} ");	
	}
}