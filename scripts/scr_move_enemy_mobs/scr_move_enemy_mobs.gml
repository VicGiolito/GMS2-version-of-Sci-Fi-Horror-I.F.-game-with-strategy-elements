
/*
Summary:

--We iterate through our enemy_mob_ar

--If we haven't already reached our destination, we check each of the four cardinal directions; if that direction is not a wall, then we add to a 
temporary priority queue as the prority the step value of that cell that we get from our chosen_path_grid, which was defined in scr_enemy_mobs_choose_closest_pc_target();
and as the value: a custom struct that includes the direction we are checking, as well as the coordinates of that direction (the mob's current coordinates + direction).

--If that temporary priority was actually filled, we use the struct information that has the lowest priority (lowest step value) from our temporary priority queue.

--If the door in that struct is unlocked, open space, or destroyed, we then actually 'move' the enemy_mob struct by updating its mob_grid_x and y, then
we iterate through the enemies_in_room_ar for our current room struct (the one the mob is in currently), and for each enemy in that array, we then iterate
through the mob struct's enemies_in_mob_ar, and if any enemy id in that array == the enemy id we are iterating over in the enemies_in_room_ar, then we flip
a boolean var to == true; and if that boolean var still == false when we reach the end of the current iteration of the enemies_in_room_ar, then we the
enemy_id from the enemies_in_room_ar to a new temporary array.
		And after we finish iterating through the enemies_in_room_ar, if the new temporary array has a length > 0, then we replace the enemies_in_room_ar with
that temporary array. What that does is it filters out any enemies in the enemies_in_room_ar that were NOT also in the mob struct's enemies_in_mob_ar.
		So enemies that don't belong to this mob struct but are in this room's enemies_in_room_ar still stay there.
		Otherwise, if they all also belong to the mob struct array, then the enemies_in_room_ar simply gets deleted, because the mob is moving.

--But if the door struct was locked or jammed, we deal damage to it based partly on the number of enemies in our mob array, and then convert it to a destroyed
door if the door's hp is <= 0.
*/

