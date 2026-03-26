
function scr_define_macros_and_enums(){
	
	enum struct_type { //used with each struct's struct_type_enum
		Room,
		Character,
		Item
	}	
	
	enum icon_type { //used in o_con draw event with our local 'icon_ar'
		powered_room,
		enemies_present,
		fire,
		electric,
		vacuum,
		gas
	}
	
	//These are mostly 'passive' type abilities and abilities that do NOT double as items:
	enum passive_abil_type {
		healing_factor, //+1 every other turn
		thick_hide, //+1 armor
		hardened_skin, //+1 armor
		melee_specialist, //Not currently in use
		child, //Increased stealth, low hp, can't use weapons or armor.
		giant, //Can't hide, increased melee dmg and melee accuracy
		cybernetic, //50% res to most hazard and damage types, 50% weakness to electric
		synthetic, //100% res to most hazard and damage types, 100% weakness to electric
		
		total_ability_types
	}
	
	enum game_state {
		
		initializing_game,
		main_menu,
		display_intro,
		choose_chars,
		
		main_game,
		enemies_moving,
		init_combat,
		access_inv,
		use_target_item,
		passing_item,
		choose_door_dir,
		choose_pc_abil,
		
		combat_paused, 
		combat_assign_pc_command,
		combat_execute_action,
		combat_choose_pc_wep,
		combat_pc_target_rank
	}
	
	enum combat_concluded_result {
		enemies_won,
		pcs_won,
		combat_continues
	}
	
	enum main_menu_options {
		main,
		options,
		sound_options,
		video_options,
		gameplay_settings,
		resolutions_options,
		total_main_menu_options
		
	}
	
	//It goes without saying the all of the rooms here must be 'powered' in order to 'operate' them and perform their function:
	enum research_vessel_room { //These must match the same order in which they are placed in their corresponding tileset
		nothing, //0
		stasis_chamber, //1 done; where the initial chars are spawned; can recruit more pcs here at the cost of advanced technology resource.
		sc_corridor_east, //2 done
		sc_corridor_west, //3 done 
		basic_corridor_ew, //4 done
		basic_corridor_ns, //5 done
		commissary, //6 done: can spend credits here to obtain food; can spend food here to restore sanity.
		barracks, //7 done: can find useful weapons, armor, and equipment here. Contains tier 1 or 2 level items.
		armory, //8 done: similar to barracks but contains tier 3 level items. Also contains explosives to change locked or jammed doors into destroyed doors; has a small chance of creating a hull breach and therefore vacuum in a room afterwards.
		control_room, //9 done: replaced by the operations of the bridge, should be removed.
		bridge, //10 done: from here the player can unlock or lock doors that are not jammed or destroyed, so long as the room is powered. For locked doors that are unlocked for the first time, the pc must first pass a difficult science-skill test to represent 'hacking the power system' open. The bridge must also be powered in order to use the engine_room, and therefore power the rest of the ship. The player will need to install a portable power cell here first in order to use the bridge, which is initially found in the engine room. The power cell automatically powers a room - the player does not need assign power here again during their turn by operating the engine room. So for now, the bridge intially allows the player to power rooms, and afterwards, allows the player to open and close doors. It also allows for certain game-critical events to unfold, like communicating with the pirates.
		environmental_control, //11 done: create presurrize or de-pressurize other powered rooms, which either creates or removes the vacuum room hazard, which in turn removes any fire or toxic gas hazard in this location (if vacuum was applied and the room is not a contant toxic gas generator)
		airlock, //12 - not in use
		medbay, //13 done: Spend M.P. and/or AP and/or resources like scrap: The character operating in this room can heal a certain amount of H.P. based upon their science skill, or create a medkit item, or create 'The Cure' item, which clears a character of all infection. 
		engine_room, //14 done: Costs 1 movement point: can spend fuel here to power rooms each turn. The amount of rooms and fuel you can spend here with each movement point in order to power rooms is == to your engineering skill.
		shuttle_bay, //15 done: this is the primary point from which the pcs will escape and beat the game. Requires advanced component resources to build, and chars with high engineering skills to pass the skill tests. Resources are not wasted if the pc fails the skill check.
		engineer_bay, //16 done: the only room where you can convert basic technology into advanced technology. Requires passing a skill test and/or M.P. and/or A.P. Can only fabricate some weapons, items, armor here at the cost of ap/mp/skill check. 
		crew_quarters, //17 done: can spend 2 movement points here to restore sanity. Essentially an infinite sanity restoration well, but forces the player to spend at least 3 turns there: at least 1 turn to get there, 1 turn to sleep and restore some sanity (2-3 points), then another turn to leave; not mention the inconvenience of traveling there in the first place.
		supply_closet, //18 done: simply contains useful resources, items and equipment.
		hydroponics_lab, //19 done: Spend 1-2 movement point and/or AP and/or pass a science based skill test: receive 1-2 food. Must be powered. So this is a potentially limitless source of food, but best operated upon by science-based characters.
		communication_station, //20 - not in use
		arboretum_n_s_e_w, //21 done
		storage_room, //22 done: contains useful resources, items and equipment, some of which may be necessary to complete the game. 
		research_lab, //23 done: upon successfully science skill test and/or MP and/or AP: convert a certain amount of bio-matter resource into 
		rec_room, //24 - not in use
		robotics_bay, //25 done: spend scrap here to create neutral droids.
		recycler, //26 done: possibly the most important room in the game: Spend 1 MP to convert an inputted amount of scrap and/or bio-matter into engine fuel. 
		astrometrics, //27 - not in use
		animal_lab, //28 done: perhaps this room just periodically spawns some particularly nasty enemy mobs. There's some dark shit going on in here.
		officers_quarters, //29 done: basic lore provided here, journals as to what actually transpired on the such; otherwise functions just like 
		computer_core, //30 - not in use
		
		intersection_e_w_n, //31 done
		intersection_e_w_s, //32 done
		intersection_n_s_e, //33 done
		intersection_n_s_w, //34 done
		
		vacuum, //35 done done
		
		airlock_e_w_n_s, //36 done: this is where pirates land, where the pcs can (eventually) escape to finish the game or travel to another grid world; its also where players in a vacuum suit can exit the ship and travel around the outside of the ship (although they have limited oxygen in this state and so need to move quickly and can't just hang out here); the 'suit oxygen' can be an item_struct variable that decreases with each movement space traveled and, once depleted, is simply deleted from memory, as it is now useless and will expose the player to vacuum.
		airlock_n_s, //37 done
		airlock_e_w, //38 done
		
		intersection_s_e, //39 done
		intersection_w_s, //40 done
		intersection_w_e_s_n, //41 done
		airlock_n_s_e, //42 done
		intersection_n_e, //43 done
		arboretum_e_s, //44 done
		arboretum_w_s, //45 done
		arboretum_w_s_n, //46 done
		arboretum_n_s_e, //47 done
		arboretum_n_e, //48 done
		arboretum_n_w, //49 done
		
		total_research_vessel_room_types
	}

	enum location {
		research_vessel,
		battleship,
		umber_planet,
		black_moon,
		forest_moon,
		derelict_ship,
		pirate_ship,
		viper_ship,
		transport_ship_1,
		transport_ship_2,
		garbage_scow,
		observatory,
		escape_pod
	}
	
	enum item_type {
		flashlight,	
		shotgun,
		semi_auto_pistol,
		pulse_pistol,
		sniper_rifle,
		mop,
		fire_axe,
		torque_wrench,
		sub_machine_gun,
		pulse_rifle,
		flame_thrower,
		frag_grenade,
		rocket_launcher,
		lead_pipe,
		assault_rifle,
		emp_grenade,
		motion_detector, //Reveals if there's enemies in the next room; could also be a torvald ability.
		medkit,
		regen_nanites, 
		taser, //cooper ability: Range 1, 0-1 damage
		dna_tester,
		fire_extinguisher,
		shield_belt,
		suit_environmental,
		suit_marine,
		suit_vacuum,
		suit_prisoner_jumpsuit,
		suit_engineer_garb,
		suit_medical_scrubs,
		suit_scientist_labcoat,
		suit_civilian_jumpsuit,
		suit_officer_jumpsuit,
		suit_flak_armor,
		suit_security_vest,
		access_targeting_hud,
		stun_baton,
		police_truncheon,
		shield_riot,
		shield_flak,
		shield_phase,
		fists_child,
		fists_adult,
		fists_giant,
		spine_projectile,
		infection_needle,
		writhing_tendril,
		field_medicine, //Heals 5 HP plus removes burning, poisoned, and bleeding status effects. Costs 3 AP.
		energizing_stim_prick, //Costs the doctor's 3 AP, but provides 2 AP to other characters; so a net loss if using on herself.
		monstrous_claw,
		kiras_noisy_game, //Acts as a player in the sense that nearby enemies are lured to it.
		machine_pistol,
		acid_spit,
		acid_cloud,
		desperate_claw,
		frag_grenade_launcher,
		sticky_slime,
		filament_spray,
		concussion_grenade_launcher,
		crude_buzzsaw,
		hand_flamer,
		light_mg,
		toxic_grenade_launcher,
		wrist_rockets,
		shocking_grasp,
		personal_shield_generator,
		smoke_grenade,
		spawn_light_sentry_gun,
		spawn_light_sentinel_droid,
		spawn_light_flamer_droid,
		spawn_light_shotgun_droid,
		spawn_light_buzzsaw_droid,
		headbutt,
		feral_bite,
		adrenal_pen,
		plasma_torch,
		total_items
	}
	
	enum character {
		mercenary_cyborg,
		child,
		mechanician,
		veteran, 
		engineer,
		doctor,
		criminal,
		ceo,
		ogre,
		service_droid,
		janitor,
		playboy,
		physicist,
		security_guard, //should be considered the last pc character for purposes of defining the char_bio_ar in scr_define_global_and_con_data()
		
		neutral_infected_scientist,
		neutral_jittering_buzzsaw,
		neutral_whipstitch_sentinel,
		neutral_spinning_scattershot,
		neutral_fumigating_flamer,
		neutral_light_sentry_gun,
		enemy_skittering_larva,
		enemy_spined_spitter,
		enemy_lumbering_carrier,
		enemy_transmogrified_soldier,
		enemy_chittering_lurker,
		enemy_sodden_shambler,
		total_char_types
	}
	
	//Must match the order of the sprites in spr_tiles_doors_44; wall and open are irrelevant
	enum door_state {
		
		locked,
		unlocked,
		jammed,
		destroyed,
		wall,
		open_space,

		total_door_states
	}
	
	//Macros for door directions:
	#macro DOOR_DIR_W 0
	#macro DOOR_DIR_N 1
	#macro DOOR_DIR_E 2
	#macro DOOR_DIR_S 3
	
	//Macros for FOW tiles - must match order in which placed in spr_tiles_fow_132
	#macro TILE_FOW 1
	#macro TILE_SHROUD 2
	
	enum hazard_type {
		toxic_gas,
		fire,
		vacuum,
		electric_current,
		total_hazard_types
	}
	
	enum equip_slot {
		accessory,
		body,
		rh,
		lh,
		total_slots
	}
	
	enum status_effect_chance {
		burn,
		bleed,
		poison,
		stun,
		infect,
		suppress,
		total_status_effects
	}
	
	enum status_res_chance {
		burn,
		bleed,
		poison,
		stun,
		infect,
		suppress,
		total_res_status_effects	
	}
	
	enum enemy_combat_ai {
		melee,
		ranged_coward,
		ranged_stationary,
		suppressor, //not currently in use
		overwatch_coward,
		stationary_overwatch,
		total_enemy_combat_ai_types
	}
	
	enum rank_pos {
		enemy_far, //0
		enemy_middle,
		enemy_near,
		pc_near,
		pc_middle,
		pc_far, //5
		total_rank_pos
	}
	
	enum team_type {
		pc,
		neutral,
		enemy,
		total_team_types
	}
	
	enum scavenge_resource {
		tech_basic,
		tech_advanced,
		food,
		scrap,
		ammo,
		engine_fuel,
		total_resources //At and beyond this index, Item instances are stored
	}
	
	//Not even sure if I'll implement this - rooms have different 'cover' values:
	enum cover_val {
		none,
		light,
		medium,
		heavy,
		fortified //Only obtainable via engineer ability
	}
	
	enum keyword_event {
		research_vessel_hall_east_of_sr,
		total_keyword_events
	}
	
	enum stat_boost {
		security,
		engineering,
		science,
		stealth,
		scavenging,
		strength,
		wisdom,
		intelligence,
		dexterity,
		accuracy,
		hp,
		sanity,
		action_points,
		ability_points,
		armor,
		evasion,
		fire_res,
		gas_res,
		vacuum_res,
		electric_res,
		spd,
		total_stats
	}
	
	//For activatable abilities (items) to distinguish what game states they can be used in.
	enum abil_use_context {
		combat_only,
		main_game_only,
		both
	}
	
	//Some stat type macros/misc. macros:
	#macro AVG_ACC_VAL 7
	#macro MIN_COMBAT_RAN_NUM 1
	#macro MAX_COMBAT_RAN_NUM 10
	#macro RAN_INITIATIVE_VAL 5
	#macro ENERGENIZING_AP_BOOST 2
	#macro SMOKE_GRENADE_EVADE_BUFF 2
	#macro SMOKE_GRENADE_DURATION 3
	#macro PERSONAL_SHIELD_ARMOR_BUFF 1
	#macro PERSONAL_SHIELD_EVASION_BUFF 1
	#macro PERSONAL_SHIELD_DURATION 3
	#macro ADRENAL_PEN_SPD_BUFF 2
	#macro ADRENAL_PEN_ACC_BUFF 1
	#macro OGRE_MELEE_ACC_BUFF 1
	#macro OGRE_MELEE_MAX_DMG_BUFF 5
	#macro BASE_DOOR_HP 20
	#macro BASE_WALL_HP 50
	#macro DOT_FIRE 5
	#macro DOT_POISON 3
	#macro UNCONSCIOUS_DURATION 4
	#macro SUPPRESSED_EVASION_DEBUFF 2
	#macro SUPPRESSED_SPEED_DEBUFF 6
	#macro SUPPRESS_DURATION 2
	#macro AVERAGE_EVASION_SCORE 0
	#macro AVERAGE_ACCURACY_SCORE 7
	#macro BASE_MAX_INFECTION 8
	#macro MAX_RAN_SPD_VAL 6
	#macro POISON_PERCENT_VAL .2
	#macro BLEED_PERCENT_VAL .25
	#macro HEALING_FACTOR_HEAL_VAL 1
	#macro HEALING_FACTOR_CD_VAL 1
	#macro REGEN_NANITES_HEAL_VAL 3
	#macro REGEN_NANITES_DURATION 4
	#macro FIELD_MEDICINE_HP_BOOST 4
	#macro EVADE_BONUS 1
	#macro FIRE_DURATION 3
	#macro BLEED_DURATION 2
	#macro POISON_DURATION 2
	#macro CRAGOS_ACC_DEBUFF 2
	#macro CRAGOS_EVASION_DEBUFF 1
	#macro GIANT_MELEE_DMG_BUFF 3
	#macro AVERAGE_CHAR_SPEED 3
	#macro MEDKIT_HP_BOOST 5
	
	#macro UNVISITED_CELL 0
	#macro VISITED_CELL 1
	
	#macro UNVISITED_STEP_VAL 999999999

	#macro GRID_ENCODE 1000000  // must be larger than your max grid width; removes the need for creating structs to store separate grid_x and grid_y vars.

}

/*A note on 'heuristic tie-breaking'; ie: var dist_to_dest = scr_return_chebyshev_dist(checking_cell_x, checking_cell_y, dest_x, dest_y) * 1.001;
When two nodes have the same f(n) value, A* has no preference between them and may explore both. In open areas this happens a lot — many cells will have identical f values, so A* fans out and explores a bunch of nodes that are all equally scored.
Tie-breaking gives A* a slight preference so it picks one path and commits rather than exploring many equivalent options. The idea is to favor nodes with a higher g(n), because a higher g means you've traveled further from the start, which means you're closer to the goal. 
Between two nodes with the same f, the one that's closer to the goal is more likely to be on the final path.
The simplest way to implement it is to multiply your heuristic by a tiny factor just above 1: 
*/