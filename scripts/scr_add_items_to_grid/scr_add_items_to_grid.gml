



function scr_add_items_to_grid(grid_to_use){
	
	var grid_w = ds_grid_width(grid_to_use), grid_h = ds_grid_height(grid_to_use);
	
	for(var xx = 0; xx < grid_w; xx++){
		for(var yy = 0; yy < grid_h; yy++){
			
			var room_struct_id = grid_to_use[# xx,yy];
			
			if grid_to_use == global.research_vessel_grid {
				
				if is_struct(room_struct_id) && room_struct_id.struct_type_enum == struct_type.Room {
					if room_struct_id.room_enum == research_vessel_room.stasis_chamber {
						scr_add_item_to_room(room_struct_id,new global.Item(item_type.suit_environmental) );
						scr_add_item_to_room(room_struct_id,new global.Item(item_type.medkit) );
						scr_add_item_to_room(room_struct_id,new global.Item(item_type.semi_auto_pistol) );
					}
				}
			}
		}
	}
	
}