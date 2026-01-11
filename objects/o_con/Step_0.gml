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
	
	/*
	if keyboard_check_released(vk_up) || keyboard_check_released(vk_down) {
		
		if keyboard_check_released(vk_up) cursor_pos--;
		else cursor_pos++;
		
		//Cap:
		if cursor_pos < 0 cursor_pos = array_length(ar_to_draw)-1;
		else if cursor_pos >= array_length(ar_to_draw) cursor_pos = 0;
	}
	*/
	
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
		
		cursor_pos = 0; //Reset
	}
}

#endregion

//Camera functions:
//if global.cur_game_state == game_state.main_game {
	
	var win_mouse_y = window_mouse_get_y(), win_mouse_x = window_mouse_get_x();
	
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
		
			d($"global.cur_zoom_val: {global.cur_zoom_val}")
		}
	}
//}






