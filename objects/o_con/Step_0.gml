/// @description o_con step event

#region Basic debug functions:

if keyboard_check_released(vk_f1) {
	game_end();
}

if keyboard_check_released(vk_f2) {
	game_restart();
}

if keyboard_check(vk_lcontrol) and keyboard_check_released(vk_enter) {
	if window_get_fullscreen() == false {
		window_set_fullscreen(true);	
	} else {
		window_set_fullscreen(false)	
	}
}

#endregion

//Always store our win_w and win_h:
var win_mouse_y = window_mouse_get_y(), win_mouse_x = window_mouse_get_x();

#region Adjust our dialogue_text_array - can be done in any game state:

// Update window dimensions based on screen size
dialogue_window_width = display_get_gui_width() * global.top_and_bottom_w_percent;
dialogue_window_height = display_get_gui_height() * global.lower_win_h_percent;
dialogue_window_x = display_get_gui_width() * global.left_win_w_percent;
dialogue_window_y = display_get_gui_height() - dialogue_window_height;

//Recalculate max scroll every step:
scr_calculate_max_scroll();

//Store mouse GUI coordinates:
var mouse_gui_x = device_mouse_x_to_gui(0), mouse_gui_y = device_mouse_y_to_gui(0);

var mouse_in_window = point_in_rectangle(mouse_gui_x,mouse_gui_y,dialogue_window_x,dialogue_window_y,
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

if (global.scrollbar_dragging) {
    // Calculate new scroll position based on mouse
    var target_button_y = mouse_gui_y - global.scrollbar_drag_offset;
    var relative_pos = (target_button_y - scrollbar_y) / (scrollbar_track_height - button_height);
    relative_pos = clamp(relative_pos, 0, 1);
    global.scroll_position = relative_pos * global.max_scroll;
}

// Handle mouse wheel scrolling (only when mouse is in window)
if (mouse_in_window) {
    var wheel = mouse_wheel_down() - mouse_wheel_up();
    global.scroll_position += wheel * global.scroll_speed;
}

// Clamp scroll position
global.scroll_position = clamp(global.scroll_position, 0, global.max_scroll);


#endregion

#region game_state == main_menu:

if global.cur_game_state == game_state.main_menu {
	
	if keyboard_check_released(vk_up) || keyboard_check_released(vk_down) {
		
		if keyboard_check_released(vk_up) cursor_pos--;
		else cursor_pos++;
		
		//Cap:
		if cursor_pos < 0 cursor_pos = array_length(ar_to_draw)-1;
		else if cursor_pos >= array_length(ar_to_draw) cursor_pos = 0;
	}
	
	if keyboard_check_released(vk_escape) {
		if cur_main_menu_option == main_menu_options.options {
			cur_main_menu_option = main_menu_options.main;	
		}
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
			scr_add_str_to_dialogue_ar(char_stats_ar[cursor_pos],true);
		}
		
		//d($"cursor_x: {cursor_x}, cursor_y: {cursor_y}.");
		keyboard_lastchar = "";
		player_input_str = "";
	}
	if keyboard_check_released(vk_escape) {
		global.cur_game_state = game_state.main_menu;
		cur_main_menu_option = main_menu_options.main;
		global.dialogue_ar = -1;
		global.dialogue_ar = [];
	}
}

#endregion

#region game_state >= main_game logic:

