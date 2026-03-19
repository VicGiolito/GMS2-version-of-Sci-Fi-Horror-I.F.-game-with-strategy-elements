

function scr_setup_char_init_gear_and_abils(){
	
	//Iterate through global.pc_char_ar, for each char, add their starting equipment:
	var pc_char_struct, pc_char_enum;
	for(var i = 0; i < array_length(global.pc_char_ar); i++) {
		
		pc_char_struct = global.pc_char_ar[i];
		
		pc_char_enum = pc_char_struct.char_type_enum;
		
		//Debug: everyone gets a sniper rifle:
		var item_id = new global.Item(item_type.sniper_rifle);
		scr_add_item_to_inv(pc_char_struct,item_id,true);
		
		if pc_char_enum == character.mercenary_cyborg {
			
			var item_id = new global.Item(item_type.flame_thrower);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.access_targeting_hud);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.sniper_rifle);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.assault_rifle);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.medkit);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.regen_nanites); 
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.shield_flak); //last one
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.shield_riot);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.machine_pistol);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.police_truncheon);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.shotgun);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.suit_marine);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.access_targeting_hud);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			
			//Abilities:
			scr_add_passive_ability(pc_char_struct,passive_abil_type.hardened_skin,"scr_setup_char_init_gear_and_abils *");
			scr_add_ability(pc_char_struct,item_type.wrist_rockets,true);
			scr_add_ability(pc_char_struct,item_type.hand_flamer,true);
		}
		
		else if pc_char_enum == character.child {
			var item_id = new global.Item(item_type.sniper_rifle);
			scr_add_item_to_inv(pc_char_struct,item_id,true);	
		}
		
		else if pc_char_enum == character.mechanician {
			var item_id = new global.Item(item_type.sniper_rifle);
			scr_add_item_to_inv(pc_char_struct,item_id,true);	
		}
		
		else if pc_char_enum == character.ogre {
			scr_add_ability(pc_char_struct,item_type.headbutt);
			scr_add_ability(pc_char_struct,item_type.feral_bite);
			scr_add_passive_ability(pc_char_struct,passive_abil_type.giant,"scr_setup_char_init_gear_and_abils");
			scr_add_passive_ability(pc_char_struct,passive_abil_type.healing_factor,"scr_setup_char_init_gear_and_abils");
		}
	}
	
}