

function scr_check_room_for_scavenge(room_struct_id){
	
	d("Entering scr_check_room_for_scavenge...");
	
	if is_array(room_struct_id.scavenge_ar) {
		
		var ar_len = array_length(room_struct_id.scavenge_ar);
		
		if ar_len >= scavenge_resource.total_resources {
			d("scr_check_room_for_scavenge: ar_len >= scavenge_resource.total_resources, returning true." );
			return true;	
		}
		
		for(var i = 0; i < ar_len; i++) {
			
			var scavenge_val = room_struct_id.scavenge_ar[i];
			
			if scavenge_val >= 0 {
				d($"scr_check_room_for_scavenge: scavenge_val == {scavenge_val}, returning true." );	
				return true;
			}
		}	
	}
	
	d($"scr_check_room_for_scavenge: returning false.");
	return false;
}