/// @description Alarm 1 - center and zoom cam:

//We want to position our camera to center on the upper window:
	//This positions the cam in the middle of the screen, not what we want...
	
var center_of_upper_win_x = global.origin_grid_x*global.cell_size - (camera_get_view_width(global.map_cam) / 2);
var center_of_upper_win_y = global.origin_grid_y*global.cell_size - (camera_get_view_height(global.map_cam) / 2);

//var center_of_upper_win_x = global.origin_grid_x-global.center_x_of_upper_window;
//var center_of_upper_win_y = global.origin_grid_y-global.center_y_of_upper_window;;

scr_center_cam(false,-1,center_of_upper_win_x,center_of_upper_win_y,global.map_cam,"o_con create event: alarm 0: center cam for first time.");

//Move up and to the right - you'll need to scale these 'cell_sizes' in order for this to work in different resolutions
center_of_upper_win_y += global.cell_size*3;
center_of_upper_win_x -= global.cell_size;
scr_center_cam(false,-1,center_of_upper_win_x,center_of_upper_win_y,global.map_cam,"o_con create event: alarm 0: center cam for first time.");





