

function scr_filter_ar_for_movement_party(ar_to_check){
	
	var new_ar = [];
	
	if is_array(ar_to_check) && array_length(ar_to_check) > 0 {
	
		var ar_len = array_length(ar_to_check), char_struct_id;
	
		for(var i = 0; i < ar_len; i++) {
			
			char_struct_id = ar_to_check[i];
			
			if is_struct(char_struct_id) && char_struct_id.struct_type_enum == struct_type.Character {
				if char_struct_id.move_points_cur > 0 {
					array_push(new_ar,char_struct_id);	
				}
			}
			
		}
	}
	
	return new_ar;
}