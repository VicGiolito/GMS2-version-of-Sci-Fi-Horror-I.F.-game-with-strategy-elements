

function scr_return_filtered_abil_ar(cur_char_id){
	
	var filtered_abil_list = [];
	
	if is_array(cur_char_id.ability_ar) && array_length(cur_char_id.ability_ar) {
		
		var ar_len = array_length(cur_char_id.ability_ar), abil_item_enum, item_struct_id;
		
		for(var i = 0; i < ar_len; i++) {
			
			abil_item_enum = cur_char_id.ability_ar[i];
			
			item_struct_id = global.item_reference_table[abil_item_enum];
			
			if is_struct(item_struct_id) && item_struct_id.struct_type_enum == struct_type.Item {
				
				if global.cur_game_state == game_state.choose_chars { array_push(filtered_abil_list,item_struct_id); }
				
				else if global.combat_begun == true {
				
					if item_struct_id.use_context == abil_use_context.combat_only || item_struct_id.use_context == abil_use_context.both {
						array_push(filtered_abil_list,item_struct_id);
					}
				}
				else {
					if item_struct_id.use_context == abil_use_context.main_game_only || item_struct_id.use_context == abil_use_context.both {
						array_push(filtered_abil_list,item_struct_id);
					}	
				}
			}
		}	
	}
	
	return filtered_abil_list;
}