
function scr_grab_and_drag_cam(cam_id){
	
	#region grab and drag camera
	
	//ai claude version:
	
	//Gather and set vars:
	if mouse_check_button_pressed(mb_middle) {
	    // Reset global vars - store the window mouse position as anchor:
	    global.cam_grab_origin_x = window_mouse_get_x();
	    global.cam_grab_origin_y = window_mouse_get_y();
	}

	// "drag" camera position while holding down the mouse button:
	if mouse_check_button(mb_middle) {
	    //Get current mouse coordinates within the window:
		var win_mouse_x = window_mouse_get_x();
	    var win_mouse_y = window_mouse_get_y();
    
	    // Calculate the difference in window coordinates - both variables are in window_coordinates so this is possible:
	    var mouse_diff_x = global.cam_grab_origin_x - win_mouse_x;
	    var mouse_diff_y = global.cam_grab_origin_y - win_mouse_y;
    
	    // Convert window coordinate difference to room coordinate difference:
	    var room_diff_x = mouse_diff_x * (camera_get_view_width(cam_id) / window_get_width());
	    var room_diff_y = mouse_diff_y * (camera_get_view_height(cam_id) / window_get_height());
    
	    // Get current camera position and add the scaled difference:
	    var current_cam_x = camera_get_view_x(cam_id);
	    var current_cam_y = camera_get_view_y(cam_id);
    
	    // Move camera:
	    camera_set_view_pos(cam_id, current_cam_x + room_diff_x, current_cam_y + room_diff_y);
    
	    // Update anchor point to current mouse position for smooth dragging:
	    global.cam_grab_origin_x = win_mouse_x;
	    global.cam_grab_origin_y = win_mouse_y;
	}
	
	#endregion
	
}