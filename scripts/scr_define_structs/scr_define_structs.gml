
function scr_define_structs(){
	
	#region Character struct
	
	Character = function(char_enum, spawn_grid_x, spawn_grid_y, spawn_grid, char_team_enum, add_to_room_list_bool, wep_loadout_int = 0) constructor {
		
		struct_type_enum = struct_type.Character;
		
        add_to_room_list_boolean = add_to_room_list_bool;

        wep_loadout_int = wep_loadout_int; //Only a debug var used for certain enemies to change their wep loadout, for debug purposes

        //Default values for instance vars for this particularly character:
        strength = 0;
        intelligence = 0;
        wisdom = 0;
        dexterity = 0;
        accuracy = AVERAGE_ACCURACY_SCORE;
        stealth = 0; //When you consider that rooms add or subtract to this value based upon their cover amount, the average here can be lower than 7
        spd = 0; //9 is current max, so a char with with 9 base spd would have to roll a 0, and a character with a base spd of 0 would have to roll a 9 to beat them.

        ran_init_val = 0; //A random value assigned that helps determine when characters act in combat

        security = 0;
        engineering = 0;
        science = 0;
        scavenging = 0; // Not currently used

        hp_cur = 0;
        hp_max = 0;
        ability_points_cur = 0;
        ability_points_max = 0;
        sanity_cur = 0;
        sanity_max = 0;

        armor = 0;
        evasion = AVERAGE_EVASION_SCORE;
        res_fire = 0;
        res_vacuum = 0;
        res_gas = 0;
        res_electric = 0;
        res_poison = 0;
        res_bleed = 0;
        res_stun = 0;
        res_infect = 0;
        res_suppress = 0;

        suppress_immune_boolean = false;
        stun_immune_boolean = false;

        cur_action_points = 2;
        max_action_points = 2;

        inv_list = [];
        ability_list = -1;

        char_team_enum = char_team_enum;

        name = "Not defined";
        subjective_pronoun = "he";
        possessive_pronoun = "his";
		
		if char_team_enum == team_type.enemy {
			starting_combat_rank = rank_pos.enemy_far;	
		}
		else {
			starting_combat_rank = rank_pos.pc_far;
		}
        
        cur_combat_rank = 0;
        participated_in_new_turn_battle = false;
        combat_ai_preference = enemy_combat_ai.ranged_coward;
        chosen_weapon = -1;
        targeted_rank = -1;
        ai_inferior_alternate_wep = -1;
        hold_the_line_count = 0;

        enemy_ai_move_boolean = false;
        enemy_ai_fight_boolean = false;
        is_opportunity_attacker_boolean = false;

        ai_is_suppressor_boolean = false; //Just a sub-set of the ENUM_AI_COMBAT_RANGED_COWARD, this enemy chooses an item with suppression instead, and resorts to a weaker melee weapon when pcs finally close with it in melee; otherwise it behaves exactly the same as Spined Spitters.

        dist_to_enemy = 0; //Used for enemy ai

        // Initialize inv_list and nested total_slots:
        for(var i = 0 ; i < equip_slot.total_slots; i++) {
            array_push(inv_list, -1);
		}

        char_type_enum = char_enum;
		
		if add_to_room_list_bool {
	        cur_grid = spawn_grid;
	        cur_room_id = spawn_grid[spawn_grid_y][spawn_grid_x];
	        cur_grid_x = spawn_grid_x;
	        cur_grid_y = spawn_grid_y;
			
			scr_add_remove_char_room_ar(cur_room_id,self,true);
		} else {
			cur_grid = -1;
			cur_room_id = -1;
			cur_grid_x = -1;
			cur_grid_y = -1
		}

        dodge_bonus_boolean = false;

        overwatch_rank = -1;
        will_overwatch_boolean = false

        infection_count = 0;
        char_max_infection = BASE_MAX_INFECTION;
        burning_count = 0;
        poisoned_count = 0;
        bleeding_count = 0;
        unconscious_count = 0;
        inside_toxic_gas_boolean = false;
        inside_vacuum_boolean = false;
        healing_nanites_count = 0;
        adrenal_pen_count = 0;
        suppressed_count = 0;
        stun_count = 0;
        spawn_minion_count = 0;

        resolve_dot_effects_boolean = true;
        healing_passive_boolean = false;
        unconscious_boolean = false;
        completely_dead_boolean = false;

        healing_factor_boolean = false;
        healing_factor_cd = 0;

        revived_dialogue_str_list = -1;
        shield_bonus_count = 0; //For things like torvald's personal shield

        already_fled_this_turn_boolean = false;
        fleeing_dir_x = -1;
        fleeing_dir_y = -1;
        flee_directional_str = "";
		
		//Important: struct methods must be defined before they are called:

        #region Define char stats....
		
        if char_type_enum == character.ogre {

            name = "Cragos, 'The Ogre'";
            hp_max = 16;
            hp_cur = 16;
            ability_points_cur = 5;
            ability_points_max = 5;
            sanity_cur = 10;
            sanity_max = 10;

            engineering = 1;
            security = 9;
            science = 0;
            scavenging = 0;
            stealth = 0;

            strength = 10;
            intelligence = 1;
            wisdom = 2;
            dexterity = 0;
            spd = -1;

            //Cragos unique resistences:
            res_bleed = 25;
            res_stun = 25;
            char_max_infection = BASE_MAX_INFECTION+4;
            res_infect = 25;
            res_poison = 25;
            res_suppress = 25;

            armor = 1;
            healing_factor_boolean = true;
            revived_dialogue_str_ar = [
                $"*{name} dusts himself off, grumbling: 'How do you kill a dead man?'*",
                $"*'Shit,' {name} mumbles. 'Must've died again.'",
                $"{name} clambers to his feet, spitting a gob of blood from his mouth. It's congealed before it hits the ground. 'Now you've really pissed me off.'",
                $"'I've still got a few debts left to pay,' {name} grumbles. He grins maliciously, cracking his knuckles. 'And a few skulls left to split...'"
            ];

            accuracy = AVERAGE_ACCURACY_SCORE-1; //Worse than average accuracy, only hits about 50% of the time, on average
            evasion = AVERAGE_EVASION_SCORE-1; //Worse than average evasion

            
		}

        else if char_type_enum == character.doctor {
            name = "Revita, 'The Doctor'";
            hp_max = 6;
            hp_cur = 6;
            ability_points_cur = 10;
            ability_points_max = 10;
            sanity_cur = 8;
            sanity_max = 8;

            engineering = 2;
            security = 0;
            science = 5;
            scavenging = 0;
            stealth = 5;

            strength = 0;
            intelligence = 8;
            wisdom = 6;
            dexterity = 2;
            spd = 2;

            subjective_pronoun = "she";
            possessive_pronoun = "her";


		}

        else if char_type_enum == character.engineer {
            name = "Amos, 'The Engineer'";
            hp_max = 8;
            hp_cur = 8;
            ability_points_cur = 10;
            ability_points_max = 10;
            sanity_cur = 6;
            sanity_max = 6;

            engineering = 8;
            security = 0;
            science = 2;
            scavenging = 0;
            stealth = 4;

            strength = 2;
            intelligence = 6;
            wisdom = 6;
            dexterity = 1;
            spd = 3;


		}

        else if char_type_enum == character.janitor {
            name = "Johns, 'The Janitor'";
            hp_max = 7;
            hp_cur = 7;
            ability_points_cur = 5;
            ability_points_max = 5;
            sanity_cur = 6;
            sanity_max = 6;

            engineering = 2;
            security = 2;
            science = 2;
            scavenging = 5;
            stealth = 7;

            strength = 2;
            intelligence = 4;
            wisdom = 4;
            dexterity = 2;
            spd = 4;

		}

        else if char_type_enum == character.mechanician {
            name = "Avia, 'The Mechanician'";
            hp_max = 6;
            hp_cur = 6;
            ability_points_cur = 10;
            ability_points_max = 10;
            sanity_cur = 10;
            sanity_max = 10;

            engineering = 7;
            security = 1;
            science = 2;
            scavenging = 1;
            stealth = 5;

            strength = 1;
            intelligence = 7;
            wisdom = 7;
            dexterity = 3;
            spd = 5;
            //Base 'half-mechanical' resistences
            res_fire = 50;
            res_vacuum = 50;
            res_gas = 50;
            res_electric = -50;
            char_max_infection = BASE_MAX_INFECTION + 4;
            res_infect = 50;
            res_poison = 25;

            subjective_pronoun = "she";
            possessive_pronoun = "her";

		}

        else if char_type_enum == character.mercenary_cyborg {
            name = "Torvald, 'The Cyborg'";
            hp_max = 12;
            hp_cur = 12;
            ability_points_cur = 8;
            ability_points_max = 8;
            sanity_cur = 10;
            sanity_max = 10;

            engineering = 3;
            security = 8;
            science = 1;
            scavenging = 1;
            stealth = 4;

            strength = 8;
            intelligence = 3;
            wisdom = 3;
            dexterity = 3;
            spd = 4;

            armor = 1;
            //Base 'half-mechanical' resistences:
            res_fire = 50;
            res_vacuum = 50;
            res_gas = 50;
            res_electric = -50;
            char_max_infection = BASE_MAX_INFECTION + 4;
            res_infect = 50;
            res_poison = 25;
            res_suppress = 25;


		}

        else if char_type_enum == character.security_guard {
            name = "Cooper, 'The Security Guard'";
            hp_max = 10;
            hp_cur = 10;
            ability_points_cur = 14;
            ability_points_max = 14;
            sanity_cur = 8;
            sanity_max = 8;

            engineering = 1;
            security = 7;
            science = 0;
            scavenging = 2;
            stealth = 3;

            strength = 7;
            intelligence = 1;
            wisdom = 2;
            dexterity = 2;
            spd = 2;
		}

        else if char_type_enum == character.biologist {
            name = "Darius, 'The Physicist'";
            hp_max = 6;
            hp_cur = 6;
            ability_points_cur = 3;
            ability_points_max = 3;
            sanity_cur = 6;
            sanity_max = 6;

            engineering = 2;
            security = 0;
            science = 9;
            scavenging = 1;
            stealth = 4;

            strength = 0;
            intelligence = 9;
            wisdom = 9;
            dexterity = 2;
            spd = 3;

		};

        else if char_type_enum == character.criminal {
            name = "Emeran, 'The Criminal'";
            hp_max = 9;
            hp_cur = 9;
            ability_points_cur = 12;
            ability_points_max = 12;
            sanity_cur = 9;
            sanity_max = 9;

            engineering = 2;
            security = 6;
            science = 2;
            scavenging = 4;
            stealth = 8;
            spd = 6;

            strength = 4;
            intelligence = 0;
            wisdom = 0;
            dexterity = 4;
            spd = 7;

            evasion = AVERAGE_EVASION_SCORE + 1;  // Better than average at evading

		}

        else if char_type_enum == character.service_droid {
            name = "RG-88, 'Service Droid'";
            hp_max = 14;
            hp_cur = 14;
            ability_points_cur = 15;
            ability_points_max = 15;
            sanity_cur = 10;
            sanity_max = 10;

            engineering = 6;
            security = 6;
            science = 6;
            scavenging = 0;
            stealth = 4;

            strength = 9;
            intelligence = 4;
            wisdom = 8;
            dexterity = 2;
            spd = 2;
            //Base 'mechanical' resistences
            res_fire = 100;
            res_vacuum = 100;
            res_gas = 100;
            res_electric = -100;
            char_max_infection = BASE_MAX_INFECTION + 4;
            res_infect = 500;
            res_poison = 500;
            res_stun = 50;


			
		}

        else if char_type_enum == character.ceo {
            name = "Celeste, 'The CEO'";
            hp_max = 7;
            hp_cur = 7;
            ability_points_cur = 8;
            ability_points_max = 8;
            sanity_cur = 4;
            sanity_max = 4;

            engineering = 3;
            security = 0;
            science = 3;
            scavenging = 3;
            stealth = 6;

            strength = 1;
            intelligence = 3;
            wisdom = 4;
            dexterity = 2;
            spd = 4;

            subjective_pronoun = "she";
            possessive_pronoun = "her";

		}

        else if char_type_enum == character.child {
            name = "Kira, 'The Gamer'";
            hp_max = 4;
            hp_cur = 4;
            ability_points_cur = 6;
            ability_points_max = 6;
            sanity_cur = 5;
            sanity_max = 5;

            engineering = 1;
            security = 0;
            science = 1;
            scavenging = 5;
            stealth = 10;

            strength = 0;
            intelligence = 2;
            wisdom = 1;
            dexterity = 7;
            spd = 5;

            evasion = AVERAGE_EVASION_SCORE+1; //Better than average at evading

            subjective_pronoun = "she";
            possessive_pronoun = "her";

		}

        else if char_type_enum == character.playboy {
			name = "Oberon, 'The Playboy'";
            hp_max = 8;
            hp_cur = 8;
            ability_points_cur = 6;
            ability_points_max = 6;
            sanity_cur = 3;
            sanity_max = 3;

            engineering = 1;
            security = 1;
            science = 1;
            scavenging = 3;
            stealth = 6;

            strength = 3;
            intelligence = 2;
            wisdom = 1;
            dexterity = 5;
            spd = 4;

			
		}

        else if char_type_enum == character.neutral_infected_scientist {
            name = "Gregos, 'The Researcher'";
            hp_max = 8;
            hp_cur = hp_max;
            ability_points_cur = 3;
            ability_points_max = 3;
            sanity_cur = 2;
            sanity_max = 2;

            engineering = 4;
            security = 0;
            science = 9;
            scavenging = 1;
            stealth = 4;

            strength = 2;
            intelligence = 8;
            wisdom = 8;
            dexterity = 2;
            spd = 2;

            combat_ai_preference = enemy_combat_ai.ranged_coward;

		}

        else if char_type_enum == character.enemy_skittering_larva {
            name = "Skittering Larva";
            hp_max = irandom_range(3,4);
            hp_cur = hp_max;
            ability_points_cur = 3;
            ability_points_max = 3;
            sanity_cur = 20;
            sanity_max = 20;
            spd = 8;

            combat_ai_preference = enemy_combat_ai.melee;

            armor = 0;
            evasion = 3;
            res_fire = 0;
            res_vacuum = 100;
            res_gas = 100;
            res_electric = 0;

		}

        else if char_type_enum == character.neutral_jittering_buzzsaw {
            name = "Jittering Buzzsaw Droid";
            hp_max = irandom_range(6,8);
            hp_cur = hp_max;
            ability_points_cur = 3;
            ability_points_max = 3;
            sanity_cur = 20;
            sanity_max = 20;
            spd = 4;

            combat_ai_preference = enemy_combat_ai.melee;

            armor = 1;
            evasion = 0;
            res_fire = 50;
            res_vacuum = 100;
            res_gas = 100;
            res_electric = -100;
            res_poison = 500;
            res_infect = 500;
            res_bleed = 500;
            

		}

        else if char_type_enum == character.neutral_fumigating_flamer {
            name = "Fumigating Flamer Droid";
            hp_max = irandom_range(6,8);
            hp_cur = hp_max;
            ability_points_cur = 3;
            ability_points_max = 3;
            sanity_cur = 20;
            sanity_max = 20;
            spd = 0;

            combat_ai_preference = enemy_combat_ai.melee;

            armor = 1;
            evasion = 0;
            res_fire = 50;
            res_vacuum = 100;
            res_gas = 100;
            res_electric = -100;
            res_poison = 500;
            res_infect = 500;
            res_bleed = 500;

		}

        else if char_type_enum == character.neutral_spinning_scattershot {
            name = "Spinning Scattershot Droid";
            hp_max = irandom_range(5,7);
            hp_cur = hp_max;
            ability_points_cur = 3;
            ability_points_max = 3;
            sanity_cur = 20;
            sanity_max = 20;
            spd = 7;

            combat_ai_preference = enemy_combat_ai.ranged_coward;

            armor = 0;
            evasion = 1;
            res_fire = 50;
            res_vacuum = 100;
            res_gas = 100;
            res_electric = -100;
            res_poison = 500;
            res_infect = 500;
            res_bleed = 500;
            

		}

        else if char_type_enum == character.neutral_whipstitch_sentinel {
            name = "Whipstitch Sentinel Droid";;
            hp_max = irandom_range(6,8)
            hp_cur = hp_max;
            ability_points_cur = 3;
            ability_points_max = 3;
            sanity_cur = 20;
            sanity_max = 20;
            spd = 3;

            combat_ai_preference =  enemy_combat_ai.overwatch;

            armor = 0;
            evasion = 0;
            res_fire = 50;
            res_vacuum = 100;
            res_gas = 100;
            res_electric = -100;
            res_poison = 500;
            res_infect = 500;
            res_bleed = 500;

		}

        else if char_type_enum == character.neutral_light_sentry_gun {
            name = "Light Sentry Drone";
            hp_max = 4;
            hp_cur = hp_max;
            ability_points_cur = 3;
            ability_points_max = 3;
            sanity_cur = 20;
            sanity_max = 20;
            spd = 10;

            combat_ai_preference = enemy_combat_ai.stationary_overwatch;

            armor = 0;
            evasion = 0;
            res_fire = 50;
            res_vacuum = 100;
            res_gas = 100;
            res_electric = -100;
            res_poison = 500;
            res_infect = 500;
            res_bleed = 500;

		}

        else if char_type_enum == character.enemy_lumbering_carrier {
            name = "Lumbering Carrier";
            hp_max = irandom_range(16,20);
            hp_cur = hp_max;
            ability_points_cur = 3;
            ability_points_max = 3;
            sanity_cur = 20;
            sanity_max = 20;

            armor = 1;
            evasion = -1;
            res_fire = 0;
            res_vacuum = 100;
            res_gas = 100;
            res_electric = 0;

            suppress_immune_boolean = true;
            stun_immune_boolean = true;
            can_spawn_minions = true;
            spawn_minion_count = irandom_range(1,3);

            combat_ai_preference = enemy_combat_ai.melee;

            spd = -1

     
		}

        else if char_type_enum == character.enemy_spined_spitter {
            name = "Spined Spitter"
            hp_max = irandom_range(9,11)
            hp_cur = hp_max
            ability_points_cur = 3
            ability_points_max = 3
            sanity_cur = 20
            sanity_max = 20

            armor = 1
            evasion = 0
            res_fire = 0
            res_vacuum = 100
            res_gas = 100
            res_electric = 0

            combat_ai_preference = enemy_combat_ai.ranged_coward;

            spd = 3


		}

        else if char_type_enum == character.enemy_transmogrified_soldier {
            name = "Transmogrified Soldier"
            hp_max = irandom_range(10,13)
            hp_cur = hp_max
            ability_points_cur = 3
            ability_points_max = 3
            sanity_cur = 20
            sanity_max = 20

            armor = 0
            evasion = -1
            res_fire = 0
            res_vacuum = 100
            res_gas = 100
            res_electric = 0

            combat_ai_preference = enemy_combat_ai.overwatch;

            spd = 2

		}

        else if char_type_enum == character.enemy_sodden_shambler {
            name = "Sodden Shambler"
            hp_max = irandom_range(8,10)
            hp_cur = hp_max
            ability_points_cur = 3
            ability_points_max = 3
            sanity_cur = 20
            sanity_max = 20

            armor = 0
            evasion = 0
            res_fire = 0
            res_vacuum = 100
            res_gas = 100
            res_electric = 0

            combat_ai_preference = enemy_combat_ai.ranged_coward;

            spd = 0

		}

        else if char_type_enum == character.enemy_chittering_lurker {
            name = "Chittering Lurker"
            hp_max = irandom_range(7,9)
            hp_cur = hp_max
            ability_points_cur = 3
            ability_points_max = 3
            sanity_cur = 20
            sanity_max = 20

            armor = 0
            evasion = 2
            res_fire = 0
            res_vacuum = 100
            res_gas = 100
            res_electric = 0

            ai_is_suppressor_boolean = true
            combat_ai_preference = enemy_combat_ai.ranged_coward

            spd = 8

		}
		
		#endregion End region for defining char stats
	
		
		//Build our self.status_res_list:
        status_res_list = []
        for(var i = 0; i < status_effect_chance.total_status_effects; i++) {
            if i == status_effect_chance.burn array_push(status_res_list,res_fire);
            else if i == status_effect_chance.infect array_push(status_res_list,res_infect); 
			else if i == status_effect_chance.poison array_push(status_res_list,res_poison);
			else if i == status_effect_chance.bleed array_push(status_res_list,res_bleed);
			else if i == status_effect_chance.stun array_push(status_res_list,res_stun);
			else if i == status_effect_chance.suppress array_push(status_res_list,res_infect);
		}
		
	} //closed bracket for Character struct
	
	#endregion
	
	#region Item struct:
	
	global.Item = function(item_enum) constructor
	{
		struct_type_enum = struct_type.Item;

        item_enum = item_enum;

        stat_boost_list = [];
        for(var i = 0; i < stat_boost.total_stats; i++) {
            array_push(stat_boost_list,0);
		}

        // Default values for instance vars for each item:
        dmg_min = 0;
        dmg_max = 0;
        requires_ammo_boolean = true;
        accuracy_bonus = 0;
        max_range = 0; //If 0=melee only

        single_use_boolean = false;
        melee_debuff_boolean = false;
        equippable_boolean = true;
        usable_boolean = false;
        changes_stats_boolean = false;
        combat_usable_boolean = false; //Used in conjunction with items that can ALSO be used by characters in combat, like adrenal pen.
        use_script  = -1; //For items or abilities that are 'used'
        use_requires_target_boolean = false; //For items or abilities that are 'used', usually destroyed after, and require a target- such as the medkit, adrenal pen, healing nanites, etc.
        is_combat_abil_only_boolean = false; //For abilities only; determines whether or not an ability is displayed on our list in the main game state.
        abil_passes_turn_boolean = false; //And when I say 'passes turn', I mean the advance_cur_combat_char is immediately called after using it.

        is_shield_boolean = false; //Currently only used utils.py function check_for_equipped_weapon()
        can_suppress_boolean = false;
        can_overwatch_boolean = false;

        // None of these are in use and are used within the stat_boost_list instead:
        vacuum_res = 0;
        gas_res = 0;
        fire_res = 0;
        electrical_res = 0;
        armor_bonus = 0;
        evade_bonus = 0;
        shield_bonus = 0;

        ability_point_cost = 0;
        ability_cost_str = "";
        non_attack_ability_boolean = false; //Torvald's shield, cooper's buffs, Avia's summons, etc.
        abil_targets_enemies_boolean = true; //If this == false, then we move to USE_ITEM game state.

        burn_chance = 0;
        poison_chance = 0;
        bleed_chance = 0;
        stun_chance = 0;
        infection_chance = 0;
        suppress_chance = 0;

        always_checks_status_effect_boolean = false;

        item_name = "Not defined";
        item_desc = "Not defined";
        item_dmg_str = "Not defined";

        equip_slot_list = []; // Default, this means that this item cannot be equipped: such as medkit, etc.

        slot_designation_str = "";
        item_verb = "fires";
        aoe_count = 1; //indicates max targets item will hit; -1 indicates it hits the entire mob, flamers only

        //region Define item stats for each item:

        if item_enum == item_type.flashlight {
            dmg_min = 1
            dmg_max = 1
            item_name = "FLASHLIGHT"
            equip_slot_list = [equip_slot.accessory];
		}
        else if item_enum == item_type.shotgun {
            dmg_min = 3;
            dmg_max = 6;
            item_name = "SHOTGUN";
            equip_slot_list = [[equip_slot.rh,equip_slot.lh]]; //Indicates two-handed weapon
            max_range = 2;
            item_verb = "pumps the";
            item_dmg_str = "shot";
            aoe_count = 3;
            can_overwatch_boolean = true;
            bleed_chance = 25;
            item_desc = "Your standard issue military grade shotgun most commonly used by security personnel.";
            can_overwatch_boolean = true;
		}
        else if item_enum == item_type.semi_auto_pistol {
            dmg_min = 1
            dmg_max = 4
            max_range = 2
            item_name = "SEMI-AUTOMATIC PISTOL"
            equip_slot_list = [equip_slot.rh,equip_slot.lh]; //Indicates either hand can equip
            item_verb = "fires the"
            item_dmg_str = "shot"
           can_overwatch_boolean = true
            bleed_chance = 10
		}
        else if item_enum == item_type.pulse_pistol {
            dmg_min = 2
            dmg_max = 5
            requires_ammo_boolean = false
            item_name = "PULSE PISTOL"
            equip_slot_list = [equip_slot.rh,equip_slot.lh] //Indicates either hand can equip
            max_range = 3
            item_verb = "fires the"
            item_dmg_str = "burned"
            can_overwatch_boolean = true
            burn_chance = 10
		}
        else if item_enum == item_type.frag_grenade {
            dmg_min = 8
            dmg_max = 12
            item_name = "FRAGMENTATION GRENADE"
            single_use_boolean = true
            equip_slot_list = [equip_slot.rh,equip_slot.lh]  // Indicates either hand can equip
            max_range = 2
            item_verb = "tosses the"
            item_dmg_str = "shredded"
            aoe_count = 6
            burn_chance = 25
            bleed_chance = 25
		}
        else if item_enum == item_type.flame_thrower {
            dmg_min = 3
            dmg_max = 6
            item_name = "FLAMETHROWER"
            equip_slot_list = [[equip_slot.rh,equip_slot.lh]] //Indicates two-handed weapon
            max_range = 0
            item_verb = "spews fire with the"
            item_dmg_str = "burned"
            aoe_count = -1
            burn_chance = 75
            always_checks_status_effect_boolean = true
		}
        else if item_enum == item_type.hand_flamer { //Torvald ability
            dmg_min = 2
            dmg_max = 5
            item_name = "PALM FLAMER"
            equip_slot_list = [[equip_slot.rh,equip_slot.lh]] //Indicates two-handed weapon
            max_range = 1
            item_verb = "spews fire with the"
            item_dmg_str = "burned"
            aoe_count = -1
            burn_chance = 75
            always_checks_status_effect_boolean = true
            ability_point_cost = 3
            ability_cost_str = $"Spend {ability_point_cost} AP"
            is_combat_abil_only_boolean = true
            requires_ammo_boolean = false
		}

        else if item_enum == item_type.wrist_rockets { //Torvald ability
            dmg_min = 8
            dmg_max = 12
            item_name = "WRIST ROCKETS"
            equip_slot_list = [[equip_slot.rh,equip_slot.lh]] //Indicates two-handed weapon
            max_range = 3
            item_verb = "fires"
            item_dmg_str = "shredded"
            aoe_count = 6
            burn_chance = 25
            bleed_chance = 25
            suppress_chance = 50
            stun_chance = 25
            always_checks_status_effect_boolean = true
            ability_point_cost = 5
            ability_cost_str = $"Spend {ability_point_cost} AP"
            is_combat_abil_only_boolean = true
            requires_ammo_boolean = false
		}

        else if item_enum == item_type.shocking_grasp { //Torvald ability
            dmg_min = 2
            dmg_max = 4
            item_name = "SHOCKING GRASP"
            equip_slot_list = [[equip_slot.rh,equip_slot.lh]] //Indicates two-handed weapon
            max_range = 0
            item_verb = "grabs with a"
            item_dmg_str = "burned"
            aoe_count = 1
            burn_chance = 10
            stun_chance = 75
            always_checks_status_effect_boolean = true
            ability_point_cost = 2
            ability_cost_str = $"Spend {ability_point_cost} AP"
            is_combat_abil_only_boolean = true
            requires_ammo_boolean = false
		}

        else if item_enum == item_type.headbutt { //ogre
            dmg_min = 2
            dmg_max = 5
            item_name = "HEAD BUTT"
            equip_slot_list = [[equip_slot.rh,equip_slot.lh]] //Indicates two-handed weapon
            max_range = 0
            item_verb = "roars and smashes with a vicious"
            item_dmg_str = "battered"
            aoe_count = 1
            stun_chance = 75
            ability_point_cost = 3
            ability_cost_str = $"Spend {ability_point_cost} AP"
            is_combat_abil_only_boolean = true
            requires_ammo_boolean = false
            always_checks_status_effect_boolean = true
		}

        else if item_enum == item_type.feral_bite { //ogre
            dmg_min = 3
            dmg_max = 6
            item_name = "MONSTROUS BITE"
            equip_slot_list = [[equip_slot.rh,equip_slot.lh]] //Indicates two-handed weapon
            max_range = 0
            item_verb = "screams and lunges with a"
            item_dmg_str = "bitten"
            aoe_count = 1
            bleed_chance = 100
            ability_point_cost = 3
            ability_cost_str = $"Spend {ability_point_cost} AP"
            is_combat_abil_only_boolean = true
            requires_ammo_boolean = false
		}

        //This skill uses utils execute_non_attack_ability()
        else if item_enum == item_type.personal_shield_generator { //Torvald ability
            dmg_min = 0
            dmg_max = 0
            item_name = "PERSONAL SHIELD GENERATOR"
            equip_slot_list = [equip_slot.body];
            max_range = 0
            ability_point_cost = 3
            ability_cost_str = $"This ability does not stack. Spend {ability_point_cost} AP to gain the following for 3 turns:"
            stat_boost_list[stat_boost.armor] = PERSONAL_SHIELD_BONUS
            stat_boost_list[stat_boost.evasion] = PERSONAL_SHIELD_BONUS
            is_combat_abil_only_boolean = true
            non_attack_ability_boolean = true
            abil_passes_turn_boolean = false
            requires_ammo_boolean = false
		}

        // This skill uses utils execute_non_attack_ability()
        else if item_enum == item_type.smoke_grenade {  // Cooper ability
            dmg_min = 0
            dmg_max = 0
            item_name = "SMOKE GRENADE"
            equip_slot_list = [equip_slot.body] 
            max_range = 0
            ability_point_cost = 3
            ability_cost_str = $"This ability does not stack. Spend {ability_point_cost} AP and pass your turn: every friendly unit in your party gains the following for next 3 turns:"
            stat_boost_list[stat_boost.evasion] = SMOKE_GRENADE_EVASION_BONUS
            is_combat_abil_only_boolean = true
            non_attack_ability_boolean = true
            abil_passes_turn_boolean = true
            requires_ammo_boolean = false
		}

        // This skill uses utils execute_non_attack_ability()
        else if item_enum == item_type.field_medicine {  // Doctor ability
            dmg_min = 0
            dmg_max = 0
            item_name = "FIELD MEDICINE"
            equip_slot_list = [equip_slot.body]  // Indicates either hand can equip
            max_range = 0
            ability_point_cost = 3
            ability_cost_str = $"Spend {ability_point_cost} AP and pass your turn: target player character heals 5 hit points and is cleared of the following status effects: burning, bleeding, poisoned."
            is_combat_abil_only_boolean = true
            non_attack_ability_boolean = false //This abil requires a target, so we don't use the execute_non_attack_ability() script, we use the item_id.use_item() script after targeting a pc
            abil_passes_turn_boolean = true
            requires_ammo_boolean = false
            use_requires_target_boolean = true  // Brings us to the USE_ITEM game state if this ability is used from the combat game state CHOOSE_ATTACK
		}
		
        // This skill uses utils execute_non_attack_ability()
        else if item_enum == item_type.spawn_light_sentry_gun {  // Engineer ability
            dmg_min = 0
            dmg_max = 0
            item_name = "LIGHT SENTRY GUN"
            equip_slot_list = [equip_slot.body]  // Indicates either hand can equip
            max_range = 0
            ability_point_cost = 4
            ability_cost_str = $"Spend {ability_point_cost} AP and pass your turn: spawn a LIGHT SENTRY GUN at your position. Sentry guns do not move, fire at enemies within their range, and set overwatch when enemies are beyond their range."
            is_combat_abil_only_boolean = true
            non_attack_ability_boolean = true
            abil_passes_turn_boolean = true
            requires_ammo_boolean = false
		}

        // This skill uses utils execute_non_attack_ability()
        else if item_enum == item_type.spawn_light_sentry_gun {  // Engineer ability
            dmg_min = 0
            dmg_max = 0
            item_name = "WHIPSTITCH SENTINEL DROID"
            equip_slot_list = [equip_slot.body]  // Indicates either hand can equip
            max_range = 0
            ability_point_cost = 6
            ability_cost_str = $"Spend {ability_point_cost} AP and pass your turn: spawn a WHIPSTITCH SENTINEL DROID at your position. This hastily constructed bag of bolts uses a PULSE PISTOL and likes to set overwatch, but only if it has the ranged advantage over the enemy."
            is_combat_abil_only_boolean = true
            non_attack_ability_boolean = true
            abil_passes_turn_boolean = true
            requires_ammo_boolean = false
		}

        // This skill uses utils execute_non_attack_ability()
        else if item_enum == item_type.spawn_light_shotgun_droid {  // Engineer ability
            dmg_min = 0
            dmg_max = 0
            item_name = "SPINNING SCATTERSHOT DROID"
            equip_slot_list = [equip_slot.body]  // Indicates either hand can equip
            max_range = 0
            ability_point_cost = 4
            ability_cost_str = $"Spend {ability_point_cost} AP and pass your turn: spawn a SPINNING SCATTERSHOT DROID at your position. This cowardly little droid likes to pepper enemies with its SHOTGUN."
            is_combat_abil_only_boolean = true
            non_attack_ability_boolean = true
            abil_passes_turn_boolean = true
            requires_ammo_boolean = false
		}

        // This skill uses utils execute_non_attack_ability()
        else if item_enum == item_type.spawn_light_flamer_droid {  // Engineer ability
            dmg_min = 0
            dmg_max = 0
            item_name = "FUMIGATING FLAMER DROID"
            equip_slot_list = [equip_slot.body]  // Indicates either hand can equip
            max_range = 0
            ability_point_cost = 3
            ability_cost_str = $"Spend {ability_point_cost} AP and pass your turn: spawn a FUMIGATING FLAMER DROID at your position. This fearless little droid would wheel itself through the gates of hell to protect you. It has been affixed with a FLAMETHROWER and is belching an unhealthy amount of smoke."
            is_combat_abil_only_boolean = true
            non_attack_ability_boolean = true
            abil_passes_turn_boolean = true
            requires_ammo_boolean = false
		}

        // This skill uses utils execute_non_attack_ability()
        else if item_enum == item_type.spawn_light_buzzsaw_droid {  // Engineer ability
            dmg_min = 0
            dmg_max = 0
            item_name = "JITTERING BUZZSAW DROID"
            equip_slot_list = [equip_slot.body]  // Indicates either hand can equip
            max_range = 0
            ability_point_cost = 3
            ability_cost_str = $"Spend {ability_point_cost} AP and pass your turn: spawn a JITTERING BUZZSAW DROID at your position. Its spinning BUZZSAW looks as though its about to bounce out of its frame! Better point this droid in the right direction..."
            is_combat_abil_only_boolean = true
            non_attack_ability_boolean = true
            abil_passes_turn_boolean = true
            requires_ammo_boolean = false
		}
        // This skill uses utils execute_non_attack_ability()
        else if item_enum == item_type.energizing_stim_prick {  
            dmg_min = 0
            dmg_max = 0
            item_name = "ENERGIZING STIMULANT"
            equip_slot_list = [equip_slot.body]  // Indicates either hand can equip
            max_range = 0
            ability_point_cost = 3
            ability_cost_str = $"Spend {ability_point_cost} AP: target player character gains 2 ability points."
            is_combat_abil_only_boolean = true
            non_attack_ability_boolean = false //This abil requires a target, so we don't use the execute_non_attack_ability() script, we use the item_id.use_item() script after targeting a pc
            abil_passes_turn_boolean = false
            requires_ammo_boolean = false
            use_requires_target_boolean = true  // Brings us to the USE_ITEM game state if this ability is used from the combat game state CHOOSE_ATTACK
		}
		
        else if item_enum == item_type.rocket_launcher {
            dmg_min = 10
            dmg_max = 15
            single_use_boolean = true
            item_name = "ROCKET LAUNCHER"
            equip_slot_list = [[equip_slot.rh,equip_slot.lh]] //Indicates two-handed weapon
            max_range = 4
            item_verb = "fires the"
            item_dmg_str = "exploded"
            aoe_count = 8
            bleed_chance = 75
            burn_chance = 75 //DEBUG
		}
        else if item_enum == item_type.lead_pipe {
            dmg_min = 1
            dmg_max = 4
            requires_ammo_boolean = false
            item_name = "LEAD PIPE"
            equip_slot_list = [equip_slot.rh,equip_slot.lh] //Indicates either hand can equip
            item_verb = "swings the"
            item_dmg_str = "blundgeoned"
            max_range = 0
            stun_chance = 50
		}
        else if item_enum == item_type.monstrous_claw {
            dmg_min = 4
            dmg_max = 8
            requires_ammo_boolean = false
            item_name = "MONSTROUS CLAWS"
            equip_slot_list = [equip_slot.rh,equip_slot.lh] //Indicates either hand can equip
            item_verb = "swipes with"
            item_dmg_str = "slashed"
            max_range = 0
            bleed_chance = 50
            infection_chance = 10
		}
        else if item_enum == item_type.writhing_tendril {
            dmg_min = 1
            dmg_max = 4
            requires_ammo_boolean = false
            item_name = "WRITHING TENDRIL"
            equip_slot_list = [equip_slot.rh,equip_slot.lh] //Indicates either hand can equip
            item_verb = "whips with a"
            item_dmg_str = "slashed"
            max_range = 0
            stun_chance = 25
            bleed_chance = 0
            always_checks_status_effect_boolean = true
            infection_chance = 10
		}
        else if item_enum == item_type.desperate_claw {
            dmg_min = 1
            dmg_max = 4
            requires_ammo_boolean = false
            item_name = "DESPERATE CLAW"
            equip_slot_list = [equip_slot.rh,equip_slot.lh]  // Indicates either hand can equip
            item_verb = "slashes with a"
            item_dmg_str = "slashed"
            max_range = 0
            bleed_chance = 25
            infection_chance = 10
		}
        else if item_enum == item_type.infection_needle {
            dmg_min = 4
            dmg_max = 4
            requires_ammo_boolean = false
            item_name = "INFECTED BARB"
            equip_slot_list = [equip_slot.rh,equip_slot.lh] //Indicates either hand can equip
            item_verb = "stabs with a"
            item_dmg_str = "punctured"
            max_range = 0
            infection_chance = 100
		}
        else if item_enum == item_type.police_truncheon {
            dmg_min = 3
            dmg_max = 4
            requires_ammo_boolean = false
            item_name = "POLICE TRUNCHEON"
            equip_slot_list = [equip_slot.rh,equip_slot.lh] //Indicates either hand can equip
            item_verb = "swings the"
            item_dmg_str = "blundgeoned"
            max_range = 0
            stun_chance = 25
		}
        else if item_enum == item_type.stun_baton { //Has a 100% chance of stunning enemies, minus their electric_res
            dmg_min = 1
            dmg_max = 2
            requires_ammo_boolean = false
            item_name = "STUN BATON"
            equip_slot_list = [equip_slot.rh,equip_slot.lh] //Indicates either hand can equip
            item_verb = "thrusts the"
            item_dmg_str = "zapped"
            max_range = 0
            stun_chance = 100
            always_checks_status_effect_boolean = true
		}
        else if item_enum == item_type.fire_axe {
            dmg_min = 2
            dmg_max = 5
            requires_ammo_boolean = false
            item_name = "FIRE AXE"
            equip_slot_list = [equip_slot.rh,equip_slot.lh] //Indicates either hand can equip
            item_verb = "swings the"
            item_dmg_str = "mauled"
            max_range = 0
            bleed_chance = 25
		}
        else if item_enum == item_type.crude_buzzsaw {
            dmg_min = 5
            dmg_max = 8
            requires_ammo_boolean = false
            item_name = "CRUDE BUZZSAW"
            equip_slot_list = [equip_slot.rh,equip_slot.lh] //Indicates either hand can equip
            item_verb = "spins the"
            item_dmg_str = "eviscerated"
            max_range = 0
            bleed_chance = 75
		}
        else if item_enum == item_type.taser { //High stun chance, extra damage to characters with weak electric_res
            dmg_min = 1
            dmg_max = 1
            requires_ammo_boolean = false
            item_name = "TASER"
            equip_slot_list = [equip_slot.rh,equip_slot.lh] //Indicates either hand can equip
            item_verb = "fires the"
            item_dmg_str = "zapped"
            max_range = 1
            stun_chance = 100
            always_checks_status_effect_boolean = true
            ability_point_cost = 2
            ability_cost_str = $"Spend {ability_point_cost} AP"
            is_combat_abil_only_boolean = true
            requires_ammo_boolean = false
		}
        else if item_enum == item_type.assault_rifle {
            dmg_min = 4
            dmg_max = 6
            item_name = "ASSAULT RIFLE"
            equip_slot_list = [[equip_slot.rh,equip_slot.lh]] //Indicates two-handed weapon
            max_range = 4
            item_verb = "fires the"
            item_dmg_str = "shot"
            can_overwatch_boolean = true
            bleed_chance = 25
            can_overwatch_boolean = true
		}
        else if item_enum == item_type.light_mg { //Light sentry gun weapon.
            dmg_min = 3
            dmg_max = 6
            item_name = "LIGHT MACHINE GUN"
            equip_slot_list = [[equip_slot.rh,equip_slot.lh]] //Indicates two-handed weapon
            max_range = 4
            item_verb = "fires the"
            item_dmg_str = "shot"
            can_overwatch_boolean = true
            bleed_chance = 25
            suppress_chance = 33
		}
        else if item_enum == item_type.spine_projectile {
            dmg_min = 3
            dmg_max = 6
            item_name = "SHOOTING SPINE"
            equip_slot_list = [[equip_slot.rh,equip_slot.lh]] //Indicates two-handed weapon
            max_range = 3
            item_verb = "fires a"
            item_dmg_str = "shot"
            bleed_chance = 25
            infection_chance = 10
            poison_chance = 25
		}
        
        else if item_enum == item_type.acid_spit {
            dmg_min = 4
            dmg_max = 8
            item_name = "ACID BILE"
            equip_slot_list = [[equip_slot.rh,equip_slot.lh]] //Indicates two-handed weapon
            max_range = 2
            item_verb = "spits with"
            item_dmg_str = "melted"
            aoe_count = 3
            can_overwatch_boolean = true
            poison_chance = 75
            infection_chance = 10
            always_checks_status_effect_boolean = true
		}
        else if item_enum == item_type.acid_cloud {
            dmg_min = 1
            dmg_max = 3
            item_name = "ACID CLOUD"
            equip_slot_list = [[equip_slot.rh,equip_slot.lh]] //Indicates two-handed weapon
            max_range = 2
            item_verb = "belches a massive"
            item_dmg_str = "melted"
            aoe_count = -1
            poison_chance = 75
            bleed_chance = 20
            infection_chance = 10
            always_checks_status_effect_boolean = true
		}
        else if item_enum == item_type.sticky_slime {
            dmg_min = 0
            dmg_max = 1
            item_name = "STICKY SLIME"
            equip_slot_list = [[equip_slot.rh,equip_slot.lh]] //Indicates two-handed weapon
            max_range = 5
            item_verb = "sprays"
            item_dmg_str = "melted"
            aoe_count = -1
            suppress_chance = 75
            always_checks_status_effect_boolean = true
            infection_chance = 10
		}
        else if item_enum == item_type.filament_spray {
            dmg_min = 0
            dmg_max = 1
            item_name = "FILAMENT SPRAY"
            equip_slot_list = [[equip_slot.rh,equip_slot.lh]] //Indicates two-handed weapon
            max_range = 5
            item_verb = "spits a massive"
            item_dmg_str = "melted"
            aoe_count = -1
            infection_chance = 10
            poison_chance = 10
            stun_chance = 20
            always_checks_status_effect_boolean = true
		}
        else if item_enum == item_type.toxic_grenade_launcher {
            dmg_min = 1
            dmg_max = 4
            item_name = "TOXIC GRENADE LAUNCHER"
            equip_slot_list = [[equip_slot.rh,equip_slot.lh]] //Indicates two-handed weapon
            max_range = 4 //Debug value
            item_verb = "fires the"
            item_dmg_str = "burned"
            aoe_count = -1
            poison_chance = 75
            always_checks_status_effect_boolean = true
		}
        else if item_enum == item_type.frag_grenade_launcher {
            dmg_min = 5
            dmg_max = 10
            item_name = "FRAGMENTAION GRENADE LAUNCHER"
            equip_slot_list = [[equip_slot.rh,equip_slot.lh]] //Indicates two-handed weapon
            max_range = 5 //Debug value
            item_verb = "fires the"
            item_dmg_str = "shredded"
            aoe_count = 4
            burn_chance = 25
            always_checks_status_effect_boolean = true
		}
        else if item_enum == item_type.concussion_grenade_launcher {
            dmg_min = 0
            dmg_max = 1
            item_name = "CONCUSSION GRENADE LAUNCHER"
            equip_slot_list = [[equip_slot.rh,equip_slot.lh]] //Indicates two-handed weapon
            max_range = 4
            item_verb = "fires the"
            item_dmg_str = "concussed"
            aoe_count = -1
            stun_chance = 75
            suppress_chance = 75
            always_checks_status_effect_boolean = true
		}
        
        else if item_enum == item_type.sub_machine_gun {
            dmg_min = 3
            dmg_max = 5
            item_name = "SUB MACHINE GUN"
            equip_slot_list = [[equip_slot.rh,equip_slot.lh]] //Indicates two-handed weapon
            max_range = 3
            item_verb = "fires the"
            item_dmg_str = "shot"
            can_overwatch_boolean = true
            aoe_count = 4
            bleed_chance = 25
            suppress_chance = 50
		}
        else if item_enum == item_type.machine_pistol {
            dmg_min = 2
            dmg_max = 4
            item_name = "MACHINE PISTOL"
            equip_slot_list = [equip_slot.rh,equip_slot.lh] //Indicates either hand can equip
            max_range = 2
            item_verb = "fires the"
            item_dmg_str = "shot"
            can_overwatch_boolean = true
            aoe_count = 3
            bleed_chance = 25
            suppress_chance = 25
		}
        else if item_enum == item_type.sniper_rifle {
            dmg_min = 8
            dmg_max = 12
            melee_debuff_boolean = true
            item_name = "SNIPER RIFLE"
            equip_slot_list = [[equip_slot.rh,equip_slot.lh]] //Indicates two-handed weapon
            max_range = 5
            item_verb = "fires the"
            item_dmg_str = "shot"
            can_overwatch_boolean = true
            bleed_chance = 50
		}
        else if item_enum == item_type.pulse_rifle {
            dmg_min = 6
            dmg_max = 9
            requires_ammo_boolean = false
            melee_debuff_boolean = true
            item_name = "PULSE RIFLE"
            equip_slot_list = [[equip_slot.rh,equip_slot.lh]] //Indicates two-handed weapon
            max_range = 4
            item_verb = "fires the"
            item_dmg_str = "burned"
            can_overwatch_boolean = true
            burn_chance = 25
		}
        else if item_enum == item_type.medkit {
            single_use_boolean = true
            usable_boolean = true
            item_name = "MEDICAL KIT"
            equippable_boolean = false
            combat_usable_boolean = true
		}
        else if item_enum == item_type.regen_nanites {
            single_use_boolean = true
            usable_boolean = true
            item_name = "PEN OF REGENERATION NANITES"
            equippable_boolean = false
            combat_usable_boolean = true
		}
        else if item_enum == item_type.kiras_noisy_game {
            single_use_boolean = false
            usable_boolean = true
            item_name = "KIRA'S NOISY GAME"
            equippable_boolean = false
		}
        else if item_enum == item_type.suit_environmental {
            fire_res = 50
            electrical_res = 50
            gas_res = 100
            armor_bonus = 1
            evade_bonus = -1
            item_name = "HAZMAT SUIT"
            equip_slot_list = [equip_slot.body]
            stat_boost_list[stat_boost.evasion] = -1
            stat_boost_list[stat_boost.armor] = 1
            stat_boost_list[stat_boost.fire_res] = 50
            stat_boost_list[stat_boost.electric_res] = 50
            stat_boost_list[stat_boost.gas_res] = 100
            changes_stats_boolean = true
		}
        else if item_enum == item_type.suit_prisoner_jumpsuit {
            item_name = "PRISONER JUMPSUIT"
            stat_boost_list[stat_boost.evasion] = 1
            changes_stats_boolean = true
            equip_slot_list = [equip_slot.body]
		}
        else if item_enum == item_type.suit_engineer_garb {
            item_name = "ENGINEER GARB"
            equip_slot_list = [equip_slot.body]
            stat_boost_list[stat_boost.evasion] = 1
            changes_stats_boolean = true
		}
        else if item_enum == item_type.suit_scientist_labcoat {
            item_name = "SCIENTIST LABCOAT"
            equip_slot_list = [equip_slot.body]
            stat_boost_list[stat_boost.evasion] = 1
            changes_stats_boolean = true
		}
        else if item_enum == item_type.suit_medical_scrubs {
            item_name = "MEDICAL SCRUBS"
            equip_slot_list = [equip_slot.body]
            stat_boost_list[stat_boost.evasion] = 1
            changes_stats_boolean = true
		}
        else if item_enum == item_type.suit_officer_jumpsuit {
            item_name = "OFFICER JUMPSUIT"
            equip_slot_list = [equip_slot.body]
            stat_boost_list[stat_boost.evasion] = 1
            changes_stats_boolean = true
		}
        else if item_enum == item_type.suit_civilian_jumpsuit {
            item_name = "CIVILIAN JUMPSUIT"
            equip_slot_list = [equip_slot.body]
            stat_boost_list[stat_boost.evasion] = 1
            changes_stats_boolean = true
		}
        else if item_enum == item_type.suit_flak_armor {
            item_name = "FLAK ARMOR"
            equip_slot_list = [equip_slot.body]
            stat_boost_list[stat_boost.armor] = 2
            stat_boost_list[stat_boost.evasion] = 0
            changes_stats_boolean = true
		}
        else if item_enum == item_type.suit_security_vest {
            item_name = "SECURITY VEST"
            equip_slot_list = [equip_slot.body]
            stat_boost_list[stat_boost.armor] = 1
            stat_boost_list[stat_boost.evasion] = 1
            changes_stats_boolean = true
		}
        else if item_enum == item_type.suit_marine {
            item_name = "MARINE ARMOR"
            equip_slot_list = [equip_slot.body]
            stat_boost_list[stat_boost.armor] = 4
            stat_boost_list[stat_boost.electric_res] = 100
            stat_boost_list[stat_boost.evasion] = -2
            stat_boost_list[stat_boost.vacuum_res] = 50
            stat_boost_list[stat_boost.gas_res] = 100
            stat_boost_list[stat_boost.fire_res] = 100
            changes_stats_boolean = true
		}
        else if item_enum == item_type.adrenal_pen {
            single_use_boolean = true
            usable_boolean = true
            item_name = "ADRENAL PEN"
            equippable_boolean = false
            combat_usable_boolean = true
		}
        else if item_enum == item_type.dna_tester {
            single_use_boolean = false
            usable_boolean = true
            item_name = "DNA ANALYZER"
            equippable_boolean = false
		}
        else if item_enum == item_type.access_targeting_hud {
            item_name = "TACTICAL MONOCLE"
            equip_slot_list = [equip_slot.accessory]
            stat_boost_list[stat_boost.accuracy] = 1
            changes_stats_boolean = true
		}
        else if item_enum == item_type.shield_riot {
            item_name = "RIOT SHIELD"
            equip_slot_list = [equip_slot.rh,equip_slot.lh]  // Indicates either hand can equip
            changes_stats_boolean = true
            stat_boost_list[stat_boost.armor] = 1
            stat_boost_list[stat_boost.evasion] = 1
            is_shield_boolean = true
		}
        else if item_enum == item_type.shield_flak {
            item_name = "FLAK SHIELD"
            equip_slot_list = [equip_slot.rh, equip_slot.lh]  // Indicates either hand can equip
            changes_stats_boolean = true
            stat_boost_list[stat_boost.armor] = 2
            stat_boost_list[stat_boost.evasion] = 2
            is_shield_boolean = true
		}
        else if item_enum == item_type.shield_phase {
            item_name = "PHASE SHIELD"
            equip_slot_list = [equip_slot.rh, equip_slot.lh]  // Indicates either hand can equip
            changes_stats_boolean = true
            stat_boost_list[stat_boost.armor] = 3
            stat_boost_list[stat_boost.evasion] = 4
            is_shield_boolean = true
		}
        else if item_enum == item_type.fists_adult {
            dmg_min = 1
            dmg_max = 2
            requires_ammo_boolean = false
            item_name = "FISTS"
            equip_slot_list = [equip_slot.rh, equip_slot.lh] //Indicates either hand can equip
            item_verb = "punches with their"
            item_dmg_str = "battered"
            max_range = 0
		}
        else if item_enum == item_type.fists_child {
            dmg_min = 0
            dmg_max = 1
            requires_ammo_boolean = false
            item_name = "CHILD FISTS"
            equip_slot_list = [equip_slot.rh, equip_slot.lh] //Indicates either hand can equip
            item_verb = "punches with their"
            item_dmg_str = "battered"
            max_range = 0
		}
        else if item_enum == item_type.fists_giant {
            dmg_min = 2
            dmg_max = 4
            requires_ammo_boolean = false
            item_name = "GIANT FISTS"
            equip_slot_list = [equip_slot.rh, equip_slot.lh] //Indicates either hand can equip
            item_verb = "punches with their"
            item_dmg_str = "battered"
            max_range = 0
            stun_chance = 25
		}

        else if item_enum == item_type.plasma_torch {
            dmg_min = 1
            dmg_max = 4
            requires_ammo_boolean = false
            item_name = "PLASMA TORCH"
            equip_slot_list = [equip_slot.rh, equip_slot.lh] //Indicates either hand can equip
            item_verb = "blazes the"
            item_dmg_str = "burns"
            max_range = 0
            burn_chance = 75
		}

        //Define slot_designation_str - currently only using the Accessory string, print_inv gets too cluttered otherwise
        if is_array(equip_slot_list) {
            if is_array(equip_slot_list[0]) {
                slot_designation_str = "Both Hands";
			}
            else if equip_slot_list[0] == equip_slot.rh || equip_slot_list[0] == equip_slot.rh {
                slot_designation_str = "One Hand";
			}
            else if equip_slot_list[0] == equip_slot.accessory {
                slot_designation_str = "Accessory"
			}
            else if equip_slot_list[0] == equip_slot.body {
                slot_designation_str = "Body"
			}
		}

        // endregion

        //Build this item's 'status_effect_list':
        status_effect_list = []
        for(var i = 0; i < status_effect_chance.total_status_effects; i++) {
            if i == status_effect_chance.burn array_push(status_effect_list,burn_chance);
            else if  i == status_effect_chance.infect array_push(status_effect_list,infection_chance);
            else if  i == status_effect_chance.poison array_push(status_effect_list,poison_chance);
            else if  i == status_effect_chance.bleed array_push(status_effect_list,bleed_chance);
            else if  i == status_effect_chance.stun array_push(status_effect_list,stun_chance);
            else if  i == status_effect_chance.suppress array_push(status_effect_list,suppress_chance);
		}
	}
	
	#endregion
	
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
		
		enemies_in_room_ar = -1;
		pcs_in_room_ar = -1
		neutrals_in_room_ar = -1;
		
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