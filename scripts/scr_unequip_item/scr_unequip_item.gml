
//Removes the item id from the inv_ar EQUIP slot, replacing it with a -1, and adding it to the bottom of the inv_ar

//returns true is sucessful; false otherwise.


function scr_unequip_item(char_struct_id, item_struct_id){
	
	for(var i = 0; i < array_length(char_struct_id.inv_ar); i++) {
		
		if char_struct_id.inv_ar[i] == item_struct_id {
			
			scr_apply_item_stat_changes(char_struct_id, item_struct_id, false, false);
			
			//If this is a two-handed item, we need to empty both hands:
			if char_struct_id.inv_ar[i].item_equip_enum == item_equip_type.two_hands {
				char_struct_id.inv_ar[equip_slot.rh] = -1;
				char_struct_id.inv_ar[equip_slot.lh] = -1;
			}
			//Just remove from the specified position:
			else {
				char_struct_id.inv_ar[i] = -1;	
			}
			
			//Add to backpack:
			array_push(char_struct_id.inv_ar, item_struct_id);
			
			//Print message:
			scr_add_str_to_dialogue_ar($"\n{char_struct_id.name} has unequipped the {item_struct_id.item_name}.", true);
			
			return true;
		}
	}
	
	return false;
}