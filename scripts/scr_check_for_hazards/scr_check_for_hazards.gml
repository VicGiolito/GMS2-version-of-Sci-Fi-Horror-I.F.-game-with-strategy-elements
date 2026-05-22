

function scr_check_for_hazards(char_struct_id){
	
	var room_struct_id = char_struct_id.cur_room_id;
	
	if is_array(room_struct_id.hazard_ar) && array_length(room_struct_id.hazard_ar) > 0 {
		return true;
	}
	
	return false;
}