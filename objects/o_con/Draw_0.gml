/// @description o_con draw event:

#region debug only:

if global.cur_game_state >= game_state.main_game {

	var debug_flood_fill_grids = true;

	if debug_flood_fill_grids && is_array(global.pc_char_ar) && array_length(global.pc_char_ar) > 0 {
		
		var offset_x = 48, offset_y = global.half_c;
		var ar_len = array_length(global.pc_char_ar);
		
		for(var i = 0; i < ar_len; i++) {
			
			if ds_exists(global.pc_char_ar[i].flood_fill_path_grid, ds_type_grid) {
				var grid_to_use = global.pc_char_ar[i].flood_fill_path_grid;
				var grid_w = ds_grid_width(grid_to_use), grid_h = ds_grid_height(grid_to_use);
				
				for(var xx = 0; xx < grid_w; xx++) {
					for(var yy = 0; yy < grid_h; yy++) {
						var step_val = grid_to_use[# xx,yy];
						
						if step_val != UNVISITED_STEP_VAL {
							draw_text(global.cell_size*xx+global.grid_offset_x+offset_x+(offset_x*i),
							global.cell_size*yy+global.grid_offset_y+offset_y,string(step_val) );	
						}
					}
				}
			}	
		}
	}
}

#endregion

#region Draw hazard, hazard generators, and enemy present icons:

if global.cur_game_state >= game_state.main_game && global.cur_game_state < game_state.combat_paused {
	
	var room_struct_id, ar_len, hazard_enum, icon_ar,icon_enum,spr_id, spr_x,spr_y;
	var y_offset = 8, step_c = c_red, step_val;
	var debug_step_vals = false;
	
	if ds_exists(global.cur_grid,ds_type_grid) {
	
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
					
					if is_array(room_struct_id.hazard_generator_ar) && array_length(room_struct_id.hazard_generator_ar) > 0 {
						if scr_check_ar_for_val(room_struct_id.hazard_generator_ar, hazard_generator_types.fire) == true {
							array_push(icon_ar, icon_type.fire_gen);
						}
						if scr_check_ar_for_val(room_struct_id.hazard_generator_ar, hazard_generator_types.vacuum) == true {
							array_push(icon_ar, icon_type.vacuum_gen);
						}
						if scr_check_ar_for_val(room_struct_id.hazard_generator_ar, hazard_generator_types.electric) == true {
							array_push(icon_ar, icon_type.electric_gen);
						}
						if scr_check_ar_for_val(room_struct_id.hazard_generator_ar, hazard_generator_types.toxic_gas) == true {
							array_push(icon_ar, icon_type.gas_gen);
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
							else if icon_enum == icon_type.vacuum_gen spr_id = spr_hazard_vacuum_gen;
							else if icon_enum == icon_type.fire_gen spr_id = spr_hazard_fire_gen;
							else if icon_enum == icon_type.gas_gen spr_id = spr_hazard_gas_gen;
							else if icon_enum == icon_type.electric_gen spr_id = spr_hazard_electrical_gen;
					
							draw_sprite(spr_id,0,spr_x,spr_y);
						}
					}
				}
		
				//Debug only:
				if ds_exists(global.steps_grid,ds_type_grid) && debug_step_vals {
			
					step_val = global.steps_grid[# xx,yy];
			
					if step_val != UNVISITED_STEP_VAL {
						draw_text_color(xx*global.cell_size+global.grid_offset_x+global.half_c,
						yy*global.cell_size+global.grid_offset_y+global.half_c,string(step_val),step_c,step_c,step_c,step_c,1);
					}
				}
			}
		}
	}
}

#endregion

#region Draw our player sprites:

if global.cur_game_state >= game_state.main_game && global.cur_game_state < game_state.combat_paused {
	if is_array(global.pc_char_ar) && array_length(global.pc_char_ar) > 0 {
		
		var ar_len = array_length(global.pc_char_ar), pc_char_id;
		var name_offset_y = 8;
		
		for(var i = 0; i < ar_len; i++){
	
			pc_char_id = global.pc_char_ar[i];
			
			//Draw sprite - its vars have already been defined by scr_update_char_sprite_position_vars:
			draw_sprite(spr_pc,0,pc_char_id.char_sprite_room_x,pc_char_id.char_sprite_room_y);
			
			//Draw char name:
			scr_center_font_align();
			draw_set_font(fnt_default_8);
			draw_text(pc_char_id.char_sprite_room_x,pc_char_id.char_sprite_room_y-(char_spr_h+name_offset_y),string(pc_char_id.nick_name) );
			scr_reset_font_align();
			scr_reset_font();
			
			//Draw cur char if applicable:
			if global.cur_game_state > game_state.choose_chars && global.cur_game_state < game_state.combat_paused {
				if global.acting_char_struct_id != -1 && is_struct(global.acting_char_struct_id) && global.acting_char_struct_id.struct_type_enum == struct_type.Character &&
				global.acting_char_struct_id.has_died_bool == false && global.acting_char_struct_id.stun_count <= 0 && global.acting_char_struct_id.unconscious_bool == false {
					
					if global.acting_char_struct_id == pc_char_id {
					
						cur_char_spr_counter++;
					
						if cur_char_spr_counter < game_get_speed(gamespeed_fps) {
							draw_sprite(spr_cur_char_spr,0,pc_char_id.char_sprite_room_x,pc_char_id.char_sprite_room_y)	;
						}
						
						if cur_char_spr_counter > game_get_speed(gamespeed_fps)*2 {
							cur_char_spr_counter = 0;	
						}
					}
				}
			}
		}
	}
}

#endregion
