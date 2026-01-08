/// @description o_con Create event

randomize();

global.cell_size = 32

global.cur_game_state = game_state.main_menu

scr_define_macros_and_enums()
scr_define_structs()
scr_define_global_and_con_data()

//Fonts and colors:
global.default_fnt = fnt_default_dialogue_screen;
draw_set_font(global.default_fnt);
global.neon_green = make_color_rgb(57, 255, 20); //Neon green
global.light_gray = make_color_rgb(192, 192, 192); // a light gray
//Background for room_main ('monitor screen background') hex val: 1A1A1A.
global.bg_monitor_c = make_color_rgb(26, 26, 26); //A slighty gray black
global.default_fnt_color = global.neon_green;
draw_set_color(global.default_fnt_color);
global.default_line_h = string_height("A");

#region ds_maps:

global.research_vessel_grid = ds_grid_create(64,64);

global.cur_grid = global.research_vessel_grid;

global.cur_grid_w = ds_grid_width(global.cur_grid);
global.cur_grid_h = ds_grid_height(global.cur_grid);

//Iterate through map, adding vacuum everywhere:
for(var xx = 0; xx < ds_grid_width(global.research_vessel_grid); xx++){
	for(var yy = 0; yy < ds_grid_height(global.research_vessel_grid); yy++){
		global.research_vessel_grid[# xx,yy] = new Room(location.research_vessel,research_vessel_room.vacuum,xx,yy,global.research_vessel_grid);
	}
}

//Start building map from inside out:
global.origin_grid_x = global.cur_grid_w div 2;
global.origin_grid_y = global.cur_grid_h div 2;
var cur_grid_x = global.origin_grid_x, cur_grid_y = global.origin_grid_y;

global.research_vessel_grid[# cur_grid_x,cur_grid_y] = new Room(location.research_vessel,research_vessel_room.stasis_chamber,cur_grid_x,cur_grid_y,global.research_vessel_grid);
cur_grid_x--;
global.research_vessel_grid[# cur_grid_x,cur_grid_y] = new Room(location.research_vessel,research_vessel_room.sc_corridor_west,cur_grid_x,cur_grid_y,global.research_vessel_grid);
cur_grid_x += 2;
global.research_vessel_grid[# cur_grid_x,cur_grid_y] = new Room(location.research_vessel,research_vessel_room.sc_corridor_east,cur_grid_x,cur_grid_y,global.research_vessel_grid);

#endregion

#region Cameras and views:

global.cam_move_spd = 16;

global.win_w = 1920;
global.win_h = 1080;

//Positional vars:
global.left_window_x = global.win_w * .25;
global.bottom_window_y = global.win_h * .5;

global.cur_zoom_val = 1; //This is the zoom value that is used in our camera functions when zooming in or out.
global.zoom_val = 0.25; //This is the value that increments or decreases our cur_zoom_val

// Set application surface size
surface_resize(application_surface, 1920, 1080);

//Our main_map cam:
scr_setup_cam_view(true,false,global.win_w,global.win_h,0,0,0,0);

#endregion

global.default_dialogue_screen_max_text_w = global.win_w-(global.cell_size*2);

cursor_pos = 0;

#region Define tilemap from grid structs:

scr_define_tilemap_from_grid_structs(global.cur_grid);

#endregion

global.cur_char = -1;

global.reset_full_screen_val = game_get_speed(gamespeed_fps) * 5;
 global.reset_full_screen_count =  global.reset_full_screen_val;
d($"reset_full_screen_count: {global.reset_full_screen_count}");

alarm[1] = 1; //center and zoom cam







