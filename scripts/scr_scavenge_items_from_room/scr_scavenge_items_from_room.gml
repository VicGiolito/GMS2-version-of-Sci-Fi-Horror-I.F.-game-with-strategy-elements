

function scr_scavenge_items_from_room(char_struct_id,room_struct_id){
	
	d($"Entering scr_scavenge_items_from_room...");
	
	if is_array(room_struct_id.scavenge_ar) && array_length(room_struct_id.scavenge_ar) > 0 {
		
		var ar_len = array_length(room_struct_id.scavenge_ar);
		
		d($"Entering scr_scavenge_items_from_room: scavenge_ar length == {ar_len} and scavenge_ar == {room_struct_id.scavenge_ar}");
		
		for(var i = 0; i < ar_len; i++) {
				
			var resource_or_item = room_struct_id.scavenge_ar[i];
				
			if i < scavenge_resource.total_resources {
				
				if resource_or_item > 0 {
					
					if i == scavenge_resource.tech_basic {
						global.resources_basic_tech += resource_or_item;	
					}
					else if i == scavenge_resource.tech_advanced {
						global.resources_advanced_tech += resource_or_item;	
					}
					else if i == scavenge_resource.food {
						global.resources_food += resource_or_item;	
					}
					else if i == scavenge_resource.scrap {
						global.resources_scrap += resource_or_item;	
					}
					else if i == scavenge_resource.engine_fuel {
						global.resources_engine_fuel += resource_or_item;	
					}
					else if i == scavenge_resource.ammo {
						global.resources_ammo += resource_or_item;	
					}
					
					scr_add_str_to_dialogue_ar($"{char_struct_id.name} has collected {resource_or_item} {scr_return_resource_str(i)}.")
				
					//Empty this index position:
					room_struct_id.scavenge_ar[i] = -1;
				}
				
			}
			//Were starting to pick up items
			else if i >= scavenge_resource.total_resources {
				
				if is_struct(resource_or_item) && resource_or_item.struct_type_enum == struct_type.Item {
				
					if array_length(char_struct_id.inv_ar) < global.max_player_inv {
					
						scr_add_item_to_inv(char_struct_id,resource_or_item,false);
						
						//Empty this index position:
						room_struct_id.scavenge_ar[i] = -1;
					}
					else {
						scr_add_str_to_dialogue_ar($"{char_struct_id.name} can't carry any more items!");
						break;
					}
				}
			}
		}
		
		d($"After scavenging, the scavenge_ar looks like: {room_struct_id.scavenge_ar}");
		
		var new_ar = [];
		
		//Copy new array without index positions >= scavenge_resource.total_resources
		for(var i = scavenge_resource.total_resources; i < ar_len; i++) {
			
			if i < scavenge_resource.total_resources {
				array_push(new_ar,room_struct_id.scavenge_ar[i]);
			}
			
			else if i >= scavenge_resource.total_resources {
			
				if room_struct_id.scavenge_ar[i] > 0 || is_struct(room_struct_id.scavenge_ar[i]) {
					array_push(new_ar,room_struct_id.scavenge_ar[i]);
				}
			}
		}
		
		d($"After building it, new_ar looks like: {new_ar}"); 
		
		room_struct_id.scavenge_ar = new_ar;
		
		//Delete array if applicable:
		if array_length(room_struct_id.scavenge_ar) < scavenge_resource.total_resources {
			room_struct_id.scavenge_ar = -1;
			d("The scavenge ar has been deleted.")
		}
		
		//Switch var to true:
		room_struct_id.scavenged_once_boolean = true;
		
		scr_add_str_to_dialogue_ar("",true);
	}	
}