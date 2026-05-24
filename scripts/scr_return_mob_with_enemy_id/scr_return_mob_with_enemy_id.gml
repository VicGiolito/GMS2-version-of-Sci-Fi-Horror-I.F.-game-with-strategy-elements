
/* Returns an array of mob struct ids at the specified grid and coordinates:

identical to scr_return_mob_ar_at_coord (oof)

*/

function scr_return_enemy_mob_id(grid_to_check, check_grid_x, check_grid_y){
	
	d($"\nEntering scr_return_enemy_mob_id now. grid_to_check = {grid_to_check}, check_grid_x = {check_grid_x}, check_grid_y = {check_grid_y} ...\n");
	
	var ar_to_return = [];
	
	if is_array(global.enemy_mob_ar) && array_length(global.enemy_mob_ar) > 0 {
		
		var mob_struct_id;
		for(var i = 0; i < array_length(global.enemy_mob_ar); i++) {
			
			mob_struct_id = global.enemy_mob_ar[i];
			
			d($"\nAt index: {i}: mob_struct_id.mob_cur_grid == {mob_struct_id.mob_cur_grid}, mob_struct_id.mob_grid_x == {mob_struct_id.mob_grid_x}, mob_struct_id.mob_grid_y == {mob_struct_id.mob_grid_y}\n");
			
			if mob_struct_id.mob_cur_grid == grid_to_check && mob_struct_id.mob_grid_x == check_grid_x && mob_struct_id.mob_grid_y == check_grid_y {
				d($"\nAt index: {i}: mob_struct_id was added to ar_to_return.");
				array_push(ar_to_return, mob_struct_id);	
			}
		}
	}
	
	return ar_to_return;
	
}