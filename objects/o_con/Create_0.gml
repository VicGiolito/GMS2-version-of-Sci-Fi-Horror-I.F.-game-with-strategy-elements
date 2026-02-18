/// @description o_con Create event

randomize();

global.cell_size = 264;
global.half_c = global.cell_size / 2;
global.grid_offset_x = 0;
global.grid_offset_y = 0;

global.cur_game_state = game_state.main_menu;
cur_main_menu_option = main_menu_options.main;

scr_define_macros_and_enums();

scr_define_structs();

main_menu_str_ar = ["Start New Game\n", "Continue Game\n", "Options\n", "Exit\n"];

party_limit = 3;

global.pc_char_ar = [];
global.enemy_char_ar = [];
global.neutral_char_ar = [];

global.cur_char_index = 0;

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

global.foreground_ui_scale = 6;

spr_icon_offset_x = sprite_get_width(asset_get_index("spr_hazard_electrical")) / 2;
spr_icon_offset_y = sprite_get_height(asset_get_index("spr_hazard_electrical"));
spr_icon_w = sprite_get_width(asset_get_index("spr_hazard_electrical"));
spr_icon_h = sprite_get_height(asset_get_index("spr_hazard_electrical"));


#region ds_maps:

//Defines cur_grid_w and h and specific grid ids:
scr_build_map_from_csv_file(location.research_vessel);

global.cur_grid = global.research_vessel_grid;

global.cur_grid_w = ds_grid_width(global.cur_grid);
global.cur_grid_h = ds_grid_height(global.cur_grid);

//Our 'stasis room' where players spawn:
global.origin_grid_x = 5;
global.origin_grid_y = 8;

global.tile_main_lay_id = layer_tilemap_get_id(layer_get_id("tile_main"));
global.tile_doors_lay_id = layer_tilemap_get_id(layer_get_id("tile_doors"));
global.tile_fow_lay_id = layer_tilemap_get_id(layer_get_id("tile_fow"));

#endregion

#region Cameras and views:

global.cam_move_spd = 16;
global.cam_grab_origin_x = 0;
global.cam_grab_origin_y = 0;

global.win_w = 1920;
global.win_h = 1200;

//Positional vars:
global.top_and_bottom_w_percent = .75;
global.lower_win_h_percent = .6;
global.left_win_w_percent = .25;
global.top_win_h_percent = .4;

global.left_window_x = global.win_w * global.left_win_w_percent; 
global.bottom_window_y = global.win_h * global.top_win_h_percent;
global.top_win_h = global.win_h * global.top_win_h_percent;
global.bottom_win_h = global.win_h * global.lower_win_h_percent;
d($"o_con create event: g.bottom_win_h = {global.bottom_win_h}");

global.bottom_and_top_win_w = global.win_w * global.top_and_bottom_w_percent;
global.center_x_of_upper_window = global.left_window_x+(global.bottom_and_top_win_w / 2);
global.center_y_of_upper_window = global.win_h * .2;

global.lower_window_txt_buffer_x = 32;
global.lower_window_txt_buffer_y = 32;
global.lower_dialogue_window_txt_origin_x = global.left_window_x+(global.lower_window_txt_buffer_x);
global.lower_dialogue_window_txt_origin_y = global.top_win_h+(global.lower_window_txt_buffer_y);

global.left_window_text_offset_x = 64;
global.left_window_text_offset_y = 64;

global.max_abilities = 6;
global.max_player_inv = 31 - global.max_abilities+1; //Most just a constraint of many lines I can fit in the left window


d($"global.center_x_of_upper_window: {global.center_x_of_upper_window}, global.center_y_of_upper_window: {global.center_y_of_upper_window}");

global.cur_zoom_val = 1; //This is the zoom value that is used in our camera functions when zooming in or out.
global.zoom_val = 0.25; //This is the value that increments or decreases our cur_zoom_val

//Create our cameras for main world game:
global.cam_w = 1920;
global.cam_h = 1200;

scr_setup_cam_view(true,false,global.win_w,global.win_h,0,0,0,0);

#endregion

sample_text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

global.default_dialogue_screen_max_text_w = global.bottom_and_top_win_w-(global.lower_window_txt_buffer_x*3);

cursor_pos = 0;

#region Defunct - Define tilemap from grid structs:

//scr_define_tilemap_from_grid_structs(global.cur_grid);

#endregion

#region Define all our dialogue window vars:

//Variables for main dialogue box (lower right side window):

//Every new string element in our dialogue_ar is a NEW LINE.
global.dialogue_ar = [];

dialogue_window_width = 0; //These vars are updated in step event
dialogue_window_height = 0;
dialogue_window_x = 0;
dialogue_window_y = 0;

scrollbar_right_edge_offset_x = 32;
scrollbar_right_edge_offset_y = 32;

global.tab_spaces_count = 6;

//0 == top, increases as you scroll down
global.scroll_position = 0;
global.max_scroll = 0;
global.dialogue_line_h = string_height("ABCDEFGHIJKLMNOPQRSTUVWXYZ");

//Scroll bar settings:
global.scrollbar_width = 15;
global.scrollbar_color = make_color_rgb(180,180,180); //A light gray
global.scrollbar_button_color = make_color_rgb(220,220,220); //An even lighter gray
global.scrollbar_button_height = 50; //Minimum height of the slider button.

//Scrollbar interaction:
global.scrollbar_dragging = false;
global.scrollbar_drag_offset = 0;

//Mouse wheel scroll speed:
global.scroll_speed = 3;

// Text input cursor variables
blinking_cursor_x = 0;
blinking_cursor_y = 0;
cursor_blink_timer = 0;
cursor_blink_speed = 30;  // Blink every 30 frames (0.5 seconds at 60fps)
cursor_visible = true;

player_input_str = "";

#endregion

scr_define_global_and_con_data();

global.cur_char = -1;

global.reset_full_screen_val = game_get_speed(gamespeed_fps) * 10;
 global.reset_full_screen_count =  global.reset_full_screen_val;
d($"reset_full_screen_count: {global.reset_full_screen_count}");

alarm[1] = 1; //center and zoom cam

//Define a lot of 'content' type data like string arrays, etc.
global.resources_food = 0;
global.resources_scrap = 0;
global.resources_basic_tech = 0;
global.resources_advanced_tech = 0;
global.resources_engine_fuel = 0;
global.resources_ammo = 0;

global.wait = false;
global.wait_time = 1;

scr_reset_wait();

//Add our first text to the left side window - we wait so that the step event has a chance to run, and several
//positional vars get a chance to be updated:
alarm[2] = 2;




