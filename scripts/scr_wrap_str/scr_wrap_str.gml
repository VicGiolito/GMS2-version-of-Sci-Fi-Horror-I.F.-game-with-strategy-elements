
//This is just a less efficient, less robust, and (probably) less accurate version of draw_text_ext()

function scr_wrap_str(str_to_wrap,max_str_len){
	
	var accumulated_str_pixel_w = 0;
	
	if is_array(str_to_wrap) {
		var str = "";
		for(var i = 0; i < array_length(str_to_wrap); i++) {
			str += str_to_wrap[i];
		}
		
		str_to_wrap = str;
	}
	
	var char_at_ind;
	for(var i = 1; i < string_length(str_to_wrap); i++){
		
		accumulated_str_pixel_w += string_width(string_char_at(str_to_wrap,i));
		
		if accumulated_str_pixel_w == max_str_len {
			char_at_ind = string_char_at(str_to_wrap,i);
			if char_at_ind == " " {
				string_insert(str_to_wrap,"\n",i);	
				accumulated_str_pixel_w = 0; //Reset
			} else {
				//start iterating back until we find a empty space:
				for(var backward_i = i; backward_i >= 1; backward_i--){
					char_at_ind = string_char_at(str_to_wrap,backward_i);	
					if char_at_ind == " " {
						str_to_wrap = string_insert(str_to_wrap,"\n",backward_i);
						var substring = string_copy(str_to_wrap, backward_i, i);
						accumulated_str_pixel_w = string_width(substring);
						break;
					}
				}
			}
		}
	}
	
	return str_to_wrap;
}