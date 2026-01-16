

function scr_return_room_desc_str(room_struct_id){
	
	var room_desc_str = "undefined";
	
	if !room_struct_id.powered_boolean && !room_struct_id.main_room_event_already_triggered {
		room_desc_str = room_struct_id.pre_event_unpowered_room_desc;
	}
	else if !room_struct_id.powered_boolean && room_struct_id.main_room_event_already_triggered {
		room_desc_str = room_struct_id.post_event_unpowered_room_desc;
	}
	else if room_struct_id.powered_boolean && !room_struct_id.main_room_event_already_triggered {
		room_desc_str = room_struct_id.pre_event_powered_room_desc;
	}
	else if room_struct_id.powered_boolean && room_struct_id.main_room_event_already_triggered {
		room_desc_str = room_struct_id.post_event_powered_room_desc;
	}
	
	return room_desc_str;
}