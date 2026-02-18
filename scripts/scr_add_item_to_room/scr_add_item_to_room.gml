


function scr_add_item_to_room(room_struct_id,item_struct_id){
	
	if !is_array(room_struct_id.scavenge_ar) {
		room_struct_id.scavenge_ar = [];
		for(var i = 0; i < scavenge_resource.total_resources; i++) {
			array_push(room_struct_id.scavenge_ar,0);
		}
	}
	
	array_push(room_struct_id.scavenge_ar,item_struct_id);
}