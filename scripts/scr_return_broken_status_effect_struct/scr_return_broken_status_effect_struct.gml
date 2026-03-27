

function scr_return_broken_status_effect_struct(char_struct_id, broken_staus_effect_enum){
	
	if is_array(char_struct_id.broken_morale_ar) && array_length(char_struct_id.broken_morale_ar) > 0 {
		
		for(var i = 0; i < array_length(char_struct_id.broken_morale_ar); i++) {
			if char_struct_id.broken_morale_ar[i].broken_morale_status_effect_enum == broken_staus_effect_enum {
				return char_struct_id.broken_morale_ar[i];	
			}
		}
	}
	
	return -1;
}