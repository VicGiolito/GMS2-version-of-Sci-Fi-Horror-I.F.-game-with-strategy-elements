
function scr_add_str_to_dialogue_ar(str_to_add, add_prompt_character = false){
	
	var formatted_str = scr_add_spaces_for_tabs(str_to_add);
	
	formatted_str = scr_format_str_into_ar_v2(formatted_str,global.default_dialogue_screen_max_text_w);
	
	for(var i = 0; i < array_length(formatted_str); i++) {
		array_push(global.dialogue_ar,formatted_str[i]);
	}
	
	if add_prompt_character {
		array_push(global.dialogue_ar,">");	
	}
	
	//Update max scroll after new text is added:
	scr_calculate_max_scroll();
	
	//Always update our scroll position to == our max scroll after we add text... why?
	// ... So the player might have the scroll back up again to see what the missed, if a 
	//particularly long string was generated?
		//global.scroll_position = global.max_scroll;
}