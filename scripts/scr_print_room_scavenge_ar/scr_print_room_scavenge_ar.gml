

function scr_print_room_scavenge_ar(room_struct_id){
	
	if is_array(room_struct_id.scavenge_ar) && array_length(room_struct_id.scavenge_ar) > 0 {
		
		var ar_len = array_length(room_struct_id.scavenge_ar);
			
		scr_add_str_to_dialogue_ar("\nItems in this room:");
				
		var loot_drop_or_item_struct_id, item_str;
		
		for(var i = 0; i < ar_len; i++) {
			
			item_str = "undefined";
			
			loot_drop_or_item_struct_id = room_struct_id.scavenge_ar[i];
			
			if is_struct(loot_drop_or_item_struct_id) {
				
				//This is an item struct because someone dropped an item struct from their inventory into this room:
				if loot_drop_or_item_struct_id.struct_type_enum == struct_type.Item {
					item_str = loot_drop_or_item_struct_id.item_name;
				}
				
				//There's a loot drop here: it's either a resource, or an enum of an item:
				else if loot_drop_or_item_struct_id.struct_type_enum == struct_type.Loot_drop {
					
					//This is a item enum, instantiate it...
					if loot_drop_or_item_struct_id.loot_drop_type_enum <= loot_drop_type.item_enum {
						
						var temp_item_id = global.item_reference_table[loot_drop_or_item_struct_id.loot_drop_item_enum];
						item_str = temp_item_id.item_name;
					}
					
					//This is a resource..
					if loot_drop_or_item_struct_id.loot_drop_type_enum > loot_drop_type.item_enum {
						
						var quant = loot_drop_or_item_struct_id.resource_quantity;
						
						if loot_drop_or_item_struct_id.loot_drop_type_enum == loot_drop_type.resource_ammo {
							item_str = $"Ammunition: {quant}";
						}
						else if loot_drop_or_item_struct_id.loot_drop_type_enum == loot_drop_type.resource_scrap {
							item_str = $"Scrap: {quant}";
						}
						else if loot_drop_or_item_struct_id.loot_drop_type_enum == loot_drop_type.resource_engine_fuel {
							item_str = $"Engine Fuel: {quant}";
						}
						else if loot_drop_or_item_struct_id.loot_drop_type_enum == loot_drop_type.resource_tech_advanced {
							item_str = $"Advanced Technoloy: {quant}";
						}
						else if loot_drop_or_item_struct_id.loot_drop_type_enum == loot_drop_type.resource_tech_basic {
							item_str = $"Basic Technology: {quant}";
						}
						else if loot_drop_or_item_struct_id.loot_drop_type_enum == loot_drop_type.resource_food {
							item_str = $"Food: {quant}";
						}
					}
				}
			}
			
			scr_add_str_to_dialogue_ar(string(item_str))
		}
	}
}