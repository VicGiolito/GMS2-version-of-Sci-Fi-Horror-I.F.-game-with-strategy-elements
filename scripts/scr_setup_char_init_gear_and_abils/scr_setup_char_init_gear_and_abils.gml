

function scr_setup_char_init_gear_and_abils(){
	
	//Iterate through global.pc_char_ar, for each char, add their starting equipment:
	var pc_char_struct, pc_char_enum;
	for(var i = 0; i < array_length(global.pc_char_ar); i++) {
		
		pc_char_struct = global.pc_char_ar[i];
		
		pc_char_enum = pc_char_struct.char_type_enum;
		
		//Debug: everyone gets a sniper rifle and a concussion grenade launcher:
		var item_id = new global.Item(item_type.sniper_rifle);
		scr_add_item_to_inv(pc_char_struct,item_id,true);
		
		var item_id = new global.Item(item_type.concussion_grenade_launcher);
		scr_add_item_to_inv(pc_char_struct,item_id,true);
		
		if pc_char_enum == character.mercenary_cyborg {
			
			var item_id = new global.Item(item_type.suit_prisoner_jumpsuit);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_index = array_get_index(pc_char_struct.inv_ar,item_id);
			if item_index != -1 scr_equip_or_unequip_item(pc_char_struct,item_id,item_index,true,true);
			
			var item_id = new global.Item(item_type.flame_thrower);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.access_targeting_hud);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.assault_rifle);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.medkit);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.regen_nanites); 
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.shield_flak);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.suit_environmental);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.suit_flak_armor);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			
			//Abilities:
			scr_add_passive_ability(pc_char_struct,passive_abil_type.hardened_skin,"scr_setup_char_init_gear_and_abils *");
			scr_add_ability(pc_char_struct,item_type.wrist_rockets,true);
			scr_add_ability(pc_char_struct,item_type.hand_flamer,true);
			scr_add_ability(pc_char_struct,item_type.shocking_grasp,true);
			scr_add_ability(pc_char_struct,item_type.personal_shield_generator,true);
		}
		
		else if pc_char_enum == character.child {
				
		}
		
		else if pc_char_enum == character.mechanician {
				
		}
		
		else if pc_char_enum == character.ogre {
			scr_add_ability(pc_char_struct,item_type.headbutt);
			scr_add_ability(pc_char_struct,item_type.feral_bite);
			scr_add_passive_ability(pc_char_struct,passive_abil_type.giant,"scr_setup_char_init_gear_and_abils");
			scr_add_passive_ability(pc_char_struct,passive_abil_type.healing_factor,"scr_setup_char_init_gear_and_abils");
			
			var item_id = new global.Item(item_type.suit_prisoner_jumpsuit);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_index = array_get_index(pc_char_struct.inv_ar,item_id);
			if item_index != -1 scr_equip_or_unequip_item(pc_char_struct,item_id,item_index,true,true);
			
			var item_id = new global.Item(item_type.access_targeting_hud);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.machine_pistol);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.police_truncheon);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.shotgun);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.suit_marine);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.shield_riot); //last one
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.suit_security_vest);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			
		}
	}
	
}