
/* 
This script adds to the array you pass in mob struct ids

identical to scr_return_mob_ar_at_coord (oof)

With this script we do the following:
Iterate through our enemy_mob_ar:
	if the mobs within have the same cur_grid_x and y as that which we feed into this script, then they get added to the ar_to_pass
*/

function scr_return_mob_with_enemy_id(grid_x, grid_y, enemy_struct_id){
	
	var ar_len = array_length(global.enemy_mob_ar);
	
	var mob_struct_id;
	
	for(var i = 0; i < ar_len; i++) {
		
		mob_struct_id = global.enemy_mob_ar[i];
		
		if mob_struct_id.mob_grid_x == grid_x && mob_struct_id.mob_grid_y == grid_y {
			
			//Iterate through its nested ar:
			if is_array(mob_struct_id.enemies_in_mob_ar) && array_length(mob_struct_id.enemies_in_mob_ar) > 0 {
				
				var enemy_id_in_mob;
				
				for(var yy = 0; yy < array_length(mob_struct_id.enemies_in_mob_ar); yy++) {
					
					enemy_id_in_mob = mob_struct_id.enemies_in_mob_ar[yy];
					
					if enemy_id_in_mob == enemy_struct_id {
						
						return mob_struct_id;
					}
				}
			}
			
			
		}
	}
	
	return -1;
}