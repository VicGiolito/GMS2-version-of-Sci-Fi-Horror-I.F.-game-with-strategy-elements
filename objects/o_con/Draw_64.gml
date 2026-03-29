/// @description o_con draw gui event

//Periodically reset screen to full because occasionally it resets to smaller resolution for some unknown reason.
//Edit: this isn't fixing the problem or doing anything at all (apparently)
global.reset_full_screen_count--;
if global.reset_full_screen_count <= 0 {
	window_set_fullscreen(true);
	global.reset_full_screen_count = global.reset_full_screen_val;
	//show_debug_message("o_con Draw gui event: automatic timer: RESET WINDOW TO FULL.")
}

var win_w = window_get_width(), win_h = window_get_height();

//Draw our background color over the lsb monitor and lower monitor to mask the actual game room.
var c = c_black;

	//Mask left window:
draw_rectangle_color(0,0,global.left_window_x,win_h,c,c,c,c,false);
	//Mask bottom window:
draw_rectangle_color(global.left_window_x,global.top_win_h,win_w,win_h,c,c,c,c,false);
	//If applicable, mask upper window:
if global.cur_game_state <= game_state.choose_chars {
	draw_rectangle_color(global.left_window_x,0,win_w,global.top_win_h,c,c,c,c,false);	
}

#region game_state == MAIN MENU:

if global.cur_game_state == game_state.main_menu {
	
	//draw_set_valign(fa_middle);
	
	//Draw in upper left so we can use some kind of transition effect to immediately start drawing our
	//intro text in the middle of the screen, after we create an ellipse ... and the main game options
	//text slowly blinks out...
	var origin_x = global.left_window_text_offset_x;
	var origin_y = global.left_window_text_offset_y;
	var y_offset = global.default_line_h;
	
	//Define ar_to_draw:
	
	if cur_main_menu_option == main_menu_options.main {
		ar_to_draw = main_menu_str_ar;
	} 
	else if cur_main_menu_option == main_menu_options.video_options {
		ar_to_draw = video_options_str_ar;
	}
	else if cur_main_menu_option == main_menu_options.options {
		ar_to_draw = options_menu_str_ar;
	}
	else if cur_main_menu_option == main_menu_options.resolutions_options {
		ar_to_draw = resolutions_str_ar;
	}
	
	var cursor_offset_y = 12;
	
	for(var i = 0; i < array_length(ar_to_draw); i++) {
		draw_text(origin_x,origin_y+(i * y_offset),string(ar_to_draw[i]) );
	}
	
	//Draw cursor:
	draw_sprite(spr_main_menu_cursor,0,origin_x-(sprite_get_width(asset_get_index("spr_main_menu_cursor"))), origin_y+cursor_offset_y+(cursor_pos*global.default_line_h) );

	//scr_reset_font_align();
}

#endregion

#region game state choose chars

else if global.cur_game_state == game_state.choose_chars {
	
	//draw_set_valign(fa_middle);
	
	//Draw in upper left so we can use some kind of transition effect to immediately start drawing our
	//intro text in the middle of the screen, after we create an ellipse ... and the main game options
	//text slowly blinks out...
	var origin_x = global.left_window_text_offset_x;
	var origin_y = global.left_window_text_offset_y;
	
	var cursor_offset_y = 12;
	var asterisk_string = "";
	
	//Draw a bit of an explanation of what the left side window is being used for:
	draw_text(origin_x,origin_y,"BROWSE THE STASIS PODS:");
	origin_y += global.default_line_h*2;
	
	for(var i = 0; i < array_length(char_str_ar); i++) {
		asterisk_string = ""
		if scr_check_char_type_enum_in_ar(global.pc_char_ar,i) == true asterisk_string = "*";
		draw_text(origin_x,origin_y+(i * global.default_line_h),string(char_str_ar[i])+asterisk_string);
	}
	
	//Draw cursor:
	draw_sprite(spr_main_menu_cursor,0,origin_x-(sprite_get_width(asset_get_index("spr_main_menu_cursor"))), origin_y+cursor_offset_y+(cursor_pos*global.default_line_h) );

	//scr_reset_font_align();
}

#endregion

#region Draw left window data for if game_state >= main: 

