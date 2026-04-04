
function scr_print_char_new_room_text(char_struct_id){
	
	//Name of room:
	scr_add_str_to_dialogue_ar("\n"+scr_return_room_name(char_struct_id.cur_room_id));
	//Room description:
	scr_add_str_to_dialogue_ar("\n");
	scr_add_str_to_dialogue_ar(scr_return_room_desc_str(char_struct_id.cur_room_id));
	//scr_add_str_to_dialogue_ar("\n");
	//Enemies, neutrals, pcs:
	scr_add_str_to_dialogue_ar("\n"+scr_return_chars_str_in_room(char_struct_id.cur_room_id));
	//Hazards:
	if is_array(char_struct_id.cur_room_id.hazard_ar) && array_length(char_struct_id.cur_room_id.hazard_ar) > 0 {
		scr_add_str_to_dialogue_ar("\n"+scr_return_hazards_str_in_room(char_struct_id.cur_room_id));
	}
	//Scavenge:
	scr_print_room_scavenge_ar(char_struct_id.cur_room_id);
	
	//Available directions:
	scr_add_str_to_dialogue_ar("\n"+scr_return_avail_directions_str(char_struct_id.cur_room_id));
	//Current character reminder:
	scr_add_str_to_dialogue_ar("\n"+scr_return_cur_char_str(char_struct_id),true);
}