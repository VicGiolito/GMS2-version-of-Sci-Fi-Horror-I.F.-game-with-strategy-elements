
/* What we want to do with this script is take a string, and each time its pixel width exceeds our
defined parameter, we break it into a new index in an array, then return that array.

*/

function scr_format_str_into_ar(str_to_format,max_str_len){
	
	var formatted_str_ar = [];
	
	var accumulated_str_pixel_w = 0;
	
	//If this is already an array, flatten it into a string before proceeding:
	if is_array(str_to_format) {
		var str = "";
		for(var i = 0; i < array_length(str_to_format); i++) {
			str += str_to_format[i];
		}
		
		str_to_format = str;
	}
	
	var char_at_ind, start_i = 1;
	for(var i = 1; i <= string_length(str_to_format); i++){
		
		accumulated_str_pixel_w += string_width(string_char_at(str_to_format,i));
		
		if accumulated_str_pixel_w >= max_str_len {
			
			char_at_ind = string_char_at(str_to_format,i);
			
			if char_at_ind == " " {
				
				var substring = string_copy(str_to_format,start_i,i);
				
				array_push(formatted_str_ar,substring);
				
				start_i = i+1; //Adjust
				
				accumulated_str_pixel_w = 0; //Reset
			} 
			else {
				//start iterating back until we find a empty space:
				for(var backward_i = i; backward_i >= 1; backward_i--){
					
					char_at_ind = string_char_at(str_to_format,backward_i);	
					
					if char_at_ind == " " {
						
						var substring = string_copy(str_to_format,start_i,backward_i);
				
						array_push(formatted_str_ar,substring);
				
						start_i = backward_i+1; //Adjust
				
						accumulated_str_pixel_w = 0; //Reset
						
						i = start_i;
						
						break;
					}
				}
			}
		}
	}
	
	return formatted_str_ar;
}