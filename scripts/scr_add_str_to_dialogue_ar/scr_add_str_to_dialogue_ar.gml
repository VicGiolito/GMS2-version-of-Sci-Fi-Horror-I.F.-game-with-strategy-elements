
function scr_add_str_to_dialogue_ar(str_to_add){
	
	var formatted_str = scr_add_spaces_for_tabs(str_to_add);
	
	formatted_str = scr_format_str_into_ar_v2(formatted_str,global.default_dialogue_screen_max_text_w);
	
	for(var i = 0; i < array_length(formatted_str); i++) {
		array_push(global.dialogue_ar,formatted_str[i]);
	}
	
	//Update max scroll after new text is added:
	scr_calculate_max_scroll();
}