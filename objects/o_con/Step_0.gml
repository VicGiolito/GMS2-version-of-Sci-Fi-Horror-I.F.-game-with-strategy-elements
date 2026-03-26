/// @description o_con step event

// Proposed solution to stop program from accepting input while the game is minimized or has lost focus (test this):
if (!window_has_focus()) {
    keyboard_lastkey = 0;
    keyboard_lastchar = "";
    exit;
}

//Always store our win_w and win_h:
var win_mouse_y = window_mouse_get_y(), win_mouse_x = window_mouse_get_x();

#region Basic debug functions:

if keyboard_check_released(vk_f1) {
	game_end();
}

if keyboard_check_released(vk_f2) {
	game_restart();
}

if keyboard_check(vk_lcontrol) && keyboard_check_released(vk_enter) {
	window_set_fullscreen(true);
}

#endregion

#region Adjust our dialogue_text_array with mouse wheel or click and drag - can be done in any game state:

// Update window dimensions based on screen size
dialogue_window_width = display_get_gui_width() * global.top_and_bottom_w_percent;
dialogue_window_height = display_get_gui_height() * global.lower_win_h_percent;
dialogue_window_x = display_get_gui_width() * global.left_win_w_percent;
dialogue_window_y = display_get_gui_height() - dialogue_window_height;

//Recalculate max scroll every step:
scr_calculate_max_scroll();

//Store mouse GUI coordinates:
var mouse_gui_x = device_mouse_x_to_gui(0), mouse_gui_y = device_mouse_y_to_gui(0);

var mouse_in_dialogue_window = point_in_rectangle(mouse_gui_x,mouse_gui_y,dialogue_window_x,dialogue_window_y,
dialogue_window_x+dialogue_window_width,dialogue_window_y+dialogue_window_height);

//Calculate scroll bar position:
var scrollbar_x = dialogue_window_x+dialogue_window_width-global.scrollbar_width-scrollbar_right_edge_offset_x;
var scrollbar_y = dialogue_window_y+scrollbar_right_edge_offset_y;
var scrollbar_track_height = dialogue_window_height-scrollbar_right_edge_offset_y;

//Calculate scrollbar button position and size:
var scroll_ratio = 0;
if (global.max_scroll > 0) {
	scroll_ratio = global.scroll_position / global.max_scroll;	
}

//Define scroll vars:
var visible_ratio = min(1, (dialogue_window_height / global.dialogue_line_h) / max(1, array_length(global.dialogue_ar)));
var button_height = max(global.scrollbar_button_height, scrollbar_track_height * visible_ratio);
var button_y = scrollbar_y + (scrollbar_track_height - button_height) * scroll_ratio;

//Check if mouse is over scrollbar button:
var mouse_on_scrollbar = point_in_rectangle(mouse_gui_x, mouse_gui_y, scrollbar_x, button_y,
                                             scrollbar_x + global.scrollbar_width,
                                             button_y + button_height);

//Logic for scrollbar dragging:
if (mouse_check_button_pressed(mb_left) && mouse_on_scrollbar) {
    global.scrollbar_dragging = true;
    global.scrollbar_drag_offset = mouse_gui_y - button_y;
}

if (mouse_check_button_released(mb_left)) {
    global.scrollbar_dragging = false;
}

//Main dialogue box scrollbar position updating:
if (global.scrollbar_dragging) {
    // Calculate new scroll position based on mouse
    var target_button_y = mouse_gui_y - global.scrollbar_drag_offset;
    var relative_pos = (target_button_y - scrollbar_y) / (scrollbar_track_height - button_height);
    relative_pos = clamp(relative_pos, 0, 1);
    global.scroll_position = relative_pos * global.max_scroll;
}

// Handle mouse wheel scrolling (only when mouse is in window)
if (mouse_in_dialogue_window) {
    var wheel = mouse_wheel_down() - mouse_wheel_up();
    global.scroll_position += wheel * global.scroll_speed;
}

// Clamp both scroll positions
global.scroll_position = clamp(global.scroll_position, 0, global.max_scroll);

#endregion

#region game_state == main_menu:

if global.cur_game_state == game_state.main_menu {
	
	var ar_to_use;
	
	if cur_main_menu_option == main_menu_options.main {
		ar_to_use = main_menu_str_ar;	
	}
	else if cur_main_menu_option == main_menu_options.options {
		ar_to_use = options_menu_str_ar;	
	}
	else if cur_main_menu_option == main_menu_options.video_options {
		ar_to_use = video_options_str_ar;	
	}
	else if cur_main_menu_option == main_menu_options.resolutions_options {
		ar_to_use = resolutions_str_ar;	
	}
	
	if keyboard_check_released(vk_up) || keyboard_check_released(vk_down) {
		
		if keyboard_check_released(vk_up) cursor_pos--;
		else cursor_pos++;
		
		//Cap:
		if cursor_pos < 0 cursor_pos = array_length(ar_to_use)-1;
		else if cursor_pos >= array_length(ar_to_use) cursor_pos = 0;
	}
	
	if keyboard_check_released(vk_escape) {
		//Return to main:
		cur_main_menu_option = main_menu_options.main;	
		cursor_pos = 0; //Reset
	}
	
	if keyboard_check_released(vk_enter) && global.wait {
		
		scr_reset_wait();
		
		if cur_main_menu_option == main_menu_options.main {
			//Start new game
			if cursor_pos == 0 {
				global.cur_game_state = game_state.display_intro;
				global.dialogue_ar = -1;
				global.dialogue_ar = [];
				scr_add_str_to_dialogue_ar(start_new_game_intro_1);
			}
			//Continue game:
			else if cursor_pos == 1 {
					
			}
			//Game options:
			else if cursor_pos == 2 {
				cur_main_menu_option = main_menu_options.options;
				d($"cur_main_menu_option now == {cur_main_menu_option}");
			}
			else if cursor_pos == 3 {
				game_end();
			}
		}
		else if cur_main_menu_option == main_menu_options.options {
			//Video options
			if cursor_pos == 0 {
				cur_main_menu_option = main_menu_options.video_options;	
			}
			//Sound options:
			else if cursor_pos == 1 {
				cur_main_menu_option = main_menu_options.sound_options;	
			}
			//Gameplay options:
			else if cursor_pos == 2 {
				cur_main_menu_option = main_menu_options.gameplay_settings;
			}
			//Backup to main:
			else if cursor_pos == 3 {
				cur_main_menu_option = main_menu_options.main;	
			}
		}
		
		#region Defunct for now - adjust resolution size:
		
		/* //Defunct for now: we can fuck with the display and resolution sizes when we're completely done
		//with this project, as polish.
		else if cur_main_menu_option == main_menu_options.video_options {
			//"CHANGE RESOLUTION"
			if cursor_pos == 0 {
				cur_main_menu_option = main_menu_options.resolutions_options;
			}
			//"ADJUST BRIGHTNESS"
			else if cursor_pos == 1 {
					
			}
			//"CHANGE FONT"
			else if cursor_pos == 2 {
					
			}
			//"BACK"
			else if cursor_pos == 3 {
				cur_main_menu_option = main_menu_options.main;
			}
		}
		
		else if cur_main_menu_option == main_menu_options.resolutions_options {
			//3840 x 2160 (4K/UHD): 640x360 scale: 6x
			if cursor_pos == 0 {
				global.win_w = 3840;
				global.win_h = 2160;
				global.ui_scale = 6;
				scr_setup_cam_view(false,global.win_w,global.win_h,0,0,0,0);
				scr_resize_game_window(global.win_w,global.win_h);
			}
			//2560 x 1440: 640x360 scale: 4x
			else if cursor_pos == 1 {
				global.win_w = 2561;
				global.win_h = 1440;
				global.ui_scale = 4;
				scr_setup_cam_view(false,global.win_w,global.win_h,0,0,0,0);
				scr_resize_game_window(global.win_w,global.win_h);
			}
			//1920x1080 (default): 640x360 scale: 3x
			else if cursor_pos == 2 {
				global.win_w = 1920;
				global.win_h = 1080;
				global.ui_scale = 3;
				scr_setup_cam_view(false,global.win_w,global.win_h,0,0,0,0);
				scr_resize_game_window(global.win_w,global.win_h);
			}
			//1600 x 900: 400 x 225 (4x scale) 
			else if cursor_pos == 3 {
				
			}
			//1366 x 768 (HD): 683 x 384 (2x scale) non-integer width, less ideal 
			else if cursor_pos == 4 {
					
			}
			//1280 x 720: 640x360 scale: 2x
			else if cursor_pos == 5 {
				global.win_w = 1280;
				global.win_h = 720;
				global.ui_scale = 2;	
				scr_resize_game_window_with_letterbox(global.win_w, global.win_h);
			}
		}
		*/
		#endregion
		
		cursor_pos = 0; //Reset
	}
}

#endregion

#region game_state == display_intro: just advance to choose chars:

else if global.cur_game_state == game_state.display_intro {
	
	if keyboard_check_released(vk_enter) && global.wait {
		
		scr_reset_wait();
		
		if intro_state == 0 {
			scr_clear_dialogue_ar();
			scr_add_str_to_dialogue_ar(start_new_game_intro_2);
			intro_state++;
		} else {
			global.cur_game_state = game_state.choose_chars;
			scr_clear_dialogue_ar();
			intro_state = 0;
			//Load our first char description:
			cursor_pos = 0;
			scr_add_str_to_dialogue_ar(char_stats_ar[cursor_pos],false);
			scr_print_char_select_instructions();
		}
		
		keyboard_lastchar = "";
		player_input_str = "";
		
		global.scroll_position = 0; //Reset to the top position in our dialogue box
	}
	if keyboard_check_released(vk_escape) {
		global.cur_game_state = game_state.main_menu;
		cur_main_menu_option = main_menu_options.main;
		global.dialogue_ar = -1;
		global.dialogue_ar = [];
	}
}

#endregion

#region game_state == choose_chars:

