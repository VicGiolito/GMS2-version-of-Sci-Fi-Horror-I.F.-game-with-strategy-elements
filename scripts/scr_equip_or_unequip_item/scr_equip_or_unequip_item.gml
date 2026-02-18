

function scr_equip_or_unequip_item(char_struct_id, item_struct_id, equip_slot_enum, equip_boolean, equipped_during_creation_boolean = false){
	
	var is_two_handed_item = scr_check_two_handed_item(item_struct_id);
	
	if equip_boolean {
	
		//Add to both hands:
		if is_two_handed_item {
			char_struct_id.inv_ar[equip_slot.rh] = item_struct_id;
			char_struct_id.inv_ar[equip_slot.lh] = item_struct_id;
		}
		//Add to corresponding equip_slot - we've already called scr_check_valid_equip so we know a corresponding equip_slot is free:
		else {
			
			var equip_slot_index;
			
			if item_struct_id.equip_slot_list[0] == equip_slot.rh || item_struct_id.equip_slot_list[0] == equip_slot.lh {
				for(var i = equip_slot.rh; i <= equip_slot.lh; i++) {
					if char_struct_id.inv_ar[i] == -1 {
						equip_slot_index = i;
						break;
					}
				}
			}
			
			else if item_struct_id.equip_slot_list[0] == equip_slot.accessory || item_struct_id.equip_slot_list[0] == equip_slot.body {
				equip_slot_index = item_struct_id.equip_slot_list[0];
			}	
			
			char_struct_id.inv_ar[equip_slot_index] = item_struct_id;
		}
		
		if equipped_during_creation_boolean == false {
			var item_name = item_struct_id.item_name;
			scr_add_str_to_dialogue_ar($"{char_struct_id.name} has equipped the {item_name}.\n");
		}
		
		//Remove from its corresponding backpack location:
		array_delete(char_struct_id.inv_ar,equip_slot_enum,1);
	}
	
	else {
		
		//Remove from both hands:
		if is_two_handed_item {
			char_struct_id.inv_ar[equip_slot.rh] = -1;
			char_struct_id.inv_ar[equip_slot.lh] = -1;
		}
		else {
			//Remove from its equip slot...
			char_struct_id.inv_ar[equip_slot_enum] = -1;
		}
		
		//Add to backpack:
		array_push(char_struct_id.inv_ar,item_struct_id);
		
		//Print unequip results:
		if equipped_during_creation_boolean == false {
			var item_name = item_struct_id.item_name;
			scr_add_str_to_dialogue_ar($"{char_struct_id.name} has removed the {item_name}.\n");	
		}
	}
	
	scr_apply_item_stat_changes(char_struct_id,item_struct_id,equip_boolean,equipped_during_creation_boolean);
	
	scr_add_str_to_dialogue_ar("\n",true);
}