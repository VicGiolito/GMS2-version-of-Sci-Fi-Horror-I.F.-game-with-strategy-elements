

//'vacuum' rooms are those room enums which, depending upon the 'location' enum of the grid we are using, will differ in their exact enum integer value;
//but they're important because we don't spread hazards like fire or toxic gas into these rooms, and they always have the 'vacuum' hazard.

function scr_check_for_vacuum_room(room_struct_id){
	
	if room_struct_id.location_enum == location.research_vessel && room_struct_id.room_enum == research_vessel_room.vacuum
	{
		return true;
	}
	
	return false;
}