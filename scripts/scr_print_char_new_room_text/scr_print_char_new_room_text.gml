
function scr_print_char_new_room_text(char_struct_id){
	
	scr_add_str_to_dialogue_ar(scr_return_room_name(char_struct_id.cur_room_id) );
	scr_add_str_to_dialogue_ar("\n");
	//Room description:
	scr_add_str_to_dialogue_ar(scr_return_room_desc_str(char_struct_id.cur_room_id) );
	scr_add_str_to_dialogue_ar("\n");
	//Enemies, neutrals, pcs:
	scr_add_str_to_dialogue_ar(scr_return_chars_str_in_room(char_struct_id.cur_room_id) );
	scr_add_str_to_dialogue_ar("\n");
	//Hazards:
	if is_array(char_struct_id.cur_room_id.hazard_ar) && array_length(char_struct_id.cur_room_id.hazard_ar) > 0 {
		scr_add_str_to_dialogue_ar(scr_return_hazards_str_in_room(char_struct_id.cur_room_id));
		scr_add_str_to_dialogue_ar("\n");
	}
	//Scavenge:
	if char_struct_id.cur_room_id.scavenged_once_boolean == true && scr_check_room_for_scavenge(char_struct_id.cur_room_id) {
		
		if is_array(char_struct_id.cur_room_id.scavenge_ar) {
		
			var ar_len = array_length(char_struct_id.cur_room_id.scavenge_ar);
			
			if ar_len >= scavenge_resource.total_resources {
				
				scr_add_str_to_dialogue_ar("Items in this room:\n");
				
				var scavenge_item_id;
				for(var i = 0; i < ar_len; i++) {
					scavenge_item_id = char_struct_id.cur_room_id.scavenge_ar[i];
					
					if is_struct(scavenge_item_id) && scavenge_item_id.struct_type_enum == struct_type.Item {
						scr_add_str_to_dialogue_ar($"{scavenge_item_id.item_name}\n");	
					}
				}
				
				scr_add_str_to_dialogue_ar("\n"); //Extra line
			}
		}
	}
	//Available directions:
	scr_add_str_to_dialogue_ar(scr_return_avail_directions_str(char_struct_id.cur_room_id));
	scr_add_str_to_dialogue_ar("\n");
	//Current character reminder:
	scr_add_str_to_dialogue_ar(scr_return_cur_char_str(char_struct_id)+"\n",true);
}