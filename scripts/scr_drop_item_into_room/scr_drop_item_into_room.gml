

function scr_drop_item_into_room(char_struct_id,item_struct_id,item_slot_index,room_struct_id){
	
	//First, add to room_struct.scavenge_ar:
	if !is_array(room_struct_id.scavenge_ar) {
		room_struct_id.scavenge_ar = [];	
		for(var i = 0; i < scavenge_resource.total_resources; i++) {
			array_push(room_struct_id.scavenge_ar,0);
		}
	}
	
	//Add to room:
	array_push(room_struct_id.scavenge_ar,item_struct_id);
	
	//Then remove from appropriate item_slot_index:
	
	//It was an equipped item, then unequip:
	if item_slot_index < equip_slot.total_slots {
		
		var is_two_handed_item = scr_check_two_handed_item(item_struct_id);
		
		//Remove from both hands:
		if is_two_handed_item {
			char_struct_id.inv_ar[equip_slot.rh] = -1;
			char_struct_id.inv_ar[equip_slot.lh] = -1;
		}
		else {
			//Remove from its equip slot...
			char_struct_id.inv_ar[item_slot_index] = -1;
		}
		
		//Apply stat changes:
		scr_apply_item_stat_changes(char_struct_id,item_struct_id,false,false);
	} 
	//It was an item in the backpack, just remove from that position
	else {
		array_delete(char_struct_id.inv_ar,item_slot_index,1);
	}
	
	scr_add_str_to_dialogue_ar($"{char_struct_id.name} has dropped the {item_struct_id.item_name}. It can be retrieved from the room again using the 'SCAVENGE' command.\n");
	scr_add_str_to_dialogue_ar("\n",true);
}