
function scr_center_map_window(grid_x, grid_y, cam_to_center, debug_str = undefined)
{
	if is_undefined(debug_str) debug_str = "UNDEFINED";
	
	var map_x = grid_x * global.cell_size + global.half_c;
	var map_y = grid_y * global.cell_size + global.half_c;
	
	var _visible_center_x = (window_get_width() * 0.25) + (window_get_width() * 0.75) / 2;
	var _visible_center_y = (window_get_height() * 0.40) / 2;

	var _cam_x = map_x - _visible_center_x;
	var _cam_y = map_y - _visible_center_y;

	var _cam_w = camera_get_view_width(cam_to_center);
	var _cam_h = camera_get_view_height(cam_to_center);

	_cam_x = clamp(_cam_x, 0, room_width - _cam_w);
	_cam_y = clamp(_cam_y, 0, room_height - _cam_h);

	camera_set_view_pos(cam_to_center, _cam_x, _cam_y);
}