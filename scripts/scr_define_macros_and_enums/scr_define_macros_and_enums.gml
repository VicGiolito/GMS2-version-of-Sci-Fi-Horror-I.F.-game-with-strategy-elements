
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
	enum ability_type {
		healing_factor, //+1 every other turn
		thick_hide, //+1 armor
		hardened_skin, //+1 armor
		melee_specialist,
		child, //Increased stealth, low hp, can't use weapons or armor.
		cragos,
		total_ability_types
	}
	
	enum game_state {
		main_menu,
		display_intro,
		choose_chars,
		main_game,
		init_combat,
		prep_combat,
		assign_combat_command,
		execute_combat_action,
		access_inv,
		choose_door_dir,
		use_target_item,
		combat_choose_attack,
		combat_target_rank
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
	
	enum research_vessel_room { //These must match the same order in which they are placed in their corresponding tileset
		nothing, //0
		stasis_chamber, //1 done
		sc_corridor_east, //2 done
		sc_corridor_west, //3 done 
		basic_corridor_ew, //4 done
		basic_corridor_ns, //5 done
		commissary, //6 done
		barracks, //7 done
		armory, //8 done
		control_room, //9 done
		bridge, //10 done
		environmental_control, //11 done
		airlock, //12 - not in use
		medbay, //13 done
		engine_room, //14 done
		shuttle_bay, //15 done
		engineer_bay, //16 done
		crew_quarters, //17 done
		supply_closet, //18 done
		hydroponics_lab, //19 done
		communication_station, //20 - not in use
		arboretum_n_s_e_w, //21 done
		storage_room, //22 done
		research_lab, //23 done
		rec_room, //24 - not in use
		robotics_bay, //25 done
		recycler, //26 done
		astrometrics, //27 - not in use
		animal_lab, //28 done
		officers_quarters, //29 done
		computer_core, //30 - not in use
		
		intersection_e_w_n, //31 done
		intersection_e_w_s, //32 done
		intersection_n_s_e, //33 done
		intersection_n_s_w, //34 done
		
		vacuum, //35 done done
		
		airlock_e_w_n_s, //36 done
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
		motion_detector,
		medkit,
		regen_nanites,
		taser,
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
		field_medicine,
		energizing_stim_prick,
		monstrous_claw,
		kiras_noisy_game,
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
		biologist,
		security_guard,
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
		suppressor,
		overwatch,
		stationary_overwatch,
		total_enemy_combat_ai_types
	}
	
	enum rank_pos {
		enemy_far,
		enemy_middle,
		enemy_near,
		pc_near,
		pc_middle,
		pc_far,
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
		total_stats
	}
	
	//Some stat type macros:
	#macro AVG_ACC_VAL 7
	#macro MIN_COMBAT_RAN_NUM 0
	#macro MAX_COMBAT_RAN_NUM 9
	#macro RAN_INITIATIVE_VAL 5
	#macro ENERGENIZING_AP_BOOST 2
	#macro SMOKE_GRENADE_EVADE_BUFF 1
	#macro PERSONAL_SHIELD_BUFF 1
	#macro ADRENAL_PEN_BUFF 2
	#macro OGRE_MELEE_ACC_BUFF 1
	#macro OGRE_MELEE_MAX_DMG_BUFF 5
	#macro BASE_DOOR_HP 20
	#macro BASE_WALL_HP 100
	
	//Some other status type or misc. macros:
	#macro DOT_FIRE 5
	#macro DOT_POISON 3
	#macro BASE_UNCONSCIOUS_COUNT 4
	#macro SUPPRESSED_EVASION_DEBUFF 2
	#macro SUPPRESSED_SPEED_DEBUFF 2
	#macro AVERAGE_EVASION_SCORE 0
	#macro AVERAGE_ACCURACY_SCORE 7
	#macro BASE_MAX_INFECTION 8
	#macro PERSONAL_SHIELD_BONUS 1
	#macro SMOKE_GRENADE_EVASION_BONUS 1
}