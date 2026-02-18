

function scr_setup_char_init_gear_and_abils(){
	
	//Iterate through global.pc_char_ar, for each char, add their starting equipment:
	var pc_char_struct, pc_char_enum;
	for(var i = 0; i < array_length(global.pc_char_ar); i++) {
		
		pc_char_struct = global.pc_char_ar[i];
		
		pc_char_enum = pc_char_struct.char_type_enum;
		
		if pc_char_enum == character.mercenary_cyborg {
			
			var item_id = new global.Item(item_type.flame_thrower);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.shotgun);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.suit_marine);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.access_targeting_hud);
			scr_add_item_to_inv(pc_char_struct,item_id,true);
			var item_id = new global.Item(item_type.hand_flamer);
			scr_add_ability(pc_char_struct,item_id,true,true);
			
			scr_add_ability(pc_char_struct,ability_type.hardened_skin,false,true);
		}
	}
	
}