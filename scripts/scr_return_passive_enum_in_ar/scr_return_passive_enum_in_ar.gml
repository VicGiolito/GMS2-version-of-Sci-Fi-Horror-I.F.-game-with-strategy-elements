

function scr_return_passive_enum_in_ar(ar_to_check, passive_abil_enum){
	
	if is_array(ar_to_check) && array_length(ar_to_check) > 0 {
		
		var ar_len = array_length(ar_to_check);
		
		for(var i = 0; i < ar_len; i++) {
			if ar_to_check[i] == passive_abil_enum return true;	
		}
	}
	
	return false;
}