function scr_set_cam_follow(cam_id,inst_id)
{
	if !is_undefined(inst_id) {
		if inst_id == noone {
			camera_set_view_target(global.map_cam,noone); //Camera will stop following it's previous target.
			exit;
		}
		else if instance_exists(inst_id) {
			camera_set_view_target(cam_id,inst_id);
		} else show_debug_message("scr_set_cam_follow: inst_id does not exist");
	} else show_debug_message("scr_set_cam_follow: inst_id == undefined");
}