
/* This script literally just clears vacuum, wherever applicable. It is reapplied again after this in scr_spread_vacuum.

if extinguish_vac_bool == false, we extinguish gas instead.

*/

function scr_extinguish_vacuum_or_gas(extinguish_vac_bool){
	
	//Start iterating through our map grids...
	var master_ar_len = array_length(global.level_ar);
	
	var grid_id;
	for(var i = 0; i < master_ar_len; i++){
		
		grid_id = global.level_ar[i];
		
		if ds_exists(grid_id, ds_type_grid) {
			
			var grid_w = ds_grid_width(grid_id), grid_h = ds_grid_height(grid_id), room_struct_id, location_enum;
			
			for(var xx = 0; xx < grid_w; xx++) {
				for(var yy = 0; yy < grid_h; yy++) {
					
					room_struct_id = grid_id[# xx,yy];
					
					//Only do this if this is not a vacuum type room:
					location_enum = scr_return_location_enum_from_grid_id(grid_id);
					
					if location_enum == location.research_vessel && room_struct_id.room_enum == research_vessel_room.vacuum {
						continue;	
					}
					
					//If there's vacuum hazard in this room and there's no vacuum generator...
					if extinguish_vac_bool {
						if is_array(room_struct_id.hazard_ar) && scr_check_ar_for_val(room_struct_id.hazard_ar, hazard_type.vacuum) == true {
						
							var invalid_cell = false;
						
							if is_array(room_struct_id.hazard_generator_ar) && scr_check_ar_for_val(room_struct_id.hazard_generator_ar, hazard_generator_types.vacuum) == true {
								invalid_cell = true;	
							}
						
							if !invalid_cell {
								//... Then simply clear the vacuum hazard. We will run scr_spread_vacuum_or_gas() after this to see if it still needs to spread.
								array_delete(room_struct_id.hazard_ar, array_get_index(room_struct_id.hazard_ar, hazard_type.vacuum), 1);
							
								//Delete array, if applicable:
								if array_length(room_struct_id.hazard_ar) == 0 {
									room_struct_id.hazard_ar = -1;	
								}
							}
						}
					}
					else if !extinguish_vac_bool {
						if is_array(room_struct_id.hazard_ar) && scr_check_ar_for_val(room_struct_id.hazard_ar, hazard_type.toxic_gas) == true {
						
							var invalid_cell = false;
						
							if is_array(room_struct_id.hazard_generator_ar) && scr_check_ar_for_val(room_struct_id.hazard_generator_ar, hazard_generator_types.toxic_gas) == true {
								invalid_cell = true;	
							}
						
							if !invalid_cell {
								//... Then simply clear the gas hazard. We will run scr_spread_vacuum_or_gas() after this to see if it still needs to spread.
								array_delete(room_struct_id.hazard_ar, array_get_index(room_struct_id.hazard_ar, hazard_type.toxic_gas), 1);
							
								//Delete array, if applicable:
								if array_length(room_struct_id.hazard_ar) == 0 {
									room_struct_id.hazard_ar = -1;	
								}
							}
						}
					}
				}
			}
		}
	}
	
}