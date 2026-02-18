/* Iterate through cur_grid, add a FOW cell to every cell with a room_struct id that has a explored boolean == true

Summary: this adds a FOW cell to the tile_fow layer for every already explored tile in the g.cur_grid


*/

function scr_reset_visibility(){
	
	var grid_w = ds_grid_width(global.cur_grid), grid_h = ds_grid_height(global.cur_grid);
	
	var room_struct_id;
	for(var xx = 0; xx < grid_w; xx++) {
		for(var yy = 0; yy < grid_h; yy++) {	
			
			room_struct_id = global.cur_grid[# xx,yy];
			
			if is_struct(room_struct_id) {
				if room_struct_id.struct_type_enum == struct_type.Room {
					if room_struct_id.explored_boolean {
						//Add to tilemap:
						if tilemap_set(global.tile_fow_lay_id,TILE_FOW,xx,yy) == true {
							//Tile is set
						}
						else {
							d($"scr_reset_visibility: FAILED to set fow tile for grid_cell_x: {xx}, y: {yy}");	
						}	
					}
				}
			}
		}
	}
	
}