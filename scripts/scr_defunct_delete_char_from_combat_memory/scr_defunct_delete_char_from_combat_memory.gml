
/*if char_fled == true, we do not remove them from the global arrays; 

also, if char_fled == true, after this script is called, we need to add them to the appropriate room team array.

//Defunct - we no longer delete chars as we move along, we flag them then delete them all at once at the end of combat.

*/

function scr_defunct_delete_char_from_combat_memory(char_struct_to_delete, char_fled = false){
	
	//Delete from init ar:
	var combat_init_index = array_get_index(global.combat_initiative_ar,char_struct_to_delete);
	array_delete(global.combat_initiative_ar,combat_init_index,1);
							
	//Delete from rank ar:
	var combat_rank_index = array_get_index(global.combat_rank_ar[char_struct_to_delete.cur_combat_rank],char_struct_to_delete);
	array_delete(global.combat_rank_ar[char_struct_to_delete.cur_combat_rank],combat_rank_index,1);
							
	//Delete from corresponding room ar and corresponding global array:
	var room_ar, global_ar;
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
	array_delete(room_ar,defender_index,1);
							
	//Delete from global ar:
	if char_fled == false {
		var defender_index = array_get_index(global_ar,char_struct_to_delete);
		array_delete(global_ar,defender_index,1);
	}
							
	//Delete from mob ar:
	if char_struct_to_delete.char_team_enum == team_type.enemy {
		var mobs_in_room_ar = [];
		mobs_in_room_ar = scr_return_mob_ar_at_coord(mobs_in_room_ar,char_struct_to_delete.cur_grid_x,char_struct_to_delete.cur_grid_y);
							
		if array_length(mobs_in_room_ar) > 0 {
			var mob_struct_id, enemy_found = false;
			for(var i = 0; i < array_length(mobs_in_room_ar); i++) {
									
				mob_struct_id = mobs_in_room_ar[i];
									
				for(var yy = 0; yy < array_length(mob_struct_id.enemies_in_mob_ar); yy++) {
					if mob_struct_id.enemies_in_mob_ar[yy] == char_struct_to_delete {
						enemy_found = true;
						array_delete(mob_struct_id.enemies_in_mob_ar,i,1);
						break;
					}
				}
				if enemy_found break;
			}
		}
	}
	
}