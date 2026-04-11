/* Mostly debug - just iterate through our grid, adding tiles and doors based upon room struct info


*/

function scr_reveal_entire_grid(grid_to_use, mark_as_explored = false){
	
	var grid_w = ds_grid_width(grid_to_use), grid_h = ds_grid_height(grid_to_use);
	
	var room_struct_id;
	for(var xx = 0; xx < grid_w; xx++) {
		for(var yy = 0; yy < grid_h; yy++) {
			
			room_struct_id = grid_to_use[# xx,yy];
			
			if mark_as_explored room_struct_id.explored_boolean = true;
			
			scr_add_cell_to_tilemap(global.tile_main_lay_id,room_struct_id.room_enum,xx,yy);
			
			scr_add_doors_to_tilemap(global.tile_doors_lay_id,xx,yy,grid_to_use);
		}
	}
}