else if global.cur_game_state >= game_state.main_game {
	
	var origin_x = global.left_window_text_offset_x;
	var origin_y = global.left_window_text_offset_y;
	
	var cur_char = global.acting_char_struct_id;
	
	if global.combat_begun cur_char = global.cur_combat_char;
	
	//Draw global resources:
	draw_text(origin_x,origin_y,$"Food: {global.resources_food} Scrap: {global.resources_scrap} Engine Fuel: {global.resources_engine_fuel}");
	
	origin_y += global.default_line_h;
	
	draw_text(origin_x,origin_y, $"Basic Tech.: {global.resources_basic_tech} Advanced Tech.: {global.resources_advanced_tech}");
	
	origin_y += global.default_line_h;
	
	draw_text(origin_x,origin_y, $"Ammunition: {global.resources_ammo}");
	
	if is_struct(cur_char) && cur_char.struct_type_enum == struct_type.Character {
		
		var is_pc_char = true;
		
		if cur_char.char_team_enum != team_type.pc is_pc_char = false;
		
		origin_y += global.default_line_h*2;
		
		var controlling_str = "";
		
		if is_pc_char controlling_str = "Controlling: ";
		
		draw_text(origin_x,origin_y,$"{controlling_str}{cur_char.name}");
	
		origin_y += global.default_line_h*2;
		
		//PC Stats - AP, MP, Sanity, and skills:
		if is_pc_char {
			//AP, Sanity, MP:
			var sanity_str = "";
			if cur_char.char_type_enum != character.service_droid {
				sanity_str = $" Sanity: {cur_char.sanity_cur}/{cur_char.sanity_max}";
			}
			draw_text(origin_x,origin_y,$"A.P.: {cur_char.ability_points_cur}/{cur_char.ability_points_max}{sanity_str} M.P.: {cur_char.move_points_cur}/{cur_char.move_points_max}");
			
			origin_y += global.default_line_h*2;

			//Skills:
			draw_text(origin_x,origin_y,$"Security: {cur_char.security} Engineering: {cur_char.engineering}");
			origin_y += global.default_line_h;
			draw_text(origin_x,origin_y,$"Science: {cur_char.science} Stealth: {cur_char.stealth}");
		
			origin_y += global.default_line_h*2;
		}
		
		//Universal stats - HP, Armor, Evasion, Accuracy, Speed:
		draw_text(origin_x,origin_y,$"HP: {cur_char.hp_cur}/{cur_char.hp_max} Armor: {cur_char.armor} Evasion: {cur_char.evasion}");
		origin_y += global.default_line_h;
		
		draw_text(origin_x,origin_y,$"Accuracy: {cur_char.accuracy} Speed: {cur_char.spd}");
		
		origin_y += global.default_line_h*2;
		
		
		//Universal - Resistences:
		draw_text(origin_x,origin_y,$"Resistances: Fire: {cur_char.res_fire} Vacuum: {cur_char.res_vacuum}");
		origin_y += global.default_line_h;
		draw_text(origin_x,origin_y,$"Electric: {cur_char.res_electric} Poison: {cur_char.res_poison} Bleed: {cur_char.res_bleed}");
		origin_y += global.default_line_h;
		draw_text(origin_x,origin_y,$"Stun: {cur_char.res_stun} Infection: {cur_char.res_infect} Suppress: {cur_char.res_suppress}");
		origin_y += global.default_line_h;
		draw_text(origin_x,origin_y,$"Toxic Gas: {cur_char.res_gas}");
		
		origin_y += global.default_line_h*2;
		
		//Status effects:
		var status_effect_str = scr_return_status_effects_str(cur_char);
		
		if status_effect_str != "None" {
			
			//d($"o_con draw gui event: left window drawing stats code: global.left_window_width == {global.left_window_width}, global.left_win_w_percent == {global.left_win_w_percent}, global.left_window_text_offset_x * 2 == {global.left_window_text_offset_x * 2}");
			
			var max_char_pixel_w = (global.left_window_width)-(global.left_window_text_offset_x * 2);
			
			draw_text_ext(origin_x,origin_y,status_effect_str,global.default_line_h, max_char_pixel_w);
			
			//Account for lines that the above draw function required:
			var line_count = scr_return_str_line_count(string_width(status_effect_str), max_char_pixel_w);
			
			origin_y += global.default_line_h*line_count;
			
			//d($"o_con draw gui event: left window drawing stats code: line_count == {line_count}");
			
			//Account for space until 'abilities':
			origin_y += global.default_line_h*2;
		}
		
		//Draw header if this char has active or passive abilities:
		if (is_array(cur_char.ability_ar) && array_length(cur_char.ability_ar) > 0) || 
		(is_array(cur_char.passive_abil_ar) && array_length(cur_char.passive_abil_ar) > 0) {
			draw_text(origin_x,origin_y,$"Abilities:"); 
			origin_y += global.default_line_h;
		}
		
		//Active Abilities:
		if is_array(cur_char.ability_ar) && array_length(cur_char.ability_ar) > 0 {
			
			var ar_len = array_length(cur_char.ability_ar)
		
			var abil_enum;
			for(var i = 0; i < ar_len; i++) {
				
				abil_enum = cur_char.ability_ar[i];
				
				if abil_enum != -1 {
					
					var abil_name = "undefined";
					
					abil_name = global.item_reference_table[abil_enum].item_name;
					
					//Insert 'SPAWN' in front of the string:
					if abil_enum >= item_type.spawn_light_sentry_gun && abil_enum <= item_type.spawn_light_buzzsaw_droid {
						abil_name = string_insert("SPAWN ", abil_name, 1);
					}
					
					if global.item_reference_table[abil_enum].use_context == abil_use_context.combat_only {
						abil_name += " (combat)";
					}
					
					draw_text(origin_x,origin_y,$"{abil_name}");
					origin_y += global.default_line_h;
				}
			}
		}
		
		//Passive abilities - PCS only:
		if cur_char.char_team_enum == team_type.pc {
			if is_array(cur_char.passive_abil_ar) && array_length(cur_char.passive_abil_ar) > 0 {
			
				var ar_len = array_length(cur_char.passive_abil_ar)
		
				var passive_abil_enum, abil_name_str;
				for(var i = 0; i < ar_len; i++) {
				
					passive_abil_enum = cur_char.passive_abil_ar[i];
					
					abil_name_str = scr_return_passive_abil_enum_name(passive_abil_enum);
					
					draw_text(origin_x,origin_y,$"{abil_name_str} (passive)");
					origin_y += global.default_line_h;
				}
			}
		}
		
		origin_y += global.default_line_h;
		
		//Start drawing inventory:
		draw_text(origin_x,origin_y,$"Inventory:"); 
		
		origin_y += global.default_line_h;
		
		var accessory_name = "";
		if is_struct(cur_char.inv_ar[equip_slot.accessory]) && cur_char.inv_ar[equip_slot.accessory].struct_type_enum == struct_type.Item {
			accessory_name = cur_char.inv_ar[equip_slot.accessory].item_name;
		}
		
		draw_text(origin_x,origin_y,$"0.) Accessory: {accessory_name}"); 
		
		origin_y += global.default_line_h;
		
		var body_item_name = "";
		if is_struct(cur_char.inv_ar[equip_slot.body]) && cur_char.inv_ar[equip_slot.body].struct_type_enum == struct_type.Item {
			body_item_name = cur_char.inv_ar[equip_slot.body].item_name;
		}
		
		draw_text(origin_x,origin_y,$"1.) Body: {body_item_name}"); 
		
		origin_y += global.default_line_h;
		
		var item_name = "";
		if is_struct(cur_char.inv_ar[equip_slot.rh]) && cur_char.inv_ar[equip_slot.rh].struct_type_enum == struct_type.Item {
			item_name = cur_char.inv_ar[equip_slot.rh].item_name;
		}
		
		draw_text(origin_x,origin_y,$"2.) Right Hand: {item_name}"); 
		
		origin_y += global.default_line_h;
		
		var item_name = "";
		if is_struct(cur_char.inv_ar[equip_slot.lh]) && cur_char.inv_ar[equip_slot.lh].struct_type_enum == struct_type.Item {
			item_name = cur_char.inv_ar[equip_slot.lh].item_name;
		}
		
		draw_text(origin_x,origin_y,$"3.) Left Hand: {item_name}"); 
		
		if is_pc_char {
		
			origin_y += global.default_line_h*2;
		
			draw_text(origin_x,origin_y,$"Carrying:"); 
		
			origin_y += global.default_line_h;
		
			var ar_len = array_length(cur_char.inv_ar)
		
			if ar_len > equip_slot.total_slots {
				var item_struct_id;
				for(var i = equip_slot.total_slots; i < ar_len; i++) {
					item_struct_id = cur_char.inv_ar[i];
					if is_struct(item_struct_id) && item_struct_id.struct_type_enum == struct_type.Item {
						draw_text(origin_x,origin_y,$"{i}.) {item_struct_id.item_name}");
						origin_y += global.default_line_h;
					}
				}
			}
		}
	}
}

