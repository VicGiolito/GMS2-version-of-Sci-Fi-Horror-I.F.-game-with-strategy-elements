
function scr_define_structs(){
	
	//The index position of the door struct within the room struct's directional_ar indicates what direction the door is in.
	global.door_struct = function (door_enum_, door_hp_, door_jam_diff_val_) constructor {	
		
		struct_type_enum = struct_type.Door;
		
		door_enum = door_enum_;
		door_hp = door_hp_;
		door_jam_diff_val = door_jam_diff_val_;
	}
	
	//if loot_drop_type_enum == loot_drop_type.item_enum, item_enum_ must == the actual item type enum; if not, item_enum_ and resource_quantity can == -1
	global.loot_drop_struct = function (loot_drop_type_enum_, item_enum_, resource_quantity_) constructor {
		
		struct_type_enum = struct_type.Loot_drop;
		
		loot_drop_type_enum = loot_drop_type_enum_;
		
		loot_drop_item_enum = item_enum_;
		
		resource_quantity = resource_quantity_;
	}
	
	#region Enemy mob struct:
	
	enemy_mob_struct = function (spawn_grid, mob_grid_x_, mob_grid_y_, location_enum_, movement_type_enum) constructor {
		
		struct_type_enum = struct_type.Enemy_mob;
		
		ai_movement_behavior = movement_type_enum;
		
		mob_cur_grid = spawn_grid;
		
		enemies_in_mob_ar = [];
		
		mob_grid_x = mob_grid_x_;
		mob_grid_y = mob_grid_y_;
		
		chosen_path_grid = -1;
		
		mob_dest_grid_x = -1;
		mob_dest_grid_y = -1;
		
		location_enum = location_enum_;
		
		no_target_found = false;
	}
	
	#endregion
	
	#region Character struct
	
	global.Character = function(char_enum, spawn_grid_x, spawn_grid_y, spawn_grid, team_enum, add_to_room_list_bool, wep_loadout_int = 0, auto_add_to_mob_struct = false, enemy_ai_movement_type_enum = ai_movement_type.guarding) constructor {
		
		struct_type_enum = struct_type.Character;
		
		origin_team = team_enum; //Keeps track of what this char's original team was after they've gone berserk or treacherous.
		
		char_hiding_in_room = false;
		
		current_broken_morale_str = "undefined";
		
		stationary_neutral_bool = false; //These neutrals don't ever from a room once they are placed there: such as security_camera and light_sentry_drone.
		
		broken_morale_ar = -1; //Can be altered during course of combat
		
		permanent_broken_morale_ar = -1; //Is never altered.
		
		fleeing_str = "fleeing str not defined";
		
		morale_immune = false;
		infection_immune = false;
		
		neutrals_following_this_char_ar = -1;
		
		unique_id = global.unique_struct_id_num;
		
		global.unique_struct_id_num++;
		
		flood_fill_path_grid = -1; //Is used as a ds_grid for flood fill pathing steps after character creation in scr_setup_char_pathing_grids().
		
		char_sprite_inst_id = -1;
		
		char_ar_pos = undefined; //Where is this defined? Let's get rid of it. Currently only used for pcs, for identifying them and switching between them.

        wep_loadout_int = wep_loadout_int; //Only a debug var used for certain enemies to change their wep loadout, for debug purposes

        //Default values for instance vars for this particularly character:
        strength = 0;
        intelligence = 0;
        wisdom = 0;
        dexterity = 0;
        accuracy = AVG_ACC_VAL;
        stealth = 0; //When you consider that rooms add or subtract to this value based upon their cover amount, the average here can be lower than 7
        spd = AVERAGE_CHAR_SPEED; //9 is current max, so a char with with 9 base spd would have to roll a 0, and a character with a base spd of 0 would have to roll a 9 to beat them.

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
		move_points_max = AVG_MOVE_POINT_VAL;
		move_points_cur = move_points_max;
		
		courage = AVG_COURAGE_VAL; //Acts just like evasion, but for morale attacks.

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

        ability_ar = -1; //ACTIVATEABLE abilities, like combat abilities; these also double as item structs.
		passive_abil_ar = -1;

        char_team_enum = team_enum;

        name = "Not defined";
        subjective_pronoun = "he";
        possessive_pronoun = "his";
		
		if char_team_enum == team_type.enemy {
			cur_combat_rank = rank_pos.enemy_far;
		}
		else {
			cur_combat_rank = rank_pos.pc_far;
		}
        
		pc_is_combat_moving = false;
        participated_in_new_turn_battle = false;
        combat_ai_preference = enemy_combat_ai.ranged_coward;
        chosen_weapon = -1;
        targeted_rank = -1;
		passing_item_struct_id = -1;
		passing_item_index = -1;
		using_item_struct_id = -1;
		using_item_index = -1;
		
		filtered_abil_ar = -1; //Is used as an array filled the char's ability that are relevant to either the combat state, main game state, or both.
		
		char_sprite_room_x = 0; //updated by scr_update_char_sprite_position_vars
		char_sprite_room_y = 0; //updated by scr_update_char_sprite_position_vars
		
		has_fled_combat_bool = false;
		
        enemy_ai_move_boolean = false;
        enemy_ai_fight_boolean = false;
		combat_move_dir = 0; //1=south; -1 = north.

        ai_is_suppressor_boolean = false; //Just a sub-set of the ENUM_AI_COMBAT_RANGED_COWARD, this enemy chooses an item with suppression instead, and resorts to a weaker melee weapon when pcs finally close with it in melee; otherwise it behaves exactly the same as Spined Spitters.

        // Initialize inv_ar and nested total_slots:
		inv_ar = [];
        for(var i = 0 ; i < equip_slot.total_slots; i++) {
            array_push(inv_ar, -1);
		}

        char_type_enum = char_enum;
		
		cur_grid = -1;
		
		if add_to_room_list_bool {
	        cur_grid = spawn_grid;
	        cur_room_id = spawn_grid[# spawn_grid_x, spawn_grid_y];
	        cur_grid_x = spawn_grid_x;
	        cur_grid_y = spawn_grid_y;
			
			scr_add_remove_char_room_ar(cur_room_id,self,true);
			scr_add_remove_char_from_global_ar(self,true);
		} 
		
		else {
			cur_grid = -1;
			cur_room_id = -1;
			cur_grid_x = -1;
			cur_grid_y = -1
		}

        will_overwatch_boolean = false;
		char_fleeing_from_broken_morale = false;
	
		//status effect type vars:
        infection_count = 0;
        char_max_infection = BASE_MAX_INFECTION;
        burning_count = 0;
        poisoned_count = 0;
        bleeding_count = 0;
        inside_toxic_gas_boolean = false;
        inside_vacuum_boolean = false;
        healing_nanites_count = 0;
        adrenal_pen_count = 0;
        suppressed_count = 0;
        stun_count = 0;
        spawn_minion_count = 0;
		
		treacherous_count = 0;
		cowering_bool = false;
		berserk_count = 0;
		
		smoke_grenade_count = 0;

        unconscious_bool = false;
		unconscious_count = 0;
        has_died_bool = false;

        healing_factor_boolean = false;
        healing_factor_cd = 0;

        shield_bubble_count = 0; //For things like torvald's personal shield

        already_fled_this_turn_boolean = false;
        fleeing_dir_x = -1;
        fleeing_dir_y = -1;
		
		party_moving_dir_x = -1;
		party_moving_dir_y = -1;
		party_moving_dir_str = "";
		
		nick_name = undefined;
		
		//more combat related stats:
		evading_boolean = false;
		
		avail_weps_or_abils_list = -1; //Used as an array; is filled with either items from rh and lh or abilities.
		
		//Use this char's cur_grid to define their 'location_enum':
		location_enum = scr_return_location_enum_from_grid_id(cur_grid);

        #region Define char stats....
		
        if char_type_enum == character.ogre {

            name = "Cragos, 'The Ogre'";
			nick_name = "Ogre";
            hp_max = 16;
            hp_cur = 16;
            ability_points_cur = 8;
            ability_points_max = 8;
            sanity_max = 12;
			
			courage = AVG_COURAGE_VAL+1;

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

            armor = 0; //thick hide will give him +1 armor
            healing_factor_boolean = true;
            revived_dialogue_str_ar = [
                $"*{nick_name} dusts himself off, grumbling: 'How do you kill a dead man?'*",
                $"*'Shit,' {nick_name} mumbles. 'Must've died again.'",
                $"{nick_name} clambers to his feet, spitting a gob of blood from his mouth. It's congealed before it hits the ground. 'Now you've really pissed me off.'",
                $"'I've still got a few debts left to pay,' {nick_name} grumbles. He grins with a mouth full of jagged teeth, cracking his knuckles. 'And a few skulls left to split...'"
            ];

            accuracy = AVG_ACC_VAL-CRAGOS_ACC_DEBUFF; //Worse than average accuracy, only hits about 50% of the time, on average
            evasion = AVERAGE_EVASION_SCORE-CRAGOS_EVASION_DEBUFF; //Worse than average evasion
			
			//Define broken_morale_ar:
			broken_morale_ar = [];
			array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.treacherous, broken_morale_str: $"{name} roars: \"Spit on me? Sneer at me? Lay hands on me? If you truly think me a monster--THEN LET ME SHOW YOU WHAT I CAN DO!\"" });
			array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.berserk, broken_morale_str: $"{name} rants and raves: \"Ceaseless toil and torment! Will the pain never end?! RAGE my constant companion! RAGE my only friend!\"" });
			
			permanent_broken_morale_ar = [];
			array_copy(permanent_broken_morale_ar,0,broken_morale_ar,0,array_length(broken_morale_ar));
			
			scr_add_passive_ability(self,passive_abil_type.giant,"constructor event");
			scr_add_passive_ability(self,passive_abil_type.healing_factor,"constructor event");
			scr_add_passive_ability(self,passive_abil_type.thick_hide,"constructor event");
			
			scr_add_ability(self,item_type.headbutt);
			scr_add_ability(self,item_type.feral_bite);
		}

        else if char_type_enum == character.doctor {
            name = "Revita, 'The Doctor'";
            hp_max = 6;
            hp_cur = 6;
            ability_points_cur = 6;
            ability_points_max = ability_points_cur;
            sanity_max = 6;
			
			nick_name = "Doc";
			
			courage = AVG_COURAGE_VAL;

            engineering = 2;
            security = 0;
            science = 5;
            scavenging = 0;
            stealth = AVG_STEALTH_VAL;

            strength = 0;
            intelligence = 8;
            wisdom = 6;
            dexterity = 2;
            spd = AVERAGE_CHAR_SPEED;

            subjective_pronoun = "she";
            possessive_pronoun = "her";
			
			//Define broken_morale_ar:
			broken_morale_ar = [];
			array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.fleeing, broken_morale_str: $"\"... I'm sorry!...\" {name} mutters, before turning to flee. \"I can't... I can't!...\"" });
			array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.cowering, broken_morale_str: $"{name} clutches her knees to her chest, whispering: \"... Their hands, outstretched... Their eyes: pleading... I couldn't save them... Couldn't save them...\"" });
			
			permanent_broken_morale_ar = [];
			array_copy(permanent_broken_morale_ar,0,broken_morale_ar,0,array_length(broken_morale_ar));
			
			scr_add_ability(self,item_type.field_medicine);
			scr_add_ability(self,item_type.energizing_stim_prick);
			scr_add_ability(self,item_type.improvised_medicine);
			scr_add_ability(self,item_type.anti_anxiety_meds);
		}
		
		else if char_type_enum == character.veteran {
            name = "Nikano, 'The Veteran'";
            hp_max = 10;
            hp_cur = hp_max;
            ability_points_cur = 9;
            ability_points_max = ability_points_cur;
            sanity_max = 8;
			
			nick_name = "Vet";

            engineering = 1;
            security = 7;
            science = 1;
            scavenging = 4;
            stealth = 7;
			
			courage = AVG_COURAGE_VAL+1;

            strength = 2;
            intelligence = 6;
            wisdom = 6;
            dexterity = 6;
            spd = AVERAGE_CHAR_SPEED+1;

            subjective_pronoun = "she";
            possessive_pronoun = "her";
			
			//Define broken_morale_ar:
			broken_morale_ar = [];
			array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.treacherous, broken_morale_str: $"\"... The voices of my kin are beckoning!...\" {name} tears at her own face and hands with fingers like claws. \"... I am sorry... I must answer their call!\"" });
			array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.berserk, broken_morale_str: $"\"Stay away from me!...\" {name} screams. \"... The transformation, it's unstable... I can't control it!\"" });
		
			permanent_broken_morale_ar = [];
			array_copy(permanent_broken_morale_ar,0,broken_morale_ar,0,array_length(broken_morale_ar));
		}

        else if char_type_enum == character.engineer {
            name = "Amos, 'The Engineer'";
            hp_max = 8;
            hp_cur = 8;
            ability_points_cur = 10;
            ability_points_max = 10;
            sanity_max = 6;
			
			nick_name = "Engie";
			
			courage = AVG_COURAGE_VAL;
			
            engineering = 8;
            security = 0;
            science = 2;
            scavenging = 0;
            stealth = AVG_STEALTH_VAL;

            strength = 2;
            intelligence = 6;
            wisdom = 6;
            dexterity = 1;
            spd = AVERAGE_CHAR_SPEED;
		
			broken_morale_ar = [];
			array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.fleeing, broken_morale_str: $"\"... They just keep coming!\" {name} cries, before routing. \"How do you stop them?! You can't... No one can!...\"" });
			array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.cowering, broken_morale_str: $"{name} gazes off into space, remarking, to no one at all: \"... Nothing comes together as easily as it falls apart...\"" });
			
			permanent_broken_morale_ar = [];
			array_copy(permanent_broken_morale_ar,0,broken_morale_ar,0,array_length(broken_morale_ar));
			
			scr_add_ability(self,item_type.spawn_light_sentry_gun);
		}

        else if char_type_enum == character.janitor { //I'll prob just get rid of this character - quite extraneous.
            name = "Johns, 'The Janitor'";
            hp_max = 7;
            hp_cur = 7;
            ability_points_cur = 5;
            ability_points_max = 5;
            sanity_max = 6;
			
			nick_name = "Jan";

            engineering = 2;
            security = 2;
            science = 2;
            scavenging = 5;
            stealth = AVG_STEALTH_VAL+1;

            strength = 2;
            intelligence = 4;
            wisdom = 4;
            dexterity = 2;
            spd = AVERAGE_CHAR_SPEED+1;
		}

        else if char_type_enum == character.mechanician {
            name = "Avia, 'The Mechanician'";
            hp_max = 6;
            hp_cur = 6;
            ability_points_cur = 10;
            ability_points_max = 10;
            sanity_max = 12;
			
			nick_name = "Avia";

            engineering = 7;
            security = 1;
            science = 2;
            scavenging = 1;
            stealth = AVG_STEALTH_VAL;
			
			courage = AVG_COURAGE_VAL;

            strength = 1;
            intelligence = 7;
            wisdom = 7;
            dexterity = 3;
            spd = AVERAGE_CHAR_SPEED;

            subjective_pronoun = "she";
            possessive_pronoun = "her";
			
			broken_morale_ar = [];
			array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.fleeing, broken_morale_str: $"\"... Wait! I can still see the code of their consciousness, drifting away!...\" {name} has outstreched her slender hands, grasping for the ethereal form of some invisible phantasm. \"This way!... The currents flow this way, follow me!...\"" });
			array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.cowering, broken_morale_str: $"\"... Their voices, echoing inside my mind, like the whispers of so many dead children...\" {name} has slumped against the floor and refuses to move. \"... Now they're condemned to the purgatory of the void forever...\"" });
			
			permanent_broken_morale_ar = [];
			array_copy(permanent_broken_morale_ar,0,broken_morale_ar,0,array_length(broken_morale_ar));
			
			scr_add_ability(self,item_type.spawn_light_buzzsaw_droid);
			scr_add_ability(self,item_type.spawn_light_flamer_droid);
			scr_add_ability(self,item_type.spawn_light_shotgun_droid);
			scr_add_ability(self,item_type.spawn_light_sentinel_droid);
			
			scr_add_passive_ability(self,passive_abil_type.cybernetic,"constructor event");
		}

        else if char_type_enum == character.mercenary_cyborg {
            
			name = "Torvald, 'The Cyborg'";
            hp_max = 12;
            hp_cur = 12;
            ability_points_cur = 8;
            ability_points_max = 8;
            sanity_max = 10;
			
			nick_name = "Cyborg";
			
			courage = AVG_COURAGE_VAL+1;
			
            engineering = 3;
            security = 8;
            science = 1;
            scavenging = 1;
            stealth = AVG_STEALTH_VAL-2;

            strength = 8;
            intelligence = 3;
            wisdom = 3;
            dexterity = 3;
            spd = AVERAGE_CHAR_SPEED+1;

            armor = 0; //Is increaed from from passive, as are his resistences.
            
			broken_morale_ar = [];
			array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.treacherous, broken_morale_str: $"\"You're infected--all of you! Skin, hair, sweat--it's vile! Obscene!\" {name} wheels about, his eyes feverish, brandishing a myriad of weapons that sprout from his skin. \"You've all been tainted by flesh! Here--stand still--let me purge it from your bones!\'"});
			array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.berserk, broken_morale_str: $"\"BURN! You will all burn!\" {name} bites into his own hand like a rabid animal, drawing forth blood and a heavy-bored barrel. Behind a veil of bedraggled hair, his eyes gleam bright with the promise of violence. \"BURN, and be purified by flame!\"" });
			array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.cowering, broken_morale_str: $"\"This flesh--it burns!\" {name} gouges his face, pulls locks from his hair. \"Let me be rid of it, once and for all!\"" });
			//debug only:
				//array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.fleeing, broken_morale_str: $"\"COCK!\"" });
			
			permanent_broken_morale_ar = [];
			array_copy(permanent_broken_morale_ar,0,broken_morale_ar,0,array_length(broken_morale_ar));
			
			//Abilities:
			scr_add_passive_ability(self,passive_abil_type.hardened_skin," constructor event ");
			scr_add_passive_ability(self,passive_abil_type.cybernetic,"constructor event");
			
			scr_add_ability(self,item_type.wrist_rockets);
			scr_add_ability(self,item_type.hand_flamer);
			scr_add_ability(self,item_type.shocking_grasp);
			scr_add_ability(self,item_type.personal_shield_generator);
		}

        else if char_type_enum == character.security_guard {
            name = "Cooper, 'The Guard'";
            hp_max = 10;
            hp_cur = 10;
            ability_points_cur = 14;
            ability_points_max = 14;
            sanity_max = 8;
			
			nick_name = "Guard";
			
			courage = AVG_COURAGE_VAL+1; 

            engineering = 1;
            security = 7;
            science = 0;
            scavenging = 2;
            stealth = AVG_STEALTH_VAL-2;

            strength = 7;
            intelligence = 1;
            wisdom = 2;
            dexterity = 2;
            spd = AVERAGE_CHAR_SPEED-1;
			
			broken_morale_ar = [];
				//Debug berserk:
				//array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.berserk, broken_morale_str: $"Cooper goes berserk."});
			array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.fleeing, broken_morale_str: $"\"Oh HELL no!\" {name} cries, bolting from his position. \"I didn't sign up for this shit!\""});
			array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.cowering, broken_morale_str: $"\"Just two more weeks, they said... Just two more weeks...\" {name} stands dumbfounded, frozen with fear. \"... Now I'll never see my little girl again...\"" });
			
			permanent_broken_morale_ar = [];
			array_copy(permanent_broken_morale_ar,0,broken_morale_ar,0,array_length(broken_morale_ar));
			
			scr_add_ability(self,item_type.taser);
			scr_add_ability(self,item_type.smoke_grenade);
		}

        else if char_type_enum == character.biologist {
            name = "Darius, 'The Biologist'";
            hp_max = 6;
            hp_cur = 6;
            ability_points_cur = 3;
            ability_points_max = 3;
            sanity_max = 4;
			
			nick_name = "Bio";
			
			courage = AVG_COURAGE_VAL-1; 
			
            engineering = 2;
            security = 0;
            science = 9;
            scavenging = 1;
            stealth = AVG_STEALTH_VAL;

            strength = 0;
            intelligence = 9;
            wisdom = 9;
            dexterity = 2;
            spd = AVERAGE_CHAR_SPEED-1;
			
			broken_morale_ar = [];
			array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.fleeing, broken_morale_str: $"\"The human fight or flight response is very strong, you see...\" {name} says, while fleeing in the opposite direction. \"... And, well--it seems my feet have decided for me! Goodbye!\""});
			array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.cowering, broken_morale_str: $"\"Millions of years of evolution... And it's all lead to this.\" {name} has assumed a thousand yard stare and refuses to move. \"How could we have been so blind?\""});
		
			permanent_broken_morale_ar = [];
			array_copy(permanent_broken_morale_ar,0,broken_morale_ar,0,array_length(broken_morale_ar));
		}

        else if char_type_enum == character.criminal { //Probably get rid of this character too
            name = "Emeran, 'The Criminal'";
            hp_max = 9;
            hp_cur = 9;
            ability_points_cur = 12;
            ability_points_max = 12;
            sanity_max = 9;
			
			nick_name = "Crim";

            engineering = 2;
            security = 6;
            science = 2;
            scavenging = AVG_STEALTH_VAL;
            stealth = 8;
            spd = 6;

            strength = 4;
            intelligence = 0;
            wisdom = 0;
            dexterity = 4;
            spd = AVERAGE_CHAR_SPEED+2;

            evasion = AVERAGE_EVASION_SCORE + 1;  // Better than average at evading

		}

        else if char_type_enum == character.service_droid {
            name = "RG-88, 'Service Droid'";
            hp_max = 6; //13;
            hp_cur = hp_max;
            ability_points_cur = 15;
            ability_points_max = 15;
            sanity_max = 20;
			
			nick_name = "RG-88";
			
			courage = AVG_COURAGE_VAL+20; 

            engineering = 7;
            security = 4;
            science = 6;
            scavenging = 0;
            stealth = AVG_STEALTH_VAL+1;

            strength = 9;
            intelligence = 4;
            wisdom = 8;
            dexterity = 2;
            spd = AVERAGE_CHAR_SPEED+1;
			
			//'Synthetic' resistences and morale_immunity granted from passive in scr_add_passive
			scr_add_passive_ability(self,passive_abil_type.synthetic,"constructor event");
			
			scr_add_ability(self, item_type.plasma_torch);
			scr_add_ability(self, item_type.fire_foam_spray);
			scr_add_ability(self, item_type.soldering_laser);
		}

        else if char_type_enum == character.ceo {
            name = "Celeste, 'The CEO'";
            hp_max = 7;
            hp_cur = 7;
            ability_points_cur = 8;
            ability_points_max = 8;
            sanity_max = 4;
			
			nick_name = "CEO";
			
			courage = AVG_COURAGE_VAL-2; 

            engineering = 3;
            security = 0;
            science = 3;
            scavenging = 3;
            stealth = AVG_STEALTH_VAL+1;

            strength = 1;
            intelligence = 3;
            wisdom = 4;
            dexterity = 2;
            spd = AVERAGE_CHAR_SPEED;

            subjective_pronoun = "she";
            possessive_pronoun = "her";
			
			broken_morale_ar = [];
			array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.fleeing, broken_morale_str: $"\"The board members, they're counting on me!\" The words of {name} are already no more than a echo as she bolts from the battle field. \"I'm sure the rest of you can handle this just fine without me!"});
			array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.cowering, broken_morale_str: $"The eyes of {name} have glazed over. She mumbles: \"Are they the monsters, or are we?\"" });
		
			permanent_broken_morale_ar = [];
			array_copy(permanent_broken_morale_ar,0,broken_morale_ar,0,array_length(broken_morale_ar));
		}

        else if char_type_enum == character.child {
            name = "Kira, 'The Gamer'";
            hp_max = 5;
            hp_cur = hp_max;
            ability_points_cur = 6;
            ability_points_max = 6;
            sanity_max = 4;
			
			nick_name = "Kira";
			
			courage = AVG_COURAGE_VAL+1;

            engineering = 1;
            security = 0;
            science = 1;
            scavenging = 5;
            stealth = AVG_STEALTH_VAL+3;

            strength = 0;
            intelligence = 2;
            wisdom = 1;
            dexterity = 7;
            spd = AVERAGE_CHAR_SPEED+1;

            evasion = AVERAGE_EVASION_SCORE+1; //Better than average at evading

            subjective_pronoun = "she";
            possessive_pronoun = "her";
			
			broken_morale_ar = [];
			array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.fleeing, broken_morale_str: $"With a whimper and sob, {name} turns tail and flees."});
			array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.cowering, broken_morale_str: $"{name} has assumed a fetal position and is screaming. \"MOMMA!\"" });
			
			permanent_broken_morale_ar = [];
			array_copy(permanent_broken_morale_ar,0,broken_morale_ar,0,array_length(broken_morale_ar));
			
			scr_add_passive_ability(self,passive_abil_type.child,"constructor event");
		}

        else if char_type_enum == character.playboy {
			name = "Oberon, 'The Playboy'";
            hp_max = 8;
            hp_cur = 8;
            ability_points_cur = 6;
            ability_points_max = 6;
            sanity_max = 4;
			
			nick_name = "Play";
			
			courage = AVG_COURAGE_VAL-2; 

            engineering = 1;
            security = 1;
            science = 1;
            scavenging = 3;
            stealth = AVG_STEALTH_VAL+1;

            strength = 3;
            intelligence = 2;
            wisdom = 1;
            dexterity = 5;
            spd = AVERAGE_CHAR_SPEED+1;
			
			broken_morale_ar = [];
			array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.fleeing, broken_morale_str: $"\"I'm really more of a general than a soldier--I work best from the back line...\" The feet of {name} are irresistibly guiding him from the battle field. \"I'll--I'll send help, okay?\""});
			array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.cowering, broken_morale_str: $"{name} has curled into a ball, sheletering his head with his hands, and muttering: \"Be a man, he said... Just act like a man, for once in your goddamned life!... Then why can't I move my fucking FEET?!\"" });
		
			permanent_broken_morale_ar = [];
			array_copy(permanent_broken_morale_ar,0,broken_morale_ar,0,array_length(broken_morale_ar));
		}

        else if char_type_enum == character.neutral_infected_scientist {
            name = "Gregos, 'The Researcher'";
            hp_max = 8;
            hp_cur = hp_max;
            ability_points_cur = 3;
            ability_points_max = 3;
            sanity_max = 3;
			
			nick_name = "Gregos";

            engineering = 4;
            security = 0;
            science = 9;
            scavenging = 1;
            stealth = 4;

            strength = 2;
            intelligence = 8;
            wisdom = 8;
            dexterity = 2;
            spd = AVERAGE_CHAR_SPEED+2;

            combat_ai_preference = enemy_combat_ai.ranged_coward;
			
			broken_morale_ar = [];
			array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.fleeing, broken_morale_str: "\"I--I can't be here! I'm sorry!\""});
			array_push(broken_morale_ar, { broken_morale_status_effect_enum: broken_morale_status_effects.cowering, broken_morale_str: "\"... What have I done?... Oh God, what have I done?...\"" });
		
			permanent_broken_morale_ar = [];
			array_copy(permanent_broken_morale_ar,0,broken_morale_ar,0,array_length(broken_morale_ar));
		}

        else if char_type_enum == character.enemy_skittering_larva {
            name = "Skittering Larva";
            hp_max = irandom_range(3,4);
            hp_cur = hp_max;
            ability_points_cur = 3;
            ability_points_max = 3;
            sanity_max = 20;
			
            spd = 8;

            combat_ai_preference = enemy_combat_ai.melee;

            armor = 0;
            
			accuracy = AVG_ACC_VAL+1;
			
			nick_name = "Larva";
			
			scr_add_ability(self,item_type.infection_needle);
			scr_add_ability(self,item_type.writhing_tendril);
			
			//Adds all of our 'alien' base resistences - they are resistant to most hazards except for fire, for which they are only partially resistant;
			//also makes them morale and infection immune.
			scr_add_passive_ability(self, passive_abil_type.alien, "character struct constructor event.");
		}

        else if char_type_enum == character.neutral_jittering_buzzsaw {
            name = "Jittering Buzzsaw Droid";
            hp_max = irandom_range(6,8);
            hp_cur = hp_max;
            ability_points_cur = 3;
            ability_points_max = 3;
            sanity_max = 20;
			
            spd = AVERAGE_CHAR_SPEED+1;
			
			nick_name = "Buzzsaw";

            combat_ai_preference = enemy_combat_ai.melee;
			
			morale_immune = true;
			
			//Resistences and armor are changed here:
			scr_add_passive_ability(self,passive_abil_type.synthetic,"constructor event");
			
			scr_add_ability(self, item_type.crude_buzzsaw);
		}

        else if char_type_enum == character.neutral_fumigating_flamer {
            name = "Fumigating Flamer Droid";
            hp_max = irandom_range(6,8);
            hp_cur = hp_max;
            ability_points_cur = 3;
            ability_points_max = 3;
            sanity_max = 20;
            spd = 0;
			
			nick_name = "Flamer";

            combat_ai_preference = enemy_combat_ai.melee;

			morale_immune = true;
			
			//Resistences and armor are changed here:
			scr_add_passive_ability(self,passive_abil_type.synthetic,"constructor event");
			
			scr_add_ability(self, item_type.flame_thrower);
		}

        else if char_type_enum == character.neutral_spinning_scattershot {
            name = "Spinning Scattershot Droid";
            hp_max = irandom_range(5,7);
            hp_cur = hp_max;
            ability_points_cur = 3;
            ability_points_max = 3;
            sanity_max = 20;
			
            spd = 7;
			
			nick_name = "Shotgun";

            combat_ai_preference = enemy_combat_ai.ranged_coward;
			
			morale_immune = true;
			
			//Resistences and armor are changed here:
			scr_add_passive_ability(self,passive_abil_type.synthetic,"constructor event");
			
			scr_add_ability(self, item_type.shotgun);
		}

        else if char_type_enum == character.neutral_whipstitch_sentinel {
            name = "Whipstitch Sentinel Droid";
            hp_max = irandom_range(6,8)
            hp_cur = hp_max;
            ability_points_cur = 3;
            ability_points_max = 3;
            sanity_max = 20;
			
            spd = AVERAGE_CHAR_SPEED;
			
			nick_name = "Sentinel";
			
			morale_immune = true;

            combat_ai_preference =  enemy_combat_ai.overwatch_coward;

            //Resistences and armor are changed here:
			scr_add_passive_ability(self,passive_abil_type.synthetic,"constructor event");
			
			scr_add_ability(self, item_type.pulse_pistol);
		}

        else if char_type_enum == character.neutral_light_sentry_gun {
            name = "Light Sentry Drone";
            hp_max = 4;
            hp_cur = hp_max;
            sanity_max = 20;
            spd = 10;
			
			nick_name = "SentryDr.";

            combat_ai_preference = enemy_combat_ai.stationary_overwatch;

            //Resistences and armor are changed here:
			scr_add_passive_ability(self,passive_abil_type.synthetic,"constructor event");
			
			scr_add_ability(self,item_type.light_mg);
			
			stationary_neutral_bool = true; //Never moves from a room.
		}

        else if char_type_enum == character.enemy_lumbering_carrier {
            name = "Lumbering Carrier";
            hp_max = irandom_range(16,20);
            hp_cur = hp_max;
            sanity_max = 20;
			
			nick_name = "Carrier";

            armor = 1;
            evasion = -1;
			
			accuracy = AVG_ACC_VAL+1; //Most enemies have better accuracy than most pcs

            suppress_immune_boolean = true;
            stun_immune_boolean = true;
            can_spawn_minions = true;
            spawn_minion_count = irandom_range(1,3);

            combat_ai_preference = enemy_combat_ai.melee;

            spd = -1

			scr_add_ability(self, item_type.monstrous_claw);
			
			//Adds all of our 'alien' base resistences - they are resistant to most hazards except for fire, for which they are only partially resistant;
			//also makes them morale and infection immune.
			scr_add_passive_ability(self, passive_abil_type.alien, "character struct constructor event.");
		}

        else if char_type_enum == character.enemy_spined_spitter {
            name = "Spined Spitter";
            hp_max = irandom_range(9,11);
            hp_cur = hp_max;
            sanity_max = 20;
			
			nick_name = "Spitter";

            armor = 1;
            evasion = 0;
			
			accuracy = AVG_ACC_VAL+1; //Most enemies have better accuracy than most pcs

            combat_ai_preference = enemy_combat_ai.ranged_coward;

            spd = AVERAGE_CHAR_SPEED+1;

			scr_add_ability(self, item_type.spine_projectile);	
			
			//Adds all of our 'alien' base resistences - they are resistant to most hazards except for fire, for which they are only partially resistant;
			//also makes them morale and infection immune.
			scr_add_passive_ability(self, passive_abil_type.alien, "character struct constructor event.");
		}

        else if char_type_enum == character.enemy_transmogrified_soldier {
            name = "Transmogrified Soldier";
            hp_max = irandom_range(10,13);
            hp_cur = hp_max;
            sanity_max = 20;
			
			nick_name = "TransformedSldr.";
			
			accuracy = AVG_ACC_VAL+2; //Most enemies have better accuracy than most pcs

            armor = 0;
            evasion = -1;

            combat_ai_preference = enemy_combat_ai.overwatch_coward;

            spd = AVERAGE_CHAR_SPEED+1;
			
			//Deal extra melee damage:
			scr_add_passive_ability(self,passive_abil_type.giant,"constructor event for transmogrified soldier char");
			
			//Adds all of our 'alien' base resistences - they are resistant to most hazards except for fire, for which they are only partially resistant;
			//also makes them morale and infection immune.
			scr_add_passive_ability(self, passive_abil_type.alien, "character struct constructor event.");
			
			//This enemy has more versatility than most - difficult to predict exactly how they will behave or what they will attack with:
			var ran_equip_int = irandom_range(1,6);
			
			if ran_equip_int == 1 {
				scr_add_ability(self, item_type.pulse_rifle);	
			}
			else if ran_equip_int == 2 {
				scr_add_ability(self, item_type.assault_rifle);	
				accuracy++;
			}
			else if ran_equip_int == 3 {
				scr_add_ability(self, item_type.shotgun);	
				armor += 2;
				evasion++;
				combat_ai_preference = enemy_combat_ai.ranged_stationary;
			}
			else if ran_equip_int == 4 {
				scr_add_ability(self, item_type.pulse_pistol);	
				armor++;
				accuracy++;
				combat_ai_preference = enemy_combat_ai.ranged_coward;
			}
			else if ran_equip_int == 5 {
				scr_add_ability(self, item_type.machine_pistol);	
				armor += 2;
				accuracy++;
				evasion++;
				combat_ai_preference = enemy_combat_ai.ranged_coward;
			}
			else if ran_equip_int == 6 {
				scr_add_ability(self, item_type.fire_axe);	
				scr_add_ability(self, item_type.lead_pipe);
				armor += 3;
				accuracy += 2;
				evasion += 2;
				combat_ai_preference = enemy_combat_ai.melee;
			}
		}

        else if char_type_enum == character.enemy_sodden_shambler {
            name = "Sodden Shambler";
            hp_max = irandom_range(8,10);
            hp_cur = hp_max;
            sanity_max = 20;
			
			nick_name = "Shambler";
			
			accuracy = AVG_ACC_VAL+1; //Most enemies have better accuracy than most pcs

            armor = 0;
            evasion = 0;
          
            combat_ai_preference = enemy_combat_ai.ranged_coward;

            spd = 0;
			
			scr_add_ability(self,item_type.acid_cloud);
			scr_add_ability(self,item_type.acid_spit);
			scr_add_ability(self,item_type.regurgitated_vomit);
			
			//Adds all of our 'alien' base resistences - they are resistant to most hazards except for fire, for which they are only partially resistant;
			//also makes them morale and infection immune.
			scr_add_passive_ability(self, passive_abil_type.alien, "character struct constructor event.");
		}

        else if char_type_enum == character.enemy_chittering_lurker {
            name = "Chittering Lurker";
            hp_max = irandom_range(7,9);
            hp_cur = hp_max;
            sanity_max = 20;
			
			nick_name = "Lurker";
			
			accuracy = AVG_ACC_VAL+1; //Most enemies have better accuracy than most pcs

            armor = 0;
            evasion = 2;

            ai_is_suppressor_boolean = true; //No idea where else this is being used - if at all
            combat_ai_preference = enemy_combat_ai.ranged_coward;

            spd = 7;

			scr_add_ability(self,item_type.filament_spray);
			scr_add_ability(self,item_type.sticky_slime);
			scr_add_ability(self,item_type.terrifying_wail);
			
			//Adds all of our 'alien' base resistences - they are resistant to most hazards except for fire, for which they are only partially resistant;
			//also makes them morale and infection immune.
			scr_add_passive_ability(self, passive_abil_type.alien, "character struct constructor event.");
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
		
		//Automatically add this enemy struct to a mob struct at this location or, if one does not exist, create and add to a new mob struct at this location;
		//also define the ai movement type enum for the mob:
		if auto_add_to_mob_struct {
			//enemy_ai_movement_type_enum	; mob_grid_x and y ; cur_grid_x ; cur_grid ; mob_cur_grid
			//Iterate through global mob_ar:
			var mob_found = false;
			if is_array(global.enemy_mob_ar) && array_length(global.enemy_mob_ar) > 0 {
				for(var mi = 0; mi < array_length(global.enemy_mob_ar); mi++) {
					
					var mob_struct_id = global.enemy_mob_ar[mi];
					
					//If we find another mob at this location that has the same movement type, simply add ourself to it:
					if mob_struct_id.mob_grid_x == cur_grid_x && mob_struct_id.mob_grid_y == cur_grid_y && mob_struct_id.ai_movement_behavior == enemy_ai_movement_type_enum {
						if !is_array(mob_struct_id.enemies_in_mob_ar) mob_struct_id.enemies_in_mob_ar = [];
						array_push(mob_struct_id.enemies_in_mob_ar, self);
						mob_found = true;
						break;
					}
				}
			}
			
			//Otherwise, we need to create one:
			if !mob_found {
				//Create new enemy mob:
				array_push(global.enemy_mob_ar, new enemy_mob_struct(cur_grid, cur_grid_x, cur_grid_y, location_enum, enemy_ai_movement_type_enum) );
				//Add to its nested array:
				array_push(global.enemy_mob_ar[array_length(global.enemy_mob_ar) - 1].enemies_in_mob_ar, self);
			}
		}
		
	} //closed bracket for Character struct
	
	#endregion
	
	#region Item struct:
	
	global.Item = function(item_enum_val) constructor
	{
		struct_type_enum = struct_type.Item;
		
		item_equip_enum = item_equip_type.none; //default, this means the item cannot be equipped
		
        item_enum = item_enum_val;

        stat_boost_list = [];
        for(var i = 0; i < stat_boost.total_stats; i++) {
            array_push(stat_boost_list,0);
		}
		
		dmg_type_enum = item_dmg_type.damage_only;
		
        // Default values for instance vars for each item:
        dmg_min = 0;
        dmg_max = 0;
        requires_ammo_boolean = true;
        max_range = 0; //If 0=melee only
		
		char_spawn_enum = -1; //Used with ability-type items that spawn other characters.

        single_use_boolean = false;
        melee_debuff_boolean = false; //May not implement this at all
        equippable_boolean = true;
        usable_boolean = false;
       
        use_requires_target = false; //For items or abilities that are 'used', usually destroyed after, and require a target- such as the medkit, adrenal pen, healing nanites, etc.
        abil_passes_turn_boolean = false; //And when I say 'passes turn', I mean using it triggers advance_cur_combat_char being called after using it, such as cooper's smoke grenade.
		
        is_shield_boolean = false; //Currently only used in scr_check_valid_item_equip()
        can_overwatch_boolean = false;
		
		basic_tech_cost = 0;
		advanced_tech_cost = 0;
		food_cost = 0;
		
		move_point_cost = 0;
		sanity_cost = 0;
		scrap_cost = 0;
        ability_point_cost = 0;
        ability_cost_str = "";
        non_attack_ability_boolean = false; //Torvald's shield, cooper's buffs, Avia's summons, etc., all == true; these type of abilities should also never be used by ai.
		
		//Most status effect type vars:
        burn_chance = 0;
        poison_chance = 0;
        bleed_chance = 0;
        stun_chance = 0;
        infection_chance = 0;
        suppress_chance = 0;

        always_checks_status_effect_boolean = false; //If true - we roll to apply a status effect even if the attack misses.

        item_name = "Not defined";
        item_desc = "Not defined";
        item_dmg_str = "Not defined";

        item_verb = "fires";
        aoe_count = 1; //indicates max targets item will hit; -1 indicates it hits the entire mob, flamers only
		
		use_context = abil_use_context.main_game_only; //Used with abilities and 'useable' items when determining where they can be used: in combat, outside of it, or in both scenarios
		
		melee_only = false; //Used to distinguish melee weapons from weapons that have a range of 0, for providing specific buffs or debuffs for chars that are strong or weak with melee weapons.
		
        //region Define item stats for each item:

        if item_enum == item_type.flashlight {
            dmg_min = 1;
            dmg_max = 1;
            item_name = "FLASHLIGHT";
            item_equip_enum = item_equip_type.accessory;
			use_context = abil_use_context.main_game_only;
		}
        else if item_enum == item_type.shotgun {
            dmg_min = 3;
            dmg_max = 6;
            item_name = "SHOTGUN";
            item_equip_enum = item_equip_type.two_hands;
            max_range = 2;
            item_verb = "pumps the";
            item_dmg_str = "shot";
            aoe_count = 3;
            can_overwatch_boolean = true;
            bleed_chance = 25;
            item_desc = "Your standard issue military grade shotgun most commonly used by security personnel.";
			use_context = abil_use_context.combat_only;
		}
        else if item_enum == item_type.semi_auto_pistol {
            dmg_min = 1;
            dmg_max = 4;
            max_range = 2;
            item_name = "SEMI-AUTOMATIC PISTOL";
            item_equip_enum = item_equip_type.one_hand;
            item_verb = "fires the";
            item_dmg_str = "shot";
            can_overwatch_boolean = true;
            bleed_chance = 10;
			use_context = abil_use_context.combat_only;
		}
        else if item_enum == item_type.pulse_pistol {
            dmg_min = 2;
            dmg_max = 5;
            requires_ammo_boolean = false;
            item_name = "PULSE PISTOL";
            item_equip_enum = item_equip_type.one_hand;
            max_range = 2; //3? Is 2 too shit?
            item_verb = "fires the";
            item_dmg_str = "burned";
            can_overwatch_boolean = true;
            burn_chance = 10;
			use_context = abil_use_context.combat_only;
		}
        else if item_enum == item_type.frag_grenade {
            dmg_min = 8;
            dmg_max = 12;
            item_name = "FRAGMENTATION GRENADE";
            single_use_boolean = true;
            item_equip_enum = item_equip_type.one_hand;
            max_range = 2;
            item_verb = "tosses the";
            item_dmg_str = "shredded";
            aoe_count = 6;
            burn_chance = 25;
            bleed_chance = 25;
			use_context = abil_use_context.combat_only;
		}
        else if item_enum == item_type.flame_thrower {
            dmg_min = 3;
            dmg_max = 6;
            item_name = "FLAMETHROWER";
			item_equip_enum = item_equip_type.two_hands;
            max_range = 0;
            item_verb = "spews fire with the";
            item_dmg_str = "burned";
            aoe_count = -1;
            burn_chance = 75;
			use_context = abil_use_context.combat_only;
		}
        else if item_enum == item_type.hand_flamer { //Torvald ability
            dmg_min = 2;
            dmg_max = 5;
            item_name = "PALM FLAMER";
            max_range = 1;
            item_verb = "spews fire with the";
            item_dmg_str = "burned";
            aoe_count = -1;
            burn_chance = 75;
            ability_point_cost = 3;
            ability_cost_str = ""; //Only defined for those abilities with their non_attack_ability_boolean == true (weapon type abilities); otherwise defined in scr_print_weapon_or_abil_list
            requires_ammo_boolean = false;
			use_context = abil_use_context.combat_only;
		}

        else if item_enum == item_type.wrist_rockets { //Torvald ability
            dmg_min = 8;
            dmg_max = 12;
            item_name = "WRIST ROCKETS";
            max_range = 3;
            item_verb = "fires";
            item_dmg_str = "shredded";
            aoe_count = 6;
            burn_chance = 25;
            bleed_chance = 25;
            suppress_chance = 50;
            stun_chance = 25;
            ability_point_cost = 5;
            ability_cost_str = ""; //Only defined for those abilities with their non_attack_ability_boolean == true (weapon type abilities); otherwise defined in scr_print_weapon_or_abil_list
            requires_ammo_boolean = false;
			use_context = abil_use_context.combat_only;
		}

        else if item_enum == item_type.shocking_grasp { //Torvald ability
            dmg_min = 2;
            dmg_max = 4;
            item_name = "SHOCKING GRASP";
            max_range = 0;
            item_verb = "grabs with a";
            item_dmg_str = "burned";
            aoe_count = 1;
            burn_chance = 25;
            stun_chance = 50;
            ability_point_cost = 1;
            ability_cost_str = ""; //Only defined for those abilities with their non_attack_ability_boolean == true (weapon type abilities); otherwise defined in scr_print_weapon_or_abil_list
            requires_ammo_boolean = false;
			use_context = abil_use_context.combat_only;
			melee_only = true;
		}

        else if item_enum == item_type.headbutt { //ogre
            dmg_min = 2;
            dmg_max = 5;
            item_name = "HEAD BUTT";
            max_range = 0;
            item_verb = "roars and smashes with a vicious";
            item_dmg_str = "battered";
            aoe_count = 1;
            stun_chance = 75;
            ability_point_cost = 3;
            ability_cost_str = $"Spend {ability_point_cost} AP";
            requires_ammo_boolean = false;
			use_context = abil_use_context.combat_only;
			melee_only = true;
		}

        else if item_enum == item_type.feral_bite { //ogre
            dmg_min = 3;
            dmg_max = 6;
            item_name = "MONSTROUS MAW";
            max_range = 0;
            item_verb = "snarls and lunges with a";
            item_dmg_str = "bitten";
            aoe_count = 1;
            bleed_chance = 100;
            ability_point_cost = 3;
            ability_cost_str = $"Spend {ability_point_cost} AP";
            requires_ammo_boolean = false;
			use_context = abil_use_context.combat_only;
			melee_only = true;
		}

        //This skill uses utils execute_non_attack_ability()
        else if item_enum == item_type.personal_shield_generator { //Torvald ability
            dmg_min = 0;
            dmg_max = 0;
            item_name = "PERSONAL SHIELD GENERATOR";
            max_range = 0;
            ability_point_cost = 3;
            stat_boost_list[stat_boost.armor] = PERSONAL_SHIELD_ARMOR_BUFF; //Not implemented in this way
            stat_boost_list[stat_boost.evasion] = PERSONAL_SHIELD_EVASION_BUFF; //Not implemented in this way
            non_attack_ability_boolean = true;
            abil_passes_turn_boolean = false;
            requires_ammo_boolean = false;
			use_context = abil_use_context.combat_only;
			ability_cost_str = $"Spend {ability_point_cost} A.P.: clear the suppression status effect, and gain +{stat_boost_list[stat_boost.armor]} armor and +{stat_boost_list[stat_boost.evasion]} evasion for 3 turns. This ability does not stack.";
		}
		
        else if item_enum == item_type.smoke_grenade {  // Cooper ability
            dmg_min = 0;
            dmg_max = 0;
            item_name = "SMOKE GRENADE" ;
            max_range = 0;
            ability_point_cost = 3;
            ability_cost_str = $"Spend {ability_point_cost} AP and pass your turn: every friendly unit in your party gains +{SMOKE_GRENADE_EVADE_BUFF} evasion for {SMOKE_GRENADE_DURATION} turns. This ability does not stack.";
            stat_boost_list[stat_boost.evasion] = SMOKE_GRENADE_EVADE_BUFF; //Not implemented in this way.
            non_attack_ability_boolean = true;
            abil_passes_turn_boolean = true;
            requires_ammo_boolean = false;
			use_context = abil_use_context.combat_only;
		}

        else if item_enum == item_type.field_medicine {  // Doctor ability
            dmg_min = 0;
            dmg_max = 0;
            item_name = "FIELD MEDICINE";
            max_range = 0;
            ability_point_cost = 3;
            ability_cost_str = $"Spend {ability_point_cost} AP and pass your turn if in combat: target player character heals {FIELD_MEDICINE_HP_BOOST} hit points and is cleared of the following status effects: burning, bleeding, poisoned.";
            non_attack_ability_boolean = true;
            abil_passes_turn_boolean = true;
            requires_ammo_boolean = false;
			use_context = abil_use_context.both;
			use_requires_target = true;
		}
		
		 else if item_enum == item_type.medkit {
            single_use_boolean = true;
            usable_boolean = true;
            item_name = "MEDICAL KIT";
            equippable_boolean = false;
			use_context = abil_use_context.both;
			use_requires_target = true;
		}
		
		else if item_enum == item_type.improvised_medicine {  // Doctor ability
            dmg_min = 0;
            dmg_max = 0;
            item_name = "IMPROVISED TREATMENT";
            max_range = 0;
            ability_point_cost = 3;
            ability_cost_str = $"Spend {ability_point_cost} AP and pass your turn if in combat: target player character heals {IMPROVISED_MEDICINE_INFECT_REMOVE_BUFF} infection points.";
            non_attack_ability_boolean = true;
            abil_passes_turn_boolean = true;
            requires_ammo_boolean = false;
			use_context = abil_use_context.both;
			use_requires_target = true;
		}
		
		//Item that repairs hazards and hazard generators:
		else if item_enum == item_type.welding_torch {
            dmg_min = 1;
            dmg_max = 4;
            requires_ammo_boolean = false;
            item_name = "WELDING TORCH";
            item_equip_enum = item_equip_type.none;
            item_verb = "blazes the";
            item_dmg_str = "burns";
            max_range = 0;
            burn_chance = 75;
			usable_boolean = true;
			use_context = abil_use_context.main_game_only;
			move_point_cost = 1;
			scrap_cost = 2;
			item_desc = $"Spend {move_point_cost} MP, {scrap_cost} scrap, and pass an engineering skill test: Repair a hull breach or leaking pipe at your current location. If both hazards are present, the hull breach will be repaired first.";
		}
		
		//Item that repairs hazards and hazard generators:
		else if item_enum == item_type.torque_wrench {
            dmg_min = 1;
            dmg_max = 2;
            requires_ammo_boolean = false;
            item_name = "TORQUE WRENCH";
            item_equip_enum = item_equip_type.none;
            item_verb = "swings the";
            item_dmg_str = "blundgeons";
            max_range = 0;
            burn_chance = 75;
			usable_boolean = true;
			use_context = abil_use_context.main_game_only;
			move_point_cost = 1;
			scrap_cost = 2;
			item_desc = $"Spend {move_point_cost} MP, {scrap_cost} scrap, and pass an engineering skill test: Repair a leaking pipe at your current location.";
		}
		
		//Item that repairs hazards and hazard generators:
		else if item_enum == item_type.soldering_tools {
            dmg_min = 1;
            dmg_max = 2;
            requires_ammo_boolean = false;
            item_name = "SOLDERING TOOLS";
            item_equip_enum = item_equip_type.none;
            item_verb = "swings the";
            item_dmg_str = "blundgeons";
            max_range = 0;
            burn_chance = 75;
			usable_boolean = true;
			use_context = abil_use_context.main_game_only;
			move_point_cost = 1;
			scrap_cost = 2;
			item_desc = $"Spend {move_point_cost} MP, {scrap_cost} scrap, and pass an engineering skill test: Repair a damaged electrical hazard at your current location.";
		}
		
		//Item that repairs hazards and hazard generators:
		else if item_enum == item_type.fire_extinguisher {
            dmg_min = 1;
            dmg_max = 2;
            requires_ammo_boolean = false;
            item_name = "FIRE EXTINGUISHER";
            item_equip_enum = item_equip_type.none;
            item_verb = "swings the";
            item_dmg_str = "blundgeons";
            max_range = 0;
            burn_chance = 75;
			usable_boolean = true;
			use_context = abil_use_context.main_game_only;
			move_point_cost = 1;
			scrap_cost = 1;
			item_desc = $"Spend {move_point_cost} MP, {scrap_cost} scrap: Extinguish a fire and/or burning fuel hazard at your current location.";
		}
		
		//Ability that repairs hazards and hazard generators:
		else if item_enum == item_type.plasma_torch {
            dmg_min = 1;
            dmg_max = 4;
            requires_ammo_boolean = false;
            item_name = "PLASMA TORCH";
            item_equip_enum = item_equip_type.none;
            item_verb = "blazes the";
            item_dmg_str = "burns";
            max_range = 0;
            burn_chance = 75;
			max_range = 0;
            ability_point_cost = 3;
			move_point_cost = 1;
			scrap_cost = 2;
            ability_cost_str = $"Spend {ability_point_cost} AP, {move_point_cost} MP, {scrap_cost} scrap, and pass an engineering skill test: repair a hull breach or leaking pipe at your current location. If both are present, hull breach will be repaired first.";
            non_attack_ability_boolean = true;
            abil_passes_turn_boolean = true;
            requires_ammo_boolean = false;
			use_context = abil_use_context.main_game_only;
			use_requires_target = false;
		}
		
		//Ability that repairs hazards and hazard generators:
		else if item_enum == item_type.soldering_laser {
            dmg_min = 1;
            dmg_max = 4;
            requires_ammo_boolean = false;
            item_name = "SOLDERING LASER";
            item_equip_enum = item_equip_type.none;
            item_verb = "blazes the";
            item_dmg_str = "burns";
            max_range = 0;
            burn_chance = 75;
			max_range = 0;
            ability_point_cost = 3;
			move_point_cost = 1;
			scrap_cost = 2;
            ability_cost_str = $"Spend {ability_point_cost} AP, {move_point_cost} MP, {scrap_cost} scrap, and pass an engineering skill test: repair a electrical hazard at your current location.";
            non_attack_ability_boolean = true;
            abil_passes_turn_boolean = true;
            requires_ammo_boolean = false;
			use_context = abil_use_context.main_game_only;
			use_requires_target = false;
		}
		
		//Ability that repairs hazards and hazard generators:
		else if item_enum == item_type.fire_foam_spray {
            dmg_min = 1;
            dmg_max = 4;
            requires_ammo_boolean = false;
            item_name = "FIRE FOAM SPRAY";
            item_equip_enum = item_equip_type.none;
            item_verb = "squirts the";
            item_dmg_str = "burns";
            max_range = 0;
            burn_chance = 75;
			max_range = 0;
            ability_point_cost = 3;
			move_point_cost = 1;
			scrap_cost = 2;
            ability_cost_str = $"Spend {ability_point_cost} AP, {move_point_cost} MP, and {scrap_cost} scrap: extinguish a fire and/or burning fuel hazard at your current location.";
            non_attack_ability_boolean = true;
            abil_passes_turn_boolean = true;
            requires_ammo_boolean = false;
			use_context = abil_use_context.main_game_only;
			use_requires_target = false;
		}
		
        else if item_enum == item_type.spawn_light_sentry_gun {  // Engineer ability
            dmg_min = 0;
            dmg_max = 0;
            item_name = "LIGHT SENTRY GUN";
            max_range = 0;
            ability_point_cost = 4;
            non_attack_ability_boolean = true;
            abil_passes_turn_boolean = true;
            requires_ammo_boolean = false;
			use_context = abil_use_context.both;
			char_spawn_enum = character.neutral_light_sentry_gun;
			scrap_cost = 2;
			ability_cost_str = $"Spend {ability_point_cost} AP, {scrap_cost} scrap, and pass your turn if in combat: spawn a LIGHT SENTRY GUN at your position. Sentry guns do not move, fire at enemies within their range, and set overwatch when enemies are beyond their range.";
		}

        else if item_enum == item_type.spawn_light_sentinel_droid {  
            dmg_min = 0;
            dmg_max = 0;
            item_name = "WHIPSTITCH SENTINEL DROID";
            max_range = 0;
            ability_point_cost = 6;
			sanity_cost = 2;
            non_attack_ability_boolean = true;
            abil_passes_turn_boolean = true;
            requires_ammo_boolean = false;
			use_context = abil_use_context.both;
			char_spawn_enum = character.neutral_whipstitch_sentinel;
			scrap_cost = 2;
			ability_cost_str = $"Spend {ability_point_cost} AP, {scrap_cost} scrap, {sanity_cost} sanity, and pass your turn if in combat: spawn a WHIPSTITCH SENTINEL DROID at your position. This hastily constructed bag of bolts uses a PULSE PISTOL and likes to set overwatch, but only if it has the ranged advantage over the enemy.";
		}

        // This skill uses utils execute_non_attack_ability()
        else if item_enum == item_type.spawn_light_shotgun_droid {  
            dmg_min = 0;
            dmg_max = 0;
            item_name = "SPINNING SCATTERSHOT DROID";
            max_range = 0;
            ability_point_cost = 4;
			sanity_cost = 2;
            non_attack_ability_boolean = true;
            abil_passes_turn_boolean = true;
            requires_ammo_boolean = false;
			use_context = abil_use_context.both;
			char_spawn_enum = character.neutral_spinning_scattershot;
			scrap_cost = 2;
			 ability_cost_str = $"Spend {ability_point_cost} AP, {scrap_cost} scrap, {sanity_cost} sanity, and pass your turn if in combat: spawn a SPINNING SCATTERSHOT DROID at your position. This cowardly little droid likes to pepper enemies with its SHOTGUN.";
		}

        // This skill uses utils execute_non_attack_ability()
        else if item_enum == item_type.spawn_light_flamer_droid {  
            dmg_min = 0;
            dmg_max = 0;
            item_name = "FUMIGATING FLAMER DROID";
            max_range = 0;
            ability_point_cost = 3;
			sanity_cost = 2;
            non_attack_ability_boolean = true;
            abil_passes_turn_boolean = true;
            requires_ammo_boolean = false;
			use_context = abil_use_context.both;
			char_spawn_enum = character.neutral_fumigating_flamer;
			scrap_cost = 2;
			ability_cost_str = $"Spend {ability_point_cost} AP, {scrap_cost} scrap, {sanity_cost} sanity, and pass your turn if in combat: spawn a FUMIGATING FLAMER DROID at your position. This fearless little droid would wheel itself through the gates of hell to protect you. It has been affixed with a FLAMETHROWER and is belching a disconcerting amount of smoke.";
		}

        // This skill uses utils execute_non_attack_ability()
        else if item_enum == item_type.spawn_light_buzzsaw_droid { 
            dmg_min = 0;
            dmg_max = 0;
            item_name = "JITTERING BUZZSAW DROID";
            max_range = 0;
            ability_point_cost = 3;
			sanity_cost = 2;
            non_attack_ability_boolean = true;
            abil_passes_turn_boolean = true;
            requires_ammo_boolean = false;
			use_context = abil_use_context.both;
			char_spawn_enum = character.neutral_jittering_buzzsaw;
			scrap_cost = 2;
			ability_cost_str = $"Spend {ability_point_cost} AP, {scrap_cost} scrap, {sanity_cost} sanity, and pass your turn if in combat: spawn a JITTERING BUZZSAW DROID at your position. Its spinning BUZZSAW looks as though its about to bounce out of its frame! Better point this droid in the right direction...";
		}
        // This skill uses utils execute_non_attack_ability()
        else if item_enum == item_type.energizing_stim_prick {  //doctor ability
            dmg_min = 0;
            dmg_max = 0;
            item_name = "ENERGIZING STIMULANT";
            max_range = 0;
            ability_point_cost = 3;
            ability_cost_str = $"Spend {ability_point_cost} AP: target player character gains {ENERGENIZING_AP_BOOST} ability points.";
            non_attack_ability_boolean = true;
            abil_passes_turn_boolean = false;
            requires_ammo_boolean = false;
            use_requires_target = true;
			use_context = abil_use_context.both;
		}
		
        else if item_enum == item_type.rocket_launcher {
            dmg_min = 10;
            dmg_max = 15;
            single_use_boolean = true;
            item_name = "ROCKET LAUNCHER";
            item_equip_enum = item_equip_type.two_hands;
            max_range = 4;
            item_verb = "fires the";
            item_dmg_str = "exploded";
            aoe_count = 8;
            bleed_chance = 75;
            burn_chance = 75; //DEBUG
			use_context = abil_use_context.combat_only;
		}
        else if item_enum == item_type.lead_pipe {
            dmg_min = 1;
            dmg_max = 4;
            requires_ammo_boolean = false;
            item_name = "LEAD PIPE";
            item_equip_enum = item_equip_type.one_hand;
            item_verb = "swings the";
            item_dmg_str = "blundgeoned";
            max_range = 0;
            stun_chance = 50;
			use_context = abil_use_context.combat_only;
			melee_only = true; //Used to distinguish melee weapons from weapons that have a range of 0, for providing specific buffs or debuffs for chars that are strong or weak with melee weapons.
		}
        else if item_enum == item_type.monstrous_claw {
            dmg_min = 4;
            dmg_max = 8;
            requires_ammo_boolean = false;
            item_name = "MONSTROUS CLAWS";
            item_equip_enum = item_equip_type.one_hand;
            item_verb = "swipes with";
            item_dmg_str = "slashed";
            max_range = 0;
            bleed_chance = 50;
            infection_chance = 10;
			use_context = abil_use_context.combat_only;
			melee_only = true; //Used to distinguish melee weapons from weapons that have a range of 0, for providing specific buffs or debuffs for chars that are strong or weak with melee weapons.
		}
        else if item_enum == item_type.writhing_tendril {
            dmg_min = 1;
            dmg_max = 4;
            requires_ammo_boolean = false;
            item_name = "WRITHING TENDRIL";
            item_equip_enum = item_equip_type.one_hand;
            item_verb = "whips with a";
            item_dmg_str = "slashed";
            max_range = 0;
            stun_chance = 25; //25;
            bleed_chance = 0;
            always_checks_status_effect_boolean = false;
            infection_chance = 15;
			use_context = abil_use_context.combat_only;
			melee_only = true; //Used to distinguish melee weapons from weapons that have a range of 0, for providing specific buffs or debuffs for chars that are strong or weak with melee weapons.
		}
        else if item_enum == item_type.desperate_claw {
            dmg_min = 1;
            dmg_max = 3;
            requires_ammo_boolean = false;
            item_name = "DESPERATE CLAW";
            item_equip_enum = item_equip_type.one_hand;
            item_verb = "slashes with a";
            item_dmg_str = "slashed";
            max_range = 0;
            bleed_chance = 25;
            infection_chance = 10;
			use_context = abil_use_context.combat_only;
			melee_only = true; //Used to distinguish melee weapons from weapons that have a range of 0, for providing specific buffs or debuffs for chars that are strong or weak with melee weapons.
		}
        else if item_enum == item_type.infection_needle {
            dmg_min = 4;
            dmg_max = 4;
            requires_ammo_boolean = false;
            item_name = "INFECTED BARB";
            item_equip_enum = item_equip_type.one_hand;
            item_verb = "stabs with a";
            item_dmg_str = "punctured";
            max_range = 0;
            infection_chance = 100;
			use_context = abil_use_context.combat_only;
			melee_only = true; //Used to distinguish melee weapons from weapons that have a range of 0, for providing specific buffs or debuffs for chars that are strong or weak with melee weapons.
		}
        else if item_enum == item_type.police_truncheon {
            dmg_min = 3;
            dmg_max = 4;
            requires_ammo_boolean = false;
            item_name = "POLICE TRUNCHEON";
            item_equip_enum = item_equip_type.one_hand;
            item_verb = "swings the";
            item_dmg_str = "blundgeoned";
            max_range = 0;
            stun_chance = 25;
			use_context = abil_use_context.combat_only;
			melee_only = true; //Used to distinguish melee weapons from weapons that have a range of 0, for providing specific buffs or debuffs for chars that are strong or weak with melee weapons.
		}
        else if item_enum == item_type.stun_baton { //Has a 100% chance of stunning enemies, minus their electric_res
            dmg_min = 1;
            dmg_max = 2;
            requires_ammo_boolean = false;
            item_name = "STUN BATON";
            item_equip_enum = item_equip_type.one_hand;
            item_verb = "thrusts the";
            item_dmg_str = "zapped";
            max_range = 0;
            stun_chance = 100;
            always_checks_status_effect_boolean = false;
			use_context = abil_use_context.combat_only;
			melee_only = true; //Used to distinguish melee weapons from weapons that have a range of 0, for providing specific buffs or debuffs for chars that are strong or weak with melee weapons.
		}
        else if item_enum == item_type.fire_axe {
            dmg_min = 2;
            dmg_max = 5;
            requires_ammo_boolean = false;
            item_name = "FIRE AXE";
            item_equip_enum = item_equip_type.one_hand;
            item_verb = "swings the";
            item_dmg_str = "mauled";
            max_range = 0;
            bleed_chance = 25;
			use_context = abil_use_context.combat_only;
			melee_only = true; //Used to distinguish melee weapons from weapons that have a range of 0, for providing specific buffs or debuffs for chars that are strong or weak with melee weapons.
		}
        else if item_enum == item_type.crude_buzzsaw {
            dmg_min = 5;
            dmg_max = 8;
            requires_ammo_boolean = false;
            item_name = "CRUDE BUZZSAW";
            item_equip_enum = item_equip_type.two_hands;
            item_verb = "spins the";
            item_dmg_str = "eviscerated";
            max_range = 0;
            bleed_chance = 75;
			use_context = abil_use_context.combat_only;
			melee_only = true; //Used to distinguish melee weapons from weapons that have a range of 0, for providing specific buffs or debuffs for chars that are strong or weak with melee weapons.
		}
        else if item_enum == item_type.taser { //High stun chance, extra damage to characters with weak electric_res
            dmg_min = 1
            dmg_max = 1
            requires_ammo_boolean = false
            item_name = "TASER"
            item_equip_enum = item_equip_type.one_hand;
            item_verb = "fires the"
            item_dmg_str = "zapped"
            max_range = 1
            stun_chance = 100
            always_checks_status_effect_boolean = false;
            ability_point_cost = 2
            ability_cost_str = $"Spend {ability_point_cost} AP"
            requires_ammo_boolean = false
			use_context = abil_use_context.combat_only;
		}
        else if item_enum == item_type.assault_rifle {
            dmg_min = 4;
            dmg_max = 6;
            item_name = "ASSAULT RIFLE";
            item_equip_enum = item_equip_type.two_hands;
            max_range = 3;
            item_verb = "fires the";
            item_dmg_str = "shot";
            can_overwatch_boolean = true;
            bleed_chance = 25;
            can_overwatch_boolean = true;
			aoe_count = 2;
			use_context = abil_use_context.combat_only;
		}
        else if item_enum == item_type.light_mg { //Light sentry gun weapon.
            dmg_min = 3;
            dmg_max = 6;
            item_name = "MACHINE GUN";
            item_equip_enum = item_equip_type.two_hands;
            max_range = 3; //3;
            item_verb = "fires the";
            item_dmg_str = "shot";
            can_overwatch_boolean = true;
            bleed_chance = 25;
            suppress_chance = 33;
			aoe_count = 1;
			use_context = abil_use_context.combat_only;
		}
        else if item_enum == item_type.spine_projectile {
            dmg_min = 3;
            dmg_max = 6;
            item_name = "BARBED SPINE";
            item_equip_enum = item_equip_type.one_hand;
            max_range = 3; //3;
            item_verb = "fires from its mouth a";
            item_dmg_str = "shot";
            bleed_chance = 25;
            infection_chance = 10;
            poison_chance = 25;
			use_context = abil_use_context.combat_only;
		}
        else if item_enum == item_type.acid_spit {
            dmg_min = 4;  
            dmg_max = 8;
            item_name = "ACID BILE";
            item_equip_enum = item_equip_type.one_hand;
            max_range = 2;
            item_verb = "spits with";
            item_dmg_str = "melted";
            aoe_count = 3;
            can_overwatch_boolean = true;
            poison_chance = 400; //75; 
            infection_chance = 10;
            always_checks_status_effect_boolean = false;
			dmg_type_enum = item_dmg_type.damage_only;
			use_context = abil_use_context.combat_only;
		}
		else if item_enum == item_type.regurgitated_vomit {
            dmg_min = 2; //2;
            dmg_max = 4; //4;
            item_name = "UNDIGESTED VOMIT";
            item_equip_enum = item_equip_type.one_hand;
            max_range = 2;
            item_verb = "sprays";
            item_dmg_str = "disgusted";
            aoe_count = 2;
            can_overwatch_boolean = true;
            always_checks_status_effect_boolean = false;
			dmg_type_enum = item_dmg_type.morale_only;
			use_context = abil_use_context.combat_only;
		}
        else if item_enum == item_type.acid_cloud {
            dmg_min = 2;
            dmg_max = 4;
            item_name = "ACID CLOUD";
            item_equip_enum = item_equip_type.one_hand;
            max_range = 2;
            item_verb = "belches a massive";
            item_dmg_str = "melted";
            aoe_count = -1;
            poison_chance = 75;
            bleed_chance = 25;
            infection_chance = 10;
            always_checks_status_effect_boolean = true;
			use_context = abil_use_context.combat_only;
		}
        else if item_enum == item_type.sticky_slime {
            dmg_min = 0;
            dmg_max = 1;
            item_name = "STICKY SLIME";
            item_equip_enum = item_equip_type.one_hand;
            max_range = 5;
            item_verb = "sprays";
            item_dmg_str = "melted";
            aoe_count = -1;
            suppress_chance = 75;
            always_checks_status_effect_boolean = true;
            infection_chance = 10;
			use_context = abil_use_context.combat_only;
		}
        else if item_enum == item_type.filament_spray {
            dmg_min = 0;
            dmg_max = 1;
            item_name = "CAUSTIC FILAMENTS";
            item_equip_enum = item_equip_type.one_hand;
            max_range = 5;
            item_verb = "spits a web of";
            item_dmg_str = "melted";
            aoe_count = -1;
            infection_chance = 10;
            poison_chance = 10;
            stun_chance = 20;
            always_checks_status_effect_boolean = true;
			dmg_type_enum = item_dmg_type.both;
			use_context = abil_use_context.combat_only;
		}
		else if item_enum == item_type.terrifying_wail {
            dmg_min = 1;//1;
            dmg_max = 3; //3;
            item_name = "TERRIFYING WAIL";
            item_equip_enum = item_equip_type.one_hand;
            max_range = 4; //3
            item_verb = "screams with a";
            item_dmg_str = "stressed";
            aoe_count = -1;
			dmg_type_enum = item_dmg_type.morale_only;
			use_context = abil_use_context.combat_only;
		}
        else if item_enum == item_type.toxic_grenade_launcher {
            dmg_min = 1;
            dmg_max = 4;
            item_name = "TOXIC G.L.";
            item_equip_enum = item_equip_type.two_hands;
            max_range = 4; //Debug value
            item_verb = "fires the";
            item_dmg_str = "burned";
            aoe_count = -1;
            poison_chance = 75;
            always_checks_status_effect_boolean = true;
			use_context = abil_use_context.combat_only;
		}
        else if item_enum == item_type.frag_grenade_launcher {
            dmg_min = 5;
            dmg_max = 10;
            item_name = "FRAGMENTAION G.L.";
            item_equip_enum = item_equip_type.two_hands;
            max_range = 5; //Debug value
            item_verb = "fires the";
            item_dmg_str = "shredded";
            aoe_count = 4;
            burn_chance = 25;
            always_checks_status_effect_boolean = false;
			use_context = abil_use_context.combat_only;
		}
        else if item_enum == item_type.concussion_grenade_launcher {
            dmg_min = 0;
            dmg_max = 1;
            item_name = "CONCUSSION G.L.";
            item_equip_enum = item_equip_type.two_hands;
            max_range = 4;
            item_verb = "fires the";
            item_dmg_str = "concussed";
            aoe_count = -1;
            stun_chance = 75; //75;
            suppress_chance = 75; //75;
            always_checks_status_effect_boolean = true;
			use_context = abil_use_context.combat_only;
		}
        
        else if item_enum == item_type.sub_machine_gun {
            dmg_min = 3;
            dmg_max = 5;
            item_name = "SUB MACHINE GUN";
            item_equip_enum = item_equip_type.two_hands;
            max_range = 3;
            item_verb = "fires the";
            item_dmg_str = "shot";
            can_overwatch_boolean = true;
            aoe_count = 4;
            bleed_chance = 25;
            suppress_chance = 50;
			use_context = abil_use_context.combat_only;
		}
        else if item_enum == item_type.machine_pistol {
            dmg_min = 2;
            dmg_max = 4;
            item_name = "MACHINE PISTOL";
            item_equip_enum = item_equip_type.one_hand;
            max_range = 2; //2;
            item_verb = "fires the";
            item_dmg_str = "shot";
            can_overwatch_boolean = true;
            aoe_count = 3;
            bleed_chance = 25;
            suppress_chance = 25;
			use_context = abil_use_context.combat_only;
		}
        else if item_enum == item_type.sniper_rifle {
            dmg_min = 8;
            dmg_max = 10;
            melee_debuff_boolean = true;
            item_name = "SNIPER RIFLE";
            item_equip_enum = item_equip_type.two_hands;
            max_range = 5;
            item_verb = "fires the";
            item_dmg_str = "shot";
            can_overwatch_boolean = true;
            bleed_chance = 50;
			use_context = abil_use_context.combat_only;
		}
        else if item_enum == item_type.pulse_rifle {
            dmg_min = 6;
            dmg_max = 9;
            requires_ammo_boolean = false;
            melee_debuff_boolean = true;
            item_name = "PULSE RIFLE";
            item_equip_enum = item_equip_type.two_hands;
            max_range = 4;
            item_verb = "fires the";
            item_dmg_str = "burned";
            can_overwatch_boolean = true;
            burn_chance = 25;
			use_context = abil_use_context.combat_only;
		}
       
		else if item_enum == item_type.anti_anxiety_meds {  // Doctor ability
            dmg_min = 0;
            dmg_max = 0;
            item_name = "ANTI-ANXIETY TABLETS";
            max_range = 0;
            ability_point_cost = 3;
            ability_cost_str = $"Spend {ability_point_cost} AP and pass your turn: target player character heals {ANTI_ANXIETY_SANITY_BUFF} sanity points.";
            non_attack_ability_boolean = true;
            abil_passes_turn_boolean = true;
            requires_ammo_boolean = false;
			use_context = abil_use_context.both;
			use_requires_target = true;
		}
        else if item_enum == item_type.regen_nanites {
            single_use_boolean = true;
            usable_boolean = true;
            item_name = "PEN OF REGENERATION NANITES";
            equippable_boolean = false;
			use_context = abil_use_context.both;
			use_requires_target = true;
			requires_ammo_boolean = false;
		}
		else if item_enum == item_type.adrenal_pen {
            single_use_boolean = true;
            usable_boolean = true;
            item_name = "ADRENAL PEN";
            equippable_boolean = false;
			use_context = abil_use_context.both;
			use_requires_target = true;
			requires_ammo_boolean = false;
		}
        else if item_enum == item_type.kiras_noisy_game {
            single_use_boolean = false
            usable_boolean = true
            item_name = "KIRA'S NOISY GAME"
            equippable_boolean = false
			use_context = abil_use_context.main_game_only;
		}
        else if item_enum == item_type.suit_environmental {
            item_name = "HAZMAT SUIT";
            item_equip_enum = item_equip_type.body;
            stat_boost_list[stat_boost.evasion] = -1;
            stat_boost_list[stat_boost.armor] = 1;
            stat_boost_list[stat_boost.fire_res] = 50;
            stat_boost_list[stat_boost.electric_res] = 50;
            stat_boost_list[stat_boost.gas_res] = 100;
			use_context = abil_use_context.main_game_only;
		}
        else if item_enum == item_type.suit_prisoner_jumpsuit {
            item_name = "PRISONER JUMPSUIT";
            stat_boost_list[stat_boost.evasion] = 1;
            item_equip_enum = item_equip_type.body;
			use_context = abil_use_context.main_game_only;
		}
        else if item_enum == item_type.suit_engineer_garb {
            item_name = "ENGINEER GARB";
            item_equip_enum = item_equip_type.body;
            stat_boost_list[stat_boost.evasion] = 1;
			use_context = abil_use_context.main_game_only;
		}
        else if item_enum == item_type.suit_scientist_labcoat {
            item_name = "SCIENTIST LABCOAT";
            item_equip_enum = item_equip_type.body;
            stat_boost_list[stat_boost.evasion] = 1;
			use_context = abil_use_context.main_game_only;
		}
        else if item_enum == item_type.suit_medical_scrubs {
            item_name = "MEDICAL SCRUBS";
            item_equip_enum = item_equip_type.body;
            stat_boost_list[stat_boost.evasion] = 1;
			use_context = abil_use_context.main_game_only;
		}
        else if item_enum == item_type.suit_officer_jumpsuit {
            item_name = "OFFICER JUMPSUIT";
            item_equip_enum = item_equip_type.body;
            stat_boost_list[stat_boost.evasion] = 1;
			use_context = abil_use_context.main_game_only;
		}
        else if item_enum == item_type.suit_civilian_jumpsuit {
            item_name = "CIVILIAN JUMPSUIT";
            item_equip_enum = item_equip_type.body;
            stat_boost_list[stat_boost.evasion] = 1;
			use_context = abil_use_context.main_game_only;
		}
        else if item_enum == item_type.suit_flak_armor {
            item_name = "FLAK ARMOR";
            item_equip_enum = item_equip_type.body;
            stat_boost_list[stat_boost.armor] = 2;
            stat_boost_list[stat_boost.evasion] = 0;
			stat_boost_list[stat_boost.spd] = -3;
			use_context = abil_use_context.main_game_only;
		}
        else if item_enum == item_type.suit_security_vest {
            item_name = "SECURITY VEST";
            item_equip_enum = item_equip_type.body;
            stat_boost_list[stat_boost.armor] = 1;
            stat_boost_list[stat_boost.evasion] = 1;
			use_context = abil_use_context.main_game_only;
		}
        else if item_enum == item_type.suit_marine {
            item_name = "MARINE ARMOR";
            item_equip_enum = item_equip_type.body;
            stat_boost_list[stat_boost.armor] = 4;
            stat_boost_list[stat_boost.electric_res] = 100;
            stat_boost_list[stat_boost.evasion] = -2;
            stat_boost_list[stat_boost.vacuum_res] = 50;
            stat_boost_list[stat_boost.gas_res] = 100;
            stat_boost_list[stat_boost.fire_res] = 100;
			stat_boost_list[stat_boost.spd] = -6;
			use_context = abil_use_context.main_game_only;
		}
        else if item_enum == item_type.dna_tester {
            single_use_boolean = false;
            usable_boolean = true;
            item_name = "DNA ANALYZER";
            equippable_boolean = false;
			use_context = abil_use_context.main_game_only;
		}
        else if item_enum == item_type.access_targeting_hud {
            item_name = "TACTICAL MONOCLE";
            item_equip_enum = item_equip_type.accessory;
            stat_boost_list[stat_boost.accuracy] = 1;
			use_context = abil_use_context.main_game_only;
		}
        else if item_enum == item_type.shield_riot {
            item_name = "RIOT SHIELD";
            item_equip_enum = item_equip_type.one_hand;
            stat_boost_list[stat_boost.armor] = 1;
            stat_boost_list[stat_boost.evasion] = 1;
            is_shield_boolean = true;
			use_context = abil_use_context.main_game_only;
		}
        else if item_enum == item_type.shield_flak {
            item_name = "FLAK SHIELD";
            item_equip_enum = item_equip_type.one_hand;
            stat_boost_list[stat_boost.armor] = 2;
            stat_boost_list[stat_boost.evasion] = 2;
			stat_boost_list[stat_boost.spd] = -1;
            is_shield_boolean = true;
			use_context = abil_use_context.main_game_only;
		}
        else if item_enum == item_type.shield_phase {
            item_name = "PHASE SHIELD";
            item_equip_enum = item_equip_type.one_hand;
            stat_boost_list[stat_boost.armor] = 3;
            stat_boost_list[stat_boost.evasion] = 4;
            is_shield_boolean = true;
			use_context = abil_use_context.main_game_only;
		}
        else if item_enum == item_type.fists_adult {
            dmg_min = 1;
            dmg_max = 2;
            requires_ammo_boolean = false;
            item_name = "FIST";
            item_equip_enum = item_equip_type.one_hand;
            item_verb = "punches with their";
            item_dmg_str = "battered";
            max_range = 0;
			melee_only = true; //Used to distinguish melee weapons from weapons that have a range of 0, for providing specific buffs or debuffs for chars that are strong or weak with melee weapons.
			use_context = abil_use_context.combat_only;
		}
        else if item_enum == item_type.fists_child {
            dmg_min = 0;
            dmg_max = 1;
            requires_ammo_boolean = false;
            item_name = "CHILD FIST";
            item_equip_enum = item_equip_type.one_hand;
            item_verb = "punches with their";
            item_dmg_str = "battered";
            max_range = 0;
			melee_only = true; //Used to distinguish melee weapons from weapons that have a range of 0, for providing specific buffs or debuffs for chars that are strong or weak with melee weapons.
			use_context = abil_use_context.combat_only;
		}
        else if item_enum == item_type.fists_giant {
            dmg_min = 2;
            dmg_max = 4;
            requires_ammo_boolean = false;
            item_name = "GIANT FIST";
            item_equip_enum = item_equip_type.one_hand;
            item_verb = "punches with their";
            item_dmg_str = "battered";
            max_range = 0;
            stun_chance = 25;
			melee_only = true; //Used to distinguish melee weapons from weapons that have a range of 0, for providing specific buffs or debuffs for chars that are strong or weak with melee weapons.
			use_context = abil_use_context.combat_only;
		}

        // endregion

        //Build this item's 'status_effect_list'; is this even in use?
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
	
	global.Room = function(location_type_enum, room_type_enum, spawn_grid_x, spawn_grid_y, location_grid_id) constructor
	{
		struct_type_enum = struct_type.Room;
		
		scavenge_ar = -1; //Is used as an array; filled with loot_drop structs
		
		hazard_generator_ar = -1;
		
		this_room_already_spread_fire = false;
		this_room_already_spread_gas = false;
		
		room_hide_difficulty_val = AVG_HIDE_DIFFICULTY_VAL;
		
		powered_boolean = false;
		
		override_door_defaults = false; //if true, then the door structs, and the direction they face, will be customized by a script.
		
		override_enemy_mob_defaults = false; //if true, then the base amount and composition of enemies in this room will be customized by a script.
		
		override_loot_in_room_defaults = false; //if true, then the base amount and composition of loot in this room will be customized by a script.
		
		cover_enum = cover_val.none; //May not even implement this; provides a static buff or debuff to pcs during combat, making some rooms more suitable as defensive choke points.
		
		pre_event_unpowered_room_desc = "undefined";
		pre_event_powered_room_desc = "undefined";
		post_event_unpowered_room_desc = "undefined";
		post_event_powered_room_desc = "undefined";
		
		scavenged_once_boolean = false; //When == true, we always show the items in this room.
		already_explored_boolean = false; //Determines whether or not we show the name and any enemies in that room when within the CHOOSE_DOOR_DIRECTION game state; if true, we do show all that.
		
		keyword_interaction_str_ar = -1 //Is used as an array
		
		directional_ar = []; //Array containing structs
		//Default is defined to open space - vacuum //(door_enum_, door_hp_, door_jam_diff_val_) constructor { }
		repeat(4) {
			array_push(directional_ar, new global.door_struct(door_state.open_space, -1, AVG_DOOR_JAM_VAL) );
		}
		
		setup_dir_ar = [];
		
		enemies_in_room_ar = -1;
		pcs_in_room_ar = -1
		neutrals_in_room_ar = -1;
		
		grid_x = spawn_grid_x;
		grid_y = spawn_grid_y
		
		room_enum = room_type_enum;
		location_enum = location_type_enum;
		location_grid = location_grid_id
		
		room_name_str = "undefined"
		
		main_room_event_already_triggered = false;
		
		explored_boolean = false;
		doors_already_added_boolean = false;
		
		hazard_ar = -1; //If hazards are present, functions as a array with enum values representing hazard types
		
        if location_type_enum == location.research_vessel {
			
			if room_enum == research_vessel_room.basic_corridor_ew {
				
				scavenge_ar = [];
				//(loot_drop_type_enum_, item_enum_, resource_quantity_)
				array_push(scavenge_ar, new global.loot_drop_struct(loot_drop_type.resource_scrap, -1, irandom_range(0,3)) );
				
				pre_event_unpowered_room_desc = "This basic corridor only serves as a connection between two areas on the ship. The floor is metal grating and the walls are dirty panels of burnished steel. A few piles of refuse lay scattered about, evidence of the station's disarray."
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_powered_room_desc = pre_event_powered_room_desc;
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_W].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_E].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_N].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_WALL_HP;
				
				room_name_str = "EAST-WEST CORRIDOR";	
			}
			
			else if room_enum == research_vessel_room.basic_corridor_ns {
				
				scavenge_ar = [];
				//(loot_drop_type_enum_, item_enum_, resource_quantity_)
				array_push(scavenge_ar, new global.loot_drop_struct(loot_drop_type.resource_scrap, -1, irandom_range(0,3)) );
				
				pre_event_unpowered_room_desc = "This basic corridor only serves as a connection between two areas on the ship. The floor is metal grating and the walls are dirty panels of burnished steel. A few piles of refuse lay scattered about, evidence of the station's disarray."
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
		
				directional_ar[DOOR_DIR_W].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_W].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_E].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_N].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_DOOR_HP;
				
				room_name_str = "NORTH-SOUTH CORRIDOR";
			}
			
			else if room_enum == research_vessel_room.storage_room {
				
				scavenge_ar = [];
				//(loot_drop_type_enum_, item_enum_, resource_quantity_)
				array_push(scavenge_ar, new global.loot_drop_struct(loot_drop_type.resource_scrap, -1, irandom_range(0,3)) );
				array_push(scavenge_ar, new global.loot_drop_struct(loot_drop_type.resource_tech_advanced, -1, irandom_range(0,3)) );
				array_push(scavenge_ar, new global.loot_drop_struct(loot_drop_type.resource_tech_basic, -1, irandom_range(0,3)) );
				
				pre_event_unpowered_room_desc = "Racks of mostly empty shelving and opened boxes indicate that this room was once used for storage. Dust and debris are mostly all that remain. It looks as though the most important items have been pilfered already.\n\nThe whirling red flare of the emergency lights overhead sends strange shadows pin-wheeling across the walls.";
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
				
				room_name_str = "STORAGE ROOM"
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_W].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_E].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_N].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_DOOR_HP;
			}
			
			else if room_enum == research_vessel_room.hydroponics_lab {
				
				scavenge_ar = [];
				//(loot_drop_type_enum_, item_enum_, resource_quantity_)
				array_push(scavenge_ar, new global.loot_drop_struct(loot_drop_type.resource_food, -1, irandom_range(12,16)) );
				
				pre_event_unpowered_room_desc = "Rows and rows of metal grow boxes line the room, their contents nothing more than withered weeds to clutching to dry, gray dirt. There's a nest of hydraulics and hoses in the walls, and huge sunlamps are recessed in the ceiling, now dark and inert.\n\nIf you can restore power to this room, perhaps there's a way to get these hydroponics working again?"
				pre_event_powered_room_desc = "The rows of hydroponics buzz happily with spray from the moisture pumps, while the leafy green vegetables within eagerly drink the light from the sunlamps overhead.\n\nThese crops of potatoes, beans, and cabbages have clearly been genetically modified to grow quickly."
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
				
				room_name_str = "HYDROPONICS LAB"
		
				directional_ar[DOOR_DIR_W].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_W].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_E].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_N].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_WALL_HP;
			}
			
			else if room_enum == research_vessel_room.stasis_chamber {
				
				//Hazard ar:
					//hazard_ar = [];
					//array_push(hazard_ar,hazard_type.toxic_gas);
				
				//debug:
				//hazard_generator_ar = [];
				//array_push(hazard_generator_ar, hazard_generator_types.vacuum);
				
				scavenge_ar = [];
				//(loot_drop_type_enum_, item_enum_, resource_quantity_)
				array_push(scavenge_ar, new global.loot_drop_struct(loot_drop_type.resource_food, -1, 12) );
				array_push(scavenge_ar, new global.loot_drop_struct(loot_drop_type.resource_ammo, -1, 55) );
				array_push(scavenge_ar, new global.loot_drop_struct(loot_drop_type.resource_tech_basic, -1, 4) );
				array_push(scavenge_ar, new global.loot_drop_struct(loot_drop_type.resource_scrap, -1, 12) );
				//Items
				array_push(scavenge_ar, new global.loot_drop_struct(loot_drop_type.item_enum, item_type.suit_environmental, -1) );
				array_push(scavenge_ar, new global.loot_drop_struct(loot_drop_type.item_enum, item_type.medkit, -1) );
				array_push(scavenge_ar, new global.loot_drop_struct(loot_drop_type.item_enum, item_type.lead_pipe, -1) );

                room_name_str = "STASIS ROOM";
				
				pre_event_unpowered_room_desc = [
					"Klaxons blare, and an eerie red illumination seeps from the emergency lights in the floor. Rows of stasis pods have been arranged in this room, most of them damaged or inoperable. Those corpses who had sought refuge within them have met a truly ignoble end, asphyxiated in their sleep. You were one of the lucky few who managed to fight off hibernation and awaken--though only time will tell if your ultimate fate will be any different from their own. There's only one empty STASIS POD that still looks operational and inviting, gleaming pearl-white in the blood-hued gloom.\n",
                    "\nThe room itself has been badly damaged. Refuse and debris lay scattered about, along with piles of personal effects: whatever non-essential items the sleepers had hastily stripped from their bodies before clamboring inside the statis pods to seal their doom.\n",
                    "\nHull stresses and fractures have fissured the walls and ceiling, exposing pipes and electrical wires. One particularly damaged PIPE is rapidly venting a noxious white gas, caustic enough to make you sputter and gag. A nearby exposed service panel reveals two huge circular valves: a BRONZE VALVE and a STEEL VALVE.\n"
				];
				
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_E].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_W].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_N].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_WALL_HP;
			}
			
			else if room_enum == research_vessel_room.sc_corridor_west {
				
				//Debug:
					//Hazard ar:
				//hazard_ar = [];
				//array_push(hazard_ar,hazard_type.toxic_gas);
				//array_push(hazard_ar,hazard_type.electric_current);
				//array_push(hazard_ar,hazard_type.vacuum);
				//array_push(hazard_ar,hazard_type.fire);
				
				//debug:
				//hazard_generator_ar = [];
				//array_push(hazard_generator_ar, hazard_generator_types.vacuum);
				
				scavenge_ar = [];
				array_push(scavenge_ar, new global.loot_drop_struct(loot_drop_type.resource_scrap, -1, 4) );
				
				room_name_str = "EAST-WEST CORRIDOR";
	
				directional_ar[DOOR_DIR_E].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_E].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_W].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_N].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_WALL_HP;
				
				keyword_interaction_map = ds_map_create();
				ds_map_add(keyword_interaction_map,"CORPSE",keyword_event.research_vessel_hall_east_of_sr);
			
                pre_event_unpowered_room_desc = [
                    "The air smells foul and stuffy in this narrow corridor, and is suffused with the dim glow of the sanguine emergency lighting. The floor is metal grating and the walls burnished steel.\n",
                    "\nA shadowed and inert form is slumped against the western bulkhead door, as if in peaceful repose. Upon closer inspection, you can see that the man is one of the security forces on board, if his military fatigues and body armor are any indication. You can also see that he is very dead: his eyes stare lifelessly at the jagged hole just beneath his flak vest, admiring the heap of coiled intestines that lay piled between his legs.\n",
                    "\nIf your eyes aren't mistaken in the gloomy light, there's an eerily luminescent, green slime clinging to the edges of the gaping wound, and more of it dribbling from the dead man's mouth. The CORPSE is also clutching a pistol in a death grip. Judging by the bloody hole in the side of his head, it looks as though his last act was to use the weapon on himself.\n",
                    "\nThe self-inflicted head wound, combined with the abyss where the man's stomach used to be, has certainly given you pause. Nonetheless, the CORPSE is carrying some useful looking gear, and there could be more in the pockets of his tactical vest. Is it wise to take a closer look?\n"
                ]
				
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = [
                    "The air smells foul and stuffy in this narrow corridor, and is suffused with the same ominous dim red light. The floor is metal grating and the walls are made up of panels of burnished steel.\n",
                    "\nThe corpse still slumped beside the western bulkhead door serves as a grim reminder of the consequence of carelessness."
                ]
				
				post_event_powered_room_desc = post_event_unpowered_room_desc;
				
			}
			
			else if room_enum == research_vessel_room.sc_corridor_east {
				
				room_name_str = "EAST-WEST CORRIDOR";
				
				//debug:
				//hazard_generator_ar = [];
				//array_push(hazard_generator_ar, hazard_generator_types.vacuum);
				
				scavenge_ar = [];
				array_push(scavenge_ar, new global.loot_drop_struct(loot_drop_type.resource_scrap, -1, 4) );
		
				directional_ar[DOOR_DIR_E].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_E].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_W].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_N].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_WALL_HP;
				
				pre_event_unpowered_room_desc = "This is the room with the friendly scientist in it.";
				pre_event_powered_room_desc = "This is the room with the friendly scientist in it.";
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
			}
			
			else if room_enum == research_vessel_room.supply_closet {
				
				room_name_str = "SUPPLY ROOM";
				
				scavenge_ar = [];
				array_push(scavenge_ar, new global.loot_drop_struct(loot_drop_type.resource_scrap, -1, 4) );
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_E].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_W].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_N].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_WALL_HP;
				
				pre_event_unpowered_room_desc = "The door to this room opens upon a narrow chamber with a second story catwalk, but the red emergency lighting recessed within the floor does little to illuminate your surroundings beyond your next step.\n\nThere are rows of narrow locked cabinets receded within the walls, but in the sanguine gloom you can't make out the labeling that identifies them. The banks of computer monitors beside each locker no longer grant access to the contents within; the consoles are utterly dead.\n";
				pre_event_powered_room_desc = "Beneath the white wash of the flood lamps from the ceiling, you can finally pick your way through the contents of this room. The computer consoles beside each locker are alive with chittering and scrolling green text. It is an easy thing to navigate their file structures, and the corresponding lockers pop open with a hiss after just a few key strokes.";
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
			}
			
			else if room_enum == research_vessel_room.bridge {
				
				room_name_str = "BRIDGE";
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_E].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_W].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_N].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_DOOR_HP;
				
				
				pre_event_unpowered_room_desc = "You breath a sigh of relief upon realizing that you have at last discovered the central processing unit of this ship: the bridge. The cushioned chairs, the banks of computer monitors, and the raised, rotating gyroscope supporting the pilot's seat all leave little doubt in your mind that you have finally found the command station of this vessel.\n\nThe room is still without power, however. Stumbling through the bloodied gloom, you collapse within the cushioned embrace of an officer's chair, to find your own wearied expression staring back at you from one of the dead facades of a computer monitor. Until the power is restored, you won't be able to accomplish anything here.";
				pre_event_powered_room_desc = "You breath a sigh of relief upon realizing that you have at last discovered the central processing unit of this ship: the bridge. The cushioned chairs, the banks of computer monitors, and the raised, rotating gyroscope supporting the pilot's seat all leave little doubt in your mind that you have finally found the command station of this vessel.\n\nThere are more than a dozen blinking interfaces that whir to life as you pass by, and it looks like their security systems have already been disabled. You sit surrounded by blinking screens that display propulsion, nagivation, communications, sub-systems and more. You could OPERATE any one of them with little trouble.";
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
			}
			
			else if room_enum == research_vessel_room.barracks {
				
				room_name_str = "BARRACKS";
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_E].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_W].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_N].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_DOOR_HP;
				
				pre_event_unpowered_room_desc = "This room is long and wide, with mess tables welded to the floor along its central line. It looks like shaded screens conceal military bunks in the walls.\n\nBeyond that, it's difficult to make out much in the gloom--although your eyes are quick tp imagine leaping and contorted forms cast by the shadows of the whirling gaze of the emergency lights."
				pre_event_powered_room_desc = "This room is long and wide, with mess tables welded to the floor along its central line. It looks like shaded screens conceal military bunks in the walls.\n\nWith the power restored, you can make out the lockers inlaid within the walls beside each bunk. It looks like their security consoles have been disabled: the cabinets open easily."

				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
			}
			
			else if room_enum == research_vessel_room.airlock_e_w_n_s {
				
				room_name_str = "MATERIAL AIRLOCK";
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_E].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_W].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_N].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_DOOR_HP;
				
				pre_event_unpowered_room_desc = "This large logistics center once clearly functioned as a material airlock for the station--although some considered havoc has occurred here since then. Material scaffolding has been smashed and toppled, while storage crates and transport machinery have been splattered by blood and a disconcerting black ichor. There are armor plated, shuttle bay doors on three sides of the room, large enough to accomodate small to medium sized ships.\n\nA yawning darkness stretches overhead, from which you imagine an ominous chittering, and darker, scurrying shadows.";
				pre_event_powered_room_desc = "This large logistics center once clearly functioned as a material airlock for the station--although some considered havoc has occurred here since then. Material scaffolding has been smashed and toppled, while storage crates and transport machinery have been splattered by blood and a disconcerting black ichor. There are armor plated, shuttle bay doors on three sides of the room, large enough to accomodate small to medium sized ships.\n\nWith the power restored, you can easily access the computer terminals that control the shuttle bay doors. It looks as though their safety protocols have been deliberately destroyed.";
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
			}
			
			else if room_enum == research_vessel_room.airlock_e_w {
				
				room_name_str = "MATERIAL AIRLOCK";
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_E].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_W].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_N].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_WALL_HP;
				
				pre_event_unpowered_room_desc = "This large logistics center once clearly functioned as a material airlock for the station--although some considered havoc has occurred here since then. Material scaffolding has been smashed and toppled, while storage crates and transport machinery have been splattered by blood and a disconcerting black ichor. There are armor plated, shuttle bay doors on three sides of the room, large enough to accomodate small to medium sized ships.\n\nA yawning darkness stretches overhead, from which you imagine an ominous chittering, and darker, scurrying shadows.";
				pre_event_powered_room_desc = "This large logistics center once clearly functioned as a material airlock for the station--although some considered havoc has occurred here since then. Material scaffolding has been smashed and toppled, while storage crates and transport machinery have been splattered by blood and a disconcerting black ichor. There are armor plated, shuttle bay doors on three sides of the room, large enough to accomodate small to medium sized ships.\n\nWith the power restored, you can easily access the computer terminals that control the shuttle bay doors. It looks as though their safety protocols have been deliberately destroyed.";
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
			} 
			
			else if room_enum == research_vessel_room.airlock_n_s {
				
				room_name_str = "MATERIAL AIRLOCK";
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_E].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_W].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_N].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_DOOR_HP;
				
				pre_event_unpowered_room_desc = "This large logistics center once clearly functioned as a material airlock for the station--although some considered havoc has occurred here since then. Material scaffolding has been smashed and toppled, while storage crates and transport machinery have been splattered by blood and a disconcerting black ichor. There are armor plated, shuttle bay doors on three sides of the room, large enough to accomodate small to medium sized ships.\n\nA yawning darkness stretches overhead, from which you imagine an ominous chittering, and darker, scurrying shadows.";
				pre_event_powered_room_desc = "This large logistics center once clearly functioned as a material airlock for the station--although some considered havoc has occurred here since then. Material scaffolding has been smashed and toppled, while storage crates and transport machinery have been splattered by blood and a disconcerting black ichor. There are armor plated, shuttle bay doors on three sides of the room, large enough to accomodate small to medium sized ships.\n\nWith the power restored, you can easily access the computer terminals that control the shuttle bay doors. It looks as though their safety protocols have been deliberately destroyed.";
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
			} 
			
			else if room_enum == research_vessel_room.airlock_n_s_e {
				
				room_name_str = "MATERIAL AIRLOCK";
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_E].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_W].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_N].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_DOOR_HP;
				
				pre_event_unpowered_room_desc = "This large logistics center once clearly functioned as a material airlock for the station--although some considered havoc has occurred here since then. Material scaffolding has been smashed and toppled, while storage crates and transport machinery have been splattered by blood and a disconcerting black ichor. There are armor plated, shuttle bay doors on three sides of the room, large enough to accomodate small to medium sized ships.\n\nA yawning darkness stretches overhead, from which you imagine an ominous chittering, and darker, scurrying shadows.";
				pre_event_powered_room_desc = "This large logistics center once clearly functioned as a material airlock for the station--although some considered havoc has occurred here since then. Material scaffolding has been smashed and toppled, while storage crates and transport machinery have been splattered by blood and a disconcerting black ichor. There are armor plated, shuttle bay doors on three sides of the room, large enough to accomodate small to medium sized ships.\n\nWith the power restored, you can easily access the computer terminals that control the shuttle bay doors. It looks as though their safety protocols have been deliberately destroyed.";
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
			}
			
			else if room_enum == research_vessel_room.officers_quarters {
				
				room_name_str = "OFFICER'S QUARTERS"; //We find some lore here, perhaps? Can spend action points to regain sanity here, perhaps?
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_E].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_W].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_N].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_WALL_HP;
				
				pre_event_unpowered_room_desc = "Officer's Quarters.";
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
			}
			
			else if room_enum == research_vessel_room.engineer_bay {
				
				room_name_str = "ENGINEERING BAY"; 
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_E].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_W].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_N].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_WALL_HP;
				
				pre_event_unpowered_room_desc = "Engineering Bay.";
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
			}
			
			else if room_enum == research_vessel_room.environmental_control {
				
				room_name_str = "ENVIRONMENTAL CONTROL"; 
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_E].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_W].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_N].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_WALL_HP;
				
				pre_event_unpowered_room_desc = "Environmental Control.";
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
			}
			
			else if room_enum == research_vessel_room.intersection_e_w_n {
				
				scavenge_ar = [];
				array_push(scavenge_ar, new global.loot_drop_struct(loot_drop_type.resource_scrap, -1, 4) );
				
				pre_event_unpowered_room_desc = "This basic corridor only serves as a connection between two areas on the ship. The floor is metal grating and the walls are dirty panels of burnished steel. A few piles of refuse lay scattered about, evidence of the station's disarray."
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
			
				directional_ar[DOOR_DIR_E].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_E].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_W].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_N].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_WALL_HP;
				
				room_name_str = "INTERSECTION";
			}
			
			else if room_enum == research_vessel_room.intersection_e_w_s {
				
				scavenge_ar = [];
				array_push(scavenge_ar, new global.loot_drop_struct(loot_drop_type.resource_scrap, -1, 4) );
				
				pre_event_unpowered_room_desc = "This basic corridor only serves as a connection between two areas on the ship. The floor is metal grating and the walls are dirty panels of burnished steel. A few piles of refuse lay scattered about, evidence of the station's disarray."
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_E].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_W].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_N].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_DOOR_HP;
				
				room_name_str = "INTERSECTION";
			}
			
			else if room_enum == research_vessel_room.intersection_n_s_e {
				
				scavenge_ar = [];
				array_push(scavenge_ar, new global.loot_drop_struct(loot_drop_type.resource_scrap, -1, 4) );
				
				pre_event_unpowered_room_desc = "This basic corridor only serves as a connection between two areas on the ship. The floor is metal grating and the walls are dirty panels of burnished steel. A few piles of refuse lay scattered about, evidence of the station's disarray."
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_E].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_W].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_N].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_DOOR_HP;
				
				room_name_str = "INTERSECTION";
			}
			
			else if room_enum == research_vessel_room.intersection_n_s_w {
				
				scavenge_ar = [];
				array_push(scavenge_ar, new global.loot_drop_struct(loot_drop_type.resource_scrap, -1, 4) );
				
				pre_event_unpowered_room_desc = "This basic corridor only serves as a connection between two areas on the ship. The floor is metal grating and the walls are dirty panels of burnished steel. A few piles of refuse lay scattered about, evidence of the station's disarray."
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_E].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_W].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_N].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_DOOR_HP;
				
				room_name_str = "INTERSECTION";
			}
			
			else if room_enum == research_vessel_room.intersection_s_e {
				
				pre_event_unpowered_room_desc = "This basic corridor only serves as a connection between two areas on the ship. The floor is metal grating and the walls are dirty panels of burnished steel. A few piles of refuse lay scattered about, evidence of the station's disarray."
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
			
				directional_ar[DOOR_DIR_E].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_E].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_W].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_N].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_DOOR_HP;
				
				room_name_str = "INTERSECTION";
			}
			
			else if room_enum == research_vessel_room.intersection_w_s {
				
				pre_event_unpowered_room_desc = "This basic corridor only serves as a connection between two areas on the ship. The floor is metal grating and the walls are dirty panels of burnished steel. A few piles of refuse lay scattered about, evidence of the station's disarray."
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
			
				directional_ar[DOOR_DIR_E].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_E].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_W].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_N].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_DOOR_HP;
				
				room_name_str = "INTERSECTION";
			}
			
			else if room_enum == research_vessel_room.intersection_w_e_s_n {
				
				pre_event_unpowered_room_desc = "This basic corridor only serves as a connection between two areas on the ship. The floor is metal grating and the walls are dirty panels of burnished steel. A few piles of refuse lay scattered about, evidence of the station's disarray."
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_E].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_W].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_N].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_DOOR_HP;
				
				room_name_str = "INTERSECTION";
			}
			
			else if room_enum == research_vessel_room.intersection_n_e {
				
				pre_event_unpowered_room_desc = "This basic corridor only serves as a connection between two areas on the ship. The floor is metal grating and the walls are dirty panels of burnished steel. A few piles of refuse lay scattered about, evidence of the station's disarray."
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_E].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_W].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_N].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_WALL_HP;
				
				room_name_str = "INTERSECTION";
			}
			
			else if room_enum == research_vessel_room.arboretum_e_s {

				pre_event_unpowered_room_desc = "Arboretum"
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_E].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_W].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_N].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_DOOR_HP;
				
				room_name_str = "ARBORETUM";
			}
			
			else if room_enum == research_vessel_room.arboretum_n_s_e_w {

				pre_event_unpowered_room_desc = "Arboretum"
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_E].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_W].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_N].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_DOOR_HP;
				
				room_name_str = "ARBORETUM";
			}
			
			else if room_enum == research_vessel_room.arboretum_w_s {

				pre_event_unpowered_room_desc = "Arboretum"
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_E].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_W].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_N].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_DOOR_HP;
				
				room_name_str = "ARBORETUM";
			}
			
			else if room_enum == research_vessel_room.arboretum_w_s_n {

				pre_event_unpowered_room_desc = "Arboretum"
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_E].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_W].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_N].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_DOOR_HP;
				
				room_name_str = "ARBORETUM";
			}
			
			else if room_enum == research_vessel_room.arboretum_n_s_e {

				pre_event_unpowered_room_desc = "Arboretum"
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
			
				directional_ar[DOOR_DIR_E].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_E].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_W].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_N].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_DOOR_HP;
				
				room_name_str = "ARBORETUM";
			}
			
			else if room_enum == research_vessel_room.arboretum_n_e {

				pre_event_unpowered_room_desc = "Arboretum"
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_E].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_W].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_N].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_WALL_HP;
				
				room_name_str = "ARBORETUM";
			}
			
			else if room_enum == research_vessel_room.arboretum_n_w {

				pre_event_unpowered_room_desc = "Arboretum"
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_E].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_W].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_N].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_WALL_HP;
				
				room_name_str = "ARBORETUM";
			}
			
			else if room_enum == research_vessel_room.commissary {

				pre_event_unpowered_room_desc = "Commissary"
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_E].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_W].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_N].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_DOOR_HP;
				
				room_name_str = "COMMISSARY";
			}
			
			else if room_enum == research_vessel_room.armory {

				pre_event_unpowered_room_desc = "Armory."
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
		
				directional_ar[DOOR_DIR_E].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_E].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_W].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_N].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_WALL_HP;
				
				room_name_str = "ARMORY";
			}
			
			else if room_enum == research_vessel_room.control_room {

				pre_event_unpowered_room_desc = "Control Room."
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_E].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_W].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_N].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_WALL_HP;
				
				room_name_str = "CONTROL ROOM";
			}
			
			else if room_enum == research_vessel_room.medbay {

				pre_event_unpowered_room_desc = "Medical Bay."
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;

				directional_ar[DOOR_DIR_E].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_E].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_W].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_N].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_WALL_HP;
				
				room_name_str = "MEDICAL BAY";
			}
			
			else if room_enum == research_vessel_room.engine_room {
				
				pre_event_unpowered_room_desc = "Engine Room."
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_E].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_W].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_N].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_WALL_HP;
				
				room_name_str = "ENGINE ROOM";
			}
			
			else if room_enum == research_vessel_room.shuttle_bay {
				
				pre_event_unpowered_room_desc = "Shuttle Bay."
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_E].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_W].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_N].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_WALL_HP;
				
				room_name_str = "SHUTTLE BAY";
			}
			
			else if room_enum == research_vessel_room.crew_quarters {
				
				pre_event_unpowered_room_desc = "Crew Quarters."
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_E].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_W].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_N].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_WALL_HP;
				
				room_name_str = "CREW QUARTERS";
			}
			
			else if room_enum == research_vessel_room.research_lab {
				
				pre_event_unpowered_room_desc = "Research Laboratory."
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_E].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_W].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_N].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_WALL_HP;
				
				room_name_str = "RESEARCH LABORATORY";
			}
			
			else if room_enum == research_vessel_room.robotics_bay {
				
				pre_event_unpowered_room_desc = "Robotics Bay."
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_E].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_W].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_N].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_WALL_HP;
				
				room_name_str = "ROBOTICS BAY";
			}
			
			else if room_enum == research_vessel_room.recycler {

				pre_event_unpowered_room_desc = "Recycling Station."
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
				
				directional_ar[DOOR_DIR_E].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_E].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_W].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_N].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_WALL_HP;
				
				room_name_str = "RECYCLING STATION";
			}
			
			else if room_enum == research_vessel_room.animal_lab {
	
				pre_event_unpowered_room_desc = "Animal Laboratory."
				pre_event_powered_room_desc = pre_event_unpowered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
			
				directional_ar[DOOR_DIR_E].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_E].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_W].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_W].door_hp = BASE_DOOR_HP;
				
				directional_ar[DOOR_DIR_N].door_enum = door_state.wall;
				directional_ar[DOOR_DIR_N].door_hp = BASE_WALL_HP;
				
				directional_ar[DOOR_DIR_S].door_enum = door_state.unlocked;
				directional_ar[DOOR_DIR_S].dir_hp = BASE_DOOR_HP;
				
				room_name_str = "ANIMAL LABORATORY";
			}
			
			else if room_enum == research_vessel_room.vacuum {
				
				//All of these rooms are automatically vacuum and vacuum generators:
				hazard_ar = [];
				array_push(hazard_ar, hazard_type.vacuum);
				hazard_generator_ar = [];
				array_push(hazard_generator_ar, hazard_generator_types.vacuum);
				
				room_name_str = "SPACE - VACUUM";
				
				pre_event_unpowered_room_desc = "You are but a speck of detritus floating through this ocean of stars.";
				pre_event_powered_room_desc = pre_event_powered_room_desc;
				
				post_event_unpowered_room_desc = pre_event_unpowered_room_desc;
				post_event_powered_room_desc = pre_event_powered_room_desc;
				
				//No need to define directional_ar, it's already been done for default rooms.
			}
			
			else {
				d($"Constructor event for Room struct: room_type_enum: {room_type_enum} not captured by if case for location_type_enum {location_type_enum}");
				show_error($"Foir room_type enum: {room_enum}, grid x:{spawn_grid_x}, room_y: {spawn_grid_y}: room enum not yet defined", true);
			}
		} //End of if location_type enum == research vessel

	}
	
	#endregion
	
}