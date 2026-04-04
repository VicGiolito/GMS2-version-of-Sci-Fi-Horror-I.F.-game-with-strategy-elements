


function scr_add_item_or_loot_drop_to_room(room_struct_id, item_or_loot_drop_struct_id){
	
	if !is_array(room_struct_id.scavenge_ar) {
		room_struct_id.scavenge_ar = [];
	}

	array_push(room_struct_id.scavenge_ar, item_or_loot_drop_struct_id);
}