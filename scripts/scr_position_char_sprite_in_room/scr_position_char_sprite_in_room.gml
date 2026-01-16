
//Should be called from the scope of the o_char_struct_spr

function scr_position_char_sprite_in_room(room_struct_id){
	
	var repeat_count = 0, ar_to_use, yy = 0;
	repeat(3) {
		
		var xx = 0;
		
		if repeat_count == 0 ar_to_use = room_struct_id.pcs_in_room_ar;
		else if repeat_count == 1 ar_to_use = room_struct_id.neutrals_in_room_ar;
		else ar_to_use = room_struct_id.enemies_in_room_ar;
		
		if is_array(ar_to_use) {
		
			var ar_len = array_length(ar_to_use);
		
			if ar_len > 0 {
				
				var char_struct_id;
				
				var x_offset = sprite_get_width(asset_get_index("spr_pc"))+8;
				var y_offset = sprite_get_height(asset_get_index("spr_pc"))+8;
				var spr_origin_x = room_struct_id.grid_x*global.cell_size+global.grid_offset_x+x_offset;
				var spr_origin_y = room_struct_id.grid_y*global.cell_size+global.grid_offset_y+y_offset;
				
				for(var i = 0; i < ar_len; i++) {
					
					char_struct_id = ar_to_use[i];
					
					if is_struct(char_struct_id) && char_struct_id.struct_type_enum == struct_type.Character {
					
						if instance_exists(char_struct_id.char_sprite_inst_id) {
							
							with(char_struct_id.char_sprite_inst_id) {
								
								x = spr_origin_x+(xx*x_offset);
								y = spr_origin_y+(yy*y_offset);;
								
							}
						}
						
						xx++;
					}	
				}
			}
		}
		
		repeat_count++;
		yy++;
	}
	
	
	
	//Just position in center coordinates of room:
	var spr_x = char_struct_id.cur_grid_x*global.cell_size+global.half_c+global.grid_offset_x;
	var spr_y = char_struct_id.cur_grid_y*global.cell_size+global.half_c+global.grid_offset_y;
	
	x = spr_x;
	y = spr_y;
}