else if global.cur_game_state == game_state.choose_chars {
	
	#region Logic for left side window:
	
	if keyboard_check_released(vk_up) || keyboard_check_released(vk_down) && global.wait {
		
		scr_reset_wait();
		
		if keyboard_check_released(vk_up) cursor_pos--;
		else cursor_pos++;
		
		//Cap:
		if cursor_pos < 0 cursor_pos = array_length(char_str_ar)-1;
		else if cursor_pos >= array_length(char_str_ar) cursor_pos = 0;
		
		//Clear our txt buffer and add the corresponding string from the char_stat_ar:
		scr_clear_dialogue_ar();
		scr_add_str_to_dialogue_ar(char_stats_ar[cursor_pos]);
		scr_add_str_to_dialogue_ar(" ");
		scr_add_str_to_dialogue_ar($"You must choose {party_limit-array_length(global.pc_char_ar)} more characters to add to your party. Enter 'A' or 'ADD' to add this character to your party, or 'R' or 'REMOVE' to remove them. Commands are not case-sensitive.",true);
	}
	
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
			//Add, start game:
		if player_input_str == "A" || player_input_str == "ADD" {
			
			if scr_check_char_type_enum_in_ar(global.pc_char_ar,cursor_pos) == false {
			
				array_push(global.pc_char_ar,new global.Character(cursor_pos,global.origin_grid_x,global.origin_grid_y,global.research_vessel_grid,team_type.pc,true,true) );
				
				scr_add_str_to_dialogue_ar($"{global.pc_char_ar[array_length(global.pc_char_ar)-1].name} has been added to the party.",true);
				
				if array_length(global.pc_char_ar) >= party_limit {	
					global.cur_char = global.pc_char_ar[0];
					global.cur_game_state = game_state.main_game;
					scr_clear_dialogue_ar();
					scr_print_char_new_room_text(global.cur_char);
					
					scr_add_char_sprites_from_room(global.cur_char.cur_room_id);
					scr_position_char_sprite_in_room(global.cur_char.cur_room_id);
				}
			} else {
				scr_add_str_to_dialogue_ar("You've already added this character to your party.",true);	
			}
		}
			//Remove
		else if player_input_str == "R" || player_input_str == "REMOVE" {
			
			if scr_check_char_type_enum_in_ar(global.pc_char_ar,cursor_pos) == true {
				
				var char_index = scr_return_char_type_index_in_ar(global.pc_char_ar,cursor_pos);
				
				if char_index != -1 {
					
					scr_add_remove_char_room_ar(global.pc_char_ar[char_index].cur_room_id,global.pc_char_ar[char_index],false);
					
					var deleted_char_name = global.pc_char_ar[char_index].name;
					
					scr_delete_val_from_ar(global.pc_char_ar,global.pc_char_ar[char_index]);
					
					scr_add_str_to_dialogue_ar($"{deleted_char_name} has been removed from the party.",true);
				} else {
					scr_add_str_to_dialogue_ar("DEBUG: o_con step event: parsing player_input_str in game_stae choose char for 'R' or 'REMOve': scr_return_char_type_index_in_ar returned TRUE, but scr_return_char_type_index_in_ar returned -1, something went wrong.");	
				}
			} else {
				scr_add_str_to_dialogue_ar("This character is not yet in your party.",true);	
			}
		}
		
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

else if global.cur_game_state >= game_state.main_game {
	
	#region Logic for left side window:
	
	/*
	if keyboard_check_released(vk_up) || keyboard_check_released(vk_down) && global.wait {
		
		scr_reset_wait();
		
		if keyboard_check_released(vk_up) cursor_pos--;
		else cursor_pos++;
		
		var ar_to_use = -1;
		
		//Cap:
		if cursor_pos < 0 cursor_pos = array_length(ar_to_use)-1;
		else if cursor_pos >= array_length(ar_to_use) cursor_pos = 0;
	}
	*/
	
	if keyboard_check_released(vk_enter) && global.wait {
		
		scr_reset_wait();
		
		//Parse player_input_str:
		
		//So there is a log of what the player is typing, add it to the last index of our g.dialogue_ar:
		global.dialogue_ar[array_length(global.dialogue_ar)-1] += string(player_input_str);
		
		//Format our string:
		player_input_str = string(player_input_str);
		player_input_str = string_upper(player_input_str);
		player_input_str = string_trim(player_input_str);
		
		//Parse player_input_str
			//Add, start game:
		if player_input_str == "W" || player_input_str == "WEST" || player_input_str == "N" || player_input_str == "NORTH" || player_input_str == "E" ||
		player_input_str == "EAST" || player_input_str == "S" || player_input_str == "SOUTH" {
			
			var move_dir_x = 0, move_dir_y = 0, directional_macro = -1, move_str = "undefined";
			
			if player_input_str == "W" || player_input_str == "WEST" { move_dir_x = -1; directional_macro = DOOR_DIR_W; move_str = "WEST"; }
			if player_input_str == "N" || player_input_str == "NORTH" { move_dir_y = -1; directional_macro = DOOR_DIR_N; move_str = "NORTH"; }
			if player_input_str == "E" || player_input_str == "EAST" { move_dir_x = 1; directional_macro = DOOR_DIR_E; move_str = "EAST"; }
			if player_input_str == "S" || player_input_str == "SOUTH" { move_dir_y = 1; directional_macro = DOOR_DIR_S; move_str = "SOUTH"; }
			
			//Check to see if that's a valid direction sides:
			var directional_struct = global.cur_char.cur_room_id.directional_ar[directional_macro];
			
			//Move:
			if directional_struct.door_enum == door_state.unlocked || directional_struct.door_enum == door_state.destroyed {
				
				//Remove from current room:
				scr_add_remove_char_room_ar(global.cur_char.cur_room_id,global.cur_char,false);
				//Update x and y vars:
				global.cur_char.cur_grid_x += move_dir_x;
				global.cur_char.cur_grid_y += move_dir_y;
				//Update cur_room_id:
				global.cur_char.cur_room_id = global.cur_grid[# global.cur_char.cur_grid_x,global.cur_char.cur_grid_y];
				//Add to next room:
				scr_add_remove_char_room_ar(global.cur_char.cur_room_id,global.cur_char,true);
				
				//Update corresponding char_sprite instance:
				scr_position_char_sprite_in_room(global.cur_char.cur_room_id);
				
				//Display move result:
				scr_add_str_to_dialogue_ar($"{global.cur_char.name} moves {move_str}.");
				scr_add_str_to_dialogue_ar(" ");
				scr_print_char_new_room_text(global.cur_char);
			}
			else{
				scr_add_str_to_dialogue_ar("You cannot move in that direction, try again.",true);	
			}
			
		}
		
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
				scr_zoom_on_inst_or_coord(zoom_on_cur_char, global.cur_char,global.map_cam,global.cur_zoom_val,-1,-1);	
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



