

function scr_char_location_enum_from_cur_grid_id(char_struct_id){
	
	var location_enum = -1;
	var char_cur_grid = char_struct_id.cur_grid;
	
	if char_cur_grid == global.research_vessel_grid {
		location_enum = location.research_vessel;
	}
	
	return location_enum;
}