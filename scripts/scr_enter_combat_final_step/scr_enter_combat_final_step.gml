
//should be called from scope of o_con

function scr_enter_combat_final_step(){
	
	d($"\nEntering scr_enter_combat_final_step, this is called from either the 'C' command in game_state.add_hidden_chars_to_combat; or after combat_begun == true in init_combat game state, if no hidden pc chars are in the same room.\n");
	
	var valid_char_found = true;
	
	var test_pc_char_id = global.combat_rank_ar[rank_pos.pc_far][0];
	
	if test_pc_char_id.unconscious_bool == true || test_pc_char_id.stun_count > 0 {
		
		valid_char_found = false;
		
		var next_avail_pc_char_id = scr_return_next_char_in_ar_direction(1, array_get_index(global.combat_rank_ar[rank_pos.pc_far],test_pc_char_id), test_pc_char_id, global.combat_rank_ar[rank_pos.pc_far]);
		
		if next_avail_pc_char_id != -1 && is_struct(next_avail_pc_char_id) && next_avail_pc_char_id.struct_type_enum == struct_type.Character {
			valid_char_found = true;
			test_pc_char_id = next_avail_pc_char_id;
		}
	}
	
	
	
	if valid_char_found {
		//Define our first g.cur_combat_char as just the first pc, just for the purposes of the prep combat phase:
		global.cur_combat_char = test_pc_char_id;
		next_combat_char = global.cur_combat_char;
		
		//Our combat rank_ar and initiative_ar have been setup, it's time to head prep combat phase:
		next_combat_game_state = game_state.combat_assign_pc_command;
		global.cur_game_state = game_state.combat_paused;
			
		global.combat_prep_phase = true;
		
		global.cur_combat_char_index = 0; //Reset
		
		scr_add_str_to_dialogue_ar("\nPress any key to enter the combat preparation phase.\n");
	}
	
	else if !valid_char_found {
		global.cur_combat_round = 1; //reset
		scr_add_str_to_dialogue_ar($"\nRound {global.cur_combat_round} of combat has begun.\n");	
		
		//Randomize and reorder the g.combat_init_ar, start fresh:
		var temp_ran_init_ar = [];
		temp_ran_init_ar = scr_shuffle_ar(global.combat_initiative_ar);
			
		global.combat_initiative_ar = scr_reverse_sort_combat_init_ar(temp_ran_init_ar);
			
		global.cur_combat_char_index = 0;
		global.cur_combat_char = global.combat_initiative_ar[0];
		next_combat_char = global.cur_combat_char;
		
		if global.cur_combat_char.char_team_enum == team_type.pc {
			//We set this as a failsafe just in case the char revives during scr_trigger_dot_effects() in our combat_paused game state; if they do not,
			//then scr_evaluate_combat_conclusion will be run anyway, and the current character correctly advanced:
			next_combat_game_state = game_state.combat_assign_pc_command; 
			/*If our first char is the unconscious pc, then scr_trigger_dot_effects() will be run on them, and they may die, remain unconscious, or revive; if they revive,
			we've correctly set our next_combat_game_state, so we'll end up in combat_assign_pc_command game state; if they remain unconscious or die, 
			scr_evaluate_combat_conclusion will be called, and the game will either end or proceed to the enemy char, and the next char correctly chosen.
			*/
			global.cur_game_state = game_state.combat_paused;
		}
		else {
			next_combat_game_state = game_state.combat_execute_action; 	
			//"This enemy can only take stock of a devastated battlefield and wait" will trigger, scr_evaluate_combat_conclusion will be called, and we'll ad
			//-vance from there as normal
		}
	}
			
	//Center our cam (eventually pressing enter will give us a slow zoom before transitioning into the combat screen):
	scr_center_map_window(global.cur_combat_char.cur_grid_x,global.cur_combat_char.cur_grid_y,global.map_cam,"\n\no_con step event: game_state == init_combat: combat begun == true: centering on the first pc in this group...");
}	