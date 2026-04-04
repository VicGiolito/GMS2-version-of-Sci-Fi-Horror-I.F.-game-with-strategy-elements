

function scr_equip_item(char_struct_id, item_struct_id, equipped_during_creation_boolean){
	
	var equip_enum = item_struct_id.item_equip_enum;
	
	//Define equip_type_str string:
	var equip_type_str = "undefined";
	if equip_enum == item_equip_type.accessory equip_type_str = "accessory";
	else if equip_enum == item_equip_type.body equip_type_str = "body";
	else if equip_enum == item_equip_type.one_hand equip_type_str = "at least one hand";
	else if equip_enum == item_equip_type.two_hands equip_type_str = "both hands";
	
	if equip_enum == item_equip_type.none {
		if !equipped_during_creation_boolean scr_add_str_to_dialogue_ar($"\nThe {item_struct_id.name} is not a type of item that can be equipped; try 'U'sing it instead.");
		exit;
	}
	
	//Check if the corresponding slot is empty:
	var valid_equip = false;
	
	if equip_enum == item_equip_type.accessory && char_struct_id.inv_ar[equip_slot.accessory] == -1 {
		valid_equip = true;
		char_struct_id.inv_ar[equip_slot.accessory] = item_struct_id;
	}
	if equip_enum == item_equip_type.body && char_struct_id.inv_ar[equip_slot.body] == -1 {
		valid_equip = true;	
		char_struct_id.inv_ar[equip_slot.body] = item_struct_id;
	}
	if equip_enum == item_equip_type.one_hand && (char_struct_id.inv_ar[equip_slot.lh] == -1 || char_struct_id.inv_ar[equip_slot.rh] == -1) {
		valid_equip = true;	
	}
	if equip_enum == item_equip_type.two_hands && char_struct_id.inv_ar[equip_slot.lh] == -1 && char_struct_id.inv_ar[equip_slot.rh] == -1 {
		valid_equip = true;	
	}
	
	if valid_equip {
		
		//Add to corresponding index in inv_ar:
		if equip_enum == item_equip_type.two_hands {
			char_struct_id.inv_ar[equip_slot.lh] = item_struct_id;
			char_struct_id.inv_ar[equip_slot.rh] = item_struct_id;
		}
		else if equip_enum == item_equip_type.one_hand {
			//Add to first empty position, starting with rh:
			for(var i = equip_slot.rh; i <= equip_slot.lh; i++) {
				if char_struct_id.inv_ar[i] == -1 {
					char_struct_id.inv_ar[i] = item_struct_id;
					break;
				}
			}
		}
		
		scr_apply_item_stat_changes(char_struct_id, item_struct_id, true, equipped_during_creation_boolean);
	}
	else {
		if !equipped_during_creation_boolean scr_add_str_to_dialogue_ar($"\nThe {item_struct_id.name} cannot be equipped, make sure the corresponding slot(s) are free: {equip_type_str}.");
	}
}