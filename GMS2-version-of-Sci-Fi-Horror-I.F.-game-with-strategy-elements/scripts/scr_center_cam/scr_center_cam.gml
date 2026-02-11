
function scr_center_cam(center_on_inst_boolean, inst_to_center, room_x, room_y, cam_to_center, debug_str = undefined)
{
	if is_undefined(debug_str) debug_str = "UNSPECIFIED.";
	if center_on_inst_boolean {
		if instance_exists(inst_to_center)
		{
			var cam_w = camera_get_view_width(cam_to_center);
			var cam_h = camera_get_view_height(cam_to_center);
			var xx = inst_to_center.x, yy = inst_to_center.y;
			camera_set_view_pos(cam_to_center,xx-(cam_w div 2),yy-(cam_h div 2));
		
			//show_debug_message("scr_center_on_inst: inst_to_center: "+string(inst_to_center)+" has been centered upon. This script was called from: "+string(debug_str));
		}
		else
		{
			show_debug_message("scr_center_on_inst: inst_to_center: "+string(inst_to_center)+" does not exist. This script was called from: "+string(debug_str));
		}
	} else if !center_on_inst_boolean {
		camera_set_view_pos(cam_to_center,room_x,room_y);	
	}
	
	//show_debug_message("Inst_id: "+string(inst_to_center)+" was just centered with our g.world_map_cam. This script was called from: "+string(debug_str) );
}