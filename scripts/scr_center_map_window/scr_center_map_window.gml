



function scr_center_map_window(grid_x, grid_y, cam_to_center, debug_str = undefined)
{
    if is_undefined(debug_str) { throw("scr_center_map_window: debug_str was undefined, we don't know where this script was called from."); }

    // Convert grid coords to world-space
    var map_x = grid_x * global.cell_size + global.half_c;
    var map_y = grid_y * global.cell_size + global.half_c;

    // Full camera view size in world space
    var _cam_w = camera_get_view_width(cam_to_center);
    var _cam_h = camera_get_view_height(cam_to_center);

    // The map panel occupies this fraction of the full camera view
    // Left edge of map panel starts after the detail bar
    var _panel_left_frac = global.left_win_w_percent;
    var _panel_w_frac    = global.top_and_bottom_w_percent;
    var _panel_top_frac  = 0.0;
    var _panel_h_frac    = global.top_win_h_percent;

    // Center of the map panel as a fraction of the full camera view
    var _panel_center_frac_x = _panel_left_frac + (_panel_w_frac / 2);
    var _panel_center_frac_y = _panel_top_frac  + (_panel_h_frac / 2);

    // Convert that fraction into world-space units
    var _visible_center_x = _panel_center_frac_x * _cam_w;
    var _visible_center_y = _panel_center_frac_y * _cam_h;

    var _cam_x = map_x - _visible_center_x;
    var _cam_y = map_y - _visible_center_y;

    //_cam_x = clamp(_cam_x, 0, room_width  - _cam_w);
    //_cam_y = clamp(_cam_y, 0, room_height - _cam_h);

    camera_set_view_pos(cam_to_center, _cam_x, _cam_y);
}