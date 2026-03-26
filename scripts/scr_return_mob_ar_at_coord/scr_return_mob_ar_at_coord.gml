
/* 
This script adds to the array you pass in mob struct ids

With this script we do the following:
Iterate through our enemy_mob_ar:
	if the mobs within have the same cur_grid_x and y as that which we feed into this script, then they get added to the ar_to_pass
*/

function scr_return_mob_ar_at_coord(ar_to_pass,grid_x,grid_y){
	
	var ar_len = array_length(global.enemy_mob_ar);
	
	var mob_struct_id;
	for(var i = 0; i < ar_len; i++) {
		mob_struct_id = global.enemy_mob_ar[i];
		
		if mob_struct_id.mob_grid_x == grid_x && mob_struct_id.mob_grid_y == grid_y {
			array_push(ar_to_pass, mob_struct_id);
		}
	}
	
	return ar_to_pass;
}