
function scr_filter_abil_ar_by_combat_only(arr){
	
	var ar_to_return = [];
	
	if is_array(arr) && array_length(arr) > 0 {
	
		var ar_len = array_length(arr), abil_enum, item_struct_id, item_struct_id;
	
		for(var i = 0; i < ar_len; i++) {
		
			abil_enum = arr[i];
		
			if is_struct(abil_enum) == false {
				item_struct_id = global.item_reference_table[abil_enum];
				if item_struct_id.use_context == abil_use_context.combat_only {
					array_push(ar_to_return, item_struct_id);
				}
			}
			else if is_struct(abil_enum) == true && abil_enum.struct_type_enum == struct_type.Item {
				if abil_enum.use_context == abil_use_context.combat_only {
					array_push(ar_to_return, abil_enum);	
				}
			}
		}
	}
	
	return ar_to_return;
}