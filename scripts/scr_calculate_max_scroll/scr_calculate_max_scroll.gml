
function scr_calculate_max_scroll(){
	
	var total_lines = array_length(global.dialogue_ar);
	
	var visible_lines = floor((global.win_h - global.lower_window_txt_buffer_y * 2) / global.dialogue_line_h);
	
	global.max_scroll = max(0,total_lines - visible_lines);
}