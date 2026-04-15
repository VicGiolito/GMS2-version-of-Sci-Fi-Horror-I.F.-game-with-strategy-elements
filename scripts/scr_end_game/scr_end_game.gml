
//Only call when the game has completely ended for the player and they have lost.

function scr_end_game(){
	
	scr_add_str_to_dialogue_ar("\nAll playable characters have been killed! You have lost this time, but hopefully you have gained some invaluable knowledge for your next playthrough...");
		
	//Wipe/reset all relevant data:
	global.research_vessel_grid = -1;
	global.cur_grid = -1;
	global.pc_char_ar = -1;
	global.pc_char_ar = [];
	global.enemy_char_ar = -1;
	global.enemy_char_ar = [];
	global.neutral_char_ar = -1;
	global.neutral_char_ar = [];
	o_con.cursor_pos = 0;
		
	o_con.alarm[2] = 1;
		
	global.cur_game_state = game_state.main_menu;
}