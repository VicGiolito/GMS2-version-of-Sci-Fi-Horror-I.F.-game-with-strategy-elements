
/*
Summary: 

--we iterate through our enemy_mob_ar

--each enemy mob struct within it then iterates through the entire g.pc_char_ar

--If applicable (they're on the same level), we find the step_val for the mob struct's current grid location inside of each pc_char's flood_fill_path_grid,
which is just a steps value grid of their current grid made from a flood fill in the code in the "END" turn block, which is used just before this script is called.

--We add that step value, along with the corresponding pc's index in the g.pc_char_ar, to a temporary struct inside of the 'step_val_ar'

--We then sort that array by the step values within the struct, and then use the pc_char_struct_id of the 0 index struct in this array as our 'target.'

--We use the cur_grid_x and cur_grid_y vars of that pc char as our destination coordinates, and its flood_fill_path_grid as our chosen_path_grid

This script is ALSO where wandering enemy mobs choose their next random destination

*/

function scr_enemy_mobs_choose_closest_pc_target(){
	
	d("\nEntering scr_enemy_mobs_choose_closest_pc_target...\n");
	
	if is_array(global.enemy_mob_ar) && array_length(global.enemy_mob_ar) > 0 {
		
		d("\nEntering scr_enemy_mobs_choose_closest_pc_target...\n");
		
		var ar_len = array_length(global.enemy_mob_ar);
		
		var enemy_mob_struct_id;
		//Iterate through the g.enemy_mob_ar:
		for(var i = 0; i < ar_len; i++) {
			
			enemy_mob_struct_id = global.enemy_mob_ar[i];
			
			if enemy_mob_struct_id.ai_movement_behavior == ai_movement_type.hunting {
			
				//Check its step value in each grid:
				var pc_ar_len = array_length(global.pc_char_ar), pc_struct_id;
			
				//Initialize temp array to length of g.pc_char_ar:
				var step_val_ar = [];
			
				//Iterate through g.pc_char_ar:
				for(var pc_char_i = 0; pc_char_i < pc_ar_len; pc_char_i++) {
				
					pc_struct_id = global.pc_char_ar[pc_char_i];
					
					//We don't path toward hiding characters...
					if pc_struct_id.char_hiding_in_room == true continue;
				
					var pc_location_enum = scr_return_location_enum_from_grid_id(pc_struct_id.cur_grid);
					
					//We don't even consider pcs that are on a different ds_grid:
					if pc_location_enum != enemy_mob_struct_id.location_enum continue;
				
					var step_val = pc_struct_id.flood_fill_path_grid[# enemy_mob_struct_id.mob_grid_x, enemy_mob_struct_id.mob_grid_y ];
					
					array_push(step_val_ar, { path_grid_step_val: step_val, pc_index: pc_char_i } );
				}
			
				//Choose our closest_pc_struct_target var:
				var closest_pc_struct_target;
			
				if array_length(step_val_ar) == 0 {
					enemy_mob_struct_id.no_target_found = true;
					d($"scr_enemy_mobs_choose_closest_pc_target: ai_movement_type == hunting: enemy_mob_struct_id could not find a target, their location did not match the pc_struct_id location.");
					continue;
				}
			
				enemy_mob_struct_id.no_target_found = false; //Reset
			
				//Just use first index:
				if array_length(step_val_ar) == 1 {
					closest_pc_struct_target = global.pc_char_ar[step_val_ar[0].pc_index];	
				}
				//Bubble sort the step_val_ar, then use first index:
				else if array_length(step_val_ar) > 1 {
					var new_step_val_ar = scr_bubble_sort_path_grid_ar(step_val_ar);
					closest_pc_struct_target = global.pc_char_ar[new_step_val_ar[0].pc_index];
				}

				enemy_mob_struct_id.chosen_path_grid = closest_pc_struct_target.flood_fill_path_grid;
				enemy_mob_struct_id.mob_dest_grid_x = closest_pc_struct_target.cur_grid_x;
				enemy_mob_struct_id.mob_dest_grid_y = closest_pc_struct_target.cur_grid_y;
			}
			
			//We'll choose a random cell up to 1 cells away - keep in mind wandering enemies won't path through or break down unlocked doors,
			//so this shouldn't be too much of an issue when it comes to enemies spreading from the south side of the ship:
			else if enemy_mob_struct_id.ai_movement_behavior == ai_movement_type.wandering {
				
				d($"scr_enemy_mobs_choose_closest_pc_target: Entering code for if ai movement type == wandering...");
				
				var mob_cur_room_id = enemy_mob_struct_id.mob_cur_grid[# enemy_mob_struct_id.mob_grid_x, enemy_mob_struct_id.mob_grid_y];
				
				var ran_dir_ar = [];
				array_push(ran_dir_ar, { ran_dir_x: 0, ran_dir_y: -1 }); //N
				array_push(ran_dir_ar, { ran_dir_x: -1, ran_dir_y: 0 }); //W
				array_push(ran_dir_ar, { ran_dir_x: 1, ran_dir_y: 0 }); //E
				array_push(ran_dir_ar, { ran_dir_x: 0, ran_dir_y: 1 }); //S
				
				var valid_dir_found = false;
				
				repeat(4) {
				
					var ran_index = irandom_range(0, array_length(ran_dir_ar)-1);
					
					var dir_x = ran_dir_ar[ran_index].ran_dir_x;
					var dir_y = ran_dir_ar[ran_index].ran_dir_y;
					
					var checking_dir_x = enemy_mob_struct_id.mob_grid_x+dir_x;
					var checking_dir_y = enemy_mob_struct_id.mob_grid_y+dir_y;
					
					if checking_dir_x >= 0 && checking_dir_x < ds_grid_width(enemy_mob_struct_id.mob_cur_grid) && 
					checking_dir_y >= 0 && checking_dir_y < ds_grid_height(enemy_mob_struct_id.mob_cur_grid) {
						
						var checking_room_struct_id = enemy_mob_struct_id.mob_cur_grid[# checking_dir_x, checking_dir_y];
						
						d($"scr_enemy_mobs_choose_closest_pc_target: wandering code: repeat loop determining which direction to choose: checking_room_struct_id: {checking_room_struct_id.room_name_str}, checking_dir_x: {checking_dir_x}, checking_dir_y: {checking_dir_y}");
					
						if scr_check_for_vacuum_room(checking_room_struct_id) == false {
							
							d($"scr_enemy_mobs_choose_closest_pc_target: wandering code: repeat loop determining which direction to choose: we passed our if vacuum room == false test.");
							
							var door_macro = scr_return_door_dir_macro(dir_x, dir_y);
					
							var door_struct_id = scr_return_door_struct_id(mob_cur_room_id, door_macro);
					
							if door_struct_id.door_enum == door_state.unlocked || door_struct_id.door_enum == door_state.open_space || 
							door_struct_id.door_enum == door_state.destroyed {
								valid_dir_found = true;
								enemy_mob_struct_id.mob_dest_grid_x = checking_dir_x;
								enemy_mob_struct_id.mob_dest_grid_y = checking_dir_y;
								d($"\n!!!WANDERING ENEMY MOB FUCKING CHOOSE THE ROOM: {checking_room_struct_id.room_name_str}!!!!\n")
								break;
							}
						}
					}
					
					array_delete(ran_dir_ar, ran_index, 1);
				}
				
				//Switch bool var if we can't move anywhere:
				if !valid_dir_found { enemy_mob_struct_id.no_target_found = true; }
			}
			
		} //End of iterating through mob_struct_ar
		
		d($"\nscr_enemy_mobs_choose_closest_pc_target: vars defined, iterating through enemy_mob_ar for debug purposes now...\n");
		for(var i = 0; i < array_length(global.enemy_mob_ar); i++) {
			d($"\nAt index: {i}: enemy_mob_struct chosen_path_grid: {enemy_mob_struct_id.chosen_path_grid}, enemy_mob_struct_id.mob_dest_grid_x: {enemy_mob_struct_id.mob_dest_grid_x}, enemy_mob_struct_id.mob_dest_grid_y: {enemy_mob_struct_id.mob_dest_grid_y}");
		}
	}
}