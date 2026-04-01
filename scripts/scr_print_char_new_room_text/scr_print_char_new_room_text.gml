
function scr_print_char_new_room_text(char_struct_id){
	
	//Name of room:
	scr_add_str_to_dialogue_ar("\n"+scr_return_room_name(char_struct_id.cur_room_id)+"\n");
	//Room description:
	scr_add_str_to_dialogue_ar("\n");
	scr_add_str_to_dialogue_ar(scr_return_room_desc_str(char_struct_id.cur_room_id));
	scr_add_str_to_dialogue_ar("\n");
	//Enemies, neutrals, pcs:
	scr_add_str_to_dialogue_ar(scr_return_chars_str_in_room(char_struct_id.cur_room_id)+"\n");
	//Hazards:
	if is_array(char_struct_id.cur_room_id.hazard_ar) && array_length(char_struct_id.cur_room_id.hazard_ar) > 0 {
		scr_add_str_to_dialogue_ar("\n"+scr_return_hazards_str_in_room(char_struct_id.cur_room_id));
	}
	//Scavenge:
	if char_struct_id.cur_room_id.scavenged_once_boolean == true && scr_check_room_for_scavenge(char_struct_id.cur_room_id) {
		
		if is_array(char_struct_id.cur_room_id.scavenge_ar) {
		
			var ar_len = array_length(char_struct_id.cur_room_id.scavenge_ar);
			
			if ar_len >= scavenge_resource.total_resources {
				
				scr_add_str_to_dialogue_ar("Items in this room:\n");
				
				var scavenge_item_enum_int;
				for(var i = scavenge_resource.total_resources; i < ar_len; i++) {
					
					scavenge_item_enum_int = char_struct_id.cur_room_id.scavenge_ar[i];
					
					if scavenge_item_enum_int >= 0 {
						var scavenge_item_name = global.item_reference_table[scavenge_item_enum_int].item_name;
						scr_add_str_to_dialogue_ar($"{scavenge_item_name}\n");	
					}
				}
			}
		}
	}
	//Available directions:
	scr_add_str_to_dialogue_ar("\n"+scr_return_avail_directions_str(char_struct_id.cur_room_id));
	//Current character reminder:
	scr_add_str_to_dialogue_ar("\n"+scr_return_cur_char_str(char_struct_id)+"\n",true);
}