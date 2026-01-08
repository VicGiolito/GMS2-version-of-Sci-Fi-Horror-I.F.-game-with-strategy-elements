

function scr_return_location_enum_from_grid_id(grid_to_check){
	var location_enum = -1;
	
	if grid_to_check == global.research_vessel_grid {
		location_enum = location.research_vessel;	
	}
	//etc. etc.
	
	return location_enum;
}