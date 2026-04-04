

function scr_scavenge_all_items_from_room(char_struct_id, room_struct_id){
	
	d($"\nEntering scr_scavenge_items_from_room...");
	
	if is_array(room_struct_id.scavenge_ar) && array_length(room_struct_id.scavenge_ar) > 0 {
		
		var ar_len = array_length(room_struct_id.scavenge_ar);
		
		d($"\nEntering scr_scavenge_items_from_room: scavenge_ar length == {ar_len} and scavenge_ar == {room_struct_id.scavenge_ar}");
		
		for(var i = 0; i < ar_len; i++) {
			
			var item_collected = false; //reset
				
			var loot_drop_or_item_struct = room_struct_id.scavenge_ar[i];
			
			if is_struct(loot_drop_or_item_struct) && loot_drop_or_item_struct.struct_type_enum == struct_type.Loot_drop {
				
				//This is a global resource that will be collected
				if loot_drop_or_item_struct.loot_drop_type_enum > loot_drop_type.item_enum {
					
					item_collected = true;
					
					var loot_drop_enum = loot_drop_or_item_struct.loot_drop_type_enum;
					
					var resource_quant = resource_quantity;
					
					if loot_drop_enum == loot_drop_type.resource_tech_basic {
						global.resources_basic_tech += resource_quant;	
					}
					else if loot_drop_enum == loot_drop_type.resource_tech_advanced {
						global.resources_advanced_tech += resource_quant;	
					}
					else if loot_drop_enum == loot_drop_type.resource_food {
						global.resources_food += resource_quant;	
					}
					else if loot_drop_enum == loot_drop_type.resource_scrap {
						global.resources_scrap += resource_quant;	
					}
					else if loot_drop_enum == loot_drop_type.resource_engine_fuel {
						global.resources_engine_fuel += resource_quant;	
					}
					else if loot_drop_enum == loot_drop_type.resource_ammo {
						global.resources_ammo += resource_quant;	
					}
				}
				
				//This is an item enum - instantiate, then add to char_inv_ar:
				else if loot_drop_or_item_struct.loot_drop_type_enum == loot_drop_type.item_enum {
					if scr_add_item_to_inv(char_struct_id, new global.Item(loot_drop_or_item_struct.loot_drop_item_enum)) == true {
						item_collected = true;	
					}
				}
			}
			
			else if is_struct(loot_drop_or_item_struct) && loot_drop_or_item_struct.struct_type_enum == struct_type.Item {
				if scr_add_item_to_inv(char_struct_id, loot_drop_or_item_struct) == true {
					item_collected = true;	
				}
			}
			
			//Empty this position:
			if item_collected { room_struct_id.scavenge_ar[i] = -1; }
			
		} //End of iterating through scavenge ar
		
		//Now we need to alter or delete scavenge ar:
		var new_ar = [];
		for(var i = 0; i < ar_len; i++) {
			if room_struct_id.scavenge_ar[i] != -1 {
				array_push(new_ar, room_struct_id.scavenge_ar[i]);
			}
		}
		
		//Alter:
		if array_length(new_ar) > 0 {
			room_struct_id.scavenge_ar = new_ar;	
		}
		//Delete:
		else {
			room_struct_id.scavenge_ar = -1;
		}
	}
}