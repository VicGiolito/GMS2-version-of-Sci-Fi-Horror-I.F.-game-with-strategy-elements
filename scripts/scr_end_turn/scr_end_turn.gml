
/* 
	--Reset AP and MP to max, char_struct_id.already_fled_this_turn_boolean and char_struct_id.participated_in_new_turn_battle to false
	
	--Reset global.full_game_turn_completed to TRUE.
	
	--Increment total turn counter.
	
	--Reduce food global resource
	
	--Grow infection, change char team, if applicable.
	
	--Call scr_trigger_dot_effects() for each char - this will do things like resolve stun, passive healing effects, and unconscious, until a char 
	either dies or revives.
	
	--Finally, if any enemies either have wandering or hunting ai movement, then each pc performs a flood fill recursion and stores it in their own
	flood_fill_path_grid, and each enemy then iterates through these grids and uses them to set their destination coordinates and nearest target, if
	applicable and if the pc is on the same grid as them.
	
	--We move to game_state.init_combat
*/

function scr_end_turn(){
	
	scr_add_str_to_dialogue_ar($"Round {global.total_turn_counter} ends. Your characters collectively consume 1 food, regain 2 action points, and regain all of their movement points. All enemies make their move. Round {global.total_turn_counter+1} begins.",true);
			
	global.full_game_turn_completed = true; //is reset to false whenever game_state.init_combat concludes with no more combat, and we then spread_hazards.
	
	global.total_turn_counter++;
	
	//Reduce global food:
	global.resources_food--;
	
	//Cap: 
	if global.resources_food < 0 { global.resources_food = 0; }

	//Reset AP, MP, and already_fled_this_turn_boolean and participated_in_new_turn_battle to false:
	var ar_len = array_length(global.pc_char_ar);
	for(var i = 0; i < ar_len; i++) {
		//Increase, cap:
		global.pc_char_ar[i].ability_points_cur += 2;
		if global.pc_char_ar[i].ability_points_cur > global.pc_char_ar[i].ability_points_max {
			global.pc_char_ar[i].ability_points_cur = global.pc_char_ar[i].ability_points_max;	
		}
		//Reset:
		global.pc_char_ar[i].move_points_cur = global.pc_char_ar[i].move_points_max;
		global.pc_char_ar[i].already_fled_this_turn_boolean = false;
		global.pc_char_ar[i].participated_in_new_turn_battle = false;
	}
			
	//Before calling scr_trigger_main_game_dot() and scr_trigger_dot_effects(), we increment infection count:
	var char_struct_id;
	for(var i = 0; i < array_length(global.pc_char_ar); i++) {
		
		char_struct_id = global.pc_char_ar[i];
		
		if char_struct_id.has_died_bool == false && char_struct_id.infection_count > 0 {
			char_struct_id.infection_count++;
			scr_add_str_to_dialogue_ar($"The insidious infection within {char_struct_id.name} has grown by 1.");
					
			//This would be where we have the char change sides - in which case we will clear their status effects and they won't take any further damage:
					
			
		}
		
		//As most status effects are cleared at the end of combat, this is primarily where we check if 
		//unconscious characters will actually die while in the main game state:
		if char_struct_id.has_died_bool == false {
			scr_trigger_dot_effects(char_struct_id);
		}
	}
			
	//Check to see if we even need to run our pathing code:
	var enemy_mob_is_hunting_or_wandering = false;
			
	if is_array(global.enemy_mob_ar) && array_length(global.enemy_mob_ar) > 0 {
		for(var i = 0; i < array_length(global.enemy_mob_ar); i++) {
			if global.enemy_mob_ar[i].ai_movement_behavior == ai_movement_type.hunting || 
			global.enemy_mob_ar[i].ai_movement_behavior == ai_movement_type.wandering {
				enemy_mob_is_hunting_or_wandering = true;
				break;
			}
		}
	}
			
	//Have each char path outward from their current location:
	if enemy_mob_is_hunting_or_wandering {
		var char_struct_id;
		for(var i = 0; i < array_length(global.pc_char_ar); i++) {
				
			char_struct_id = global.pc_char_ar[i];
				
			//Reset their flood_fill_path_grid to match their cur_grid; it will be used as the 'steps_grid' in our pathing algorithm:
			char_struct_id.flood_fill_path_grid = -1;
			char_struct_id.flood_fill_path_grid = ds_grid_create(ds_grid_width(char_struct_id.cur_grid), ds_grid_height(char_struct_id.cur_grid) );
			ds_grid_clear(char_struct_id.flood_fill_path_grid, UNVISITED_STEP_VAL);
				
			//Reset the g.visited_grid so that its dimensions match the char's cur grid:
			if !ds_exists(global.visited_grid, ds_type_grid) { global.visited_grid = ds_grid_create(ds_grid_width(char_struct_id.cur_grid), ds_grid_height(char_struct_id.cur_grid) ); }
			ds_grid_resize(global.visited_grid, ds_grid_width(char_struct_id.cur_grid), ds_grid_height(char_struct_id.cur_grid) );
			ds_grid_clear(global.visited_grid, UNVISITED_CELL);
				
			//Reset frontier_queue, if applicable:
			if !ds_exists(global.frontier_queue, ds_type_priority) { global.frontier_queue = ds_priority_create(); }
			ds_priority_clear(global.frontier_queue);
				
			scr_perform_flood_fill_recursion(char_struct_id, char_struct_id.flood_fill_path_grid);
		}
			
			
		if is_array(global.enemy_mob_ar) && array_length(global.enemy_mob_ar) > 0 {
				
			scr_enemy_mobs_choose_closest_pc_target();
				
			//Okay, the mob structs now have their destination grid cells chosen. 
				
			//Now move them 1 space along their paths:
			scr_move_enemy_mobs();
		}
	}
			
	global.cur_game_state = game_state.init_combat;
	
}