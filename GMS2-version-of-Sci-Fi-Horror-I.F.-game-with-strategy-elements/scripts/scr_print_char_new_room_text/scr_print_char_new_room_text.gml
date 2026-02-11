
function scr_print_char_new_room_text(char_struct_id){
	
	scr_add_str_to_dialogue_ar(scr_return_room_desc_str(char_struct_id.cur_room_id));
	scr_add_str_to_dialogue_ar(" ");
	scr_add_str_to_dialogue_ar(scr_return_chars_str_in_room(char_struct_id.cur_room_id));
	scr_add_str_to_dialogue_ar(" ");
	scr_add_str_to_dialogue_ar(scr_return_avail_directions_str(char_struct_id.cur_room_id));
	scr_add_str_to_dialogue_ar(" ");
	scr_add_str_to_dialogue_ar(scr_return_cur_char_str(char_struct_id),true);
	
}