else if global.cur_game_state == game_state.choose_chars {
	
	#region Logic for left side window:
	
	if (keyboard_check_released(vk_up) || keyboard_check_released(vk_down)) && global.wait {
		
		scr_reset_wait();
		
		if keyboard_check_released(vk_up) cursor_pos--;
		else cursor_pos++;
		
		//Cap:
		if cursor_pos < 0 cursor_pos = array_length(char_str_ar)-1;
		else if cursor_pos >= array_length(char_str_ar) cursor_pos = 0;
		
		//Clear our txt buffer and add the corresponding string from the char_stat_ar:
		scr_clear_dialogue_ar();
		scr_add_str_to_dialogue_ar(char_stats_ar[cursor_pos]);
		scr_print_char_select_instructions();
	}
	
	#endregion
	
	#region Logic for enter keypress:
	
	if keyboard_check_released(vk_enter) && global.wait {
		
		scr_reset_wait();
		
		//So there is a log of what the player is typing, add it to the last index of our g.dialogue_ar:
		global.dialogue_ar[array_length(global.dialogue_ar)-1] += string(player_input_str);
		//scr_add_str_to_dialogue_ar(">"+string(player_input_str));
		
		//Format our string:
		player_input_str = string(player_input_str);
		player_input_str = string_upper(player_input_str);
		player_input_str = string_trim(player_input_str);
		
		//Parse player_input_str
		
		//Access help commands:
		if player_input_str == "H" || player_input_str == "HELP" {
			scr_add_str_to_dialogue_ar("\n");
			scr_add_str_to_dialogue_ar(global.help_instructions_str_ar);
			scr_add_str_to_dialogue_ar("\n");
			scr_add_str_to_dialogue_ar(char_stats_ar[cursor_pos]);
			scr_print_char_select_instructions();	
		}
		
		#region Add character, check start game:
		
		else if (player_input_str == "A" || player_input_str == "ADD") {
			
			if scr_check_char_type_enum_in_ar(global.pc_char_ar,cursor_pos) == false {
			
				new global.Character(cursor_pos,global.origin_grid_x,global.origin_grid_y,global.cur_grid,team_type.pc,true,true);
				
				//Set its 'char_ar_pos' var:
				global.pc_char_ar[array_length(global.pc_char_ar)-1].char_ar_pos = array_length(global.pc_char_ar)-1;
				
				d($"For char struct: {global.pc_char_ar[array_length(global.pc_char_ar)-1].name}, char_ar_pos == {global.pc_char_ar[array_length(global.pc_char_ar)-1].char_ar_pos}")
				
				scr_add_str_to_dialogue_ar($"{global.pc_char_ar[array_length(global.pc_char_ar)-1].name} has been added to the party.",true);
				
				if array_length(global.pc_char_ar) >= party_limit {	
					
					global.acting_char_struct_id = global.pc_char_ar[0];
					global.acting_char_struct_id_index = 0;
					global.cur_game_state = game_state.main_game;
					
					d($"g.cur_char.cur_grid_x: {global.acting_char_struct_id.cur_grid_x} g.cur_char.cur_grid_y: {global.acting_char_struct_id.cur_grid_y}");
					
					//Center on current char:
					scr_center_map_window(global.acting_char_struct_id.cur_grid_x,global.acting_char_struct_id.cur_grid_y,global.map_cam,"\n\no_con step event: choose_chars game state: player just finished adding last party memeber to party - starting game.");
					
					//Define initial starting items for all chars in the g.pc_char_ar
					scr_setup_char_init_gear_and_abils();
					
					//Set explored and doors_already_added boolean var for origin room == true:
					global.cur_grid[# global.origin_grid_x,global.origin_grid_y].explored_boolean = true;
					global.cur_grid[# global.origin_grid_x,global.origin_grid_y].doors_already_added_boolean = true
					
					//Re-position the sprite vars for each of our pc chars:
					for(var oo = 0; oo < array_length(global.pc_char_ar); oo++) {
						scr_update_char_sprite_position_vars(global.pc_char_ar[oo]);
					}
					
					scr_define_enemy_mobs(global.cur_grid);
					
					scr_reveal_entire_grid(global.cur_grid); //debug only
					
					scr_clear_dialogue_ar();
					scr_print_char_new_room_text(global.acting_char_struct_id);
					
					scr_setup_char_pathing_grids();
				}
			} else {
				scr_add_str_to_dialogue_ar("You've already added this character to your party.",true);	
			}
		}
		
		#endregion
		
		#region Remove char:
		
		else if player_input_str == "R" || player_input_str == "REMOVE" {
			
			if scr_check_char_type_enum_in_ar(global.pc_char_ar,cursor_pos) == true {
				
				var char_index = scr_return_char_type_index_in_ar(global.pc_char_ar,cursor_pos);
				
				if char_index != -1 {
					
					scr_add_remove_char_room_ar(global.pc_char_ar[char_index].cur_room_id,global.pc_char_ar[char_index],false);
					
					var deleted_char_name = global.pc_char_ar[char_index].name;
					
					global.pc_char_ar = scr_add_remove_val_from_ar(global.pc_char_ar, global.pc_char_ar[char_index], true, false);
					
					scr_add_str_to_dialogue_ar($"{deleted_char_name} has been removed from the party.",true);
				} else {
					scr_add_str_to_dialogue_ar("DEBUG: o_con step event: parsing player_input_str in game_stae choose char for 'R' or 'REMOve': scr_return_char_type_index_in_ar returned TRUE, but scr_return_char_type_index_in_ar returned -1, something went wrong.");	
				}
			} else {
				scr_add_str_to_dialogue_ar("This character is not yet in your party.",true);	
			}
		}
		
		#endregion
		
		#region Display character bio:
		
		else if player_input_str == "B" || player_input_str == "BIO" {
			scr_add_str_to_dialogue_ar(char_bio_ar[cursor_pos]);
			scr_add_str_to_dialogue_ar("\n");
			scr_print_char_select_instructions();
		}
		
		#endregion
		
		else {
			scr_add_str_to_dialogue_ar("That is an invalid command, try again.",true);		
		}
		
		//Reset our player_input_str:
		player_input_str = "";
	}
	
	#endregion
	
	#region Accept input for player_input_str:

	// Detect new character input
	if (keyboard_lastchar != "") {
	    if keyboard_lastkey != vk_up && keyboard_lastkey != vk_down && keyboard_lastkey != vk_right 
		&& keyboard_lastkey != vk_left && keyboard_lastkey != vk_backspace {
			
			player_input_str += keyboard_lastchar;
			keyboard_lastchar = ""; 
		}
	}

	// Handle backspace
	if (keyboard_check_pressed(vk_backspace) && string_length(player_input_str) > 0) {
	    player_input_str = string_copy(player_input_str, 1, string_length(player_input_str) - 1);
	}

	#endregion
	
}

#endregion

#region game_state = enemies_moving

else if global.cur_game_state == game_state.enemies_moving {
	
	cur_enemy_mob_struct = global.enemy_mob_ar[cur_enemy_mob_index];
	
	//Have the enemy jump to their farthest accessible point:
	
	cur_enemy_mob_index++;
	
	if cur_enemy_mob_index >= array_length(global.enemy_mob_ar) {
		global.cur_game_state = game_state.main_game;
		global.acting_char_struct_id_index = 0;
		global.acting_char_struct_id = global.pc_char_ar[global.acting_char_struct_id_index];
	}
}

#endregion

#region game_state = init_combat

else if global.cur_game_state == game_state.init_combat {
	
	//Because we return here whenever the combat phase has completed, we need to check if any pcs are still alive:
	var pc_found = scr_check_if_pcs_exist();
	
	d($"Entering game_state.init_combat, pc_found == {pc_found}...");
	
	if pc_found	{
		
		var combat_begun = scr_check_combat_start();
		
		d($"After calling scr_check_combat_start(), combat_begun == {combat_begun}...");
		
		//Combat was not triggered - Move back to main game state, if applicable;
		//This is our very last code block between entering 'end' turn and re-entering the main game state.
		if !combat_begun {
			d($"scr_check_combat_start returned false.");
			scr_post_combat_reset_vars();
			global.cur_game_state = game_state.main_game;
			global.acting_char_struct_id = global.pc_char_ar[0];
			scr_print_char_new_room_text(global.acting_char_struct_id);
		} 
	
		//Combat is warranted - go to pause, then assign pc command (combat prep phase)
		else if combat_begun {
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
			scr_center_map_window(global.cur_combat_char.cur_grid_x,global.cur_combat_char.cur_grid_y,global.map_cam,"\n\no_con step event: game_state == init_combat: combat begun == true: centering on the first pc in this group...")
		}
		else {
			throw("o_con step event: game_state == init_combat: scr_check_combat_start did not return true or false, something went wrong.");
		}
	}
	
	else if !pc_found {
		
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
		cursor_pos = 0;
		
		alarm[2] = 1;
		
		global.cur_game_state = game_state.main_menu;
	}
}

#endregion

#region game_state == combat_paused:

else if global.cur_game_state == game_state.combat_paused && global.wait {
	
	if keyboard_check_released(vk_anykey) && global.wait {
		
		d($"o_con step event: game_state == combat_paused, any key press detected...");
		
		//So there is a log of what the player is typing, add it to the last index of our g.dialogue_ar:
			//global.dialogue_ar[array_length(global.dialogue_ar)-1] += string(player_input_str); //unnecessary for this game state.
		
		//Format our string:
		player_input_str = string(player_input_str);
		player_input_str = string_upper(player_input_str);
		player_input_str = string_trim(player_input_str); //Remove all LEADING white spaces
		
		scr_reset_wait();
		
		//Dead or fled chars don't enter this game state as the next_combat_char, so we don't need to consider them here; 
		//they are weeded out by scr_evaluate_combat_conclusion().
		
		//... We are NOT ending combat...
		if next_combat_game_state != game_state.init_combat {
			//Assign the g.cur_combat_char:
			global.cur_combat_char = next_combat_char;
			
			//Trigger DOT effects, if they are not performing an opportunity attack and we are not in overwatch mode;
			//also reset some combat related vars:
			var char_is_still_alive = true;
			if global.char_is_fleeing_bool == false && global.overwatch_mode_enabled == false {
				
				scr_reset_certain_char_combat_vars(global.cur_combat_char);
				
				char_is_still_alive = scr_trigger_dot_effects(global.cur_combat_char);
			}
			
			//Only allow execute action or pc_command if they not unconscious and not stunned:
			if char_is_still_alive && global.cur_combat_char.unconscious_bool == false && global.cur_combat_char.stun_count <= 0 {
				global.cur_game_state = next_combat_game_state;
		
				//Print combat ranks if we're moving to the assign pc command game state:
				if global.cur_game_state == game_state.combat_assign_pc_command {
					scr_print_combat_ranks(global.cur_combat_char);
				}
			}
			//If they are otherwise impaired (dead, unconscious, or stunned), move to next char in queue:
			else if char_is_still_alive == false || global.cur_combat_char.unconscious_bool == true || global.cur_combat_char.stun_count > 0 {
				scr_evaluate_combat_conclusion($"o_con step event: game_state == combat_paused, the next_combat_char was just assigned as the g.cur_combat_char and it just died from dot effects. Its name was {global.cur_combat_char.name}.");	
			}
		}
		
		//... Combat has concluded - either pcs or enemies have 'won' because all members of the opposite team are dead or fled:
		else if next_combat_game_state == game_state.init_combat {
			global.combat_begun = false;
			global.cur_game_state = game_state.init_combat;
			scr_delete_combat_chars();
		}
		
		//Reset our player_input_str:
		player_input_str = "";
	}
	
	#region Accept input for player_input_str:

	// Detect new character input
	if (keyboard_lastchar != "") {
	    if keyboard_lastkey != vk_up && keyboard_lastkey != vk_down && keyboard_lastkey != vk_right && keyboard_lastkey != vk_left &&
		keyboard_lastkey != vk_backspace {
			player_input_str += keyboard_lastchar;
			keyboard_lastchar = "";
		}
	}

	// Handle backspace
	if (keyboard_check_pressed(vk_backspace) && string_length(player_input_str) > 0) {
	    player_input_str = string_copy(player_input_str, 1, string_length(player_input_str) - 1);
	}

	#endregion
}

#endregion

#region Assign PC combat command game state:

else if global.cur_game_state == game_state.combat_assign_pc_command {
	
	if keyboard_check_released(vk_enter) && global.wait {
		
		scr_reset_wait();
		
		d($"\ngame_state == combat_assign_pc_command, before formatting, player_input_str == {player_input_str}");
		
		//So there is a log of what the player is typing, add it to the last index of our g.dialogue_ar:
		global.dialogue_ar[array_length(global.dialogue_ar)-1] += string(player_input_str);
		
		//Format our string:
		player_input_str = string(player_input_str);
		player_input_str = string_upper(player_input_str);
		player_input_str = string_trim(player_input_str); //Remove all LEADING white spaces
		
		d($"\ngame_state == combat_assign_pc_command, after formatting, player_input_str == {player_input_str}");
		
		var valid_command = false, immediately_move_to_next_char = false;
		
		var multi_word_str_failed = false; //This bool merely indicates whether or not we should show the player an additional explanation message.
		
		#region Evade:
		
		if (player_input_str == "E" || player_input_str == "EVADE") && global.combat_prep_phase == false {
			
			valid_command = true;
			immediately_move_to_next_char = true;
			
			scr_add_str_to_dialogue_ar("\n");
			scr_add_str_to_dialogue_ar($"{global.cur_combat_char.name} is acting defensively this turn (+1 evasion until the start of their next turn).\n");
			
			global.cur_combat_char.evading_boolean = true;
			global.cur_combat_char.evasion += 1;
		}
		
		#endregion
		
		#region 'A'dvance or 'W'ithdraw:
		
		else if (player_input_str == "A" || player_input_str == "ADVANCE" || player_input_str == "W" || player_input_str == "WITHDRAW") 
		&& global.combat_prep_phase == false {
			
			if global.cur_combat_char.suppressed_count <= 0 {
			
				global.cur_combat_char.pc_is_combat_moving = true;
			
				var valid_movement = true;
				if player_input_str == "A" || player_input_str == "ADVANCE" {
					if global.cur_combat_char.cur_combat_rank - 1 >= 0 {
						global.cur_combat_char.combat_move_dir = -1;
					} else valid_movement = false;
				}
				else if player_input_str == "W" || player_input_str == "WITHDRAW" {
					if global.cur_combat_char.cur_combat_rank + 1 < array_length(global.combat_rank_ar) {
						global.cur_combat_char.combat_move_dir = 1;
					} else valid_movement = false;
				}
			
				if valid_movement {
					global.cur_game_state = game_state.combat_execute_action;
				}
				else {
					scr_add_str_to_dialogue_ar("\nYou can move no farther in that direction, try again.",true);
				}
			}
			else {
				var plural_str = "";
				if global.cur_combat_char.suppressed_count > 1 plural_str = "s";
				scr_add_str_to_dialogue_ar($"\nYou're currently suppressed for {global.cur_combat_char.suppressed_count} more turn{plural_str} and can't move from your current position!", true);	
			}
		}
		
		#endregion
		
		#region 'O'verwatch:
		
		else if (player_input_str == "O" || player_input_str == "OVERWATCH") && global.combat_prep_phase == false {
			
			//Build avail_weps_or_abils_ar:
			avail_weps_or_abils_list = -1;
			avail_weps_or_abils_list = [];
			avail_weps_or_abils_list = scr_build_weps_or_abils_list(avail_weps_or_abils_list,global.cur_combat_char,true);
			
			var temp_item_id = avail_weps_or_abils_list[0];
			
			if temp_item_id.max_range > 0 {
				if global.resources_ammo > 0 || temp_item_id.requires_ammo_boolean == false {
					//Switch boolean var:
					global.overwatch_mode_enabled = true;
					//Assign chosen weapon:
					global.cur_combat_char.chosen_weapon = temp_item_id;
					//Move to target ranks state:
					prev_game_state = global.cur_game_state;
					global.cur_game_state = game_state.combat_pc_target_rank;
					scr_print_ranks_to_target(global.cur_combat_char);
				}
				else {
					scr_add_str_to_dialogue_ar("\n");
					scr_add_str_to_dialogue_ar($"You're out of ammo--you can't use overwatch fire!", true);
				}
			}
			else {
				scr_add_str_to_dialogue_ar("\n");
				scr_add_str_to_dialogue_ar($"Your currently equipped weapon doesn't support overwatch fire, try again.", true);	
			}
		}
		
		#endregion
		
		#region 'ABIL'ITY - Move to choose ability game state:
		
		else if (player_input_str == "ABIL" || player_input_str == "ABILITY") {
			
			if is_array(global.cur_combat_char.ability_ar) && array_length(global.cur_combat_char.ability_ar) > 0 {
				
				global.cur_combat_char.filtered_abil_ar = scr_return_filtered_abil_ar(global.cur_combat_char);
				
				if array_length(global.cur_combat_char.filtered_abil_ar) > 0 {
					
					prev_game_state = global.cur_game_state;
					
					global.cur_game_state = game_state.choose_pc_abil;
					
					scr_print_weapon_or_abil_list(false, global.cur_combat_char);
				}
				else {
					scr_add_str_to_dialogue_ar("\nThis character has no abilities that they can use in combat.\n",true);	
				}
			}
			else {
				scr_add_str_to_dialogue_ar("\nThis character has no abilities that they can use in combat.\n",true);	
			}
		}
		
		#endregion
		
		#region 'F'ight - Automatically attack if applicable (no dual wielding):
		
		else if (player_input_str == "F" || player_input_str == "FIGHT") && global.combat_prep_phase == false {
			
			//Build avail_weps_or_abils_ar:
			avail_weps_or_abils_list = -1;
			avail_weps_or_abils_list = [];
			avail_weps_or_abils_list = scr_build_weps_or_abils_list(avail_weps_or_abils_list,global.cur_combat_char,true);
			
			d($"\ncombat_assign_pc_command 'F' chosen: avail_weps_or_abils_list == {avail_weps_or_abils_list}\n");
			
			//Since a player can only have one applicable weapon equipped at a time, we can just chose the first index:
			global.cur_combat_char.chosen_weapon = avail_weps_or_abils_list[0];
			
			//Automatically assign fists if we were trying to use a weapon that requires ammo and we don't have any:
			if global.resources_ammo <= 0 && global.cur_combat_char.chosen_weapon.requires_ammo_boolean == true {
				
				var fists_item_struct_id = scr_return_fists_item_struct_id(global.cur_combat_char);
				
				global.cur_combat_char.chosen_weapon = fists_item_struct_id;
				
				scr_add_str_to_dialogue_ar("\n");
				scr_add_str_to_dialogue_ar($"You're out of ammo! You have resorted to using your {global.cur_combat_char.chosen_weapon.item_name} instead!");
			}
			
			//Check to see if there's an enemy in range:
			var closest_enemy_rank = scr_return_nearest_target_rank_pos(global.cur_combat_char.cur_combat_rank,false);
			
			var dist_to_target = abs(global.cur_combat_char.cur_combat_rank - closest_enemy_rank);
			
			var wep_range = global.cur_combat_char.chosen_weapon.max_range;
			
			//If there's an enemy in range and our max_range is greater than 0, then move to choose_pc_rank_target:
			if dist_to_target <= wep_range {
				
				prev_game_state = global.cur_game_state;
				
				/*To streamline the process even further, check to see if the enemy only occupies one rank in the entire combat_rank_ar;
				if they do (we already know the enemy is within range), just automatically define our range 
				based upon what rank it is in, then automatically move to execute action:
				*/
				if scr_return_opposite_team_occupied_ranks(global.cur_combat_char.char_team_enum) <= 1 {
					global.cur_combat_char.targeted_rank = closest_enemy_rank;
					global.cur_game_state = game_state.combat_execute_action;	
				}
				
				else {
					if wep_range > 0 {
						global.cur_game_state = game_state.combat_pc_target_rank;
						scr_print_ranks_to_target(global.cur_combat_char);
					}
					//otherwise, define our chosen rank and move straight to execute_action:
					else if wep_range <= 0 {
						global.cur_combat_char.targeted_rank = closest_enemy_rank;
						global.cur_game_state = game_state.combat_execute_action;
					}
				}
			}
			else {
				scr_add_str_to_dialogue_ar("\n");
				scr_add_str_to_dialogue_ar($"There are no targets within your weapon's range. Your {global.cur_combat_char.chosen_weapon.item_name} has a maximum range of {wep_range}. Either change weapons, or move closer to the enemy.", true);
			}
		}
		
		#endregion
		
		#region 'V'iew Initiative Order
		
		else if (player_input_str == "V" || player_input_str == "VIEW") {
			scr_print_combat_init_ar();
			scr_add_str_to_dialogue_ar("\n");
			scr_add_str_to_dialogue_ar("Press any key to view the battlefield and available commands again.");
			next_combat_game_state = game_state.combat_assign_pc_command;
			global.cur_game_state = game_state.combat_paused;
		}
		
		#endregion
		
		#region Access help commands:
		
		else if player_input_str == "H" || player_input_str == "HELP" {
			scr_add_str_to_dialogue_ar(global.help_instructions_str_ar);
			scr_add_str_to_dialogue_ar("\n");
			scr_print_combat_ranks(global.cur_combat_char);
		}
		
		#endregion
		
		#region '<' or '>' Change active char - combat prep only:
		
		else if (player_input_str == "<" || player_input_str == ">") && global.combat_prep_phase {
			var iterate_dir = 1;
			if player_input_str == "<" iterate_dir = -1;
			
			var new_pc_combat_char_struct_id = scr_return_next_combat_char_in_ar_direction(iterate_dir,array_get_index(global.combat_initiative_ar,global.cur_combat_char),global.cur_combat_char);
			
			if new_pc_combat_char_struct_id != -1 {
			
				global.cur_combat_char = new_pc_combat_char_struct_id;
				scr_add_str_to_dialogue_ar("\n");
				scr_add_str_to_dialogue_ar($"You have changed control to {global.cur_combat_char.name}.");
				scr_add_str_to_dialogue_ar("\n");
				scr_print_combat_ranks(global.cur_combat_char);
			}
		}
		
		#endregion
		
		#region 'S'tart combat - Combat prep phase only:
		
		else if (player_input_str == "S" || player_input_str == "START") && global.combat_prep_phase {
			
			global.combat_prep_phase = false;
			global.cur_combat_round = 1; //reset
			scr_add_str_to_dialogue_ar($"\nRound {global.cur_combat_round} of combat has begun.\n");
			
			global.cur_combat_char_index = 0;
			global.cur_combat_char = global.combat_initiative_ar[0];
			
			next_combat_char = global.cur_combat_char;
			
			d($"'START' combat selected from o_con step event combat prep phase: global.cur_combat_char.name == {global.cur_combat_char.name}.");
			
			if global.cur_combat_char.char_team_enum == team_type.pc {
				
				global.cur_game_state = game_state.combat_assign_pc_command;
				
				scr_print_combat_ranks(global.cur_combat_char);
			}
			else {

				global.cur_game_state = game_state.combat_execute_action;
			}
		}
		
		#endregion
		
		#region Show 'Inv'entory detailed list:
		
		else if player_input_str == "I" || player_input_str == "INV" || player_input_str == "INVENTORY" {
			scr_print_inv_detailed_list(global.cur_combat_char);
			scr_print_combat_ranks(global.cur_combat_char);
		}
		
		#endregion
		
		#region Logic for all multi-word commands - includes 'R'UN - can be performed in prep_combat or regular combat:
		
		else if scr_check_multi_word_str(player_input_str) == true {
			
			var multi_word_ar = scr_return_multi_word_ar(player_input_str);
			
			var valid_drop_item = false, valid_equip_or_unequip = false, valid_item_index = false;
			var valid_run_dir = false, valid_flee_command = false;
			var valid_give_item = false, valid_use_item = false, valid_look_item = false; 
			
			if multi_word_ar[0] == "D" || multi_word_ar[0] == "DROP" valid_drop_item = true;
			
			else if multi_word_ar[0] == "E" || multi_word_ar[0] == "EQUIP" valid_equip_or_unequip = true;
			
			else if multi_word_ar[0] == "G" || multi_word_ar[0] == "GIVE" valid_give_item = true;
			
			else if multi_word_ar[0] == "U" || multi_word_ar[0] == "USE" valid_use_item = true;
			
			else if multi_word_ar[0] == "EX" || multi_word_ar[0] == "EXAMINE" valid_look_item = true;
			
			else if (multi_word_ar[0] == "R" || multi_word_ar[0] == "RUN") && global.combat_prep_phase == false { valid_flee_command = true; }
			
			#region Make sure its a valid item in the inventory:
			
			if !valid_flee_command {
				try {
					var index_int = real(multi_word_ar[1]);
					
					if is_real(index_int) {
						if index_int >= 0 && index_int < array_length(global.cur_combat_char.inv_ar) && 
						is_struct(global.cur_combat_char.inv_ar[index_int]) && global.cur_combat_char.inv_ar[index_int].struct_type_enum == struct_type.Item {
					
							valid_item_index = true;
					
							var item_struct_id = global.cur_combat_char.inv_ar[index_int];
						}
						else {
							multi_word_str_failed = true;
							scr_add_str_to_dialogue_ar("There is no such item in your inventory, try again.", true);	
						}
					}
				}
			
				catch(_exception) {
					//multi_word_str_failed = true;
					//scr_add_str_to_dialogue_ar("There is no such item in your inventory, try again.", true);
					show_debug_message(_exception.message);
				    show_debug_message(_exception.longMessage);
				    show_debug_message(_exception.script);
				    show_debug_message(_exception.stacktrace);
				}
			}
			
			#endregion
			
			#region Make sure its a valid flee direction:
			
			else if valid_flee_command {
				
				var move_dir_x = 0, move_dir_y = 0;
				
				if multi_word_ar[1] == "E" || multi_word_ar[1] == "EAST" || multi_word_ar[1] == "W" || multi_word_ar[1] == "WEST" ||
				multi_word_ar[1] == "N" || multi_word_ar[1] == "NORTH" || multi_word_ar[1] == "S" || multi_word_ar[1] == "SOUTH" {
					
					if global.cur_combat_char.already_fled_this_turn_boolean == false {
						
						if multi_word_ar[1] == "E" || multi_word_ar[1] == "EAST" move_dir_x = 1;
						else if multi_word_ar[1] == "W" || multi_word_ar[1] == "WEST" move_dir_x = -1;
						else if multi_word_ar[1] == "N" || multi_word_ar[1] == "NORTH" move_dir_y = -1;
						else if multi_word_ar[1] == "S" || multi_word_ar[1] == "SOUTH" move_dir_y = 1;
					
						if move_dir_x != 0 || move_dir_y != 0 {
						
							valid_run_dir = scr_check_valid_door_dir(global.cur_combat_char.cur_room_id,move_dir_x,move_dir_y);
						
							#region Code for determining attacks of opportunity:
						
							if valid_run_dir {
							
								#region 'R'UN command:
			
								//Check to make sure we're at one of the appropriate positions:
								if (global.cur_combat_char.cur_combat_rank == rank_pos.enemy_far || global.cur_combat_char.cur_combat_rank == rank_pos.pc_far) {
				
									//Choose the enemy character as the 'next_combat_char' that will get a free hit on this char, if any:
									/*pseudo code:
										--Iterate through the combat_rank_ar in both directions (starting north), searching for enemies. 
										--Each enemy we find, create a temporary array or list that is a copy of their ability_ar. Randomize the index 
										positions in it. Then iterate through that list, checking each weapon to see if its max range is within range
										of the fleeing character id. If it is, then we choose this character as the 'next_combat_char', and this
										weapon as their chosen weapon. Then we jump to execute action.
										--At the end of execute action, if the fleeing character hasn't been killed, then we remove them from combat,
										and check the end combat game state (script that).
										--Make all of this robust enough so that this code could be performed from the perspective of a fleeing
										pc, enemy, or neutral. It would be cool to have pcs and neutrals that can force enemies to run, and vice verssa.
									*/
				
									var valid_attacker_found = false, char_id, enemy_fleeing = false, applicable_char_found = false;
									var cur_char_rank = global.cur_combat_char.cur_combat_rank, iterate_count = 0;
									var diff = cur_char_rank, rank_i = cur_char_rank;
									//First repeat loop we iterate 'north' (up); second time, we iterate south (down):
									repeat(2) {
										if valid_attacker_found break;
										if iterate_count == 1 { 
											diff = array_length(global.combat_rank_ar) - cur_char_rank;
										}
					
										//Cap:
										if diff == 0 diff = 1;
					
										//Reset:
										rank_i = cur_char_rank;
					
										//Iterate through up or down through g.combat_rank:
										repeat(diff) {
											//Iterate through nested_array:
											for(var i = 0; i < array_length(global.combat_rank_ar[rank_i]); i++) {
												applicable_char_found = false //reset
												//Assign char_id we are checking:
												char_id = global.combat_rank_ar[rank_i][i]; 
												//Unconscious, dead, fled, or stunned chars cannot perform opportunity attack:
												if char_id.unconscious_bool == false && char_id.stun_count <= 0 && char_id.has_died_bool == false && char_id.has_fled_combat_bool == false {
													//If this is a pc or a neutral fleeing, check to see if this is a enemy:
													if !enemy_fleeing && char_id.char_team_enum == team_type.enemy {
														applicable_char_found = true;
													}
													//If this is a enemy fleeing, check to see if this is a pc or a neutral:
													else if enemy_fleeing && (char_id.char_team_enum == team_type.pc || char_id.char_team_enum == team_type.neutral) {
														applicable_char_found = true;	
													}
												}
						
												if applicable_char_found {
													var temp_wep_ar = scr_shuffle_ar(char_id.ability_ar);
							
													for(var item_i = 0; item_i < array_length(temp_wep_ar); item_i++) {
								
														var item_enum = temp_wep_ar[item_i];
														var item_struct_id = global.item_reference_table[item_enum];
														var item_range = item_struct_id.max_range;
								
														var dist = abs(cur_char_rank-rank_i);
								
														if dist <= item_range {
															//Assign vars for the opportunity attacker:
															next_combat_char = char_id;
															next_combat_char.chosen_weapon = item_struct_id;
															next_combat_char.targeted_rank = cur_char_rank;
															//Assign vars for the fleeing char:
															global.cur_combat_char.fleeing_dir_x = move_dir_x;
															global.cur_combat_char.fleeing_dir_y = move_dir_y;
															global.fleeing_combat_char_id = global.cur_combat_char;
														
															valid_attacker_found = true;
														
															global.char_is_fleeing_bool = true;
															//Assign char_id_after_char_flees or is killed:
															var cur_char_index = array_get_index(global.combat_initiative_ar,global.cur_combat_char);
														
															if cur_char_index + 1 < array_length(global.combat_initiative_ar) {
																char_id_after_char_flees = global.combat_initiative_ar[cur_char_index+1];
															}
															else {
																char_id_after_char_flees = -1;	
															}
															d($"\no_con step event: pc combat assign command: 'R'un command: a valid opportunity-of-attack char was found, it is: {next_combat_char.name}, using a weapon: {next_combat_char.chosen_weapon} with a range of: {next_combat_char.chosen_weapon.max_range}; the dist between this char and the fleeing char was: {dist}.");
															break;
														}
													}
												}
						
												if valid_attacker_found break;
											} //End of iterating through the nested array.
											if valid_attacker_found break;
						
											if iterate_count == 0 {
												rank_i--;	
											}
											else {
												rank_i++;	
											}
										} //End of repeat(diff), iterating one way or the other through g.combat_rank_ar.
										iterate_count++;
									} //ENd of repeat(2), changing iteration direction each time.
				
									if valid_attacker_found {
										next_combat_game_state = game_state.combat_execute_action;
										global.cur_game_state = game_state.combat_paused;
					
										scr_add_str_to_dialogue_ar("\n");
										var capitalized_str = scr_string_capitalize(global.cur_combat_char.name);
										scr_add_str_to_dialogue_ar($"{capitalized_str} is attempting to flee through enemies that are within range, press any key to continue...");
										multi_word_str_failed = true;
									}
									//The pc gets to escape unmolested:
									else if !valid_attacker_found {
										valid_command = true;
										immediately_move_to_next_char = true;
										scr_add_str_to_dialogue_ar("\n");
										scr_add_str_to_dialogue_ar($"{global.cur_combat_char.name} successfully escapes the room unscathed; there were no enemies in range to attack them.");
										multi_word_str_failed = true;
									
										//Update bool var:
										global.cur_combat_char.has_fled_combat_bool = true;
									
										//Now update vars to reflect room change:
										//Update char x and y vars:
										global.cur_combat_char.cur_grid_x += move_dir_x;
										global.cur_combat_char.cur_grid_y += move_dir_y;
										
										//Update vars for any neutrals in this char's neutrals_following_this_char_ar, if applicable:
										if is_array(global.cur_combat_char.neutrals_following_this_char_ar) && array_length(global.cur_combat_char.neutrals_following_this_char_ar) > 0 {
											scr_update_neutrals_movement_vars(global.cur_combat_char.neutrals_following_this_char_ar,global.cur_combat_char.cur_grid_x,global.cur_combat_char.cur_grid_y);	
										}
										
										//Remove from cur room ar:
										scr_add_remove_char_room_ar(global.cur_combat_char.cur_room_id,global.cur_combat_char,false);
				
										//Update cur_room_id:
										global.cur_combat_char.cur_room_id = global.cur_grid[# global.cur_combat_char.cur_grid_x,global.cur_combat_char.cur_grid_y];
										
										//Add to next room array:
										scr_add_remove_char_room_ar(global.cur_combat_char.cur_room_id,global.cur_combat_char,true);
										
										//Re-position it's sprite vars:
										scr_update_char_sprite_position_vars(global.cur_combat_char);
										
										//Add room to tilemap, if it hasn't already been done:
										if global.cur_combat_char.cur_room_id.explored_boolean == false {
											scr_add_cell_to_tilemap(global.tile_main_lay_id,global.cur_combat_char.cur_room_id.room_enum,global.cur_combat_char.cur_grid_x,global.cur_combat_char.cur_grid_y);
										}
										//Add doors to room, if it hasn't already been done:
										if global.cur_combat_char.cur_room_id.doors_already_added_boolean == false {
											scr_add_doors_to_tilemap(global.tile_doors_lay_id,global.cur_combat_char.cur_grid_x,global.cur_combat_char.cur_grid_y);
										}
				
										//Update the room's boolean vars:
										global.cur_combat_char.cur_room_id.explored_boolean = true;
										global.cur_combat_char.cur_room_id.doors_already_added_boolean = true;
			
										//Call scr_reset_visibility(), then update visibility:
										scr_reset_visibility();
										scr_update_visibility();
									
										//Most important: reset our var that permits pcs to trigger combat again:
										global.cur_combat_char.participated_in_new_turn_battle = false;
									
										//Also reset var that forbids pcs from fleeing again the same turn:
										global.cur_combat_char.already_fled_this_turn_boolean = true;
										
										//reset this var; this char is escaping immediately, and we won't need it in the 
										//execute action game state; we won't even be going to that game state:
										global.char_is_fleeing_bool = false;
									}
								}
								else {
									scr_add_str_to_dialogue_ar("\n");
									scr_add_str_to_dialogue_ar("You must be within the distant enemy position or distant pc position in order to attempt to flee from combat, try again.",true);
									multi_word_str_failed = true;
								}
		
							#endregion
							
							}
							else {
								scr_add_str_to_dialogue_ar("\n");
								scr_add_str_to_dialogue_ar("That direction is blocked!",true);
								multi_word_str_failed = true;
							}
						
							#endregion
						}
						else {
							scr_add_str_to_dialogue_ar("\n");
							scr_add_str_to_dialogue_ar("That is an invalid direction in which to flee, try again.", true);
							multi_word_str_failed = true;
						}
					}
					else {
						scr_add_str_to_dialogue_ar("\n");
						scr_add_str_to_dialogue_ar("This character is exhausted. They have already fled once this turn and cannot escape from combat.", true);
						multi_word_str_failed = true;	
					}
				}
			}
			
			#endregion
			
			#region 'USE' an item:
			
			if valid_use_item && valid_item_index {
				//Make sure this is a useable item:
				if item_struct_id.usable_boolean == true {
					prev_game_state = global.cur_game_state;
					global.cur_combat_char.using_item_struct_id = item_struct_id;
					global.cur_combat_char.using_item_index = index_int;
					global.cur_game_state = game_state.use_target_item;
					scr_reset_wait();
					scr_print_pc_party(false, true);
				}
				else if item_struct_id.usable_boolean == false {
					multi_word_str_failed = true;
					scr_add_str_to_dialogue_ar("\n");
					scr_add_str_to_dialogue_ar("This item cannot be 'use'd in this way.", true);	
				}
			}
			
			#endregion
			
			#region Dropping items back into a room:
			
			else if valid_drop_item && valid_item_index {
				
				scr_drop_item_into_room(global.cur_combat_char,item_struct_id,index_int,global.cur_combat_char.cur_room_id);	
			}
			
			#endregion
			
			#region EXAMINING at an item:
			
			else if valid_look_item && valid_item_index {
				
				scr_add_str_to_dialogue_ar("\n");
				scr_add_str_to_dialogue_ar($"{item_struct_id.item_desc}");
				scr_add_str_to_dialogue_ar("\n");
				//Current character reminder:
				scr_print_char_reminder(global.acting_char_struct_id)
			}
			
			#endregion
			
			#region Passing an item to another character in the same room:
			
			else if valid_give_item && valid_item_index {
				
				//First, make sure there's another actual character in the room to give the item to:
				if array_length(global.cur_combat_char.cur_room_id.pcs_in_room_ar) > 1 {
					
					prev_game_state = global.cur_game_state;
					
					global.cur_game_state = game_state.passing_item;
					
					global.cur_combat_char.passing_item_struct_id = item_struct_id;
					global.cur_combat_char.passing_item_index = index_int;
				
					scr_print_pc_party(true,false);
				
					global.passing_item_boolean = true;
				}
				else {
					multi_word_str_failed = true;
					scr_add_str_to_dialogue_ar("\nThere are no other playable characters in this room to give the item to.");	
				}
			}
			
			#endregion
			
			#region Equip or unequip an item in your inventory:
			
			else if valid_equip_or_unequip && valid_item_index {
				
				//Determine if we're equipping, unequipping, or swapping items (unequipping, then equipping):
					//Unequipping:
				if index_int < equip_slot.total_slots {
					
					scr_equip_or_unequip_item(global.cur_combat_char,item_struct_id,index_int,false,false);
					scr_print_combat_ranks(global.cur_combat_char);
				}
				
				//Equipping:
				else if index_int >= equip_slot.total_slots {
					
					var valid_equip = scr_check_valid_equip(global.cur_combat_char,item_struct_id);
					
					if valid_equip {
						scr_equip_or_unequip_item(global.cur_combat_char,item_struct_id,index_int,true,false);	
						scr_print_combat_ranks(global.cur_combat_char);
					}
					else {
						multi_word_str_failed = true;
						scr_add_str_to_dialogue_ar($"\nYou can't equip the {item_struct_id.item_name}, make sure the corresponding equipment slot is free first.",true);
					}
				}
			}
			
			else if !valid_item_index && !valid_flee_command {
				multi_word_str_failed = true;
				scr_add_str_to_dialogue_ar("\nThat is an invalid combat command, try again.",true);	
			}
			
			#endregion
			
		}
		
		#endregion
		
		else if multi_word_str_failed == false {
			scr_add_str_to_dialogue_ar("\nThat is an invalid combat command, try again.", true);
		}
		
		//Reset our player_input_str:
		player_input_str = "";
		
		#region Logic for commands that immediately move us to next character:
		
		//This currently triggers whenever we use 'E' (evade) and 'R'un (if they are able to immediately run without triggering an attack of opportuntiy):
		if valid_command && immediately_move_to_next_char {

			//Advances cur_char, game state, checks combat end conditions:
			scr_evaluate_combat_conclusion("o_con step event: game_state == combat_pc_assign_commmand: valid_command && immediately move to next char both == true.");
		}
		
		#endregion
		
	}
	
	#region Accept input for player_input_str:

	// Detect new character input
	if (keyboard_lastchar != "") {
	    if keyboard_lastkey != vk_up && keyboard_lastkey != vk_down && keyboard_lastkey != vk_right && keyboard_lastkey != vk_left &&
		keyboard_lastkey != vk_backspace {
			player_input_str += keyboard_lastchar;
			keyboard_lastchar = "";
		}
	}

	// Handle backspace
	if (keyboard_check_pressed(vk_backspace) && string_length(player_input_str) > 0) {
	    player_input_str = string_copy(player_input_str, 1, string_length(player_input_str) - 1);
	}

	#endregion
	
}

#endregion

#region Combat Execute action game state:

else if global.cur_game_state == game_state.combat_execute_action {
	
	var attacker_id = global.cur_combat_char;
	var defender_killed = false;
	
	//Reset ai vars:
	if attacker_id.char_team_enum != team_type.pc {
		attacker_id.enemy_ai_fight_boolean = false;
		attacker_id.enemy_ai_move_boolean = false;
		attacker_id.combat_move_dir = 0;
	}
	
	d($"\n...o_con step event: game_state == combat_execute_action: {attacker_id.name} is entering game_state execute action now, and G.CUR_COMBAT_CHAR_INDEX == {global.cur_combat_char_index}...");
	
	if global.char_is_fleeing_bool d($"\n o_con step event: game_state == combat_execute_action: g.char_is_fleeing_bool == true: {attacker_id.name} is an opportunity attacker, responding to the character: {global.fleeing_combat_char_id.name}, who is fleeing. Their chosen wep is: {attacker_id.chosen_weapon.item_name}");
	
	#region Evaluate enemy ai:
	
	if global.char_is_fleeing_bool == false && global.overwatch_mode_enabled == false && 
	(attacker_id.char_team_enum == team_type.enemy || attacker_id.char_team_enum == team_type.neutral) {
		
		//d($"ENTERING ENEMY AI NOW!!");
		
		var ai_type_enum = attacker_id.combat_ai_preference;
		
		#region AI type: melee only:
		
		if ai_type_enum == enemy_combat_ai.melee {
			
			//Those that use this ai act like berserkers - they simply move toward the nearest valid targets and engage in melee.
			
			//d($"ENTERING ENEMY AI MELEE NOW!!");
			//All of this enemy's attacks are melee, choose one at random:
			var chosen_wep_enum = attacker_id.ability_ar[irandom_range(0,array_length(attacker_id.ability_ar)-1)];
			var chosen_wep_item_struct_id = global.item_reference_table[chosen_wep_enum];
			attacker_id.chosen_weapon = chosen_wep_item_struct_id;
			
			//d($"combat_execute_action: evaluating enemy ai: melee: attacker_id.chosen_weapon == {attacker_id.chosen_weapon.item_name}");
			//d($"combat_execute_action: evaluating enemy ai: melee: attacker_id.chosen_weapon == {attacker_id.chosen_weapon.aoe_count}");
			
			attacker_id.targeted_rank = scr_return_nearest_target_rank_pos(attacker_id.cur_combat_rank);
		
			d($"\ncombat_execute_action: evaluating enemy ai: melee: Just finished calling scr_enemy_return_nearest_target_rank_pos: attacker_id.targeted_rank == {attacker_id.targeted_rank}, its chosen_weapon.name == {attacker_id.chosen_weapon.item_name}, and it's aoe_count == {attacker_id.chosen_weapon.aoe_count}")
		
			if attacker_id.targeted_rank != -1 {
				//Move to melee attack:
				if attacker_id.targeted_rank == attacker_id.cur_combat_rank {
					attacker_id.enemy_ai_fight_boolean = true;
				}
				//We need to move:
				else {
					if attacker_id.suppressed_count <= 0 {
						attacker_id.enemy_ai_move_boolean = true;
						//Determine whether the target is north or south of us:
							//Nearest target is north of us:
						
						if attacker_id.cur_combat_rank > attacker_id.targeted_rank {
							//So move north:
							attacker_id.combat_move_dir = -1;
						}
							//Nearest target us south of us:
						else {
							//So move south:
							attacker_id.combat_move_dir = 1;
						}
					}
					//This melee character is suppressed - there's nothing else they can do.
					else {
						var capitalized = scr_string_capitalize(attacker_id.name);
						var plural_str = "";
						if attacker_id.suppressed_count > 1 plural_str = "s";
						scr_add_str_to_dialogue_ar($"\n{capitalized} wants to move closer to their target but they can't - they're suppressed for {attacker_id.suppressed_count} more turn{plural_str}!");
					}
				}
			}
			else {
				d($"\no_con step event: combat_execute_action: evaluating enemy melee_only ai: attacker_id.targeted_rank == {attacker_id.targeted_rank}, which indicates that there was no valid targets for the {attacker_id.name}({attacker_id.unique_id}). This can happen if all neutrals and pcs are dead, fled, or unconscious. We'll just show a message and move on.");
				scr_add_str_to_dialogue_ar($"\n{attacker_id.name}({attacker_id.unique_id}) can only take stock of the devastated battlefield and wait. (All valid targets are dead, fled, or unconscious.)");
			}
		}
		
		#endregion
		
		#region AI type: ranged coward:
		
		else if ai_type_enum == enemy_combat_ai.ranged_coward {
			
			//Always retreats (either north or south) if nearest != their max_range, UNLESS their is overwatch in the rank they want to retreat to;
			//naturally, due to the nature of this particularly combat system, they will generally retreat north.
			
			//Create a temporary array of all of this enemy's available weapons from its abil_ar:
			var temp_abil_ar = [], item_enum;
			for(var i = 0; i < array_length(attacker_id.ability_ar); i++) {
				item_enum = attacker_id.ability_ar[i];
				array_push(temp_abil_ar, global.item_reference_table[item_enum]);
			}
			
			//Need to shuffle the array first so that those positions with == values will be randomized:
			var sorted_by_range_abil_ar = scr_shuffle_ar(temp_abil_ar);
			
			//Actually reverse sort:
			sorted_by_range_abil_ar = scr_reverse_sort_ar_by_struct_var(sorted_by_range_abil_ar,"max_range");
			
			if sorted_by_range_abil_ar != -1 {
				
				var highest_range_item_id = sorted_by_range_abil_ar[0];
				attacker_id.chosen_weapon = highest_range_item_id;
				var wep_range = highest_range_item_id.max_range;
			
				//Assign the rank
				var nearest_valid_rank_int = scr_return_nearest_target_rank_pos(attacker_id.cur_combat_rank);
			
				if nearest_valid_rank_int != -1 {
			
					//Determine the dist to to the nearest_valid_target, store as dist_to_nearest_valid_target:
					var dist_to_nearest_valid_target = abs(attacker_id.cur_combat_rank - nearest_valid_rank_int);
			
					//Attack - this is our ideal range:
					if dist_to_nearest_valid_target == wep_range {
				
						attacker_id.targeted_rank = nearest_valid_rank_int;
						attacker_id.enemy_ai_fight_boolean = true;
					}
			
					//Backup if we're not suppressed, there's room to do so, and we won't walk into over watch fire; otherwise, attack
					else if dist_to_nearest_valid_target < wep_range {
				
						//Move 'north':
						if attacker_id.cur_combat_rank-1 >= 0 && attacker_id.suppressed_count <= 0 && scr_check_overwatch_in_target_rank(attacker_id, attacker_id.cur_combat_rank-1) == -1 {
							attacker_id.combat_move_dir = -1;
							attacker_id.enemy_ai_move_boolean = true;
						}
						//We're unable to move because of any of those conditions, just attack:
						else {
							//Choose an 'inferior' melee weapon if the player has cornered us into melee; this 'rewards' the player by being aggressive, in much
							//the same way that enemies use weaker melee attacks in Darkest Dungeon when forced into the front ranks; this generally can only 
							//happen if the enemy was suppressed, cornered by overwatch fire, or backed into the final rank:
							if dist_to_nearest_valid_target == 0 {
								attacker_id.chosen_weapon = global.item_reference_table[item_type.desperate_claw];
							}
							attacker_id.targeted_rank = nearest_valid_rank_int;
							attacker_id.enemy_ai_fight_boolean = true;
						}
					}
			
					else if dist_to_nearest_valid_target > wep_range {
				
						if attacker_id.suppressed_count <= 0 {
							//Determine the direction of our target - we don't need to worry about out-of-bounds 
							//here because we are using our target's array position as our reference:
							attacker_id.enemy_ai_move_boolean = true;
							//Determine whether the target is north or south of us:
					
							/*
							The ONLY case in which the enemy would need to move 'up' again (which is normally their 'retreat' direction) is if they were movement locked by suppression or because a pc had overwatched the rank behind them, and another pc slipped behind them to one of the deep enemy ranks.

							We also don't care if the rank they are moving into is over watched at this point because it's still better than causing a frozen game state where the enemies refuse to move and the player refuses to stop overwatching.
							*/
					
								//Nearest target is north of us:
							if attacker_id.cur_combat_rank > nearest_valid_rank_int {
								//So move north:
								attacker_id.combat_move_dir = -1;
							}
								//Nearest target us south of us:
							else {
								//So move south:
								attacker_id.combat_move_dir = 1;
							}
						}
						else {
							var capitalized = scr_string_capitalize(attacker_id.name);
							var plural_str = "";
							if attacker_id.suppressed_count > 1 plural_str = "s";
							scr_add_str_to_dialogue_ar($"\n{capitalized} wants to move closer to their target but they can't - they're suppressed for {attacker_id.suppressed_count} more turn{plural_str}!");	
						}
					}
				}
				else {
					d($"\no_con step event: combat_execute_action: evaluating ranged coward enemy ai: nearest_valid_rank_int == {nearest_valid_rank_int}, which indicates that there was no valid targets for the {attacker_id.name}({attacker_id.unique_id}). This can happen if all neutrals and pcs are dead, fled, or unconscious. We'll just show a message and move on.");
					scr_add_str_to_dialogue_ar($"\n{attacker_id.name}({attacker_id.unique_id}) can only take stock of the devastated battlefield and wait. (All valid targets are dead, fled, or unconscious.)");	
				}
			}
			else {
				throw($"o_con step event: combat_execute_action game state: evaluating ranged_stationary enemy ai: sorted_by_range_abil_ar == {sorted_by_range_abil_ar}, something went wrong.");	
			}
		}
		
		#endregion
		
		#region AI type: ranged stationary:
		
		else if ai_type_enum == enemy_combat_ai.ranged_stationary {
			
			//This ai type never retreats; otherwise is identical to ranged_coward.
			
			//Create a temporary array of all of this enemy's available weapons from its abil_ar:
			var temp_abil_ar = [], item_enum;
			for(var i = 0; i < array_length(attacker_id.ability_ar); i++) {
				item_enum = attacker_id.ability_ar[i];
				array_push(temp_abil_ar, global.item_reference_table[item_enum]);
			}
			
			//Need to shuffle the array first so that those positions with == values will be randomized:
			var sorted_by_range_abil_ar = scr_shuffle_ar(temp_abil_ar);
			
			//Actually reverse sort:
			sorted_by_range_abil_ar = scr_reverse_sort_ar_by_struct_var(sorted_by_range_abil_ar,"max_range");
			
			if sorted_by_range_abil_ar != -1 {
				
				var highest_range_item_id = sorted_by_range_abil_ar[0];
				attacker_id.chosen_weapon = highest_range_item_id;
				var wep_range = highest_range_item_id.max_range;
				
				//Assign nearest valid rank int:
				var nearest_valid_rank_int = scr_return_nearest_target_rank_pos(attacker_id.cur_combat_rank);
			
				if nearest_valid_rank_int != -1 {
					
					//Determine the dist to to the nearest_valid_target, store as dist_to_nearest_valid_target:
					var dist_to_nearest_valid_target = abs(attacker_id.cur_combat_rank - nearest_valid_rank_int);
				
					if dist_to_nearest_valid_target <= wep_range {
					
						//Attack:
						attacker_id.targeted_rank = nearest_valid_rank_int;
						attacker_id.enemy_ai_fight_boolean = true;
					
						//Switch to 'superior' melee wep if we're in melee range of our nearest target; this type of enemy does not mind engaging in melee:
						if dist_to_nearest_valid_target == 0 {
							var melee_wep_item_id = global.item_reference_table[item_type.monstrous_claw];	
							attacker_id.chosen_weapon = melee_wep_item_id;
						}
					}
					
					//Move closer:
					else if dist_to_nearest_valid_target > wep_range {
						
						if attacker_id.suppressed_count <= 0 {
							//Determine the direction of our target - we don't need to worry about out-of-bounds 
							//here because we are using our target's array position as our reference:
							attacker_id.enemy_ai_move_boolean = true;
							//Determine whether the target is north or south of us:
					
							/*
							The ONLY case in which the enemy would need to move 'up' again (which is normally their 'retreat' direction) is if they were movement locked by suppression or because a pc had overwatched the rank behind them, and another pc slipped behind them to one of the deep enemy ranks.

							We also don't care if the rank they are moving into is over watched at this point because it's still better than causing a frozen game state where the enemies refuse to move and the player refuses to stop overwatching.
							*/
					
								//Nearest target is north of us:
							if attacker_id.cur_combat_rank > nearest_valid_rank_int {
								//So move north:
								attacker_id.combat_move_dir = -1;
							}
								//Nearest target us south of us:
							else {
								//So move south:
								attacker_id.combat_move_dir = 1;
							}
						}
						else {
							var capitalized = scr_string_capitalize(attacker_id.name);
							var plural_str = "";
							if attacker_id.suppressed_count > 1 plural_str = "s";
							scr_add_str_to_dialogue_ar($"\n{capitalized} wants to move closer to their target but they can't - they're suppressed for {attacker_id.suppressed_count} more turn{plural_str}!");	
						}
					}
				}
				else {
					d($"\no_con step event: combat_execute_action: evaluating ranged stationary enemy ai: nearest_valid_rank_int == {nearest_valid_rank_int}, which indicates that there was no valid targets for the {attacker_id.name}({attacker_id.unique_id}). This can happen if all neutrals and pcs are dead, fled, or unconscious. We'll just show a message and move on.");
					scr_add_str_to_dialogue_ar($"\n{attacker_id.name}({attacker_id.unique_id}) can only take stock of the devastated battlefield and wait. (All valid targets are dead, fled, or unconscious.)");	
				}
				
			}
			else {
				throw($"o_con step event: combat_execute_action game state: evaluating ranged_stationary enemy ai: sorted_by_range_abil_ar == {sorted_by_range_abil_ar}, something went wrong.");	
			}
			
		}
		
		#endregion
		
		#region AI type: stationary overwatch:
		
		else if ai_type_enum == enemy_combat_ai.stationary_overwatch {
			
			//This ai type never retreats, fires upon enemies within its range, and sets overwatch on its max range when targets are outside of it;
			//Should have a weapon with at least a range of 1.
			
			//Create a temporary array of all of this enemy's available weapons from its abil_ar:
			var temp_abil_ar = [], item_enum;
			for(var i = 0; i < array_length(attacker_id.ability_ar); i++) {
				item_enum = attacker_id.ability_ar[i];
				array_push(temp_abil_ar, global.item_reference_table[item_enum]);
			}
			
			//Need to shuffle the array first so that those positions with == values will be randomized:
			var sorted_by_range_abil_ar = scr_shuffle_ar(temp_abil_ar);
			
			//Actually reverse sort:
			sorted_by_range_abil_ar = scr_reverse_sort_ar_by_struct_var(sorted_by_range_abil_ar,"max_range");
			
			if sorted_by_range_abil_ar != -1 {
				var highest_range_item_id = sorted_by_range_abil_ar[0];
				attacker_id.chosen_weapon = highest_range_item_id;
				var wep_range = highest_range_item_id.max_range;
				
				//Assign nearest valid rank int:
				var nearest_valid_rank_int = scr_return_nearest_target_rank_pos(attacker_id.cur_combat_rank);
			
				if nearest_valid_rank_int != -1 {
					
					//Determine the dist to to the nearest_valid_target, store as dist_to_nearest_valid_target:
					var dist_to_nearest_valid_target = abs(attacker_id.cur_combat_rank - nearest_valid_rank_int);
					
					//Attack:
					if dist_to_nearest_valid_target <= wep_range {
						//Attack:
						attacker_id.targeted_rank = nearest_valid_rank_int;
						attacker_id.enemy_ai_fight_boolean = true;
					}
					//Set overwatch:
					else if dist_to_nearest_valid_target > wep_range {
						
						//We need to determine what rank our maximum weapon range falls upon:
							//Target is 'south' of us:
						var maximum_targeted_rank;
						if nearest_valid_rank_int > attacker_id.cur_combat_rank { maximum_targeted_rank = attacker_id.cur_combat_rank + wep_range; }
							//Target is 'north' of us
						else if nearest_valid_rank_int < attacker_id.cur_combat_rank { maximum_targeted_rank = attacker_id.cur_combat_rank - wep_range; }
						//else if nearest_valid_rank_int == attacker_id.cur_combat_rank, then dist_to_nearest_valid_target would not be greater than wep_range, which has a minimum wep_range of 0, so this will never trigger.
						
						//Cap - technically not necessary, but just in case:
						if maximum_targeted_rank < 0 maximum_targeted_rank = 0;
						if maximum_targeted_rank >= array_length(global.combat_rank_ar) maximum_targeted_rank = array_length(global.combat_rank_ar)-1; 
						
						//Assign as targeted rank - we'll need this var to remove this char id from the global array later in scr_reset_certain_char_combat_vars:
						attacker_id.targeted_rank = maximum_targeted_rank;
					
						//Add to corresponding nested struct array in overwatch array:
						scr_apply_overwatch(attacker_id);
					
						//No other actionable vars have been set for this char, the should just skip the rest of this game state's code.
					}
				}
				else {
					d($"\no_con step event: combat_execute_action: evaluating stationary overwatch ai: nearest_valid_rank_int == {nearest_valid_rank_int}, which indicates that there was no valid targets for the {attacker_id.name}({attacker_id.unique_id}). This can happen if all neutrals and pcs are dead, fled, or unconscious. We'll just show a message and move on.");
					scr_add_str_to_dialogue_ar($"\n{attacker_id.name}({attacker_id.unique_id}) can only take stock of the devastated battlefield and wait. (All valid targets are dead, fled, or unconscious.)");	
				}
			}
			else {
				throw($"o_con step event: combat_execute_action game state: evaluating ranged_stationary enemy ai: sorted_by_range_abil_ar == {sorted_by_range_abil_ar}, something went wrong.");	
			}
		}
		
		#endregion
		
		#region AI type: overwatch (coward):
		
		else if ai_type_enum == enemy_combat_ai.overwatch_coward {
			
			//Create a temporary array of all of this enemy's available weapons from its abil_ar:
			var temp_abil_ar = [], item_enum;
			for(var i = 0; i < array_length(attacker_id.ability_ar); i++) {
				item_enum = attacker_id.ability_ar[i];
				array_push(temp_abil_ar, global.item_reference_table[item_enum]);
			}
			
			//Need to shuffle the array first so that those positions with == values will be randomized:
			var sorted_by_range_abil_ar = scr_shuffle_ar(temp_abil_ar);
			
			//Actually reverse sort:
			sorted_by_range_abil_ar = scr_reverse_sort_ar_by_struct_var(sorted_by_range_abil_ar,"max_range");
			
			if sorted_by_range_abil_ar != -1 {
				var highest_range_item_id = sorted_by_range_abil_ar[0];
				attacker_id.chosen_weapon = highest_range_item_id;
				var wep_range = highest_range_item_id.max_range;
				
				//Assign nearest valid rank int:
				var nearest_valid_rank_int = scr_return_nearest_target_rank_pos(attacker_id.cur_combat_rank);
			
				if nearest_valid_rank_int != -1 {
					
					var longest_range_in_opposite_team = scr_return_min_max_opposite_team_range(attacker_id, true);
					
					d($"o_con step event: game_state == combat_execute_action: evaluating enemy ai for overwatch coward: scr_return_min_max_opposite_team_range returned: {longest_range_in_opposite_team}");
					
					var we_have_ranged_advantage = true;
					
					if longest_range_in_opposite_team > wep_range we_have_ranged_advantage = false;
					
					//Determine the dist to to the nearest_valid_target, store as dist_to_nearest_valid_target:
					var dist_to_nearest_valid_target = abs(attacker_id.cur_combat_rank - nearest_valid_rank_int);
					
					#region Set overwatch - they will be forced to come to us through our overwatch fire:
					
					if we_have_ranged_advantage && dist_to_nearest_valid_target > wep_range {
						//We need to determine what rank our maximum weapon range falls upon:
							//Target is 'south' of us:
						var maximum_targeted_rank;
						if nearest_valid_rank_int > attacker_id.cur_combat_rank { maximum_targeted_rank = attacker_id.cur_combat_rank + wep_range; }
							//Target is 'north' of us
						else if nearest_valid_rank_int < attacker_id.cur_combat_rank { maximum_targeted_rank = attacker_id.cur_combat_rank - wep_range; }
						//else if nearest_valid_rank_int == attacker_id.cur_combat_rank, then dist_to_nearest_valid_target would not be greater than wep_range, which has a minimum wep_range of 0, so this will never trigger.
						
						//Cap - technically not necessary, but just in case:
						if maximum_targeted_rank < 0 maximum_targeted_rank = 0;
						if maximum_targeted_rank >= array_length(global.combat_rank_ar) maximum_targeted_rank = array_length(global.combat_rank_ar)-1; 
						
						//Assign as targeted rank - we'll need this var to remove this char id from the global array later in scr_reset_certain_char_combat_vars
						//(which itself calls scr_remove_char_from_overwatch_arrays):
						attacker_id.targeted_rank = maximum_targeted_rank;
					
						//Add to corresponding nested struct array in overwatch array:
						scr_apply_overwatch(attacker_id);
						
						//No other actionable vars have been set for this char, the should just skip the rest of this game state's code.
					}
					
					#endregion
					
					#region Advance, if able; otherwise, set overwatch:
					
					else if we_have_ranged_advantage == false && dist_to_nearest_valid_target > wep_range {
						
						//Set over watch anyway, it's better than doing nothing while suppressed:
						if attacker_id.suppressed_count > 0 {
							//We need to determine what rank our maximum weapon range falls upon:
							//Target is 'south' of us:
							var maximum_targeted_rank;
							if nearest_valid_rank_int > attacker_id.cur_combat_rank { maximum_targeted_rank = attacker_id.cur_combat_rank + wep_range; }
								//Target is 'north' of us
							else if nearest_valid_rank_int < attacker_id.cur_combat_rank { maximum_targeted_rank = attacker_id.cur_combat_rank - wep_range; }
							//else if nearest_valid_rank_int == attacker_id.cur_combat_rank, then dist_to_nearest_valid_target would not be greater than wep_range, which has a minimum wep_range of 0, so this will never trigger.
						
							//Cap - technically not necessary, but just in case:
							if maximum_targeted_rank < 0 maximum_targeted_rank = 0;
							if maximum_targeted_rank >= array_length(global.combat_rank_ar) maximum_targeted_rank = array_length(global.combat_rank_ar)-1; 
						
							//Assign as targeted rank - we'll need this var to remove this char id from the global array later in scr_reset_certain_char_combat_vars
							//(which itself calls scr_remove_char_from_overwatch_arrays):
							attacker_id.targeted_rank = maximum_targeted_rank;
					
							//Add to corresponding nested struct array in overwatch array:
							scr_apply_overwatch(attacker_id);
							
							//No other actionable vars have been set for this char, the should just skip the rest of this game state's code.
						}
						
						//Adavance, we don't have the ranged advantage, so setting over watch would be potentially useless; we also don't care if we're moving
						//through overwatch fire - it's still better than potentially causing a frozen game state:
						else {
							//Set boolean var:
							attacker_id.enemy_ai_move_boolean = true;
							//Determine whether the target is north or south of us:
								//Nearest target is north of us:
							if attacker_id.cur_combat_rank > nearest_valid_rank_int {
								//So move north:
								attacker_id.combat_move_dir = -1;
							}
								//Nearest target us south of us:
							else {
								//So move south:
								attacker_id.combat_move_dir = 1;
							}
						}
					}
					
					#endregion
					
					#region Withdraw, if able, to potentially setup overwatch fire the next turn; if unable to withdraw, simply attack:
					
					else if we_have_ranged_advantage && dist_to_nearest_valid_target <= wep_range {
						
						//Determine withdraw direction - the OPPOSITE DIRECTION of wherever our opponent is located;
						//determine whether the target is north or south of us:
						var move_south;
							//Nearest target is north of us - so move south to WITHDRAW and get away from them:
						if attacker_id.cur_combat_rank > nearest_valid_rank_int {
							
							move_south = true;
						}
							//Nearest target us south of us - so move north to WITHDRAW and get away from them::
						else if attacker_id.cur_combat_rank <= nearest_valid_rank_int{
							
							move_south = false;
						}
						
						var array_bounds_allow = false;
						
						if move_south && attacker_id.cur_combat_rank + 1 < array_length(global.combat_rank_ar) array_bounds_allow = true;
						
						else if !move_south && attacker_id.cur_combat_rank - 1 >= 0 array_bounds_allow = true;
						
						//Withdraw, if able:
						if array_bounds_allow && attacker_id.suppressed_count <= 0 && scr_check_overwatch_in_target_rank(attacker_id, attacker_id.cur_combat_rank-1) == -1 {
							//Withdraw:
								//Set boolean var:
							attacker_id.enemy_ai_move_boolean = true;
							if move_south attacker_id.combat_move_dir = 1;
							else attacker_id.combat_move_dir = -1;
						}
						//Just attack - they're in range, anyway:
						else {
							attacker_id.targeted_rank = nearest_valid_rank_int;
							attacker_id.enemy_ai_fight_boolean = true;
						}
					}
					
					#endregion
					
					#region Just fire on the enemy - they have the ranged advantage and they're within our weapon's range:
					
					//We might as well fire on our opponent, withdrawing potentially wouldn't do us any good, as the enemy ultimately 
					//has the ranged advantage over us anyway, and they could just back us up into the most distant position, or fire on us as we're withdrawing:
					else if !we_have_ranged_advantage && dist_to_nearest_valid_target <= wep_range {
						attacker_id.targeted_rank = nearest_valid_rank_int;
						attacker_id.enemy_ai_fight_boolean = true;	
					}
					
					#endregion
					
				}
				else {
					d($"\no_con step event: combat_execute_action: evaluating overwatch coward ai: nearest_valid_rank_int == {nearest_valid_rank_int}, which indicates that there was no valid targets for the {attacker_id.name}({attacker_id.unique_id}). This can happen if all neutrals and pcs are dead, fled, or unconscious. We'll just show a message and move on.");
					scr_add_str_to_dialogue_ar($"\n{attacker_id.name}({attacker_id.unique_id}) can only take stock of the devastated battlefield and wait. (All valid targets are dead, fled, or unconscious.)");	
				}
				
			}
			else {
				throw($"o_con step event: combat_execute_action game state: evaluating ranged_coward ai: sorted_by_range_abil_ar == {sorted_by_range_abil_ar}, something went wrong.");	
			}
		}
		
		#endregion
		
		d($"\n o_con step event: game_state == combat_execute_action: After evaluating its ai, enemy_ai_move_boolean == {attacker_id.enemy_ai_move_boolean}, and enemy_ai_fight_boolean == {attacker_id.enemy_ai_fight_boolean}.");
	}
	
	#endregion
	
	#region Moving (for both enemies and pcs):
	
	//All char types will pass through here when moving:
	if global.char_is_fleeing_bool == false && global.overwatch_mode_enabled == false &&
	(attacker_id.enemy_ai_move_boolean == true || attacker_id.pc_is_combat_moving == true) {
		d($"\n o_con step event: game_state == combat_execute_action: {attacker_id.name} has chosen to move.");
		var move_str = "MOVING BITCHES";
		
		//Define move_str - 'advancing' or 'withdrawing' is subjective and depends upon whether this is an enemy or not;
		//enemies 'advance' while moving down, and pcs and neutrals 'advance' while moving up; and etc.
		if attacker_id.char_team_enum == team_type.enemy {
			if attacker_id.combat_move_dir == -1 move_str = "withdraws";
			else if attacker_id.combat_move_dir == 1 move_str = "advances";
		}
		else {
			if attacker_id.combat_move_dir == -1 move_str = "advances";
			else if attacker_id.combat_move_dir == 1 move_str = "withdraws";
		}
		
		//Remove from current nested array:
		var cur_ar = global.combat_rank_ar[attacker_id.cur_combat_rank];
		var char_index = array_get_index(cur_ar,attacker_id);
		array_delete(cur_ar,char_index,1);
			
		//Add to next position's nested array:
			//Update var:
		attacker_id.cur_combat_rank = attacker_id.cur_combat_rank + attacker_id.combat_move_dir;
			//Add to new array:
		array_push(global.combat_rank_ar[attacker_id.cur_combat_rank],attacker_id);
		
		var attacker_capitalized_str = scr_string_capitalize(attacker_id.name);
		scr_add_str_to_dialogue_ar($"\n{attacker_capitalized_str}({attacker_id.unique_id}) {move_str}.");
		
		//Now check and see if they have triggered overwatch fire:
		var overwatch_ar_to_check = scr_check_overwatch_in_target_rank(attacker_id, attacker_id.cur_combat_rank);
		
		if overwatch_ar_to_check != -1 {
		
			global.overwatch_mode_enabled = true;
			global.target_id_of_overwatch_fire = attacker_id;
			global.overwatch_attacker_index = 0;
			overwatch_attackers_ar = overwatch_ar_to_check;
			
			scr_add_str_to_dialogue_ar($"\n{attacker_capitalized_str} has triggered overwatch fire!");
		}
	}
	
	#endregion
	
	#region Executing action (attacking):
	
	//If this is a pc or an enemy that has been designated to attack, move to attack calculations:
	else if global.char_is_fleeing_bool == true || attacker_id.char_team_enum == team_type.pc || attacker_id.enemy_ai_fight_boolean == true || 
	global.overwatch_mode_enabled == true {
		d($"\n o_con step event: game_state == combat_execute_action: {attacker_id.name} has chosen to fight. Its chosen_weapon.name == {attacker_id.chosen_weapon.item_name}, and it's aoe_count == {attacker_id.chosen_weapon.aoe_count}");
		
		var num_attacks = 1;
		var attack_index = 0;
		
		//Create filtered list:
		var filtered_ar = [];
		filtered_ar = scr_return_ar_of_opposite_team(attacker_id, global.combat_rank_ar[attacker_id.targeted_rank]);
		
		//If applicable, assign num_attacks:
		if attacker_id.will_overwatch_boolean == false && global.char_is_fleeing_bool == false {
			
			//Hits entire rank:
			if attacker_id.chosen_weapon.aoe_count == -1 { num_attacks = array_length(filtered_ar); }
			
			//Hits either the aoe_count, or the array length of possible targets, whichever is smaller
			else {
				num_attacks = min(array_length(filtered_ar), attacker_id.chosen_weapon.aoe_count);	
			}
		}
		
		//Manually assign num attacks to == 1 if we're in opportunity attack mode or overwatch boolean mode:
		if global.char_is_fleeing_bool || global.overwatch_mode_enabled {
			num_attacks = 1;	
		}
		
		//Whatever the outcome of the attack (even if they're out of ammo) we need to increment our overwatch attacker index:
		if global.overwatch_mode_enabled global.overwatch_attacker_index++;
		
		//Reduce AP (if applicable) only once:
		if attacker_id.chosen_weapon.ability_point_cost > 0 { attacker_id.ability_points_cur -= attacker_id.chosen_weapon.ability_point_cost; }
		
		repeat(num_attacks) {
			d("\n o_con step event: game_state == combat_execute_action: Entering num_attacks repeat loop now...");
			//Make sure we have ammunition:
			if global.resources_ammo > 0 || attacker_id.char_team_enum != team_type.pc || 
			attacker_id.chosen_weapon.requires_ammo_boolean == false {
				d("\n o_con step event: game_state == combat_execute_action: There was either sufficient ammo (> 0) or the attacker did not a pc, calculating attack now...");
					
				//Define defender_id:
					//This is an aoe attack - we'll iterate through defenders sequentially (always starting at 0)
				if num_attacks == -1 || num_attacks > 1 {
					var defender_id = filtered_ar[attack_index];
				}
					//This is a single target attack - choose target randomly:
				else if num_attacks == 1 {
					var defender_id = filtered_ar[irandom_range(0,array_length(filtered_ar)-1)]; 
				}
				
				//Increment attack index:
				attack_index++;
					
				//Manually assign defender_id instead if this is an opportunity attacker:
				if global.char_is_fleeing_bool == true {
					defender_id = global.fleeing_combat_char_id;
					d($"\n o_con step event: game_state == combat_execute_action: global.char_is_fleeing_bool == true, therefore we have manually assigned the defender id as the global.fleeing_combat_char_id; defender_id.name now == {defender_id.name}");
				}
				
				//Manually assign defender_id instead if we're in overwatch:
				if global.overwatch_mode_enabled {
					defender_id = global.target_id_of_overwatch_fire;
				}
				
				var attack_result_str = "";
				
				//Define stats, perform combat calculations:
				var attacker_acc = attacker_id.accuracy;
				var defender_evasion = defender_id.evasion;
				
				//Apply 'giant' melee bonuses:
				if attacker_id.chosen_weapon.melee_only == true && scr_return_passive_enum_in_ar(attacker_id.passive_abil_ar, passive_abil_type.giant) == true {
					attacker_acc += CRAGOS_ACC_DEBUFF;
				}
				
				//Define total_attack_val; modify it if the defender has negative evasion
				var alternate_to_hit_str = "";
				if defender_evasion < 0 {
					alternate_to_hit_str = " Their accuracy was boosted by the defender's negative evasion value instead!";
					var total_attack_val = attacker_acc + abs(defender_evasion);
				}
				else var total_attack_val = attacker_acc - defender_evasion;
					
				var ran_to_hit_val = irandom_range(MIN_COMBAT_RAN_NUM,MAX_COMBAT_RAN_NUM); //0-9
					
				attack_result_str += $"{attacker_id.name}({attacker_id.unique_id}) {attacker_id.chosen_weapon.item_verb} {attacker_id.chosen_weapon.item_name}.  Chance to hit: {attacker_acc} (accuracy) modified by {defender_evasion} (defender's evasion) = {total_attack_val}.{alternate_to_hit_str} Rolled: {ran_to_hit_val}.";
					
				//Reduce ammo:
				global.resources_ammo--;
					
				//Hit:
				if total_attack_val >= ran_to_hit_val {
						
					var dmg_roll = irandom_range(attacker_id.chosen_weapon.dmg_min,attacker_id.chosen_weapon.dmg_max);
					
					//Apply 'giant' melee bonuses:
					if attacker_id.chosen_weapon.melee_only == true && scr_return_passive_enum_in_ar(attacker_id.passive_abil_ar, passive_abil_type.giant) == true {
						dmg_roll += GIANT_MELEE_DMG_BUFF;
					}
					
					var total_dmg = dmg_roll - defender_id.armor;
					
					//Cap:
					if total_dmg < 0 total_dmg = 0;
						
					//Reduce target hp:
					defender_id.hp_cur -= total_dmg;
						
					var negated_str = "";
					//Edit: not actually using this negated string for now - it feels redundant - the player can figure it out easily enough just by reading;
					//the combat text is already bloated enough.
					if total_dmg <= 0 && dmg_roll > 0 {
						//negated_str = $" The armor of {defender_id.name} has completed negated the damage.";
					}
					var capitalized_str = scr_string_capitalize(defender_id.name);
					attack_result_str += $"\n**{capitalized_str}({defender_id.unique_id}) has been {attacker_id.chosen_weapon.item_dmg_str} for {dmg_roll} damage - {defender_id.armor} armor, for a total of {total_dmg} damage.{negated_str}**";	
						
					#region Set defender's bool var to true:
						
					if defender_id.hp_cur <= 0 {
							
						defender_killed = true;
							
						d($"THE {defender_id.name} with id:({defender_id.unique_id}) has been downed! If it was an enemy or neutral, their bool var was flipped; if it was a pc, they have been rendered unconscious instead.");
						
						if defender_id.char_team_enum != team_type.pc {
							defender_id.has_died_bool = true;
							attack_result_str += $"\n\n**{capitalized_str}({defender_id.unique_id}) has been killed!**";
						}
						//Render unconscious instead:
						else {
							defender_id.unconscious_bool = true;
							//Reset all of their DOTs - we don't chars to continue taking DOT while unconscious:
							scr_reset_status_effects(defender_id);
							attack_result_str += $"\n\n**{capitalized_str}({defender_id.unique_id}) has collapsed!**";
						}
					}
						
					#endregion
						
				}
				//Miss
				else {
					var capitalized_atk_str = scr_string_capitalize(attacker_id.name);
					var enemy_the_str = "";
					if defender_id.char_team_enum != team_type.pc enemy_the_str = "the ";
					attack_result_str += $"\n--//{capitalized_atk_str}({attacker_id.unique_id}) misses {enemy_the_str}{defender_id.name}({defender_id.unique_id}) with their attack!//--";
				}
				
				//Whether it was a hit or miss, or whether damage was applied or not, we need to print our attack_result_str now:
				scr_add_str_to_dialogue_ar("\n"+attack_result_str);
				
				//Check to see if we need to apply status effects, if the defender is still alive:
				if defender_id.hp_cur > 0 {
					//A hit may or may not have been scored, either way we check to apply status effects:
					if attacker_id.chosen_weapon.always_checks_status_effect_boolean == true {
						scr_apply_status_effects(attacker_id.chosen_weapon, defender_id);
					}
					//A hit was scored, check to apply status effects
					else if attacker_id.chosen_weapon.always_checks_status_effect_boolean == false && total_attack_val >= ran_to_hit_val {
						scr_apply_status_effects(attacker_id.chosen_weapon, defender_id);	
					}
				}
				
			} //End of if an attack was actually executed
			else {
				scr_add_str_to_dialogue_ar($"\nThe {attacker_id.chosen_weapon.item_name} clicks with a hollow sound. You're out of ammo!");
				break;
			}
		}	
	}
	
	#endregion
	
	var defender_successfully_fled = false;
	
	#region Char successfully fled - If applicable, show 'successfully fled' message, and execute fled logic:
	
	if defender_killed == false && global.char_is_fleeing_bool && global.overwatch_mode_enabled == false {
		
		d($"\no_con step event: cur_game_state == combat_execute_action: EXECUTING CODE FOR IF DEFENDER_KILLED == false AND CHAR_IS_FLEEING_BOOL == TRUE")
		
		var fled_char_id = global.fleeing_combat_char_id;
		
		fled_char_id.has_fled_combat_bool = true;
		
		var capital_str = scr_string_capitalize(fled_char_id.name);
		scr_add_str_to_dialogue_ar($"\n**{capital_str} has successfully fled from combat!**");
		defender_successfully_fled = true;

		//Remove from current room array:
		scr_add_remove_char_room_ar(fled_char_id.cur_room_id,fled_char_id,false);
									
		//Now update vars to reflect room change:
		d($"\n o_con step event: game_state == combat_execute_action: ABOUT TO UPDATE the fleeing char's cur grid x and y vars, cur_grid_x == {fled_char_id.cur_grid_x}, y == {fled_char_id.cur_grid_y}; its fleeing_dir_x == {fled_char_id.fleeing_dir_x}, fleeing_dir_y == {fled_char_id.fleeing_dir_y}.");
		//Update char x and y vars:
		fled_char_id.cur_grid_x += fled_char_id.fleeing_dir_x;
		fled_char_id.cur_grid_y += fled_char_id.fleeing_dir_y;
		
		//Update vars for any neutrals in this char's neutrals_following_this_char_ar, if applicable:
		if is_array(fled_char_id.neutrals_following_this_char_ar) && array_length(fled_char_id.neutrals_following_this_char_ar) > 0 {
			scr_update_neutrals_movement_vars(fled_char_id.neutrals_following_this_char_ar,fled_char_id.cur_grid_x,fled_char_id.cur_grid_y);	
		}
				
		//Update cur_room_id:
		fled_char_id.cur_room_id = global.cur_grid[# fled_char_id.cur_grid_x,fled_char_id.cur_grid_y];
				
		//Add to next room array:
		scr_add_remove_char_room_ar(fled_char_id.cur_room_id,fled_char_id,true);
		
		//Re-position it's sprite vars:
		scr_update_char_sprite_position_vars(fled_char_id);
									
		//Add room to tilemap, if it hasn't already been done:
		if fled_char_id.cur_room_id.explored_boolean == false {
			scr_add_cell_to_tilemap(global.tile_main_lay_id,fled_char_id.cur_room_id.room_enum,fled_char_id.cur_grid_x,fled_char_id.cur_grid_y);
		}
		//Add doors to room, if it hasn't already been done:
		if fled_char_id.cur_room_id.doors_already_added_boolean == false {
			scr_add_doors_to_tilemap(global.tile_doors_lay_id,fled_char_id.cur_grid_x,fled_char_id.cur_grid_y);
		}
				
		//Update the room's boolean vars:
		fled_char_id.cur_room_id.explored_boolean = true;
		fled_char_id.cur_room_id.doors_already_added_boolean = true;
			
		//Call scr_reset_visibility(), then update visibility:
		scr_reset_visibility();
		scr_update_visibility();
		
		//Finally, we reset this because this character can now trigger combat again in a new room
		fled_char_id.participated_in_new_turn_battle = false;
		//Also flip their already fled this turn var, so they can't run again this turn:
		fled_char_id.already_fled_this_turn_boolean = true;
	}
	
	#endregion
	
	#region Advance cur_char, check end combat state:
	
	//Whatever has happened, move to next char in combat initiative queue.
	
	/* Cases we need to consider if manually changing our g.cur_char_combat_index:
	--if the defender was fleeing (pc was attempting to flee), then the g.cur_combat_char would have been the attacker 
	performing the opportunity attack, but the g.cur_combat_char_index should still be == to the defender; so we don't
	need to manually change anything.
	
	*/
	
	//In any case, we've made it this far in execute action, it's safe to say the fleeing_char_id has now either fled 
	//or been killed, so we can reset this var:
	global.char_is_fleeing_bool = false;
	
	//Cancel overwatch mode prematurely if the defender died:
	if defender_killed {
		global.overwatch_mode_enabled = false;	
	}
	
	if global.overwatch_mode_enabled {
		
		//The global.overwatch_attacker_index
		if global.overwatch_attacker_index < array_length(overwatch_attackers_ar) {
			
			next_combat_char = overwatch_attackers_ar[global.overwatch_attacker_index];
			
			var target_str, target_unique_id_str;
			if global.overwatch_attacker_index == 0 { target_str = global.cur_combat_char.name; target_unique_id_str = global.cur_combat_char.unique_id; }
			else { target_str = defender_id.name; target_unique_id_str = defender_id.unique_id; }
		
			var capitalized_ow_attacker = scr_string_capitalize(next_combat_char.name);
			var ow_attacker_unique_id = next_combat_char.unique_id;
			scr_add_str_to_dialogue_ar($"\n{capitalized_ow_attacker}({ow_attacker_unique_id}) is attacking {target_str}({target_unique_id_str}) with overwatch fire! Press any key to continue...");
			
			next_combat_game_state = game_state.combat_execute_action;
			
			global.cur_game_state = game_state.combat_paused;
		}
		
		else if global.overwatch_attacker_index >= array_length(overwatch_attackers_ar) {
			
			global.overwatch_mode_enabled = false;
		}
	}
	
	//Advances cur_char_index, game state, checks combat end conditions:
	if global.overwatch_mode_enabled == false {
		scr_evaluate_combat_conclusion("o_con step event: game_state == combat_execute_action, very end of this game state.");
	}
	
	#endregion
	
}

#endregion

#region game_state == combat_choose_pc_wep or choose_pc_abil:

else if (global.cur_game_state == game_state.combat_choose_pc_wep || global.cur_game_state == game_state.choose_pc_abil) && global.wait {
	
	#region Logic for enter keypress:
	
	if keyboard_check_released(vk_enter) && global.wait {
		
		scr_reset_wait();
		
		//So there is a log of what the player is typing, add it to the last index of our g.dialogue_ar:
		global.dialogue_ar[array_length(global.dialogue_ar)-1] += string(player_input_str);
		
		//Format string:
		player_input_str = string(player_input_str);
		player_input_str = string_upper(player_input_str);
		player_input_str = string_trim(player_input_str); //Remove all LEADING white spaces
		
		if player_input_str == "B" || player_input_str == "BACK" {
			scr_reset_wait();
			global.cur_game_state = prev_game_state;
			scr_print_combat_ranks(global.cur_combat_char);
		}
		
		//Check for number keypress here, then all of the other restrictions:
		else {
			var valid_index = false;
			try {
				var index_int = real(player_input_str);
				
				d($"\no_con step event: game_state = choose wep or abil game state: player_input_str == {player_input_str}");
			
				if global.cur_game_state == game_state.combat_choose_pc_wep && index_int >= 0 && index_int < array_length(avail_weps_or_abils_list) {
					
					valid_index = true;
				}
				else if global.cur_game_state == game_state.choose_pc_abil && index_int >= 0 && index_int < array_length(global.cur_combat_char.filtered_abil_ar) {
					
					valid_index = true;	
				}
			}
			catch(_exception) {
				//scr_add_str_to_dialogue_ar("\n");
				//scr_add_str_to_dialogue_ar("That is an invalid command, try again.",true);	
				
				show_debug_message(_exception.message);
			    show_debug_message(_exception.longMessage);
			    show_debug_message(_exception.script);
			    show_debug_message(_exception.stacktrace);
			}
			
			if valid_index {
				
				//This is not currently in use - currently pcs cannot dual-wield weapons:
				if global.cur_game_state == game_state.combat_choose_pc_wep {
					
					global.cur_combat_char.chosen_weapon = avail_weps_or_abils_list[index_int];
					
					global.cur_game_state = game_state.combat_pc_target_rank;
					
					scr_print_ranks_to_target(global.cur_combat_char);
				}
					
				else if global.cur_game_state == game_state.choose_pc_abil {
					
					//We already know this abil can be used in combat - our filtered_abil_ar should only contains 
					//item structs that can be used here 
					var abil_item_struct_id = global.cur_combat_char.filtered_abil_ar[index_int];
					
					//Check to make sure we have sufficient AP:
					if global.cur_combat_char.ability_points_cur >= abil_item_struct_id.ability_point_cost {
						
						if global.cur_combat_char.sanity_cur >= abil_item_struct_id.sanity_cost {
						
							//filtered_abil_ar created by scr_return_filtered_abil_ar() is only filled with actual item_struct_ids that are applicable for the 
							//corresponding game state (either main, combat, or both), so we know that what is here is a valid option.
						
							//This is an ability that functions just like a weapon: hand flamer, wrist rockets, etc.;
							//we don't reduce AP here because it's reduced (if applicable) in combat_execute_action, which is where this char is going if
							//they're using an ability like this:
							if abil_item_struct_id.non_attack_ability_boolean == false {
							
								if global.combat_prep_phase == false {
							
									//These all have range requirements:
							
									//Check to see if there's an enemy in range:
									var closest_enemy_rank = scr_return_nearest_target_rank_pos(global.cur_combat_char.cur_combat_rank,false);
			
									var dist_to_target = abs(global.cur_combat_char.cur_combat_rank - closest_enemy_rank);
			
									var wep_range = abil_item_struct_id.max_range;
			
									//If there's an enemy in range and our max_range is greater than 0, then move to choose_pc_rank_target:
									if dist_to_target <= wep_range {
								
										//Assign chosen weapon:
										global.cur_combat_char.chosen_weapon = abil_item_struct_id;
								
										prev_game_state = global.cur_game_state;
				
										/*To streamline the process even further, check to see if the enemy only occupies one rank in the entire combat_rank_ar;
										if they do (we already know the enemy is within range), just automatically define our range 
										based upon what rank it is in, then automatically move to execute action:
										*/
										if scr_return_opposite_team_occupied_ranks(global.cur_combat_char.char_team_enum) <= 1 {
											global.cur_combat_char.targeted_rank = closest_enemy_rank;
											global.cur_game_state = game_state.combat_execute_action;	
										}
				
										else {
											if wep_range > 0 {
												global.cur_game_state = game_state.combat_pc_target_rank;
												scr_print_ranks_to_target(global.cur_combat_char);
											}
											//otherwise, define our chosen rank and move straight to execute_action:
											else if wep_range <= 0 {
												global.cur_combat_char.targeted_rank = closest_enemy_rank;
												global.cur_game_state = game_state.combat_execute_action;
											}
										}
									}
									else {
										scr_add_str_to_dialogue_ar("\n");
										scr_add_str_to_dialogue_ar($"There are no targets within your ability's range. Your {abil_item_struct_id.item_name} has a maximum range of {wep_range}. Either use a different ability, or move closer to the enemy.", true);
									}
								}
								else {
									scr_add_str_to_dialogue_ar("You can't use this ability during the combat preparation phase, try again.\n",true);	
								}
							}
							//This is an ability that does something else: spawns a unit, buffs a stat, applies a debuff, etc.
							//some of these may require a target and will therefore send us to game_state.use_target_item
							//some examples include: torvalds shield generator, energizing stim prick, cooper's smoke grenade, field_medicine, avia's spawn droid, etc.
							else if abil_item_struct_id.non_attack_ability_boolean == true {
							
								//We can execute the abil right away - it will be something like shield generator, smoke grenade, spawn droid, etc.:
								//We only target ourself in such a case.
								if abil_item_struct_id.use_requires_target == false {
								
									//Reduce AP:
									if abil_item_struct_id.ability_point_cost > 0 {
										global.cur_combat_char.ability_points_cur -= abil_item_struct_id.ability_point_cost;
									}
								
									scr_use_item_or_ability(abil_item_struct_id,global.cur_combat_char,global.cur_combat_char);
								
									//if this ability instantly finishes this char's turn (like smoke grenade), we need to advance the cur char now:
									if abil_item_struct_id.abil_passes_turn_boolean == true {
										scr_evaluate_combat_conclusion("o_con step event: game_state == combat_assign_pc_combat: player just used an ability that does NOT require a target but DOES immediately end the cur char's turn.")	
									}
									else {
										//Important: we need to actually return to combat_assign_pc_command game state, since only pcs can access this game state:
										global.cur_game_state = game_state.combat_assign_pc_command;
										scr_print_combat_ranks(global.cur_combat_char);
									}
								}
								//Using this abil requires that we move to game_state.use_target_item
								else if abil_item_struct_id.use_requires_target == true {
									prev_game_state = global.cur_game_state;
									global.cur_combat_char.using_item_struct_id = abil_item_struct_id;
									global.cur_combat_char.using_item_index = index_int;
							
									global.cur_game_state = game_state.use_target_item;
							
									scr_print_pc_party(false, true);	
								}
							}
						}
						else {
							scr_add_str_to_dialogue_ar("\nYou don't have enough sanity points to use that ability, try again.",true);	
						}
					}
					else {
						scr_add_str_to_dialogue_ar("\nYou don't have enough ability points to use that ability, try again.",true);	
					}
				}	
			}
			else if !valid_index { //A valid number, but not a valid character selection:
				scr_add_str_to_dialogue_ar("\n");
				scr_add_str_to_dialogue_ar($"That is not a valid selection, try again.",true);		
			}
		}
		
		//Reset our player_input_str:
		player_input_str = "";	
	}
	
	#endregion
	
	#region Accept input for player_input_str:

	// Detect new character input
	if (keyboard_lastchar != "") {
	    if keyboard_lastkey != vk_up && keyboard_lastkey != vk_down && keyboard_lastkey != vk_right && keyboard_lastkey != vk_left &&
		keyboard_lastkey != vk_backspace {
			player_input_str += keyboard_lastchar;
			keyboard_lastchar = "";
		}
	}

	// Handle backspace
	if (keyboard_check_pressed(vk_backspace) && string_length(player_input_str) > 0) {
	    player_input_str = string_copy(player_input_str, 1, string_length(player_input_str) - 1);
	}

	#endregion	
}

#endregion

#region game_state == combat_pc_target_rank:

else if global.cur_game_state == game_state.combat_pc_target_rank && global.wait {
	
	#region Logic for enter keypress:
	
	if keyboard_check_released(vk_enter) && global.wait {
		
		scr_reset_wait();
		
		//So there is a log of what the player is typing, add it to the last index of our g.dialogue_ar:
		global.dialogue_ar[array_length(global.dialogue_ar)-1] += string(player_input_str);
		
		//Format string:
		player_input_str = string(player_input_str);
		player_input_str = string_upper(player_input_str);
		player_input_str = string_trim(player_input_str); //Remove all LEADING white spaces
		
		if player_input_str == "B" || player_input_str == "BACK" {
			global.cur_game_state = game_state.combat_assign_pc_command;
			//Reset overwatch mode:
			if global.overwatch_mode_enabled == true global.overwatch_mode_enabled = false;
			scr_reset_wait();
			scr_print_combat_ranks(global.cur_combat_char);
		}
		
		//Check for number keypress here, then all of the other restrictions:
		else {
			var valid_index = false, error_msg_already_printed = false;
			try {
				var index_int = real(player_input_str);
				
				d($"o_con step event: game_state = combat_pc_target_rank: player_input_str == {player_input_str}");
			
				if index_int >= rank_pos.enemy_far && index_int <= rank_pos.pc_far { //if index_int >= 0 && index_int <= 5
					
					//If we're not targeting overwatch, check if we're within weapon's range:
					if global.overwatch_mode_enabled == false {
						if abs(global.cur_combat_char.cur_combat_rank - index_int) <= global.cur_combat_char.chosen_weapon.max_range {
					
							//Check and make sure there are actual enemies in this rank:
							if scr_check_enemies_in_rank(index_int) {
						
								valid_index = true;
							}
							else {
								error_msg_already_printed = true;
								scr_add_str_to_dialogue_ar("\n");
								scr_add_str_to_dialogue_ar("There are no enemies in that rank to target, try again.",true);	
							}
						}
						else {
							error_msg_already_printed = true;
							scr_add_str_to_dialogue_ar("\n");
							scr_add_str_to_dialogue_ar("That position is beyond your currently selected weapon's range, try again.",true);	
						}
					}
					else if global.overwatch_mode_enabled {
						if abs(global.cur_combat_char.cur_combat_rank - index_int) <= global.cur_combat_char.chosen_weapon.max_range {
							
							valid_index = true;
						}
						else {
							error_msg_already_printed = true;
							scr_add_str_to_dialogue_ar("\n");
							scr_add_str_to_dialogue_ar("That position is beyond your currently selected weapon's range, try again.",true);	
						}
					}
				}
			}
			catch(_exception) {
				//scr_add_str_to_dialogue_ar("\n");
				//scr_add_str_to_dialogue_ar("That is an invalid command, try again.",true);	
				
				show_debug_message(_exception.message);
			    show_debug_message(_exception.longMessage);
			    show_debug_message(_exception.script);
			    show_debug_message(_exception.stacktrace);
				error_msg_already_printed = true;
			}
			
			if valid_index {
				
				if global.overwatch_mode_enabled == false {
					
					//Assign targeted rank, immediately move to execute action:
					global.cur_combat_char.targeted_rank = index_int;
							
					global.cur_game_state = game_state.combat_execute_action;	
				
					d($"{global.cur_combat_char.name} has successfully targeted a rank, their targeted_rank == {global.cur_combat_char.targeted_rank}, moving to game state execute action now.");
				}
				else if global.overwatch_mode_enabled {
					
					//Assign as targeted rank - we'll need this var to remove this char id from the global array later in scr_reset_certain_char_combat_vars:
					global.cur_combat_char.targeted_rank = index_int;
					
					//Add to corresponding nested struct array in overwatch array:
					scr_apply_overwatch(attacker_id);
					
					//Advances cur_char, game state, checks combat end conditions:
					scr_evaluate_combat_conclusion($"\no_con step event: game_state == pc_targets_rank: successfully overwatched target rank: {index_int} and added to corresponding nested struct array in g.overwatch_rank_ar. global.overwatch_mode_enabled == true\n");
				}
			}
			//A valid number, but not a valid selection:
			else if !valid_index && !error_msg_already_printed { 
				scr_add_str_to_dialogue_ar("\n");
				scr_add_str_to_dialogue_ar($"That is not a valid selection, try again.",true);		
			}
		}
		
		//Reset our player_input_str:
		player_input_str = "";	
	}
	
	#endregion
	
	#region Accept input for player_input_str:

	// Detect new character input
	if (keyboard_lastchar != "") {
	    if keyboard_lastkey != vk_up && keyboard_lastkey != vk_down && keyboard_lastkey != vk_right && keyboard_lastkey != vk_left &&
		keyboard_lastkey != vk_backspace {
			player_input_str += keyboard_lastchar;
			keyboard_lastchar = "";
		}
	}

	// Handle backspace
	if (keyboard_check_pressed(vk_backspace) && string_length(player_input_str) > 0) {
	    player_input_str = string_copy(player_input_str, 1, string_length(player_input_str) - 1);
	}

	#endregion	
}

#endregion

#region game_state == use item or pass item:

else if (global.cur_game_state == game_state.use_target_item || global.cur_game_state == game_state.passing_item) && global.wait {
	
	#region Logic for enter keypress:
	
	if keyboard_check_released(vk_enter) && global.wait {
		
		scr_reset_wait();
		
		//So there is a log of what the player is typing, add it to the last index of our g.dialogue_ar:
		global.dialogue_ar[array_length(global.dialogue_ar)-1] += string(player_input_str);
		
		//Format string:
		player_input_str = string(player_input_str);
		player_input_str = string_upper(player_input_str);
		player_input_str = string_trim(player_input_str); //Remove all LEADING white spaces
		
		if player_input_str == "B" || player_input_str == "BACK" {
			global.cur_game_state = prev_game_state;	
		}
		
		//Check for number keypress here, then all of the other restrictions:
		else {
			var valid_char_index = false;
			try {
				var index_int = real(player_input_str);
				
				d($"o_con step event: game_state = passing item or using item: player_input_str == {player_input_str}");
			
				if index_int >= 0 && index_int < array_length(global.acting_char_struct_id.cur_room_id.pcs_in_room_ar) {
					
					valid_char_index = true;
					
					var item_target_char_struct_id = global.acting_char_struct_id.cur_room_id.pcs_in_room_ar[index_int];
				}
			}
			catch(_exception) {
				//scr_add_str_to_dialogue_ar("\n");
				//scr_add_str_to_dialogue_ar("That is an invalid command, try again.",true);	
				
				show_debug_message(_exception.message);
			    show_debug_message(_exception.longMessage);
			    show_debug_message(_exception.script);
			    show_debug_message(_exception.stacktrace);
			}
			
			if valid_char_index {
				
				//Define cur_char - as we could be accessing this screen from the main game state or from combat:
				var cur_char = global.acting_char_struct_id;
				if global.combat_begun cur_char = global.cur_combat_char;
				
				if global.cur_game_state == game_state.passing_item {
					
					//Make sure we're not trying to give it to ourself:
					if cur_char != item_target_char_struct_id {
						
						//Make sure the character we're trying to pass the item actually has the inventory space to accomodate it:
						if scr_check_backpack_size_restriction(item_target_char_struct_id) == true { //We -4 b.c we don't include the equipment slots; we add 1 b.c we're considering whether or not the player's inv_space can accomodate 1 more item.
						
							//Remove item from corresponding index in acting struct:
								//Remove from backpack:
							if cur_char.passing_item_index >= equip_slot.total_slots {
								array_delete(cur_char.inv_ar,cur_char.passing_item_index,1);	
							}
							//Unequip item:
							else {
								//Check if its a two handed item first:
								if scr_check_two_handed_item(cur_char.passing_item_struct_id) == false {
									cur_char.inv_ar[cur_char.passing_item_index] = -1;
								}
								else {
									cur_char.inv_ar[equip_slot.lh] = -1;
									cur_char.inv_ar[equip_slot.rh] = -1;
								}
							}
							
							//Add item to first empty backpack slot of character:
							array_push(item_target_char_struct_id.inv_ar,cur_char.passing_item_struct_id);
							
							scr_add_str_to_dialogue_ar($"\n{item_target_char_struct_id.name} has picked up the {cur_char.passing_item_struct_id.item_name}",true);
							
							//Return to prev game state: main or assign pc combat command.
							global.cur_game_state = prev_game_state;
						}
						else {
							scr_add_str_to_dialogue_ar($"\n{item_target_char_struct_id.name} is already carrying too many items! They will need to drop or pass an item before receiving this one.");
							//Send us back to our prev game state, it's less confusing this way:
							global.cur_game_state = prev_game_state;
							if global.cur_game_state == game_state.main_game {
								scr_print_char_reminder(cur_char);
							}
							else if global.cur_game_state == game_state.combat_assign_pc_command {
								scr_print_combat_ranks(cur_char);	
							}
						}
					}
					else {
						scr_add_str_to_dialogue_ar("\nYou already possess this item; you cannot give it to yourself.",true);
						//Send us back to our prev game state, it's less confusing this way:
						global.cur_game_state = prev_game_state;
						if global.cur_game_state == game_state.main_game {
							scr_print_char_reminder(cur_char);
						}
						else if global.cur_game_state == game_state.combat_assign_pc_command {
							scr_print_combat_ranks(cur_char);	
						}
					}
				}
				
				//We only end up in this game state if using the item or ability requires a target.
				else if global.cur_game_state == game_state.use_target_item {
					
					//We've successfully used the item, we can reduce our AP now, if applicable:
					if cur_char.using_item_struct_id.ability_point_cost > 0 {
						cur_char.ability_points_cur -= cur_char.using_item_struct_id.ability_point_cost;
					}
					
					scr_use_item_or_ability(cur_char.using_item_struct_id, item_target_char_struct_id, cur_char);
					
					//Only actual items will ever have the single_use_boolean == true, so we know that this is an actual item_id in the cur_char's inventory:
					if cur_char.using_item_struct_id.single_use_boolean == true {
						var item_index = array_get_index(cur_char.inv_ar, cur_char.using_item_struct_id);
						if item_index != -1 {
							array_delete(cur_char.inv_ar,item_index,1);
						}
					}
					
					//Return to main:
					if prev_game_state == game_state.main_game || global.combat_begun == false {
						//"You are {}. What will you do?"
						scr_add_str_to_dialogue_ar(scr_return_cur_char_str(cur_char),true);
						
						//Explicitly reset both and send us back to main:
						global.cur_game_state = game_state.main_game;
						prev_game_state = game_state.main_game;
					}
					//Return to combat_assign_pc_command OR advance the cur_combat_char within the combat system, 
					//if this ability causes you to finish your turn:
					else if prev_game_state == game_state.choose_pc_abil && global.combat_begun {
						
						//if the use of the ability causes the g.cur_Combat_char to end their turn, then end it now;
						//otherwise simply return to combat_assign_pc_command:
						if cur_char.using_item_struct_id.abil_passes_turn_boolean == true {
							global.cur_game_state = game_state.combat_assign_pc_command; //Might as well reset this, although we may or may not be going back there after scr_evaluate_combat_conclusion() finishes
							scr_evaluate_combat_conclusion("\no_con step event: global.cur_game_state == game_state.use_target_item, just finished using an item or ability that required a target.");
						}
						else {
							global.cur_game_state = game_state.combat_assign_pc_command;
							scr_print_combat_ranks(global.cur_combat_char);
						}
					}
				}	
			}
			else if !valid_char_index { //A valid number, but not a valid character selection:
				scr_add_str_to_dialogue_ar($"\nThat is not a valid character selection, try again.",true);
				//Send us back to our prev game state, it's less confusing this way:
				global.cur_game_state = prev_game_state;
				if global.cur_game_state == game_state.main_game {
					scr_print_char_reminder(cur_char);
				}
				else if global.cur_game_state == game_state.combat_assign_pc_command {
					scr_print_combat_ranks(cur_char);	
				}
			}
		}
		
		//Reset our player_input_str:
		player_input_str = "";	
	}
	
	#endregion
	
	#region Accept input for player_input_str:

	// Detect new character input
	if (keyboard_lastchar != "") {
	    if keyboard_lastkey != vk_up && keyboard_lastkey != vk_down && keyboard_lastkey != vk_right && keyboard_lastkey != vk_left &&
		keyboard_lastkey != vk_backspace {
			player_input_str += keyboard_lastchar;
			keyboard_lastchar = "";
		}
	}

	// Handle backspace
	if (keyboard_check_pressed(vk_backspace) && string_length(player_input_str) > 0) {
	    player_input_str = string_copy(player_input_str, 1, string_length(player_input_str) - 1);
	}

	#endregion
	
}

#endregion

#region Our main game state:

else if global.cur_game_state == game_state.main_game && global.wait {
	
	if keyboard_check_released(vk_enter) && global.wait {
		
		scr_reset_wait();
		
		//Parse player_input_str:
		
		//So there is a log of what the player is typing, add it to the last index of our g.dialogue_ar:
		global.dialogue_ar[array_length(global.dialogue_ar)-1] += string(player_input_str);
		
		//Format our string:
		player_input_str = string(player_input_str);
		player_input_str = string_upper(player_input_str);
		player_input_str = string_trim(player_input_str); //Remove all LEADING white spaces
		
		d($"After formatting, player_Input_str == {player_input_str}");
		
		//Parse player_input_str
		
		var changed_cur_char = false, multi_word_str_failed = false, new_char_is_in_different_room = false;
		
		#region Logic for iterating through party or changing chars or selecting pc to give item to:
		
		//See if we're entering a number in an attempt to change chars or give an item:
		try {
			var index_int = real(player_input_str);
			
			if index_int >= 0 && index_int < array_length(global.pc_char_ar) {
				//Changing pcs:
				if !global.passing_item_boolean {
					global.acting_char_struct_id_index = index_int;
					changed_cur_char = true;
				}
			}	
		}
		catch(_exception) {
			//do nothing, move on
			d($"This is a normal, expected catch block: could not convert index_int into a real number (intentional)")
		}
		
		if player_input_str == "<" || player_input_str == ">" {
			changed_cur_char = true;
			if player_input_str == "<" global.acting_char_struct_id_index --;
			else global.acting_char_struct_id_index ++;
			
			//Cap:
			if global.acting_char_struct_id_index < 0 global.acting_char_struct_id_index = array_length(global.pc_char_ar)-1;
			else if global.acting_char_struct_id_index >= array_length(global.pc_char_ar) global.acting_char_struct_id_index = 0;
		}
		
		if changed_cur_char {
			
			var prev_cur_char = global.acting_char_struct_id;
			
			global.acting_char_struct_id = global.pc_char_ar[global.acting_char_struct_id_index];
			
			if scr_check_ar_for_val(prev_cur_char.cur_room_id.pcs_in_room_ar,global.acting_char_struct_id) == false {
				new_char_is_in_different_room = true;	
			}
			
			//Just print a quick reminder of our new character:
			if !new_char_is_in_different_room {
				scr_print_char_reminder(global.acting_char_struct_id)
			}
			//Show all of the information associated with the room this other person is in:
			else if new_char_is_in_different_room {
				scr_print_char_new_room_text(global.acting_char_struct_id);	
			}
		}
		
		#endregion
		
		#region End turn:
		
		else if player_input_str == "END" {
			
			scr_add_str_to_dialogue_ar($"Round {global.total_turn_counter} ends. Your characters collectively consume 1 food, regain 2 action points, and regain all of their movement points. All enemies make their move. Round {global.total_turn_counter+1} begins.",true);
			
			scr_end_turn();
			
			//Have each char path outward from their current location:
			var grid_id, char_struct_id;
			for(var i = 0; i < array_length(global.pc_char_ar); i++) {
				char_struct_id = global.pc_char_ar[i];
				grid_id = char_struct_id.flood_fill_path_grid;
				scr_perform_flood_fill_recursion(char_struct_id, grid_id);
			}
			
			if is_array(global.enemy_mob_ar) && array_length(global.enemy_mob_ar) > 0 {
				
				scr_enemy_mobs_choose_closest_pc_target();
				
				//Okay, the mob structs now have their destination grid cells chosen. 
				
				//Now move them 1 space along their paths:
				scr_move_enemy_mobs();
				
				scr_reset_wait();
			}
			
			global.cur_game_state = game_state.init_combat;
		}
		
		#endregion
		
		#region Display character bio:
		
		else if player_input_str == "B" || player_input_str == "BIO" {
			scr_add_str_to_dialogue_ar(char_bio_ar[global.acting_char_struct_id.char_type_enum]);
			scr_add_str_to_dialogue_ar("\n");
			scr_print_char_reminder(global.acting_char_struct_id);
		}
		
		#endregion
		
		#region 'Inv'entory:
		
		else if player_input_str == "I" || player_input_str == "INV" || player_input_str == "INVENTORY" {
			scr_print_inv_detailed_list(global.acting_char_struct_id);
			scr_print_char_reminder(global.acting_char_struct_id);
		}
		
		#endregion
		
		#region Show pc party:
		
		else if player_input_str == "P" || player_input_str == "PARTY" {
			scr_print_pc_party(false,false);
		}
		
		#endregion
		
		#region Pickup all items from room:
		
		else if player_input_str == "SCAVENGE" {
			
			if is_array(global.acting_char_struct_id.cur_room_id.scavenge_ar) && array_length(global.acting_char_struct_id.cur_room_id.scavenge_ar) > 0 {
			
				scr_scavenge_items_from_room(global.acting_char_struct_id,global.acting_char_struct_id.cur_room_id);
				scr_print_char_reminder(global.acting_char_struct_id);
			}
			else {
				scr_add_str_to_dialogue_ar("\n");
				scr_add_str_to_dialogue_ar("There are no items or resources in this room to collect.", true);	
			}
		}
		
		#endregion
		
		#region Print room description again:
		
		else if player_input_str == "L" || player_input_str == "LOOK" {
			scr_print_char_new_room_text(global.acting_char_struct_id);
		}
		
		#endregion
		
		#region Access help commands:
		
		else if player_input_str == "H" || player_input_str == "HELP" {
			scr_add_str_to_dialogue_ar(global.help_instructions_str_ar);
			scr_print_char_reminder(global.acting_char_struct_id);
		}
		
		#endregion
		
		#region Use 'ABIL'ITY - Move to choose ability game state:
		
		else if (player_input_str == "ABIL" || player_input_str == "ABILITY") {
			
			if is_array(global.acting_char_struct_id.ability_ar) && array_length(global.acting_char_struct_id.ability_ar) > 0 {
				
				global.acting_char_struct_id.filtered_abil_ar = scr_return_filtered_abil_ar(global.acting_char_struct_id);
				
				if array_length(global.acting_char_struct_id.filtered_abil_ar) > 0 {
					
					prev_game_state = global.cur_game_state;
					
					global.cur_game_state = game_state.choose_pc_abil;
					
					scr_print_weapon_or_abil_list(false, global.acting_char_struct_id);
				}
				else {
					scr_add_str_to_dialogue_ar("\nThis character has no abilities that they can use outside of combat.\n",true);	
				}
			}
			else {
				scr_add_str_to_dialogue_ar("\nThis character has no abilities that they can use outside of combat.\n",true);	
			}
		}
		
		#endregion
		
		#region Logic for movement commands:
		
		//Movement commands:
		else if player_input_str == "W" || player_input_str == "WEST" || player_input_str == "N" || player_input_str == "NORTH" || player_input_str == "E" ||
		player_input_str == "EAST" || player_input_str == "S" || player_input_str == "SOUTH" {
			
			var move_dir_x = 0, move_dir_y = 0, move_str = "undefined";
			
			if player_input_str == "W" || player_input_str == "WEST" { move_dir_x = -1; move_str = "WEST"; }
			if player_input_str == "N" || player_input_str == "NORTH" { move_dir_y = -1; move_str = "NORTH"; }
			if player_input_str == "E" || player_input_str == "EAST" { move_dir_x = 1; move_str = "EAST"; }
			if player_input_str == "S" || player_input_str == "SOUTH" { move_dir_y = 1; move_str = "SOUTH"; }
			
			//Check to see if that's a valid direction sides:
			var valid_direction = scr_check_valid_door_dir(global.acting_char_struct_id.cur_room_id,move_dir_x,move_dir_y);
			
			//Move:
			if valid_direction {
				
				if global.acting_char_struct_id.move_points_cur > 0 {
				
					//Reduce movepoints:
					global.acting_char_struct_id.move_points_cur -= 1;
					
					//Remove from current room:
					scr_add_remove_char_room_ar(global.acting_char_struct_id.cur_room_id,global.acting_char_struct_id,false);
					
					//Update char x and y vars:
					global.acting_char_struct_id.cur_grid_x += move_dir_x;
					global.acting_char_struct_id.cur_grid_y += move_dir_y;
				
					//Update cur_room_id:
					global.acting_char_struct_id.cur_room_id = global.cur_grid[# global.acting_char_struct_id.cur_grid_x,global.acting_char_struct_id.cur_grid_y];
				
					//Add to next room array:
					scr_add_remove_char_room_ar(global.acting_char_struct_id.cur_room_id,global.acting_char_struct_id,true);
					
					//Update vars for any neutrals in this char's neutrals_following_this_char_ar, if applicable:
					if is_array(global.acting_char_struct_id.neutrals_following_this_char_ar) && array_length(global.acting_char_struct_id.neutrals_following_this_char_ar) > 0 {
						scr_update_neutrals_movement_vars(global.acting_char_struct_id.neutrals_following_this_char_ar,global.acting_char_struct_id.cur_grid_x,global.acting_char_struct_id.cur_grid_y);	
					}
					
					//Re-position it's sprite vars:
					scr_update_char_sprite_position_vars(global.acting_char_struct_id);
					
					//Update camera:
					scr_center_map_window(global.acting_char_struct_id.cur_grid_x,global.acting_char_struct_id.cur_grid_y,global.map_cam,"\n\no_con step event: player just successfully moved a pc to another room.");
				
					//Add room to tilemap, if it hasn't already been done:
					if global.acting_char_struct_id.cur_room_id.explored_boolean == false {
						scr_add_cell_to_tilemap(global.tile_main_lay_id,global.acting_char_struct_id.cur_room_id.room_enum,global.acting_char_struct_id.cur_grid_x,global.acting_char_struct_id.cur_grid_y);
					}
					//Add doors to room, if it hasn't already been done:
					if global.acting_char_struct_id.cur_room_id.doors_already_added_boolean == false {
						scr_add_doors_to_tilemap(global.tile_doors_lay_id,global.acting_char_struct_id.cur_grid_x,global.acting_char_struct_id.cur_grid_y);
					}
				
					//Update the room's boolean vars:
					global.acting_char_struct_id.cur_room_id.explored_boolean = true;
					global.acting_char_struct_id.cur_room_id.doors_already_added_boolean = true;
			
					//Call scr_reset_visibility(), then update visibility:
					scr_reset_visibility();
					scr_update_visibility();
				
					//Display move result:
					scr_add_str_to_dialogue_ar($"{global.acting_char_struct_id.name} moves {move_str}.\n\n");
					scr_print_char_new_room_text(global.acting_char_struct_id);
				}
				else {
					scr_add_str_to_dialogue_ar("\nYou don't have enough move points.",true);	
				}
			}
			else{
				scr_add_str_to_dialogue_ar("\nYou cannot move in that direction, try again.",true);	
			}
			
		}
		
		#endregion
		
		#region Logic for all multi-word commands:
		
		else if scr_check_multi_word_str(player_input_str) == true {
			
			var multi_word_ar = scr_return_multi_word_ar(player_input_str);
			
			var valid_drop_item = false, valid_equip_or_unequip = false, valid_item_index = false;
			var valid_give_item = false, valid_use_item = false, valid_look_item = false;
			
			if multi_word_ar[0] == "D" || multi_word_ar[0] == "DROP" valid_drop_item = true;
			
			else if multi_word_ar[0] == "E" || multi_word_ar[0] == "EQUIP" valid_equip_or_unequip = true;
			
			else if multi_word_ar[0] == "G" || multi_word_ar[0] == "GIVE" valid_give_item = true;
			
			else if multi_word_ar[0] == "U" || multi_word_ar[0] == "USE" valid_use_item = true;
			
			else if multi_word_ar[0] == "EX" || multi_word_ar[0] == "EXAMINE" valid_look_item = true;
			
			//Make sure its a valid item in the inventory:
			try {
				var index_int = real(multi_word_ar[1]);
				
				if is_real(index_int) {
					if index_int >= 0 && index_int < array_length(global.acting_char_struct_id.inv_ar) && 
					is_struct(global.acting_char_struct_id.inv_ar[index_int]) && global.acting_char_struct_id.inv_ar[index_int].struct_type_enum == struct_type.Item {
					
						valid_item_index = true;
					
						var item_struct_id = global.acting_char_struct_id.inv_ar[index_int];
					}
					else {
						multi_word_str_failed = true;
						scr_add_str_to_dialogue_ar("There is no such item in your inventory, try again.", true);	
					}
				}
			}
			
			catch(_exception) {
				//if !multi_word_str_failed scr_add_str_to_dialogue_ar("That is an invalid command, try again.", true);
				//multi_word_str_failed = true;
				show_debug_message(_exception.message);
			    show_debug_message(_exception.longMessage);
			    show_debug_message(_exception.script);
			    show_debug_message(_exception.stacktrace);
			}
			
			#region 'USE' an item:
			
			if valid_use_item && valid_item_index {
				//Make sure this is a useable item:
				if item_struct_id.usable_boolean == true {
					prev_game_state = global.cur_game_state;
					global.acting_char_struct_id.using_item_struct_id = item_struct_id;
					global.acting_char_struct_id.using_item_index = index_int;
					
					if item_struct_id.use_requires_target == true {
						global.cur_game_state = game_state.use_target_item;
						scr_reset_wait();
						scr_print_pc_party(false, true);
					}
					//Just use the item right away (it will be used on self):
					else {
						scr_use_item_or_ability(item_struct_id,global.acting_char_struct_id,global.acting_char_struct_id);
						scr_print_char_reminder(global.acting_char_struct_id);
					}
				}
				else if item_struct_id.usable_boolean == false {
					multi_word_str_failed = true;
					scr_add_str_to_dialogue_ar("\nThis item cannot be 'use'd in this way.", true);	
				}
			}
			
			#endregion
			
			#region Dropping items back into a room:
			
			else if valid_drop_item && valid_item_index {
				
				scr_drop_item_into_room(global.acting_char_struct_id,item_struct_id,index_int,global.acting_char_struct_id.cur_room_id);	
			}
			
			#endregion
			
			#region EXAMINING at an item:
			
			else if valid_look_item && valid_item_index {
				
				scr_add_str_to_dialogue_ar("\n");
				scr_add_str_to_dialogue_ar($"{item_struct_id.item_desc}");
				scr_add_str_to_dialogue_ar("\n");
				//Current character reminder:
				scr_print_char_reminder(global.acting_char_struct_id)
			}
			
			#endregion
			
			#region Passing an item to another character in the same room:
			
			else if valid_give_item && valid_item_index {
				
				//First, make sure there's another actual character in the room to give the item to:
				if array_length(global.acting_char_struct_id.cur_room_id.pcs_in_room_ar) > 1 {
					
					prev_game_state = global.cur_game_state;
					
					global.cur_game_state = game_state.passing_item;
					
					global.acting_char_struct_id.passing_item_struct_id = item_struct_id;
					global.acting_char_struct_id.passing_item_index = index_int;
				
					scr_print_pc_party(true,false);
				
					global.passing_item_boolean = true;
				}
				else {
					multi_word_str_failed = true;
					scr_add_str_to_dialogue_ar("\n");
					scr_add_str_to_dialogue_ar("There are no other playable characters in this room to give the item to.");	
				}
			}
			
			#endregion
			
			#region Equip or unequip an item in your inventory:
			
			else if valid_equip_or_unequip && valid_item_index {
				
				//Determine if we're equipping, unequipping, or swapping items (unequipping, then equipping):
					//Unequipping:
				if index_int < equip_slot.total_slots {
					
					scr_equip_or_unequip_item(global.acting_char_struct_id,item_struct_id,index_int,false,false);
					scr_print_char_reminder(global.acting_char_struct_id);
				}
				
				//Equipping:
				else if index_int >= equip_slot.total_slots {
					
					var valid_equip = scr_check_valid_equip(global.acting_char_struct_id,item_struct_id);
					
					if valid_equip {
						
						scr_equip_or_unequip_item(global.acting_char_struct_id,item_struct_id,index_int,true,false);
						scr_print_char_reminder(global.acting_char_struct_id);
					}
					else {
						multi_word_str_failed = true;
						scr_add_str_to_dialogue_ar($"\nYou can't equip the {item_struct_id.item_name}, make sure the corresponding equipment slot is free first.",true);
					}
				}
			}
			
			else if !valid_item_index {
				multi_word_str_failed = true;
				scr_add_str_to_dialogue_ar("\nThat is an invalid command, try again.",true);	
			}
			
			#endregion
		}
		
		#endregion
		
		else if multi_word_str_failed == false {
			scr_add_str_to_dialogue_ar("\nThat is an invalid command, try again.",true);
		}
		
		//Reset our player_input_str:
		player_input_str = "";
	}
	
	#region Accept input for player_input_str:

	// Detect new character input
	if (keyboard_lastchar != "") {
	    if keyboard_lastkey != vk_up && keyboard_lastkey != vk_down && keyboard_lastkey != vk_right && keyboard_lastkey != vk_left &&
		keyboard_lastkey != vk_backspace {
			player_input_str += keyboard_lastchar;
			keyboard_lastchar = "";
		}
	}

	// Handle backspace
	if (keyboard_check_pressed(vk_backspace) && string_length(player_input_str) > 0) {
	    player_input_str = string_copy(player_input_str, 1, string_length(player_input_str) - 1);
	}

	#endregion
	
	#region Camera functions:
	
	if win_mouse_y < global.top_win_h and win_mouse_x > global.left_window_x {
	
		scr_grab_and_drag_cam(global.map_cam);
	
		var cam_dir_x = 0, cam_dir_y = 0, cam_key_pressed = false;
		
		if(keyboard_check(vk_left)) { cam_dir_x = global.cam_move_spd*-1; cam_key_pressed = true; }
		if(keyboard_check(vk_right)) { cam_dir_x = global.cam_move_spd; cam_key_pressed = true; }
		if(keyboard_check(vk_up)) { cam_dir_y = global.cam_move_spd*-1; cam_key_pressed = true; }
		if(keyboard_check(vk_down)) { cam_dir_y = global.cam_move_spd; cam_key_pressed = true; }

		if(cam_key_pressed) {
			scr_move_cam(global.map_cam,cam_dir_x,cam_dir_y);
		}

		//Zoom in or out on mouse coordinates:
	
		//Zoom out:
		var zoom_key = false;
		if keyboard_check_released(vk_subtract) || mouse_wheel_down()
		{
			global.cur_zoom_val += global.zoom_val;
			zoom_key = true;
		}

		//Zoom In:
		if keyboard_check_released(vk_add) || mouse_wheel_up()
		{
			global.cur_zoom_val -= global.zoom_val;
			zoom_key = true;
		}

		if zoom_key
		{
			//Cap our cur_zoom_val so we're never zooming in too close or zooming out too far:
			if global.cur_zoom_val < .25 global.cur_zoom_val = .25; //Cap zoom in
			if global.cur_zoom_val > 4 global.cur_zoom_val = 4; //Cap zoom out
	
			var zoom_on_cur_char = false;
	
			if zoom_on_cur_char
			{
				scr_zoom_on_inst_or_coord(zoom_on_cur_char, global.acting_char_struct_id,global.map_cam,global.cur_zoom_val,-1,-1);	
			}
			else if !zoom_on_cur_char
			{
				//Just use the current approx halfway point of our cam w and cam h as our coordinate:
				var half_cam_w = camera_get_view_x(global.map_cam)+(camera_get_view_width(global.map_cam) div 2);
				var half_cam_h = camera_get_view_y(global.map_cam)+(camera_get_view_height(global.map_cam) div 2);
			
				scr_zoom_on_inst_or_coord(zoom_on_cur_char,-1,global.map_cam,global.cur_zoom_val,half_cam_w,half_cam_h);
			}
		
			d($"global.cur_zoom_val: {global.cur_zoom_val}");
		}
	}
	
	#endregion	
	
}

#endregion
