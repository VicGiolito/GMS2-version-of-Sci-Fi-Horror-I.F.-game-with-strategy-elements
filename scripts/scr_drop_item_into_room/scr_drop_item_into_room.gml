

function scr_drop_item_into_room(char_struct_id, item_struct_id, room_struct_id, print_message = true){
	
	//First, create to room_struct.scavenge_ar if applicable:
	if !is_array(room_struct_id.scavenge_ar) {
		room_struct_id.scavenge_ar = [];
	}
	
	//Add to room:
	array_push(room_struct_id.scavenge_ar,item_struct_id);
	
	if print_message {
		scr_add_str_to_dialogue_ar($"\n{char_struct_id.name} has dropped the {item_struct_id.item_name}. It can be retrieved from the room again using the 'SCAVENGE' command.", true);
	}
}