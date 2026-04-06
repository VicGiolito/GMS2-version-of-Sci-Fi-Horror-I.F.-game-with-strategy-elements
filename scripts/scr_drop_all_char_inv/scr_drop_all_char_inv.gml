

function scr_drop_all_char_inv(char_struct_id, print_message = false){
	
	if is_array(char_struct_id.inv_ar) && array_length(char_struct_id.inv_ar) {
		
		var ar_len = array_length(char_struct_id.inv_ar), item_struct_id, item_dropped = false;
		
		for(var i = 0; i < ar_len; i++) {
			
			item_struct_id = char_struct_id.inv_ar[i];
			
			if is_struct(item_struct_id) && item_struct_id.struct_type_enum == struct_type.Item {
				
				item_dropped = true;
				
				//'Empty' this equip slot position:
				
					//If it's an already-equipped, 2handed item, then empty both hands:
				if i < equip_slot.total_slots && item_struct_id.item_equip_enum == item_equip_type.two_hands {
					char_struct_id.inv_ar[equip_slot.lh] = -1;
					char_struct_id.inv_ar[equip_slot.rh] = -1;
				}
				//If it's an other item, regardless of whether or not equipped, or whatever its index is in the array, 'empty' the index position:
				else 
				{
					char_struct_id.inv_ar[i] = -1;
				}
				
				scr_drop_item_into_room(char_struct_id, item_struct_id, char_struct_id.cur_room_id, print_message);
			}
		}
		
		//Adjust inventory array:
		if item_dropped {
			
			char_struct_id.inv_ar = -1;
			char_struct_id.inv_ar = [];
			
			for(var i = 0; i < equip_slot.total_slots; i++) {
				char_struct_id.inv_ar[i] = -1;	
			}
		}
	}
}