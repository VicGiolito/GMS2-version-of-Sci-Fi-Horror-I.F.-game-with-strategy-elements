
/* Fill our corresponding location grid with enums from a csv file

*/

function scr_build_map_from_csv_file(location_enum){
	
	var add_ran_enemies = false;
	
	if add_ran_enemies {
		var ran_enemy_coord_ar = [];
		
		var ran_enemy_count = 12; //irandom_range(6, 12);
		
		repeat(ran_enemy_count) {
			array_push(ran_enemy_coord_ar, { ran_x: irandom_range(3, 8), ran_y: irandom_range(3, 18) } );
		}
	}
	
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
				global.research_vessel_grid[# xx,yy] = new global.Room(location.research_vessel, room_enum, xx, yy, global.research_vessel_grid);
				
				//Define local var:
				room_struct_id = global.research_vessel_grid[# xx,yy];
				
				room_enum = room_struct_id.room_enum;
				
				//Debug: add ran enemies:
				if add_ran_enemies {
					//Iterate through ran_enemy_coord_ar:
					if is_array(ran_enemy_coord_ar) && array_length(ran_enemy_coord_ar) > 0 {
						for(var ran_i = 0; ran_i < array_length(ran_enemy_coord_ar); ran_i++){
							var coord_struct = ran_enemy_coord_ar[ran_i];
							
							if xx == coord_struct.ran_x && yy == coord_struct.ran_y {
								
								if room_enum != research_vessel_room.vacuum {
								
									new global.Character(character.enemy_skittering_larva,xx,yy,global.research_vessel_grid,team_type.enemy,true);
									array_delete(ran_enemy_coord_ar, ran_i, 1);
									break;
								}
							}
						}
					}
				}
				
				//Debug: add an enemy in the hallway to the west of the west-stasis chamber:
				if xx == 3 && yy == 8 {
					//new global.Character(character.enemy_skittering_larva,xx,yy,global.research_vessel_grid,team_type.enemy,true);	
				}
				
				//West of stasis room:
				if room_enum == research_vessel_room.sc_corridor_west {
					
					//Debug:
					//new global.Character(character.enemy_skittering_larva,xx,yy,global.research_vessel_grid,team_type.enemy,true); 
					//new global.Character(character.enemy_sodden_shambler,xx,yy,global.research_vessel_grid,team_type.enemy,true);
					
					//Debug hazards:
					/*
					if !is_array(room_struct_id.hazard_generator_ar) room_struct_id.hazard_generator_ar = [];
					array_push(room_struct_id.hazard_generator_ar, hazard_generator_types.electric);
					if !is_array(room_struct_id.hazard_ar) room_struct_id.hazard_ar = [];
					array_push(room_struct_id.hazard_ar, hazard_type.electric_current);
					*/
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
					/*
					if !is_array(room_struct_id.hazard_generator_ar) room_struct_id.hazard_generator_ar = [];
					array_push(room_struct_id.hazard_generator_ar, hazard_generator_types.toxic_gas);
					if !is_array(room_struct_id.hazard_ar) room_struct_id.hazard_ar = [];
					array_push(room_struct_id.hazard_ar, hazard_type.toxic_gas);
					*/
					
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
					
					new global.Character(character.ogre,xx,yy,global.research_vessel_grid,team_type.pc,true);
					new global.Character(character.mechanician,xx,yy,global.research_vessel_grid,team_type.pc,true);
					new global.Character(character.security_guard,xx,yy,global.research_vessel_grid,team_type.pc,true);
					new global.Character(character.doctor,xx,yy,global.research_vessel_grid,team_type.pc,true);
					new global.Character(character.engineer,xx,yy,global.research_vessel_grid,team_type.pc,true);
					new global.Character(character.service_droid,xx,yy,global.research_vessel_grid,team_type.pc,true);
					new global.Character(character.child,xx,yy,global.research_vessel_grid,team_type.pc,true);
				}
				
				//East of stasis room:
				else if room_enum == research_vessel_room.sc_corridor_east {
					
					//Debug hazards:
					
					if !is_array(room_struct_id.hazard_generator_ar) room_struct_id.hazard_generator_ar = [];
					array_push(room_struct_id.hazard_generator_ar, hazard_generator_types.fire);
					if !is_array(room_struct_id.hazard_ar) room_struct_id.hazard_ar = [];
					array_push(room_struct_id.hazard_ar, hazard_type.fire);
					
					
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