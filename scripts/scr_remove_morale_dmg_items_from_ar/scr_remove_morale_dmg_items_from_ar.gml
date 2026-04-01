

function scr_remove_morale_dmg_items_from_ar(ar_to_check){
	
	var ar_len = array_length(ar_to_check), item_struct_id;
	
	var new_arr = [];
	
	for(var i = 0; i < ar_len; i++) {
		
		item_struct_id = ar_to_check[i];
		
		if !is_struct(item_struct_id) {
			var temp_struct_id = global.item_reference_table[item_struct_id];
			item_struct_id = temp_struct_id;
		}
		
		if item_struct_id.dmg_type_enum != item_dmg_type.morale_only {
			array_push(new_arr);
		}
	}
	
	return new_arr;
}