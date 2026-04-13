
/*Only should be run once, when a map is defined, after create event.

'enemy_mobs' are custom structs (defined here) with the following characteristics:
--the grid they belong to (mob_cur_grid);
--their current x and y on that grid (mob_grid_x and mob_grid_y)
--an array containing every enemy_struct_id that belongs to this mob struct (enemies_in_mob_ar)
--a 'chosen path grid': the 'steps_grid' of the pc that has used scr_perform_flood_fill_recursion(); this mob chooses
the steps that has the lowest step value that they are currently standing on, and this is defined in 
scr_enemy_mobs_choose_closest_pc_target()
--the destination grid coordinates of the pc they are pathing to (mob_dest_grid_x and y).

This script really should generally only be called when loading a new level for the first time, after all of its enemies_in_room arrays have been defined.


*/

function scr_define_enemy_mobs() {
	
	for(var i = 0; i < array_length(global.level_ar); i++) {
		
		var grid_id = global.level_ar[i];
		var grid_w = ds_grid_width(grid_id), grid_h = ds_grid_height(grid_id);
		
		var room_struct_id;
		for(var xx = 0; xx < grid_w; xx++) {
			for(var yy = 0; yy < grid_h; yy++) {
			
				room_struct_id = grid_id[# xx,yy];
			
				if is_struct(room_struct_id) && room_struct_id.struct_type_enum == struct_type.Room {
				
					if is_array(room_struct_id.enemies_in_room_ar) && array_length(room_struct_id.enemies_in_room_ar) > 0 {
						
						var location_enum = scr_return_location_enum_from_grid_id(grid_id);
						
						//Manually define some hunting and wandering type mobs; default will be guarding:
						var movement_type = ai_movement_type.wandering; //guarding
						
						if location_enum == location.research_vessel && room_struct_id.room_enum == research_vessel_room.shuttle_bay {
							movement_type = ai_movement_type.hunting;
						}
						
						array_push(global.enemy_mob_ar, new enemy_mob_struct(grid_id, xx, yy, location_enum, movement_type) );
						
						d($"scr_define_enemy_mobs: enemy mob spawned at: grid_x: {global.enemy_mob_ar[array_length(global.enemy_mob_ar) - 1].mob_grid_x}, grid_y: {global.enemy_mob_ar[array_length(global.enemy_mob_ar) - 1].mob_grid_y}");
					
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
	
}