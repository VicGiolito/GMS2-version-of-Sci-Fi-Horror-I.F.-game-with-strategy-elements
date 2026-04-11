/// @description Setup ds_grids and initial enemy structs

//switch to full screen:
window_set_fullscreen(true);

#region Setup our ds_grids for our world maps, and spawn initial enemy structs:

//Defines cur_grid_w and h and specific grid ids:
array_push(global.level_ar, scr_build_map_from_csv_file(location.research_vessel) );

global.cur_grid = global.research_vessel_grid;

global.cur_grid_w = ds_grid_width(global.cur_grid);
global.cur_grid_h = ds_grid_height(global.cur_grid);

//Our 'stasis room' where players spawn:
global.origin_grid_x = 5;
global.origin_grid_y = 8;

global.tile_main_lay_id = layer_tilemap_get_id(layer_get_id("tile_main"));
global.tile_doors_lay_id = layer_tilemap_get_id(layer_get_id("tile_doors"));
global.tile_fow_lay_id = layer_tilemap_get_id(layer_get_id("tile_fow"));

global.frontier_queue = ds_priority_create(); 

scr_reset_pathing_grids_to_match_grid(global.cur_grid);

scr_define_global_and_con_data();

global.cur_game_state = game_state.main_menu;

//Fill our item reference table with instantiated item structs
global.item_reference_table = -1;
global.item_reference_table = [];
for(var i = 0; i < item_type.total_items; i++) {
	array_push(global.item_reference_table,new global.Item(i));
}

#endregion











