
//should be called from scope of o_con

function scr_enter_combat_final_step(){
	
	//Define our first g.cur_combat_char as just the first pc, just for the purposes of the prep combat phase:
	global.cur_combat_char = global.combat_rank_ar[rank_pos.pc_far][0];
	next_combat_char = global.cur_combat_char;
		
	d($"scr_check_combat_start returned true.");
	//Our combat rank_ar and initiative_ar have been setup, it's time to head prep combat phase:
	next_combat_game_state = game_state.combat_assign_pc_command;
	global.cur_game_state = game_state.combat_paused;
			
	global.combat_prep_phase = true;
			
	global.cur_combat_char_index = 0;
	scr_add_str_to_dialogue_ar("\nPress any key to enter the combat preparation phase.\n");
			
	//Center our cam (eventually pressing enter will give us a slow zoom before transitioning into the combat screen):
	scr_center_map_window(global.cur_combat_char.cur_grid_x,global.cur_combat_char.cur_grid_y,global.map_cam,"\n\no_con step event: game_state == init_combat: combat begun == true: centering on the first pc in this group...");
}	