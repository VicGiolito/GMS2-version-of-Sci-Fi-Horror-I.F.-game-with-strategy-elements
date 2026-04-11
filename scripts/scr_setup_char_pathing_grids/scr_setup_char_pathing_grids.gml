

function scr_setup_char_pathing_grids(){
	
	var pc_struct_id;
	for(var i = 0; i < array_length(global.pc_char_ar); i++) {
		
		pc_struct_id = global.pc_char_ar[i];
		
		with(pc_struct_id) {
			
			if !ds_exists(flood_fill_path_grid,ds_type_grid) {
				flood_fill_path_grid = ds_grid_create(ds_grid_width(cur_grid), ds_grid_height(cur_grid) );
			}
		}
	}
	
}