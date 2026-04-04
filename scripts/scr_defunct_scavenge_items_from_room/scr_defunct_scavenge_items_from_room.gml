

function scr_defunct_scavenge_items_from_room(char_struct_id,room_struct_id){
	
	d($"Entering scr_scavenge_items_from_room...");
	
	if is_array(room_struct_id.scavenge_ar) && array_length(room_struct_id.scavenge_ar) > 0 {
		
		var ar_len = array_length(room_struct_id.scavenge_ar);
		
		d($"Entering scr_scavenge_items_from_room: scavenge_ar length == {ar_len} and scavenge_ar == {room_struct_id.scavenge_ar}");
		
		for(var i = 0; i < ar_len; i++) {
				
			var resource_int_or_item_enum_int = room_struct_id.scavenge_ar[i];
				
			if i < scavenge_resource.total_resources {
				
				if resource_int_or_item_enum_int > 0 {
					
					if i == scavenge_resource.tech_basic {
						global.resources_basic_tech += resource_int_or_item_enum_int;	
					}
					else if i == scavenge_resource.tech_advanced {
						global.resources_advanced_tech += resource_int_or_item_enum_int;	
					}
					else if i == scavenge_resource.food {
						global.resources_food += resource_int_or_item_enum_int;	
					}
					else if i == scavenge_resource.scrap {
						global.resources_scrap += resource_int_or_item_enum_int;	
					}
					else if i == scavenge_resource.engine_fuel {
						global.resources_engine_fuel += resource_int_or_item_enum_int;	
					}
					else if i == scavenge_resource.ammo {
						global.resources_ammo += resource_int_or_item_enum_int;	
					}
					
					scr_add_str_to_dialogue_ar($"{char_struct_id.name} has collected {resource_int_or_item_enum_int} {scr_return_resource_str(i)}.")
				
					//Empty this index position:
					room_struct_id.scavenge_ar[i] = 0;
				}
				
			}
			//Were starting to pick up items
			else if i >= scavenge_resource.total_resources {
				
				if resource_int_or_item_enum_int >= 0 {
				
					if scr_check_backpack_size_restriction(char_struct_id) == true { //We -4 b.c we don't count the 4 equipment slots.
						
						var new_item_struct_id = new global.Item(resource_int_or_item_enum_int);
						
						scr_add_item_to_inv(char_struct_id,new_item_struct_id,false);
						
						//Empty this index position:
						room_struct_id.scavenge_ar[i] = -1;
					}
					else {
						scr_add_str_to_dialogue_ar($"{char_struct_id.name} can't carry any more items!");
						break;
					}
				}
			}
		} //End of iterating through scavenge ar
		
		d($"After scavenging, but before creating the new array, the scavenge_ar looks like: {room_struct_id.scavenge_ar}");
		
		var new_ar = [];
		
		//Create new array as copy of original, just with all of the resource values as 0, and any position at or beyond
		//total_resources that is not a leftover item struct gets ignored.
		var resource_int_or_item_enum_int, leftover_item_found = false;
		for(var i = 0; i < ar_len; i++) {
			
			resource_int_or_item_enum_int = room_struct_id.scavenge_ar[i];
			
			if i < scavenge_resource.total_resources {
				array_push(new_ar, 0);
			}
			
			else if i >= scavenge_resource.total_resources {
			
				if resource_int_or_item_enum_int >= 0 {
					leftover_item_found = true;
					array_push(new_ar,resource_int_or_item_enum_int);
				}
			}
		}
		
		d($"After building it, new_ar looks like: {new_ar}"); 
		
		if leftover_item_found {
			room_struct_id.scavenge_ar = new_ar;
		}
		
		//Delete array if applicable:
		else {
			room_struct_id.scavenge_ar = -1;
			d("The scavenge ar has been deleted, there was nothing left in it to collect.")
		}
		
		//Switch var to true:
		room_struct_id.scavenged_once_boolean = true;
		
		scr_add_str_to_dialogue_ar("",true);
	}	
}