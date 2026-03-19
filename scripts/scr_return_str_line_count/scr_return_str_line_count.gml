

function scr_return_str_line_count(str_pixel_width, max_width){
	
	var str_line_count = str_pixel_width div max_width;
	
	//d($"scr_return_str_line_count: str_pixel_width == {str_pixel_width}, max_width == {max_width}, str_line_count == {str_line_count}");
	
	return str_line_count;
}