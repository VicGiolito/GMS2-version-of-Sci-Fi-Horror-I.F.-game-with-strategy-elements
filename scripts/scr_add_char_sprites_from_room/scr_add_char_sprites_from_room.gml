

function scr_add_char_sprites_from_room(room_struct_id){
	
	var repeat_count = 0, ar_to_use;
	repeat(3) {
		if repeat_count == 0 ar_to_use = room_struct_id.pcs_in_room_ar;
		else if repeat_count == 1 ar_to_use = room_struct_id.enemies_in_room_ar;
		else ar_to_use = room_struct_id.neutrals_in_room_ar;
		
		if is_array(ar_to_use) {
		
			var ar_len = array_length(ar_to_use);
		
			if ar_len > 0 {
				
				var char_struct_id;
				
				for(var i = 0; i < ar_len; i++) {
					
					char_struct_id = ar_to_use[i];
					
					if is_struct(char_struct_id) && char_struct_id.struct_type_enum == struct_type.Character {
					
					if char_struct_id.char_sprite_inst_id == -1 {
							
							
							with(instance_create_layer(0,0,"layer_main",o_char_struct_spr)) {
								
								char_struct_id.char_sprite_inst_id = id;
								represents_struct_id = char_struct_id;
								
								if char_struct_id.char_team_enum == team_type.pc sprite_index = spr_pc;
								else if char_struct_id.char_team_enum == team_type.enemy sprite_index = spr_enemy;
								else sprite_index = spr_neutral;
							}
						}
					}	
				}
			}
		}
		
		repeat_count++;
	}
}