
/* Simlpy iterates through the specified grid, applying random hazard generators with a 50% chance

*/

function scr_apply_random_hazard_gen(grid_to_use){
	
	var grid_w = ds_grid_width(grid_to_use), grid_h = ds_grid_height(grid_to_use);
	
	//var ran_hazard_gen_ar = [ hazard_generator_types.fire, hazard_generator_types.vacuum, hazard_generator_types.toxic_gas, hazard_generator_types.electric ];
	
	var ran_hazard_gen_ar = [ hazard_generator_types.vacuum, hazard_generator_types.fire, hazard_generator_types.toxic_gas, hazard_generator_types.electric,
	hazard_generator_types.vacuum, hazard_generator_types.fire, hazard_generator_types.toxic_gas, hazard_generator_types.electric, hazard_generator_types.fire,
	hazard_generator_types.fire, hazard_generator_types.fire ];
	
	var ran_hazard_count = 0, ran_hazard_max = array_length(ran_hazard_gen_ar), failsafe_val = 0, failsafe_max = (grid_w*grid_h)+1;
	
	var room_struct_id, ran_x, ran_y;
	do {
		
		ran_x = irandom_range(0, grid_w-1);
		ran_y = irandom_range(0, grid_h-1);
		
		if ran_hazard_count >= ran_hazard_max exit;
			
		room_struct_id = grid_to_use[# ran_x, ran_y];
			
		if scr_check_for_vacuum_room(room_struct_id) == false {
					
			var ran_hazard_gen = ran_hazard_gen_ar[0];
					
			if !is_array(room_struct_id.hazard_generator_ar) {
				room_struct_id.hazard_generator_ar = [];	
			}
			
			if scr_check_ar_for_val(room_struct_id.hazard_generator_ar, ran_hazard_gen) == false {
					
				array_push(room_struct_id.hazard_generator_ar, ran_hazard_gen);
					
				var corresponding_hazard_enum;
					
				if ran_hazard_gen == hazard_generator_types.fire corresponding_hazard_enum = hazard_type.fire;
				else if ran_hazard_gen == hazard_generator_types.toxic_gas corresponding_hazard_enum = hazard_type.toxic_gas;
				else if ran_hazard_gen == hazard_generator_types.electric corresponding_hazard_enum = hazard_type.electric_current;
				else if ran_hazard_gen == hazard_generator_types.vacuum corresponding_hazard_enum = hazard_type.vacuum;
					
				if !is_array(room_struct_id.hazard_ar) {
					room_struct_id.hazard_ar = [];	
				}
					
				array_push(room_struct_id.hazard_ar, corresponding_hazard_enum);
			
				array_delete(ran_hazard_gen_ar, 0, 1);
			
				ran_hazard_count++;
			}
		}
		
		failsafe_val++;
	}
	until(ran_hazard_count >= ran_hazard_max || failsafe_val >= failsafe_max);
}