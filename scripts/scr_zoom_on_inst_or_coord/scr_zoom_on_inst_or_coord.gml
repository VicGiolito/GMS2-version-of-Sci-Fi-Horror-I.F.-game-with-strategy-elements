
//This script essentially just changes the camera view width and height, then repositions either
//on an instance, or on the coordinates provided.

function scr_zoom_on_inst_or_coord(zoom_on_inst_boolean, zoom_inst,cam_to_zoom, zoom_scale, zoom_x_coord, zoom_y_coord)
{
	//zoom_on_inst_boolean: if true == zoom on inst only, and zoom_x_coord and y can be == w.e (-1); 
	//if false == zoom on room coordinates instead, zoom_inst can == -1 and zoom_x_coord and y must be defined
	
	//Change camera position in room to match our new zoom size:
	if zoom_on_inst_boolean
	{
		//Change camera size to match our new zoom scale:
		camera_set_view_size(cam_to_zoom,(global.win_w*zoom_scale),(global.win_h*zoom_scale) );
		var cam_w = camera_get_view_width(cam_to_zoom);
		var cam_h = camera_get_view_height(cam_to_zoom);
		
		//Reposition cam:
		camera_set_view_pos(cam_to_zoom,zoom_inst.x-(cam_w div 2),zoom_inst.y-(cam_h div 2) );
	}
	
	if !zoom_on_inst_boolean
	{
		//Change camera size to match our new zoom scale:
		camera_set_view_size(cam_to_zoom,(global.win_w*zoom_scale),(global.win_h*zoom_scale) );
		var cam_w = camera_get_view_width(cam_to_zoom);
		var cam_h = camera_get_view_height(cam_to_zoom);
		
		//Reposition cam:
		camera_set_view_pos(cam_to_zoom,zoom_x_coord-(cam_w div 2),zoom_y_coord-(cam_h div 2) );
	}
	
	d("ZOOMING FUCKING CAM!");
}