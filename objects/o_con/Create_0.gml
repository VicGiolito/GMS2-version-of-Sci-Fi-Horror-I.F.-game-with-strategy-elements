/// @description o_con Create event

global.cell_size = 32













global.cam_move_spd = 16;

global.win_h = 1024;
global.win_w = 768;

global.cam_center_offset_y = global.cell_size*3; //We add a bit of extra height to some camera center functions to account for the fact that the txt_dialogue screen is taking up the lower half of the screen

global.cur_zoom_val = 1; //This is the zoom value that is used in our camera functions when zooming in or out.
global.zoom_val = 0.25; //This is the value that increments or decreases our cur_zoom_val

//Our main_map cam:
scr_setup_cam_view(true,true,global.win_w,global.win_h,0,0,0,0);











