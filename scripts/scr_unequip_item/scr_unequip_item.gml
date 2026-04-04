

function scr_unequip_item(char_struct_id, item_struct_id){
	
	for(var i = 0; i < array_length(char_struct_id.inv_ar); i++) {
		
		if char_struct_id.inv_ar[i] == item_struct_id {
			scr_apply_item_stat_changes(char_struct_id, item_struct_id, false, false);
			char_struct_id.inv_ar[i] = -1;
			scr_add_str_to_dialogue_ar($"{char_struct_id.name} has unequipped the {item_struct_id.item_name}.");
			return true;
		}
	}
	
	return false;
}