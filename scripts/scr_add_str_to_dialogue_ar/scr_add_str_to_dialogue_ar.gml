

/* if dialogue_ar_to_add_to == detailed_view_ar, then add_prompt_char should always == false, as we don't use it for the left window

should be run from the scope of o_con

*/

function scr_add_str_to_dialogue_ar(str_to_add, add_prompt_character = false){
	
	var formatted_str = scr_add_spaces_for_tabs(str_to_add);
	
	formatted_str = scr_format_str_into_ar_v2(formatted_str, global.default_dialogue_screen_max_text_w);
	
	for(var i = 0; i < array_length(formatted_str); i++) {
		array_push(global.dialogue_ar,formatted_str[i]);
	}
	
	if add_prompt_character {
		array_push(global.dialogue_ar,">");	
	}
	
	//Update max scroll after new text is added:
	scr_calculate_max_scroll();
	
	/*Always update our scroll position to == our max scroll after we add text... why?
	The reason for this is because when the player is moving around to different rooms, particularly
	rooms they've already explored before, we don't want the player to have to constantly be adjusting the scroll
	bar for the dialogue box to see where they are at. 
	It's easier and more intuitive for the player to OCCASIONALLY have to scroll UP to see what they missed 
	if a particularly large chunk of text was generated, than it is for them to CONSTANTLY be scrolling DOWN 
	to figure out what is happening.
	*/
	
	global.scroll_position = global.max_scroll;
}