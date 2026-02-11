// In your scr_resize_game_window or setup script
function scr_resize_game_window_with_letterbox(display_w, display_h) {
    var base_w = 640;
    var base_h = 360;
    var aspect = base_w / base_h; // 16:9 = 1.777...
    
    // Calculate the largest possible viewport that maintains aspect ratio
    var view_w = display_w;
    var view_h = display_h;
    
    if (display_w / display_h > aspect) {
        // Display is wider - add pillarboxing (black bars on sides)
        view_w = display_h * aspect;
    } else {
        // Display is taller - add letterboxing (black bars on top/bottom)
        view_h = display_w / aspect;
    }
    
    // Center the viewport
    var view_x = (display_w - view_w) / 2;
    var view_y = (display_h - view_h) / 2;
    
    // Set up the camera/view
    camera_set_view_size(view_camera[0], base_w, base_h);
    camera_set_view_pos(view_camera[0], 0, 0);
    
    // Set the viewport (where on screen the view is drawn)
    view_set_wport(0, view_w);
    view_set_hport(0, view_h);
    view_set_xport(0, view_x);
    view_set_yport(0, view_y);
    
    // Set window/display size
    window_set_size(display_w, display_h);
    
    if (display_w == display_get_width() && display_h == display_get_height()) {
        window_set_fullscreen(true);
    }
}