
/* We remove chars with the .has_died_bool and .has_fled_combat_bool from all of their appropriate arrays.


//Note: characters who fled have already been removed from the current room array and added to the room array
that they were fleeing to, so we don't need to edit their corresponding room arrays at all.

*/

function scr_delete_combat_chars(){
	
	//Iterate through our g.combat_init_ar:
	var ar_len = array_length(global.combat_initiative_ar), char_struct_to_delete;
	var room_ar, global_ar;
	
	for(var i = 0; i < ar_len; i++) {
		
		char_struct_to_delete = global.combat_initiative_ar[i];
		
		//Delete from corresponding room ar and corresponding global array:
		if char_struct_to_delete.has_died_bool == true {
			
			if char_struct_to_delete.char_team_enum == team_type.enemy {
				room_ar = char_struct_to_delete.cur_room_id.enemies_in_room_ar;
				global_ar = global.enemy_char_ar;
			}
			else if char_struct_to_delete.char_team_enum == team_type.pc {
				room_ar = char_struct_to_delete.cur_room_id.pcs_in_room_ar;
				global_ar = global.pc_char_ar;	
			}
			else if char_struct_to_delete.char_team_enum == team_type.neutral {
				room_ar = char_struct_to_delete.cur_room_id.neutrals_in_room_ar;
				global_ar = global.neutral_char_ar;
			}
							
			//Delete from room ar:
			var defender_index = array_get_index(room_ar,char_struct_to_delete);
				//Throw error, if they were not in the room array, we want to know why:
			if defender_index == -1 throw($"scr_delete_combat_chars: for char_struct_to_delete.name: {char_struct_to_delete.name} their returned defender_index == -1, for some reason their char_struct_id could not be found in their corresponding room_array, we want to know why.");
			array_delete(room_ar,defender_index,1);
							
			//Delete from global ar:
			var defender_index = array_get_index(global_ar,char_struct_to_delete);
				//Throw error, if they were not in the room array, we want to know why:
			if defender_index == -1 throw($"scr_delete_combat_chars: for char_struct_to_delete.name: {char_struct_to_delete.name} their returned defender_index == -1, for some reason their char_struct_id could not be found in their corresponding global array, we want to know why.");
			array_delete(global_ar,defender_index,1);
		}
	}
	
	//Combat is finished - We don't need the combat_init_ar and combat_rank_ar at all anymore - we can simply wipe these:
	global.combat_initiative_ar = -1;
	global.combat_initiative_ar = [];
	global.combat_rank_ar = -1;
	global.combat_rank_ar = [];
}