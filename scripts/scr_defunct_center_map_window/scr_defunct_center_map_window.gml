
/* Centers the upper map view on to a specific map grid cell.




*/

function scr_defunct_center_map_window(grid_x, grid_y, cam_to_center, debug_str = undefined)
{
	if is_undefined(debug_str) { throw("scr_center_map_window: debug_str was undefined, we don't know where this script was called from."); }
	
	var map_x = grid_x * global.cell_size + global.half_c;
	var map_y = grid_y * global.cell_size + global.half_c;
	
	var _visible_center_x = (window_get_width() * global.left_win_w_percent) + (window_get_width() * global.top_and_bottom_w_percent) / 2;
	var _visible_center_y = (window_get_height() * global.top_win_h_percent) / 2;

	var _cam_x = map_x - _visible_center_x;
	var _cam_y = map_y - _visible_center_y;

	var _cam_w = camera_get_view_width(cam_to_center);
	var _cam_h = camera_get_view_height(cam_to_center);

	_cam_x = clamp(_cam_x, 0, room_width - _cam_w);
	_cam_y = clamp(_cam_y, 0, room_height - _cam_h);

	camera_set_view_pos(cam_to_center, _cam_x, _cam_y);
}