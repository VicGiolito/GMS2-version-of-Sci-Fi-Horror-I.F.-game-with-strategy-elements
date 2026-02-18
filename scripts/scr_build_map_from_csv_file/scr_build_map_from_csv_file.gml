
/* Fill our corresponding location grid with enums from a csv file



*/

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
				
				//Add enemies:
				var room_enum = global.research_vessel_grid[# xx,yy].room_enum;
				if room_enum == research_vessel_room.sc_corridor_west {
					if !is_array(global.research_vessel_grid[# xx,yy].enemies_in_room_ar) {
						//global.research_vessel_grid[# xx,yy].enemies_in_room_ar = [];
						//array_push(global.research_vessel_grid[# xx,yy].enemies_in_room_ar, new global.Character(character.enemy_skittering_larva,xx,yy,global.research_vessel_grid,team_type.enemy,true));
						//function(char_enum, spawn_grid_x, spawn_grid_y, spawn_grid, team_enum, add_to_room_list_bool, wep_loadout_int = 0) 
					}
				}
				else if room_enum == research_vessel_room.shuttle_bay {
					if !is_array(global.research_vessel_grid[# xx,yy].enemies_in_room_ar) {
						global.research_vessel_grid[# xx,yy].enemies_in_room_ar = [];
						repeat(3) {
							array_push(global.research_vessel_grid[# xx,yy].enemies_in_room_ar, new global.Character(character.enemy_skittering_larva,xx,yy,global.research_vessel_grid,team_type.enemy,true));
							//function(char_enum, spawn_grid_x, spawn_grid_y, spawn_grid, team_enum, add_to_room_list_bool, wep_loadout_int = 0) 
						}
					}
				}
			}
		}
	}
}