
//Should be called from the scope of the o_char_struct_spr

function scr_position_char_sprite_in_room(room_struct_id){
	
	var repeat_count = 0, ar_to_use, yy = 0, xx = 0;
	var spr_w = sprite_get_width(asset_get_index("spr_pc"));
	var spr_h = sprite_get_height(asset_get_index("spr_pc"));
	var half_spr_w = spr_w / 2;
	var half_spr_h = spr_h / 2;
	var x_offset = spr_w * 2, y_offset = spr_h * 2;
	
	repeat(2) {
		
		if repeat_count == 0 ar_to_use = room_struct_id.pcs_in_room_ar;
		else if repeat_count == 1 ar_to_use = room_struct_id.neutrals_in_room_ar;
		
		if is_array(ar_to_use) {
		
			var ar_len = array_length(ar_to_use);
		
			if ar_len > 0 {
				
				var char_struct_id;
				
				var spr_origin_x = room_struct_id.grid_x*global.cell_size+global.grid_offset_x+spr_w;
				var spr_origin_y = room_struct_id.grid_y*global.cell_size+global.grid_offset_y+spr_h;
				
				for(var i = 0; i < ar_len; i++) {
					
					char_struct_id = ar_to_use[i];
					
					if is_struct(char_struct_id) && char_struct_id.struct_type_enum == struct_type.Character {
					
						if instance_exists(char_struct_id.char_sprite_inst_id) {
							
							with(char_struct_id.char_sprite_inst_id) {
								
								x = spr_origin_x+(xx*x_offset);
								y = spr_origin_y+(yy*y_offset);
								
							}
						}
						
						xx++;
						
						if xx > 3 {
							yy++;
							xx = 0;
						}
					}	
				}
			}
		}
		
		repeat_count++;
	}
}