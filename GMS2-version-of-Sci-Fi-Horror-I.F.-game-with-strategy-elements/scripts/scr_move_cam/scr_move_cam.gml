
//cam_to_move == cam_id

function scr_move_cam(cam_to_move, move_amount_x, move_amount_y)
{
	var cam_x = camera_get_view_x(cam_to_move), cam_y = camera_get_view_y(cam_to_move);
		
	camera_set_view_pos(cam_to_move,cam_x+move_amount_x,cam_y+move_amount_y);
	
	//d("MOVING FUCKING CAM!");
} 