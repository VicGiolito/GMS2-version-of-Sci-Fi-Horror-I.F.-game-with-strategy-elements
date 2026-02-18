/// @description o_con draw event:

#region Debug: draw grid lines:

var room_struct_id, ar_len, hazard_enum, icon_ar,icon_enum,spr_id, spr_x,spr_y;
var y_offset = 8;

for(var xx = 0; xx < global.cur_grid_w; xx++) {
	for(var yy = 0; yy < global.cur_grid_h; yy++) {
			
		room_struct_id = global.cur_grid[# xx,yy];
		
		if is_struct(room_struct_id) && room_struct_id.struct_type_enum == struct_type.Room {

			icon_ar = [];
			
			if room_struct_id.powered_boolean == true {
				array_push(icon_ar,icon_type.powered_room);
			}
			
			var enemy_ar = room_struct_id.enemies_in_room_ar;
		
			if is_array(enemy_ar) && array_length(enemy_ar) > 0 {
				array_push(icon_ar,icon_type.enemies_present);
			}
			
			var hazard_ar = room_struct_id.hazard_ar;
			
			if is_array(hazard_ar) && array_length(hazard_ar) > 0 {
				ar_len = array_length(hazard_ar);
				for(var i = 0; i < ar_len; i++) {
					hazard_enum = hazard_ar[i];
					if hazard_enum == hazard_type.fire {
						array_push(icon_ar,icon_type.fire);	
					}
					else if hazard_enum == hazard_type.electric_current {
						array_push(icon_ar,icon_type.electric);
					}
					else if hazard_enum == hazard_type.vacuum {
						array_push(icon_ar,icon_type.vacuum);

					}
					else if hazard_enum == hazard_type.toxic_gas {
						array_push(icon_ar,icon_type.gas);	
					}
				}
			}
			
			//Now start drawing along the bottom row based upon our icon_ar:
			if array_length(icon_ar) > 0 {
				
				var ar_len = array_length(icon_ar);
				var total_row_pixel_w = ar_len * spr_icon_w;
				var spr_origin_x = (global.cell_size - total_row_pixel_w) / 2;
				
				for(var i = 0; i < ar_len; i++) {
					spr_x = xx*global.cell_size+global.grid_offset_x+spr_origin_x+i*spr_icon_w;
					spr_y = yy*global.cell_size+global.grid_offset_y+global.cell_size-spr_icon_h-y_offset;
					icon_enum = icon_ar[i];
					if icon_enum == icon_type.enemies_present spr_id = spr_hazard_enemy_present;
					else if icon_enum == icon_type.fire spr_id = spr_hazard_fire;
					else if icon_enum == icon_type.gas spr_id = spr_hazard_gas;
					else if icon_enum == icon_type.electric spr_id = spr_hazard_electrical;
					else if icon_enum == icon_type.powered_room spr_id = spr_powered_icon;
					else if icon_enum == icon_type.vacuum spr_id = spr_hazard_vacuum;
					
					draw_sprite(spr_id,0,spr_x,spr_y);
				}
			}
		}
	}
}

#endregion










