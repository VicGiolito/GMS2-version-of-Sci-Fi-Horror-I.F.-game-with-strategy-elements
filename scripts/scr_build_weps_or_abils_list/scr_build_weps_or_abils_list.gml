
//if build_weps_list_bool == false, we build from their ability_ar.



function scr_build_weps_or_abils_list(ar_to_pass, char_struct_id, build_weps_list_bool){
	
	if build_weps_list_bool {
		var item_struct_id;
		for(var i = equip_slot.rh; i <= equip_slot.lh; i++) {
			
			item_struct_id = char_struct_id.inv_ar[i];
			
			if item_struct_id != -1 && is_struct(item_struct_id) && item_struct_id.struct_type_enum == struct_type.Item { 
				if item_struct_id.is_shield_boolean == false {
					array_push(ar_to_pass, item_struct_id);
				}
			}
		}
	}
	else {
		var ar_len = array_length(char_struct_id.ability_ar)
		var item_struct_or_abil_or_item_enum;
		for(var i = 0; i < ar_len; i++) {
			
			item_struct_or_abil_or_item_enum = char_struct_id.ability_ar[i];
			
			if item_struct_or_abil_or_item_enum != -1 && is_struct(item_struct_or_abil_or_item_enum) && item_struct_or_abil_or_item_enum.struct_type_enum == struct_type.Item {
				array_push(ar_to_pass,item_struct_or_abil_or_item_enum);
			}
		}	
	}
	
	//Add fists if we're building a weapon's list and none were available:
	if array_length(ar_to_pass) == 0 && build_weps_list_bool {
		var fists_item_struct_id = scr_return_fists_item_struct_id(char_struct_id);
		
		array_push(ar_to_pass,fists_item_struct_id);
	}
	
	return ar_to_pass;
}