
/*
We iterate through our cur_grid and if a room does have an explored boolean == true and DOES 
possess a pc struct in it, then we clear the FOW cell from the corresponding cell
*/

function scr_update_visibility(){
	
	var grid_w = ds_grid_width(global.cur_grid), grid_h = ds_grid_height(global.cur_grid);
	
	var room_struct_id;
	for(var xx = 0; xx < grid_w; xx++) {
		for(var yy = 0; yy < grid_h; yy++) {	
			
			room_struct_id = global.cur_grid[# xx,yy];
			
			if room_struct_id.explored_boolean {
				if is_array(room_struct_id.pcs_in_room_ar) && array_length(room_struct_id.pcs_in_room_ar) > 0 {
					//Remove FOW tile from cell:
					tilemap_set(global.tile_fow_lay_id,0,xx,yy);
				}
			}
		}
	}
	
	
}