
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
				//d($"scr_build_map_from_csv_file: iterating through retarded csv file: xx: {xx}, yy: {yy}");
				
				//Convert to real number:
				global.research_vessel_grid[# xx,yy] = real(global.research_vessel_grid[# xx,yy]);
				
				//Show result:
				room_enum = global.research_vessel_grid[# xx,yy];
				
				//Now instantiate that enum:
				global.research_vessel_grid[# xx,yy] = new global.Room(location.research_vessel,room_enum,xx,yy,global.research_vessel_grid);
				
				//Add enemies:
				var room_enum = global.research_vessel_grid[# xx,yy].room_enum;
				
				//West of stasis room:
				if room_enum == research_vessel_room.sc_corridor_west {
					if !is_array(global.research_vessel_grid[# xx,yy].enemies_in_room_ar) {
						//Debug:
						new global.Character(character.enemy_skittering_larva,xx,yy,global.research_vessel_grid,team_type.enemy,true); 
						new global.Character(character.engineer,xx,yy,global.research_vessel_grid,team_type.pc,true);
						new global.Character(character.ogre,xx,yy,global.research_vessel_grid,team_type.pc,true);
					}
				}
				
				//For path finding purposes:
				else if room_enum == research_vessel_room.shuttle_bay { //5x 18y
					if !is_array(global.research_vessel_grid[# xx,yy].enemies_in_room_ar) {
						global.research_vessel_grid[# xx,yy].enemies_in_room_ar = [];
						repeat(3) {
							new global.Character(character.enemy_skittering_larva,xx,yy,global.research_vessel_grid,team_type.enemy,true);
						}
					}
				}
				
				//Our pc spawn point:
				else if room_enum == research_vessel_room.stasis_chamber {
					if !is_array(global.research_vessel_grid[# xx,yy].enemies_in_room_ar) {
						global.research_vessel_grid[# xx,yy].enemies_in_room_ar = [];
						//Skittering larva:
						repeat(3) {
							new global.Character(character.enemy_skittering_larva,xx,yy,global.research_vessel_grid,team_type.enemy,true);
						}
						//Lumbering carrier:
						new global.Character(character.enemy_lumbering_carrier,xx,yy,global.research_vessel_grid,team_type.enemy,true);
					}
				}
				
				//East of stasis room:
				else if room_enum == research_vessel_room.sc_corridor_east {
					if !is_array(global.research_vessel_grid[# xx,yy].enemies_in_room_ar) {
						//Debug:
						new global.Character(character.enemy_skittering_larva,xx,yy,global.research_vessel_grid,team_type.enemy,true); 
						new global.Character(character.ceo,xx,yy,global.research_vessel_grid,team_type.pc,true);
						new global.Character(character.biologist,xx,yy,global.research_vessel_grid,team_type.pc,true);
					}
				}
			}
		}
	}
}