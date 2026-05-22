
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
		
		var room_enum, room_struct_id;
		
		for(var xx = 0; xx < global.cur_grid_w; xx++) {
			for(var yy = 0; yy < global.cur_grid_h; yy++){
				//d($"scr_build_map_from_csv_file: iterating through retarded csv file: xx: {xx}, yy: {yy}");
				
				//Convert to real number:
				global.research_vessel_grid[# xx,yy] = real(global.research_vessel_grid[# xx,yy]);
				
				//Show result:
				room_enum = global.research_vessel_grid[# xx,yy];
				
				//Now instantiate that enum:
					//location_type_enum, room_type_enum, spawn_grid_x, spawn_grid_y, location_grid_id)
				global.research_vessel_grid[# xx,yy] = new global.Room(location.research_vessel,room_enum, xx, yy, global.research_vessel_grid);
				
				//Define local var:
				room_struct_id = global.research_vessel_grid[# xx,yy];
				
				room_enum = room_struct_id.room_enum;
				
				//West of stasis room:
				if room_enum == research_vessel_room.sc_corridor_west {
					
					//Debug:
					//new global.Character(character.enemy_skittering_larva,xx,yy,global.research_vessel_grid,team_type.enemy,true); 
					//new global.Character(character.enemy_sodden_shambler,xx,yy,global.research_vessel_grid,team_type.enemy,true);
					
				}
				
				//For path finding purposes:
				else if room_enum == research_vessel_room.shuttle_bay { //5x 18y
					
					//Debug enemies:
					repeat(1) {
						//new global.Character(character.enemy_skittering_larva,xx,yy,global.research_vessel_grid,team_type.enemy,true);
					}
					
					//Debug pcs
					//new global.Character(character.ogre,xx,yy,global.research_vessel_grid,team_type.pc,true);
				}
				
				//Stasis Room - Our pc spawn point:
				else if room_enum == research_vessel_room.stasis_chamber {
					
					//Debug hazards:
					if !is_array(room_struct_id.hazard_generator_ar) room_struct_id.hazard_generator_ar = [];
					array_push(room_struct_id.hazard_generator_ar, hazard_generator_types.toxic_gas);
					if !is_array(room_struct_id.hazard_ar) room_struct_id.hazard_ar = [];
					array_push(room_struct_id.hazard_ar, hazard_type.toxic_gas);
					
					//Debug enemies
					
					repeat(1) {
						//new global.Character(character.enemy_skittering_larva,xx,yy,global.research_vessel_grid,team_type.enemy,true);
						//new global.Character(character.enemy_sodden_shambler,xx,yy,global.research_vessel_grid,team_type.enemy,true);
						//new global.Character(character.enemy_spined_spitter,xx,yy,global.research_vessel_grid,team_type.enemy,true);
						//new global.Character(character.enemy_lumbering_carrier,xx,yy,global.research_vessel_grid,team_type.enemy,true);
						//new global.Character(character.enemy_chittering_lurker,xx,yy,global.research_vessel_grid,team_type.enemy,true);
					}
					
					repeat(6) {
						//new global.Character(character.enemy_lumbering_carrier,xx,yy,global.research_vessel_grid,team_type.enemy,true);
						//new global.Character(character.enemy_skittering_larva,xx,yy,global.research_vessel_grid,team_type.enemy,true);
						//new global.Character(character.enemy_spined/_spitter,xx,yy,global.research_vessel_grid,team_type.enemy,true);
						//new global.Character(character.enemy_sodden_shambler,xx,yy,global.research_vessel_grid,team_type.enemy,true);
						//new global.Character(character.neutral_light_sentry_gun,xx,yy,global.research_vessel_grid,team_type.enemy,true);
						//global.Character(character.enemy_transmogrified_soldier,xx,yy,global.research_vessel_grid,team_type.enemy,true);
						//new global.Character(character.enemy_chittering_lurker,xx,yy,global.research_vessel_grid,team_type.enemy,true);
					}
						
					//Debug pcs:
					
					//new global.Character(character.ogre,xx,yy,global.research_vessel_grid,team_type.pc,true);
					new global.Character(character.mechanician,xx,yy,global.research_vessel_grid,team_type.pc,true);
					//new global.Character(character.security_guard,xx,yy,global.research_vessel_grid,team_type.pc,true);
					//new global.Character(character.doctor,xx,yy,global.research_vessel_grid,team_type.pc,true);
					//new global.Character(character.engineer,xx,yy,global.research_vessel_grid,team_type.pc,true);
					//new global.Character(character.service_droid,xx,yy,global.research_vessel_grid,team_type.pc,true);
					new global.Character(character.child,xx,yy,global.research_vessel_grid,team_type.pc,true);
				}
				
				//East of stasis room:
				else if room_enum == research_vessel_room.sc_corridor_east {
					
					//Debug:
						//Enemies:
					//new global.Character(character.enemy_skittering_larva,xx,yy,global.research_vessel_grid,team_type.enemy,true); 
					//new global.Character(character.enemy_sodden_shambler,xx,yy,global.research_vessel_grid,team_type.enemy,true);
						//Debug pcs:
					//new global.Character(character.ceo,xx,yy,global.research_vessel_grid,team_type.pc,true);
					//new global.Character(character.doctor,xx,yy,global.research_vessel_grid,team_type.pc,true);
					
				}
			}
		}
		
		return global.research_vessel_grid;
	}
}