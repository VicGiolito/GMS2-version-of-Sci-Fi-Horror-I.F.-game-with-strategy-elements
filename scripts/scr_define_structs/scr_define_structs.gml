


function scr_define_structs(){
	
	#region Room struct:
	
	Room = function(location_type_enum,room_type_enum,spawn_grid_x,spawn_grid_y,location_grid_id) constructor
	{
		struct_type_enum = struct_type.Room;
		
		scavenge_ar = -1; //Everything == and after scavenge_resource.total_resources index is an item
		
		powered_boolean = false;
		
		cover_enum = cover_val.none; //May not even implement this; provides a static buff or debuff to pcs during combat, making some rooms more suitable as defensive choke points.
		
		unpowered_room_desc = "undefined";
		powered_room_desc = "undefined";
		post_event_unpowered_room_desc = "undefined";
		post_event_powered_room_desc = "undefined";
		
		scavenged_once_boolean = false; //When == true, we always show the items in this room.
		already_explored_boolean = false; //Determines whether or not we show the name and any enemies in that room when within the CHOOSE_DOOR_DIRECTION game state; if true, we do show all that.
		
		keyword_interaction_str_ar = -1 //Is used as an array
		
		directional_ar = -1; //Array containing structs
		
		enemies_in_room_ar = -1
		pcs_in_room_ar = -1
		neutrals_in_room_ar = -1
		
		grid_x = spawn_grid_x;
		grid_y = spawn_grid_y
		
		room_enum = room_type_enum;
		location_enum = location_type_enum;
		location_grid = location_grid_id
		
		room_name_str = "undefined"
		
        if location_type_enum == location.research_vessel {
			
			if room_enum == research_vessel_room.basic_corridor_ew {
				scavenge_ar = [];
				for(var i = 0; i < scavenge_resource.total_resources; i++) {
					array_push(scavenge_ar,0);
				}
				scavenge_ar[scavenge_resource.tech_basic] = irandom_range(0,3);
				
				unpowered_room_desc = "This basic corridor only serves as a connection between two areas on the ship. The floor is metal grating and the walls are dirty panels of burnished steel. A few piles of refuse lay scattered about, evidence of the vessel's disuse."
				powered_room_desc = unpowered_room_desc;
				
				directional_ar = [];
				array_push(directional_ar,{ door_dir: "EAST", door_state: door_state.unlocked });
				array_push(directional_ar,{ door_dir: "WEST", door_state: door_state.unlocked });
				
				room_name_str = "EAST-WEST CORRIDOR";	
			}
			
			else if room_enum == research_vessel_room.basic_corridor_ns {
				scavenge_ar = [];
				for(var i = 0; i < scavenge_resource.total_resources; i++) {
					array_push(scavenge_ar,0);
				}
				scavenge_ar[scavenge_resource.tech_basic] = irandom_range(0,3);
				
				unpowered_room_desc = "This basic corridor only serves as a connection between two areas on the ship. The floor is metal grating and the walls are dirty panels of burnished steel. A few piles of refuse lay scattered about, evidence of the vessel's disuse."
				powered_room_desc = unpowered_room_desc;
				
				directional_ar = [];
				array_push(directional_ar,{ door_dir: "EAST", door_state: door_state.unlocked });
				array_push(directional_ar,{ door_dir: "WEST", door_state: door_state.unlocked });
				
				room_name_str = "NORTH-SOUTH CORRIDOR";
			}
			
			else if room_enum == research_vessel_room.storage_room {
				scavenge_ar = [];
				for(var i = 0; i < scavenge_resource.total_resources; i++) {
					array_push(scavenge_ar,0);
				}
				scavenge_ar[scavenge_resource.tech_basic] = irandom_range(0,3);
				scavenge_ar[scavenge_resource.tech_advanced] = 1;
				scavenge_ar[scavenge_resource.food] = irandom_range(6,12);
				
				unpowered_room_desc = "Racks of mostly empty shelving and opened boxes indicate that this room was once used for storage. Dust and debris are mostly all that remain. It looks as though the most important items have been pilfered already. The whirling red flare of the emergency lights overhead sends strange shadows pin-wheeling across the walls.";
				
				room_name_str = "STORAGE ROOM"
			}
			
			else if room_enum == research_vessel_room.hydroponics_lab {
				scavenge_ar = [];
				for(var i = 0; i < scavenge_resource.total_resources; i++) {
					array_push(scavenge_ar,0);
				}
				scavenge_ar[scavenge_resource.food] = irandom_range(12,24);
				
				unpowered_room_desc = "Rows and rows of metal grow boxes line the room, their contents nothing more than withered weeds to clutching to dry, gray dirt. There's a nest of hydraulics and hoses in the walls, and huge sunlamps are recessed in the ceiling, now dark and inert. If you can restore power to this room, perhaps there's a way to get these hydroponics working again?"
				powered_room_desc = "The rows of hydroponics buzz happily with spray from the moisture pumps, while the leafy green vegetables within eagerly drink the light from the sunlamps overhead. These crops of potatoes, beans, and cabbages have clearly been genetically modified to grow quickly."
				
				room_name_str = "HYDROPONICS LAB"
			}
			
			else if room_enum == research_vessel_room.stasis_chamber {
				scavenge_ar = [];
				for(var i = 0; i < scavenge_resource.total_resources; i++) {
					array_push(scavenge_ar,0);
				}
				scavenge_ar[scavenge_resource.food] = 12;
				scavenge_ar[scavenge_resource.ammo] = 55;
				scavenge_ar[scavenge_resource.tech_basic] = 4;
				
				//Items:
				//self.scavenge_resource_list.append(Item(ENUM_ITEM_SUIT_ENVIRONMENTAL))
                //self.scavenge_resource_list.append(Item(ENUM_ITEM_MEDKIT))
				
				directional_ar = [];
				array_push(directional_ar,{ door_dir: "EAST", door_state: door_state.unlocked });
				array_push(directional_ar,{ door_dir: "WEST", door_state: door_state.unlocked });
				
                room_name_str = "STASIS ROOM";
				
				unpowered_room_desc = [
					"Klaxons blare, and an eerie red illumination seeps from the emergency lights in the floor. Row upon row of stasis pods have been arranged in this room, most of them shattered or inoperable. Those corpses who had sought refuge within them have met a truly ignoble end, asphyxiated in their sleep. There's only one STASIS POD that still looks operational and inviting, gleaming pearl-white in the blood-hued gloom.",
                    "The room itself has been badly damaged. Refuse and debris lay scattered about, along with piles of personal effects: whatever non-essential items the sleepers had stripped from their bodies before hastily clamboring within the statis pods to seal their doom.",
                    "Hull stresses and fractures have fissured the walls and ceiling, exposing pipes and electrical wires. One particularly damaged PIPE is rapidly venting a noxious green gas, caustic enough to make you sputter and gag. A nearby exposed service panel reveals two huge circular valves: a BRONZE VALVE and a STEEL VALVE.",
                    "The cover of the service panel looks as though it was torn off with some haste, almost as though someone was determined to access these valves but soon abandoned their task; you can only speculate as to why."
				]
				
				powered_room_desc = unpowered_room_desc;
			}
			
			else if room_enum == research_vessel_room.sc_corridor_west {
				scavenge_ar = [];
				for(var i = 0; i < scavenge_resource.total_resources; i++) {
					array_push(scavenge_ar,0);
				}
				scavenge_ar[scavenge_resource.tech_basic] = 4;
				
				room_name_str = "EAST-WEST CORRIDOR";
				
				directional_ar = [];
				array_push(directional_ar,{ door_dir: "EAST", door_state: door_state.unlocked });
				array_push(directional_ar,{ door_dir: "WEST", door_state: door_state.unlocked });
				
				keyword_interaction_map = ds_map_create();
				ds_map_add(keyword_interaction_map,"CORPSE",keyword_event.research_vessel_hall_east_of_sr);
			
                unpowered_room_desc = [
                    "The air smells foul and stuffy in this narrow corridor, and is suffused with the same ominous dim red light. The floor is metal grating and the walls are made up of panels of burnished steel.",
                    "A shadowed and inert form is slumped against the western bulkhead door, as if in peaceful repose. Upon closer inspection, you can see that the man is one of the security forces on board, if his military fatigues and body armor are any indication. You can also see that he is very dead: his eyes stare lifelessly at the jagged hole in his abdomen beneath his flak vest, admiring the great heap of coiled intestines that lay piled between his legs.",
                    "If your eyes aren't mistaken in the gloomy light, there's a strangely colored, green goo clinging to the edges of the gaping wound, and more of it dribbling from his mouth. The CORPSE is also clutching a pistol in a death grip. Judging by the bloody hole in the side of his head, it looks as though his last act was to use the weapon on himself.",
                    "The self-inflicted head wound, combined with the abyss where the man's stomach used to be, has certainly given you pause. Nonetheless, the CORPSE is carrying some useful looking gear, and there could be more in the pockets of his tactical vest. Is it wise to take a closer look?"
                ]
				powered_room_desc = unpowered_room_desc;
				post_event_unpowered_room_desc = [
                    "The air smells foul and stuffy in this narrow corridor, and is suffused with the same ominous dim red light. The floor is metal grating and the walls are made up of panels of burnished steel.",
                    "The corpse still slumped beside the western bulkhead door serves as a grim reminder of the consequence of carelessness."
                ]
				post_event_powered_room_desc = post_event_unpowered_room_desc;
			}
			
			else if room_enum == research_vessel_room.sc_corridor_east {
				scavenge_ar = [];
				for(var i = 0; i < scavenge_resource.total_resources; i++) {
					array_push(scavenge_ar,0);
				}
				
				room_name_str = "EAST-WEST CORRIDOR";
				
				directional_ar = [];
				array_push(directional_ar,{ door_dir: "EAST", door_state: door_state.unlocked });
				array_push(directional_ar,{ door_dir: "WEST", door_state: door_state.unlocked });
				
				unpowered_room_desc = "There's an NPC in this room."
				powered_room_desc = "There's an NPC in this room.";
			}
			
			else if room_enum == research_vessel_room.vacuum {
				room_name_str = "SPACE - VACUUM"	
				
				unpowered_room_desc = "The cold vacuum of space will kill even the strongest man in two turns.";
                powered_room_desc = "The cold vacuum of space will kill even the strongest man in two turns.";
			}
			
			else {
				d($"Constructor event for Room struct: room_type_enum: {room_type_enum} not captured by if case for location_type_enum {location_type_enum}");
			}
		} //End of if location_type enum == research vessel

	}
	
	#endregion
	
}