function scr_move_enemy_mobs(){
	
	if is_array(global.enemy_mob_ar) && array_length(global.enemy_mob_ar) > 0 {
		d("\nEntering scr_move_enemy_mobs...\n");
		var ar_len = array_length(global.enemy_mob_ar), enemy_mob_struct_id;
		//Iterate through g.enemy_mob_ar
		for(var i = 0; i < ar_len; i++){ 
			
			enemy_mob_struct_id = global.enemy_mob_ar[i];
			
			d($"\nscr_move_enemy_mobs... enemy_mob mob_grid_x: {enemy_mob_struct_id.mob_grid_x}, mob_grid_y: {enemy_mob_struct_id.mob_grid_y}, mob_dest_grid_x = {enemy_mob_struct_id.mob_dest_grid_x}, mob_dest_grid_y = {enemy_mob_struct_id.mob_dest_grid_y}");
			
			if enemy_mob_struct_id.no_target_found == true || enemy_mob_struct_id.ai_movement_behavior == ai_movement_type.guarding continue;
			
			//Only do any of this if we're not already in the same room with our target:
			if enemy_mob_struct_id.mob_grid_x != enemy_mob_struct_id.mob_dest_grid_x || 
			enemy_mob_struct_id.mob_grid_y != enemy_mob_struct_id.mob_dest_grid_y
			{
				
				d($"scr_move_enemy_mobs: Entering movement code for if enemy mob ai movement type != guarding...");
				
				if enemy_mob_struct_id.ai_movement_behavior == ai_movement_type.hunting {
				
					var grid_id = enemy_mob_struct_id.chosen_path_grid;
					var cur_mob_grid = enemy_mob_struct_id.mob_cur_grid;
					var cur_room_struct_id = cur_mob_grid[# enemy_mob_struct_id.mob_grid_x, enemy_mob_struct_id.mob_grid_y];
					var next_dir_priority_queue = ds_priority_create();
				
					d($"\nscr_move_enemy_mobs... enemy_mob in the {cur_room_struct_id.room_name_str} is preparing to check its cardinal directions...\n");
				
					/*Iterate through all possible directions in this room directional array; if it's not a wall direction,
					add a struct to our next_dir_priority_queue, along with the priority which is the step value of that cell we are checking.
					The struct in our next_dir_priority_queue simply contains its grid coordinate (dest_grid_x and y),
					and the x and y directions we used to get there (cell_dir_x and y).
					*/
					for(var dir_i = 0; dir_i <= 3; dir_i++) {
						var check_dir_x = 0, check_dir_y = 0;
						if dir_i == 0 { check_dir_x = -1; door_macro = DOOR_DIR_W; } //W
						else if dir_i == 1 { check_dir_y = -1; door_macro = DOOR_DIR_N; } //N
						else if dir_i == 2 { check_dir_x = 1; door_macro = DOOR_DIR_E; } //E
						else if dir_i == 3 { check_dir_y = 1; door_macro = DOOR_DIR_S; } //S
				
						var door_macro = scr_return_door_dir_macro(check_dir_x,check_dir_y);
				
						var door_state_enum = cur_room_struct_id.directional_ar[door_macro];
				
						if door_state_enum != door_state.wall {
							//Add to priority queue:
							ds_priority_add(next_dir_priority_queue, { cell_dir_x: check_dir_x, cell_dir_y: check_dir_y, dest_grid_x: enemy_mob_struct_id.mob_grid_x+check_dir_x, dest_grid_y: enemy_mob_struct_id.mob_grid_y+check_dir_y }, grid_id[# enemy_mob_struct_id.mob_grid_x+check_dir_x,enemy_mob_struct_id.mob_grid_y+check_dir_y] );
						}
					}
			
					//Now we choose our direction with the lowest direction, and move there, if applicable:
					if !ds_priority_empty(next_dir_priority_queue) {
					
						d($"\nscr_move_enemy_mobs... for enemy mob in the {cur_room_struct_id.room_name_str}, enemy_mob next_dir_priority_queue was NOT empty, so we're going to use its vars now...\n");
					
						var cell_struct_id = ds_priority_delete_min(next_dir_priority_queue);
				
						var door_macro = scr_return_door_dir_macro(cell_struct_id.cell_dir_x,cell_struct_id.cell_dir_y);
				
						var door_dir_str = scr_return_door_dir_str_from_macro(door_macro);
				
						var directional_struct_id = cur_room_struct_id.directional_ar[door_macro];
				
						var door_state_enum = directional_struct_id.door_enum;
				
						if door_state_enum == door_state.unlocked || door_state_enum == door_state.open_space || 
						door_state_enum == door_state.destroyed {
					
							//Move there, change vars: change the enemy mob struct grid coordinates, then adjust both of the enemies_in_room arrays for both the room they are leaving and the room they are entering.
					
							//Update the mob's mob_grid_x and mob_grid_y:
							enemy_mob_struct_id.mob_grid_x = cell_struct_id.dest_grid_x;
							enemy_mob_struct_id.mob_grid_y = cell_struct_id.dest_grid_y;
					
							//Update the enemies_in_room_ar to weed out any enemies in the current mob array:
							var new_enemies_in_room_ar = [];
					
							var enemy_in_room_struct_id, enemy_in_mob_struct_id;
						
							for(var enemy_i = 0; enemy_i < array_length(cur_room_struct_id.enemies_in_room_ar); enemy_i++) {
						
								enemy_in_room_struct_id = cur_room_struct_id.enemies_in_room_ar[enemy_i];
						
								var duplicate_enemy_found = false;
						
								for(var enemy_in_mob_index = 0; enemy_in_mob_index < array_length(enemy_mob_struct_id.enemies_in_mob_ar); enemy_in_mob_index++) {
							
									enemy_in_mob_struct_id = enemy_mob_struct_id.enemies_in_mob_ar[enemy_in_mob_index];
							
									if enemy_in_mob_struct_id == enemy_in_room_struct_id {
										duplicate_enemy_found = true;
										break;
									}
								}
						
								if !duplicate_enemy_found {
									array_push(new_enemies_in_room_ar, enemy_in_room_struct_id);
								}
							}
					
							if array_length(new_enemies_in_room_ar) > 0 {
								cur_room_struct_id.enemies_in_room_ar = new_enemies_in_room_ar;
							} else {
								cur_room_struct_id.enemies_in_room_ar = -1;	
							}
					
							//Now simply add to the destination room enemies in room array:
								//Iterate through enemy_mob_struct_id.enemies_in_mob_ar, add to dest room enemies in room ar:
							var new_dest_room_struct_id = cur_mob_grid[# enemy_mob_struct_id.mob_grid_x,enemy_mob_struct_id.mob_grid_y];
					
							//Create, if it does not exist:
							if !is_array(new_dest_room_struct_id.enemies_in_room_ar) {
								new_dest_room_struct_id.enemies_in_room_ar = [];		
							}
						
							//Add to the NEW room struct's enemies_in_room_ar each character id within the enemy_mob_struct_id.enemies_in_mob_ar
							for(var enemy_in_mob_i = 0; enemy_in_mob_i < array_length(enemy_mob_struct_id.enemies_in_mob_ar); enemy_in_mob_i++) {
								array_push(new_dest_room_struct_id.enemies_in_room_ar, enemy_mob_struct_id.enemies_in_mob_ar[enemy_in_mob_i]);
							}
							d("\nMOB FUCKING HUNTING MOVED!\n");
						}
					
						else if door_state_enum == door_state.jammed || door_state_enum == door_state.locked {
							d("\nMOB TRYING TO BREAK DOWN DOOR!\n");
							//Attempt to break down door, deal damage first:
							var mob_door_dmg = array_length(enemy_mob_struct_id.enemies_in_mob_ar)*5;
							directional_struct_id.door_hp -= mob_door_dmg;
							d($"\n!!!!!! MOB IS ATTACKING A DOOR STRUCT: scr_move_enemy_mobs: the enemy mob has done {mob_door_dmg} damage to a locked or jammed door that was in their path!!!!!\n");
							var door_destroyed = false;
							if directional_struct_id.door_hp <= 0 {
								door_destroyed = true;
								directional_struct_id.door_enum = door_state.destroyed;
								d($"\nscr_move_enemy_mobs: the enemy mob has destroyed the door.\n");
								//Check within bounds (the enemy shouldn't ever be trying to path off the map, but just in case):
								if cell_struct_id.dest_grid_x >= 0 && cell_struct_id.dest_grid_x < ds_grid_width(cur_mob_grid) &&
								cell_struct_id.dest_grid_y >= 0 && cell_struct_id.dest_grid_y < ds_grid_height(cur_mob_grid) {
									//Destroy adjoining door as well:
									var opposite_door_macro = scr_return_opposite_door_dir_macro(door_macro);
									var adjoining_door_struct_id = scr_return_door_struct_id(cur_mob_grid[# cell_struct_id.dest_grid_x, cell_struct_id.dest_grid_y], opposite_door_macro);
									adjoining_door_struct_id.door_enum = door_state.destroyed;
								}
							
							}
						
							//Show damage or door destroyed, if there's a pc in the destination room.
							if is_array(new_dest_room_struct_id.pcs_in_room_ar) && array_length(new_dest_room_struct_id.pcs_in_room_ar) > 0 {
								var pc_name = new_dest_room_struct_id.pcs_in_room_ar[0].name;
								if !door_destroyed {
									scr_add_str_to_dialogue_ar($"{pc_name}: \"It sounds like something is trying to break down the {door_dir_str} door!\"");	
								} else {
									scr_add_str_to_dialogue_ar($"{pc_name}: \"They've destroyed the {door_dir_str} door!\"");	
								}
							}	
						}
					}
					//We're surrounded by walls and therefore stuck, show debug, do nothing:
					else {
						d($"scr_move_enemy_mobs: the enemy mob struct is surrounded by walls and couldn't move anywhere, it's cur grid_x: {enemy_mob_struct_id.mob_grid_x}, its cur_grid_y: {enemy_mob_struct_id.mob_grid_y}");
					}
				}
				
				//We already know from scr_enemy_mobs_choose_closest_pc_target() that this is a valid cell to move, just move there:
				else if enemy_mob_struct_id.ai_movement_behavior == ai_movement_type.wandering {
					
					var cur_room_struct_id = enemy_mob_struct_id.mob_cur_grid[# enemy_mob_struct_id.mob_grid_x, enemy_mob_struct_id.mob_grid_y];
					
					//Update the mob's mob_grid_x and mob_grid_y:
					enemy_mob_struct_id.mob_grid_x = enemy_mob_struct_id.mob_dest_grid_x;
					enemy_mob_struct_id.mob_grid_y = enemy_mob_struct_id.mob_dest_grid_y;
					
					//Update the enemies_in_room_ar to weed out any enemies in the current mob array:
					var new_enemies_in_room_ar = [];
					
					var enemy_in_room_struct_id, enemy_in_mob_struct_id;
						
					for(var enemy_i = 0; enemy_i < array_length(cur_room_struct_id.enemies_in_room_ar); enemy_i++) {
						
						enemy_in_room_struct_id = cur_room_struct_id.enemies_in_room_ar[enemy_i];
						
						var duplicate_enemy_found = false;
						
						for(var enemy_in_mob_index = 0; enemy_in_mob_index < array_length(enemy_mob_struct_id.enemies_in_mob_ar); enemy_in_mob_index++) {
							
							enemy_in_mob_struct_id = enemy_mob_struct_id.enemies_in_mob_ar[enemy_in_mob_index];
							
							if enemy_in_mob_struct_id == enemy_in_room_struct_id {
								duplicate_enemy_found = true;
								break;
							}
						}
						
						if !duplicate_enemy_found {
							array_push(new_enemies_in_room_ar, enemy_in_room_struct_id);
						}
					}
					
					if array_length(new_enemies_in_room_ar) > 0 {
						cur_room_struct_id.enemies_in_room_ar = new_enemies_in_room_ar;
					} else {
						cur_room_struct_id.enemies_in_room_ar = -1;	
					}
					
					//Now simply add to the destination room enemies in room array:
						//Add to dest room enemies in room ar:
					var new_dest_room_struct_id = enemy_mob_struct_id.mob_cur_grid[# enemy_mob_struct_id.mob_grid_x, enemy_mob_struct_id.mob_grid_y];
					
					//Create, if it does not exist:
					if !is_array(new_dest_room_struct_id.enemies_in_room_ar) {
						new_dest_room_struct_id.enemies_in_room_ar = [];		
					}
						
					//Add to the NEW room struct's enemies_in_room_ar each character id within the enemy_mob_struct_id.enemies_in_mob_ar
					for(var enemy_in_mob_i = 0; enemy_in_mob_i < array_length(enemy_mob_struct_id.enemies_in_mob_ar); enemy_in_mob_i++) {
						array_push(new_dest_room_struct_id.enemies_in_room_ar, enemy_mob_struct_id.enemies_in_mob_ar[enemy_in_mob_i]);
					}
					d("\nMOB FUCKING HUNTING MOVED!\n");
				}
			}
			else {
				d($"scr_move_enemy_mobs: the mob struct was already in the same cell as its target, there was no need to move.");	
			}
		}
	}
}