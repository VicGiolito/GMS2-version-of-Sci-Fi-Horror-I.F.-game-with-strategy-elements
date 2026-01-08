/// @description o_con draw gui event

#region Account for out 'letter boxing':

//Get the GUI dimensions
var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

//d($"gui_width = {gui_width}, gui_height = {gui_height}")

// Your game's internal resolution
var game_width = global.win_w;
var game_height = global.win_h;

// Calculate offset for letterboxing
var gui_offset_x = (gui_width - game_width) / 2;
var gui_offset_y = (gui_height - game_height) / 2;

#endregion

//Constantly reset full screen:

if window_get_fullscreen() == false {
	window_set_fullscreen(true);	
}

global.reset_full_screen_count--;

if global.reset_full_screen_count <= 0 {
	
	window_set_fullscreen(true);

	d("FUCKING RESET FUCLL SCREEN TO FULL BITCH!")


	global.reset_full_screen_count =  global.reset_full_screen_val;
}

var win_w = window_get_width(), win_h = window_get_height();

//Draw our background color over the lsb monitor and lower monitor to mask the actual game room.
	//Mask left window:
/*
draw_rectangle_color(0,0,global.left_window_x,global.win_h,global.bg_monitor_c,global.bg_monitor_c,global.bg_monitor_c,global.bg_monitor_c,false);
	//Mask bottom window:
draw_rectangle_color(global.left_window_x,global.bottom_window_y,global.win_w,global.win_h,global.bg_monitor_c,global.bg_monitor_c,global.bg_monitor_c,global.bg_monitor_c,false);
*/

//Draw our foreground UI, in any game state:
draw_sprite_ext(spr_foreground_UI,0,gui_offset_x,gui_offset_y,2,2,0,c_white,1);

#region game_state == MAIN MENU:

if global.cur_game_state == game_state.main_menu {
	
	draw_set_valign(fa_middle)
	
	//Draw in upper left so we can use some kind of transition effect to immediately start drawing our
	//intro text in the middle of the screen, after we create an ellipse ... and the main game options
	//text slowly blinks out...
	var origin_x = gui_offset_x+global.cell_size*2, origin_y = gui_offset_y+global.cell_size*2;
	var y_offset = string_height(main_menu_str_ar[0])+4
	
	for(var i = 0; i < array_length(main_menu_str_ar); i++) {
		draw_text(origin_x,origin_y+(i * y_offset),string(main_menu_str_ar[i]) );
	}
	
	//Draw cursor:
	draw_sprite(spr_main_menu_cursor,0,origin_x-(sprite_get_width(asset_get_index("spr_main_menu_cursor")))-8, origin_y+(cursor_pos*y_offset) );

	scr_reset_font_align()
}
#endregion







