
//Only checks to see if its there and returns a boolean var of true if it is, false if its not

function scr_check_char_type_enum_in_ar(ar_id,char_enum){
	
	var ar_len = array_length(ar_id), char_id;
	for(var i = 0; i < ar_len; i++) {
		char_id = ar_id[i];
		
		if is_struct(char_id) {
			if char_id.struct_type_enum == struct_type.Character && char_id.char_type_enum == char_enum {
				return true;
			}
		}
	}
	
	return false;
}