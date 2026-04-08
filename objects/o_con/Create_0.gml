/// @description o_con Create event

randomize();

global.unique_struct_id_num = 0;

global.cell_size = 264;
global.half_c = global.cell_size / 2;
global.grid_offset_x = 0;
global.grid_offset_y = 0;

global.cur_game_state = game_state.initializing_game;
cur_main_menu_option = main_menu_options.main;

scr_define_macros_and_enums();

scr_define_structs();

main_menu_str_ar = ["Start New Game\n", "Continue Game\n", "Options\n", "Exit\n"];

party_limit = 2;

global.pc_char_ar = [];
global.enemy_char_ar = [];
global.neutral_char_ar = [];
global.enemy_mob_ar = []; //A nested array filled with arrays of enemies.

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
global.left_window_width = global.win_w * global.left_win_w_percent;

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
global.max_player_inv = 20; //12; //23; //Just my observation with this current font-window size etc. how many fit.

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

//scr_define_global_and_con_data(); //moved to alarm2

global.acting_char_struct_id = -1;

global.reset_full_screen_val = game_get_speed(gamespeed_fps) * 5;
 global.reset_full_screen_count =  global.reset_full_screen_val;
d($"reset_full_screen_count: {global.reset_full_screen_count}");

alarm[2] = 1; //Setup all of our 'initialization' data: grids, world maps, cur_grid variables, character selection data, etc.

//Define a lot of 'content' type data like string arrays, etc.
global.resources_food = 0;
global.resources_scrap = 8; // 0;
global.resources_basic_tech = 0;
global.resources_advanced_tech = 0;
global.resources_engine_fuel = 0;
global.resources_ammo = 15;

global.wait = false;
global.wait_time = 2;

scr_reset_wait();

//A Star path finding vars:

origin_x = -1;
origin_y = -1;
dest_x = -1;
dest_y = -1;
pather_x = -1;
pather_y = -1;

failsafe_val = 0;
failsafe_max = 100000; //ds_grid_width(global.cur_grid)*ds_grid_height(global.cur_grid)+1;

path_points_ar = [];

directional_ar = [];
for(var i = 0; i < 8; i++) {
	if i == 0 {
		array_push(directional_ar,{ check_dir_x : -1, check_dir_y : 0 }); //west	
	}
	else if i == 1 {
		array_push(directional_ar,{ check_dir_x : 0, check_dir_y : -1 }); //north	
	}
	else if i == 2 {
		array_push(directional_ar,{ check_dir_x : 1, check_dir_y : 0 }); //east	
	}
	else if i == 3 {
		array_push(directional_ar,{ check_dir_x : 0, check_dir_y : 1 }); //south	
	}
	else if i == 4 {
		array_push(directional_ar,{ check_dir_x : -1, check_dir_y : -1 }); //NW	
	}
	else if i == 5 {
		array_push(directional_ar,{ check_dir_x : 1, check_dir_y : -1 }); //NE	
	}
	else if i == 6 {
		array_push(directional_ar,{ check_dir_x : 1, check_dir_y : 1 }); //SE	
	}
	else if i == 7 {
		array_push(directional_ar,{ check_dir_x : -1, check_dir_y : 1 }); //SW	
	}
}

global.plotting_path = false;

global.path_successful = false;

cur_enemy_mob_index = 0;
cur_enemy_mob_struct = -1;

global.total_turn_counter = 1;

//Combat vars:
global.combat_rank_ar = -1; //A nested array
global.combat_initiative_ar = -1;
global.cur_combat_round = 0;
global.cur_combat_char = -1;

next_combat_game_state = -1;
next_combat_char = -1;

global.passing_item_boolean = false;

prev_game_state = -1;

global.combat_prep_phase = false;
global.combat_begun = false;

global.item_reference_table = []; //Contains an instantiated struct for each item; defined in alarm[2]; these item structs are mainly referenced in the char selection screen and when enemies are using their 'abilities' in combat.

avail_weps_or_abils_list = -1; //Is used as an array
global.fleeing_combat_char_id = -1;
global.char_is_fleeing_bool = false; //where is this reset?

char_id_after_char_flees = -1;

global.cur_combat_char_index = 0;

char_spr_w = sprite_get_width(asset_get_index("spr_pc"));
char_spr_h = sprite_get_height(asset_get_index("spr_pc"));

max_char_sprites_per_room = 6;

//Overwatch vars:
global.target_id_of_overwatch_fire = -1;
global.overwatch_mode_enabled = false;
overwatch_attackers_ar = [];
global.overwatch_rank_ar = [];
global.overwatch_attacker_index = -1;
overwatch_attackers_ar = -1;
scr_reset_global_overwatch_ar();

global.choosing_neutral_char = false;

changing_neutral_id_owner = -1;
prev_follow_ar_of_neutral = -1;
new_neutral_owner_id = -1;

filtered_targets_ar_for_item_or_abil = -1;

global.just_view_combat_init_order = false;

hidden_chars_in_room_ar = -1; //Since we only use this in init_combat game state after calling scr_check_combat_start, it's not necessary to keep track of in every room struct.

local_party_ar = -1;

moving_party_ar = -1;

party_moving_dir_x = -1;
party_moving_dir_y = -1;
party_moing_dir_str = "";



