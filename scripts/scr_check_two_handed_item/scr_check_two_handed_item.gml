

function scr_check_two_handed_item(item_struct_id){
	
	if is_array(item_struct_id.equip_slot_list) && array_length(item_struct_id.equip_slot_list) > 0 {
		if is_array(item_struct_id.equip_slot_list[0]) {
			return true;	
		}
	}
	
	return false;
}