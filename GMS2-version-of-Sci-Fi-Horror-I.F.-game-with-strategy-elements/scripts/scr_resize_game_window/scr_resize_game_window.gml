


function scr_resize_game_window(resolution_w,resolution_h){
	
	//Resize window and application surface:
	window_set_size(resolution_w,resolution_h);
	surface_resize(application_surface, resolution_w,resolution_h);

	//Update GUI to match:
	display_set_gui_size(resolution_w,resolution_h)
	display_set_gui_maximize();
}