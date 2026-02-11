
function scr_return_ar_str_height(ar_to_pass){

	var total_str_h = 0;
	
	for(var i = 0; i < array_length(ar_to_pass); i++) {
		total_str_h += string_height_ext(ar_to_pass[i],global.default_line_h,global.default_dialogue_screen_max_text_w)
	}
	
	return total_str_h;

}