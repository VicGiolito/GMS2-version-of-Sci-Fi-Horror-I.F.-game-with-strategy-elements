
/*Only should be run once, when a map is defined, after create event.

'enemy_mobs' are custom structs (defined here) with the following characteristics:
--the grid they belong to (mob_cur_grid);
--their current x and y on that grid (mob_grid_x and mob_grid_y)
--an array containing every enemy_struct_id that belongs to this mob struct (enemies_in_mob_ar)
--a 'chosen path grid': the 'steps_grid' of the pc that has used scr_perform_flood_fill_recursion(); this mob chooses
the steps that has the lowest step value that they are currently standing on, and this is defined in 
scr_enemy_mobs_choose_closest_pc_target()
--the destination grid coordinates of the pc they are pathing to (mob_dest_grid_x and y).

*/

function scr_define_enemy_mobs(spawn_grid) {
	
	var room_struct_id;
	for(var xx = 0; xx < global.cur_grid_w; xx++) {
		for(var yy = 0; yy < global.cur_grid_h; yy++) {
			
			room_struct_id = global.cur_grid[# xx,yy];
			
			if is_struct(room_struct_id) && room_struct_id.struct_type_enum == struct_type.Room {
				if is_array(room_struct_id.enemies_in_room_ar) && array_length(room_struct_id.enemies_in_room_ar) > 0 {
					
					array_push(global.enemy_mob_ar, { mob_cur_grid: spawn_grid, enemies_in_mob_ar : [], mob_grid_x : xx, mob_grid_y : yy, chosen_path_grid: -1, mob_dest_grid_x: -1, mob_dest_grid_y: -1 } );
					
					//Iterate through enemies_in_room at this grid cell, add to newly created mob_struct:
					var ar_len = array_length(room_struct_id.enemies_in_room_ar);
					var char_struct_id;
					for(var i = 0; i < ar_len; i++) {
						char_struct_id = room_struct_id.enemies_in_room_ar[i];
						
						if is_struct(char_struct_id) && char_struct_id.struct_type_enum == struct_type.Character {
							array_push(global.enemy_mob_ar[array_length(global.enemy_mob_ar) - 1].enemies_in_mob_ar, char_struct_id);
						}
					}
				}
			}
		}	
	}
}