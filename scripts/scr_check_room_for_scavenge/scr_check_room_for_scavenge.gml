

function scr_check_room_for_scavenge(room_struct_id){
	
	if is_array(room_struct_id.scavenge_ar) {
		
		var ar_len = array_length(room_struct_id.scavenge_ar);
		
		if ar_len >= scavenge_resource.total_resources {
			return true;	
		}
		
		for(var i = 0; i < ar_len; i++) {
			
			var scavenge_val = room_struct_id.scavenge_ar[i];
			
			if scavenge_val > 0 || is_struct(scavenge_val) return true;
		}	
	}
	
	return false;
}