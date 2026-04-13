
/* Should only be called after enemies have potentially been deleted from the global.enemy_char_ar; this script checks
each enemy id in each enemy_mob_ar, and if it's not also in the g.enemy_char_ar, then we delete it from the enemy_mob_ar;
and if that enemy_mob_ar is empty after iterating through them, then we delete the mob struct from the global.enemy_mob_ar.
*/

function scr_delete_enemy_mobs(){
	
	if is_array(global.enemy_mob_ar) && array_length(global.enemy_mob_ar) > 0 {
		
		var mob_deleted = false;
		
		var ar_len = array_length(global.enemy_mob_ar), enemy_id, mob_struct_id;
		
		for(var i = 0; i < ar_len; i++) {
			
			mob_struct_id = global.enemy_mob_ar[i];
			
			if is_struct(mob_struct_id) && mob_struct_id.struct_type_enum == struct_type.Enemy_mob {
				
				if is_array(mob_struct_id.enemies_in_mob_ar) && array_length(mob_struct_id.enemies_in_mob_ar) > 0 {
					
					var new_enemy_mob_ar = [];
					
					for(var enemy_i = 0; enemy_i < array_length(mob_struct_id.enemies_in_mob_ar); enemy_i++) {
						
						enemy_id = mob_struct_id.enemies_in_mob_ar[enemy_i];
						
						//Check to see if enemy_id is within global.enemy_char_id:
						if is_array(global.enemy_char_ar) && array_length(global.enemy_char_ar) {
							
							for(var zz = 0; zz < array_length(global.enemy_char_ar); zz++) {
							
								if enemy_id == global.enemy_char_ar[zz] {
									array_push(new_enemy_mob_ar, enemy_id);
									break;
								}
							}
						}	
					}
					
					//If after iterating through the enemy_mob_ar, no enemy_ids were added to the new_enemy_mob_ar, then that means every enemy_id in it had been killed;
					//so we can just delete the entire mob_struct_id:
					if array_length(new_enemy_mob_ar) == 0 {
						global.enemy_mob_ar[i] = -1;
						mob_deleted = true;
						d($"scr_delete_enemy_mobs: mob struct at index {i} of our global.enemy_char_ar has been deleted.")
					}
					//At least one enemy_id was also found in the glboal.enemy_char_ar; our enemy_mob struct's array now becomes this array:
					else if array_length(new_enemy_mob_ar) > 0 {
						mob_struct_id.enemies_in_mob_ar = new_enemy_mob_ar;
					}
				}
			}
		} //End of iterating through global.enemy_mob_ar
		
		//If after iterating through our glboal.enemy_mob_ar, at least 1 mob struct was deleted, we need to edit the global.enemy_mob_ar to match:
		if mob_deleted {
			
			var new_global_enemy_mob_ar = [];
			
			for(var i = 0; i < ar_len; i++) {
			
				mob_struct_id = global.enemy_mob_ar[i];
				
				if mob_struct_id != -1 && is_struct(mob_struct_id) && mob_struct_id.struct_type_enum == struct_type.Enemy_mob {
					array_push(new_global_enemy_mob_ar, mob_struct_id);
				}
			}
			
			//If after iterating through the global.enemy mob ar we couldn't find a single mob struct to add to the array, just delete and reset the global array:
			if array_length(new_global_enemy_mob_ar) == 0 {
				global.enemy_mob_ar = -1;
				global.enemy_mob_ar = [];
			}
			//There was at least still 1 valid enemy mob in the global array, the global array now == the local scope array:
			else if array_length(new_global_enemy_mob_ar) > 0 {
				global.enemy_mob_ar = -1;
				global.enemy_mob_ar = new_global_enemy_mob_ar;
			}
		}
	}
}