#endregion

#region Draw our global.dialogue_ar in the bounds of the lower dialogue window - currently visible in any game state:

// Calculate visible line range
var start_line = floor(global.scroll_position);
var visible_lines = ceil((dialogue_window_height - global.lower_window_txt_buffer_x * 2) / global.dialogue_line_h) + 1;

// Draw text lines
var text_x = dialogue_window_x + global.lower_window_txt_buffer_x;
var text_y = dialogue_window_y + global.lower_window_txt_buffer_y - ((global.scroll_position - start_line) * global.dialogue_line_h);

for (var i = start_line; i < min(start_line + visible_lines, array_length(global.dialogue_ar)); i++) {
    if (i >= 0 && i < array_length(global.dialogue_ar)) {
        var current_y = text_y + ((i - start_line) * global.dialogue_line_h);
        
        // Only draw if within window bounds
        if (current_y >= dialogue_window_y && current_y < dialogue_window_y + dialogue_window_height) {
            draw_text(text_x, current_y, global.dialogue_ar[i]);
        }
    }
}

// Draw scrollbar only if there's content to scroll
if (global.max_scroll > 0) {
    // Recalculate scrollbar positions for drawing
    var scrollbar_x = dialogue_window_x + dialogue_window_width - global.scrollbar_width - scrollbar_right_edge_offset_x;
    var scrollbar_y = dialogue_window_y + scrollbar_right_edge_offset_y;
    var scrollbar_track_height = dialogue_window_height - scrollbar_right_edge_offset_y;
    
    var scroll_ratio = global.scroll_position / global.max_scroll;
    var visible_ratio = min(1, (dialogue_window_height / global.dialogue_line_h) / array_length(global.dialogue_ar));
    var button_height = max(global.scrollbar_button_height, scrollbar_track_height * visible_ratio);
    var button_y = scrollbar_y + (scrollbar_track_height - button_height) * scroll_ratio;
    
    // Draw scrollbar track
    draw_rectangle_color(scrollbar_x, scrollbar_y, 
                   scrollbar_x + global.scrollbar_width, 
                   scrollbar_y + scrollbar_track_height, global.scrollbar_color,global.scrollbar_color,global.scrollbar_color,global.scrollbar_color,false);
    
    // Draw scrollbar button
    draw_rectangle_color(scrollbar_x, button_y,
                   scrollbar_x + global.scrollbar_width,
                   button_y + button_height, global.scrollbar_button_color,global.scrollbar_button_color,global.scrollbar_button_color,global.scrollbar_button_color,false);
    
    // Draw button border
    draw_set_color(c_white);
    draw_rectangle(scrollbar_x, button_y,
                   scrollbar_x + global.scrollbar_width,
                   button_y + button_height, true);
				   
	// Reset drawing settings
	draw_set_color(global.default_fnt_color);
	draw_set_alpha(1);
}

