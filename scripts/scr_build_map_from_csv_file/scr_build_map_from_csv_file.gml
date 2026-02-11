

function scr_build_map_from_csv_file(location_enum){
	
	if location_enum == location.research_vessel {
		// Load the CSV file into the grid
		global.research_vessel_grid = load_csv("researchvesselmap.csv");
		
		global.cur_grid_w = ds_grid_width(global.research_vessel_grid);
		global.cur_grid_h = ds_grid_height(global.research_vessel_grid);
		
		global.cur_grid = global.research_vessel_grid;
		
		d($"file_grid ds_grid w: {global.cur_grid_w}, h: {global.cur_grid_h}.");
		
		var room_enum;
		
		for(var xx = 0; xx < global.cur_grid_w; xx++) {
			for(var yy = 0; yy < global.cur_grid_h; yy++){
				//Delete comma from string, if applicable:
				if xx != global.cur_grid_w-1 && yy != global.cur_grid_h-1 { //There are no commas for the last coordinates in any row/colum
					global.research_vessel_grid[# xx,yy] = string_delete(global.research_vessel_grid[# xx,yy],string_length(global.research_vessel_grid[# xx,yy]), 1);
				}
				//Convert to real number:
				global.research_vessel_grid[# xx,yy] = real(global.research_vessel_grid[# xx,yy]);
				//Show result:
				room_enum = global.research_vessel_grid[# xx,yy];
				//d($"At grid x: {xx}, y: {yy}, val == {room_enum}");
				//Now instantiate that enum:
				global.research_vessel_grid[# xx,yy] = new global.Room(location.research_vessel,room_enum,xx,yy,global.research_vessel_grid);
			}
		}
	}
}