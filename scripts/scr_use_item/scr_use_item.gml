

function scr_use_item(item_struct_id, item_index_in_inv, target_char_struct_of_item, char_struct_using_item){
	
	//We already know its a valid item:
	var item_type_enum = item_struct_id.item_enum;
	
	if item_type_enum == item_type.medkit {
		scr_add_str_to_dialogue_ar("\n");
		scr_add_str_to_dialogue_ar($"{target_char_struct_of_item.name} has been effected by the {item_struct_id.item_name}. This item's use effect has not been coded yet.");
	}
	
	if item_struct_id.single_use_boolean {
		array_delete(char_struct_using_item.inv_ar,item_index_in_inv,1);	
	}
}