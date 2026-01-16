/// @description o_con draw gui event

//Periodically reset screen to full because occasionally it resets to smaller resolution for some unknown reason.
global.reset_full_screen_count--;
if global.reset_full_screen_count <= 0 {
	//window_set_fullscreen(true);
	global.reset_full_screen_count =  global.reset_full_screen_val;
	//show_debug_message("o_con Draw gui event: automatic timer: RESET WINDOW TO FULL.")
}

var win_w = window_get_width(), win_h = window_get_height();

#region Draw grid lines - we do this here in draw_gui event to avoid any 'camera transformations' that
/* arise from sub-pixel rendering issues. According to ai:
This is a classic sub-pixel rendering issue with zooming! When your view is scaled, the grid lines end up 
at fractional pixel positions on screen, causing them to flicker or disappear.
*/

/*

var view_x = camera_get_view_x(global.map_cam);
var view_y = camera_get_view_y(global.map_cam);
var zoom_w = camera_get_view_width(global.map_cam);
var zoom_h = camera_get_view_height(global.map_cam);

// Calculate grid boundaries in screen space
var grid_left = ((0 - view_x) / zoom_w) * display_get_gui_width();
var grid_top = ((0 - view_y) / zoom_h) * display_get_gui_height();
var grid_right = ((global.cur_grid_w * global.cell_size - view_x) / zoom_w) * display_get_gui_width();
var grid_bottom = ((global.cur_grid_h * global.cell_size - view_y) / zoom_h) * display_get_gui_height();

// Draw vertical lines
for(var xx = 0; xx <= global.cur_grid_w; xx++){
    var screen_x = ((xx * global.cell_size - view_x) / zoom_w) * display_get_gui_width();
    draw_line(screen_x, grid_top, screen_x, grid_bottom);
}

// Draw horizontal lines
for(var yy = 0; yy <= global.cur_grid_h; yy++){
    var screen_y = ((yy * global.cell_size - view_y) / zoom_h) * display_get_gui_height();
    draw_line(grid_left, screen_y, grid_right, screen_y);
}

*/

#endregion

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
	
	draw_set_valign(fa_middle)
	
	//Draw in upper left so we can use some kind of transition effect to immediately start drawing our
	//intro text in the middle of the screen, after we create an ellipse ... and the main game options
	//text slowly blinks out...
	var origin_x = global.left_window_text_offset_x;
	var origin_y = global.left_window_text_offset_y;
	
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
	
	var y_offset = string_height(ar_to_draw[0])+4;
	
	for(var i = 0; i < array_length(ar_to_draw); i++) {
		draw_text(origin_x,origin_y+(i * y_offset),string(ar_to_draw[i]) );
	}
	
	//Draw cursor:
	draw_sprite(spr_main_menu_cursor,0,origin_x-(sprite_get_width(asset_get_index("spr_main_menu_cursor"))), origin_y+(cursor_pos*y_offset) );

	scr_reset_font_align();
}

#endregion

#region game state choose chars

else if global.cur_game_state == game_state.choose_chars {
	
	draw_set_valign(fa_middle)
	
	//Draw in upper left so we can use some kind of transition effect to immediately start drawing our
	//intro text in the middle of the screen, after we create an ellipse ... and the main game options
	//text slowly blinks out...
	var origin_x = global.left_window_text_offset_x;
	var origin_y = global.left_window_text_offset_y;
	
	var y_offset = string_height(char_str_ar[0])+4;
	var asterisk_string = "";
	
	for(var i = 0; i < array_length(char_str_ar); i++) {
		asterisk_string = ""
		if scr_check_char_type_enum_in_ar(global.pc_char_ar,i) == true asterisk_string = "*";
		draw_text(origin_x,origin_y+(i * y_offset),string(char_str_ar[i])+asterisk_string);
	}
	
	//Draw cursor:
	draw_sprite(spr_main_menu_cursor,0,origin_x-(sprite_get_width(asset_get_index("spr_main_menu_cursor"))), origin_y+(cursor_pos*y_offset) );

	scr_reset_font_align();
	
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




