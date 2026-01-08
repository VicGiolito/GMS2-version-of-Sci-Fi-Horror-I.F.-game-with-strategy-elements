
function scr_setup_cam_view(init_boolean,full_screen_boolean,win_w,win_h,view_x_port,view_y_port,cam_x_port,cam_y_port)
{
	if !view_enabled view_enabled = true;
	
	/*IMPORTANT NOTE!!: Whenever starting a new project and changing the
	views and cameras in any way, you need to go into the game's global
	settings and change the aspect ratio to "FULL SCALE", rather than "Maintain
	aspect ratio"; this is the reason why you will see the black bars on
	the sides of the screen as though the window and cam width are not
	set properly; this fucking bullshit has bit me in the ass every single
	goddamn time, so I am making a note of it now. Take heed!
	
	A note on 'maintain aspect ratio' vs 'full scale': maintain aspect ratio creates the 'letterboxed'
	effect if your window resolution doesn't match your monitor's resolution. That's why you'll see the
	black bars on the sides or top of the screen. If that's something you want, then 'maintain aspect
	ratio' is actually ideal.
	
	REMEMBER: Camera coordinates align with ROOM coordinates;
	View port coordinates align with WINDOW coordinates;
	*/
	
	//full_screen_boolean whether or not we are running this in full screen or not

	if init_boolean
	{
		//Set our window size: default is 1024w 768h for now:
		if !full_screen_boolean window_set_size(win_w,win_h);
		
		//Set for full screen mode:
		else
		{
			window_set_fullscreen(true);
		}
		
		//Create our cameras for main world game:
		global.map_cam = camera_create_view(cam_x_port,cam_y_port,win_w,win_h);
		global.map_view_port = 0;
	}
	
	//In any case, setup camera and view vars:
	view_enabled = true;

	//Main map Cam:
	view_visible[global.map_view_port] = true;
	view_camera[global.map_view_port] = global.map_cam;
	view_xport[global.map_view_port] = view_x_port;
	view_yport[global.map_view_port] = view_y_port;
	view_wport[global.map_view_port] = win_w;
	view_hport[global.map_view_port] = win_h;

	
	//Setup our camera view border and camera view speed - these will only be used when the 
	//camera has been assigned an instance to follow:
	camera_set_view_border(global.map_cam,win_w div 2,win_h div 2);
	camera_set_view_speed(global.map_cam,-1,-1);

	//show_debug_message("scr_setup_cam_views: defining our g.combat_room_cam variables now: ");
	
	//We want our GUI to match window and cam size:
	display_set_gui_size(win_w,win_h)
	display_set_gui_maximize();
	
} //Closed bracket for end of script