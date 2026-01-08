/// @description o_con step event

#region Basic debug functions:

if keyboard_check_released(vk_escape) {
	game_end();
}

if keyboard_check_released(vk_f1) {
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

#region game_state == main_menu:

if global.cur_game_state == game_state.main_menu {
	
	/*
	if keyboard_check_released(vk_up) || keyboard_check_released(vk_down) {
		
		if keyboard_check_released(vk_up) cursor_pos--;
		else cursor_pos++;
		
		//Cap:
		if cursor_pos < 0 cursor_pos = array_length(main_menu_str_ar)-1;
		else if cursor_pos >= array_length(main_menu_str_ar) cursor_pos = 0;
	}
	*/
}

#endregion

//Camera functions:

var cam_dir_x = 0, cam_dir_y = 0, cam_key_pressed = false;
var win_mouse_y = window_mouse_get_y();

if(keyboard_check(vk_left)) { cam_dir_x = global.cam_move_spd*-1; cam_key_pressed = true; }
if(keyboard_check(vk_right)) { cam_dir_x = global.cam_move_spd; cam_key_pressed = true; }
if(keyboard_check(vk_up)) { cam_dir_y = global.cam_move_spd*-1; cam_key_pressed = true; }
if(keyboard_check(vk_down)) { cam_dir_y = global.cam_move_spd; cam_key_pressed = true; }

if(cam_key_pressed) {
	scr_move_cam(global.map_cam,cam_dir_x,cam_dir_y);
}

//Zoom in or out on mouse coordinates:
if win_mouse_y > global.bottom_window_y {
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
		if global.cur_zoom_val > 4 global.cur_zoom_val = 4;
	
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
	}
}








