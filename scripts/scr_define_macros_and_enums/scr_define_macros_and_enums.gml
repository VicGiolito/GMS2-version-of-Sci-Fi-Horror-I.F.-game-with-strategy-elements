
function scr_define_macros_and_enums(){
	
	enum struct_type { //used with each struct's struct_type_enum
		Room,
		Character,
		Item
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
		nothing,
		stasis_chamber,
		sc_corridor_east,
		sc_corridor_west,
		basic_corridor_ew,
		basic_corridor_ns,
		commissary,
		barracks,
		armory,
		control_room,
		bridge,
		environmental_control,
		airlock,
		medbay,
		engine_room,
		shuttle_bay,
		engineer_bay,
		crew_quarters,
		supply_closet,
		hydroponics_lab,
		communication_station,
		arboretum,
		storage_room,
		research_lab,
		rec_room,
		robotics_bay,
		recycler,
		astrometrics,
		animal_lab,
		officers_ready_room,
		computer_core,
		intersection,
		vacuum,
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
		engineer,
		doctor,
		criminal,
		ceo,
		service_droid,
		ogre,
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
	
	enum door_state {
		unlocked,
		locked,
		jammed,
		destroyed,
		open_space,
		total_door_states
	}
	
	enum hazard_type {
		toxic_gas,
		fire,
		vacuum,
		electric_current
	}
	
	enum equip_slot {
		body,
		accessory,
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
		credits,
		scrap,
		bio_matter,
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