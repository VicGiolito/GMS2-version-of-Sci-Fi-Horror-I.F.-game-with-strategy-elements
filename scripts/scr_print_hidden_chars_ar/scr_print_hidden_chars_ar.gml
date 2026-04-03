
//hidden_chars_ar_in_room must be defined

function scr_print_hidden_chars_ar(){
	
	var char_id;
	for(var i = 0; i < array_length(hidden_chars_in_room_ar); i++) {
		
		char_id = hidden_chars_in_room_ar[i];
		
		scr_add_str_to_dialogue_ar($"\n{i}.) {char_id.name}");	
	}
}