
function scr_check_valid_equip(char_struct_id,item_struct_id){
	
	var equip_slot_list = item_struct_id.equip_slot_list;
	var inv_ar = char_struct_id.inv_ar; 
	
	//This should always be an array:
	var ar_len = array_length(equip_slot_list);
	
	//Item that can't be equipped, such as medkits, etc.:
	if ar_len == 0 {
		return false;	
	}
	else 
	{
		for(var i = 0; i < ar_len; i++) {
			
			//If an element is a nested array (such as the first element), this indicates it is a two-handed weapon:
			if is_array(equip_slot_list[i]) {
				
				if inv_ar[equip_slot.rh] == -1 && inv_ar[equip_slot.lh] == -1 {
					return true;	
				} 
				else return false;
			}
			else {
				if equip_slot_list[i] == equip_slot.rh || equip_slot_list[i] == equip_slot.lh {
					
					//If it's a shield, make sure there are no shields in either other hand:
					if item_struct_id.is_shield_boolean == true {
						if is_struct(inv_ar[equip_slot.rh])	&& inv_ar[equip_slot.rh].is_shield_boolean == true {
							scr_add_str_to_dialogue_ar("You can't wield two shields at the same time.");
							return false;	
						}
						if is_struct(inv_ar[equip_slot.lh])	&& inv_ar[equip_slot.lh].is_shield_boolean == true {
							scr_add_str_to_dialogue_ar("You can't wield two shields at the same time.");
							return false;	
						}
					}
					
					if inv_ar[equip_slot.rh] == -1 || inv_ar[equip_slot.lh] == -1 {
						return true;	
					}
				}
				if equip_slot_list[i] == equip_slot.accessory && inv_ar[equip_slot.accessory] == -1 {
					return true;	
				}
				if equip_slot_list[i] == equip_slot.body && inv_ar[equip_slot.body] == -1 {
					return true;	
				}
			}
		}
	}
	
	return false;
}