#endregion

#region Draw text input cursor (blinking line)

// Only draw cursor if we're in a state where text input is expected
if array_length(global.dialogue_ar) > 0 { 
    
    // Instance variables for cursor position (add these to your Create event or variable definitions)
    // cursor_x and cursor_y will mark where new text should appear
    
    // Calculate cursor position based on last line in dialogue array
   
    // Get the last visible line
    var last_line_index = array_length(global.dialogue_ar) - 1;
    var last_line_text = global.dialogue_ar[last_line_index];
        
    // Position cursor to the right of the last character
    cursor_x = text_x + string_width(last_line_text);
    cursor_y = text_y + (last_line_index - start_line) * global.dialogue_line_h;
        
    // Make cursor blink (using a simple timer)
    cursor_blink_timer += 1;
    if (cursor_blink_timer >= cursor_blink_speed) {
        cursor_blink_timer = 0;
        cursor_visible = !cursor_visible;
    }
        
    // Draw the cursor if visible and within window bounds
    if (cursor_visible && cursor_y >= dialogue_window_y && cursor_y < dialogue_window_y + dialogue_window_height) {
        var cursor_height = string_height(last_line_text);
        draw_line_width(cursor_x+(string_width(player_input_str)), cursor_y + cursor_height, cursor_x+(string_width(player_input_str)), cursor_y, 2);
    }
	
	//Draw our player_input_str:
	draw_text(cursor_x,cursor_y,string(player_input_str));
}

#endregion

//Draw our foreground UI, in any game state:
draw_sprite_ext(spr_foreground_UI_320_200,0,0,0,global.foreground_ui_scale,global.foreground_ui_scale,0,c_white,1);

//Draw our fps values:
var debug_fps_str = "Intended FPS: "+string(game_get_speed(gamespeed_fps))+", Actual FPS: "+string(fps_real);
draw_text_color(win_w-string_width(debug_fps_str)-16,32,debug_fps_str,c_red,c_red,c_red,c_red,1);




