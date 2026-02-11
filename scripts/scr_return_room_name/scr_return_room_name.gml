
function scr_return_room_name(room_struct_id){
	
	var room_name_str = "undefined";
	
	if is_struct(room_struct_id) {
	
		if room_struct_id.struct_type_enum == struct_type.Room {
	
			room_name_str = room_struct_id.room_name_str;
		
		}
	}
	
	return room_name_str;
}