
/* We remove chars with the .has_died_bool and .has_fled_combat_bool from all of their appropriate arrays.


//Note: characters who fled have already been removed from the current room array and added to the room array
that they were fleeing to, so we don't need to edit their corresponding room arrays at all.

*/

function scr_delete_combat_chars(){
	
	//Iterate through our g.combat_init_ar:
	var ar_len = array_length(global.combat_initiative_ar), char_struct_to_delete;
	
	for(var i = 0; i < ar_len; i++) {
		
		char_struct_to_delete = global.combat_initiative_ar[i];
		
		//In any case, reset stunned, morale effects:
		if char_struct_to_delete.stun_count > 0 {
			char_struct_to_delete.cowering_bool = false;
			char_struct_to_delete.stun_count = 0;
		}
		if char_struct_to_delete.berserk_count > 0 {
			char_struct_to_delete.berserk_count = 0;
			char_struct_to_delete.char_team_enum = char_struct_to_delete.origin_team;
			d($"****{char_struct_to_delete.name} is NO LONGER BERSERK, their team changed to origin team. (changed in scr_delete_combat_chars)****");
		}
		if char_struct_to_delete.treacherous_count > 0 {
			char_struct_to_delete.treacherous_count = 0;
			char_struct_to_delete.char_team_enum = char_struct_to_delete.origin_team;
			d($"****{char_struct_to_delete.name} is NO LONGER TREACHEROUS, their team changed to origin team. (changed in scr_delete_combat_chars)****");
		}
		
		//If its dead, delete from corresponding room ar and corresponding global array:
		if char_struct_to_delete.has_died_bool == true {
			
			//If this is a pc, we also need to check their neutrals_following_this_char_ar, and reassign or delete any within it:
			if char_struct_to_delete.char_team_enum == team_type.pc && is_array(char_struct_to_delete.neutrals_following_this_char_ar) && array_length(char_struct_to_delete.neutrals_following_this_char_ar) > 0 {
				
				//Iterate through neutrals_following_this_char_ar
				for(var kk = 0; kk < array_length(char_struct_to_delete.neutrals_following_this_char_ar); kk++) {
					
					var neutral_id = char_struct_to_delete.neutrals_following_this_char_ar[kk];
					
					if neutral_id.has_died_bool == false && neutral_id.has_fled_combat_bool == false {
						
						var new_owner_found = false;
						
						if is_array(neutral_id.cur_room_id.pcs_in_room_ar) && array_length(neutral_id.cur_room_id.pcs_in_room_ar) > 0 {
							
							for(var zz = 0; zz < array_length(neutral_id.cur_room_id.pcs_in_room_ar); zz++) {
								
								var pc_char_id = neutral_id.cur_room_id.pcs_in_room_ar[zz];
								
								if pc_char_id.has_fled_combat_bool == false && pc_char_id.has_died_bool == false {
									
									new_owner_found = true;
									
									//Remove this neutral from its previous owner's neutrals_following_this_char_ar:
									var neutrals_prev_ar = scr_return_neutral_owner_id_or_ar(neutral_id.cur_room_id.pcs_in_room_ar, neutral_id, true);
									if neutrals_prev_ar != -1 {
										var neutrals_ar_index = array_get_index(neutrals_prev_ar, neutral_id);
										if neutrals_ar_index != -1 {
											array_delete(neutrals_prev_ar,neutrals_ar_index,1);	
										}
									}
									
									//Add to the new owner's neutrals_following_this_char_ar
									if !is_array(pc_char_id.neutrals_following_this_char_ar) { pc_char_id.neutrals_following_this_char_ar = []; } 
									
									array_push(pc_char_id.neutrals_following_this_char_ar, neutral_id);
									
									scr_add_str_to_dialogue_ar($"\n**With its previous owner slain, ownership of the {neutral_id.name} has been automatically transferred to {pc_char_id.name}.**");
									
									break;
								}
							}
						}
						
						//Delete this neutral:
						if !new_owner_found {
							neutral_id.has_died_bool = true;
							scr_add_str_to_dialogue_ar($"\n**There were no playable characters left in this room to assume control of the {neutral_id.name}. Without the guidance of an operator, this droid's A.I. has deactivated and cannot be revived. It is now essentially dead.**");
							scr_delete_char_from_global_and_room_ar(neutral_id);
						}
					}
				}	
				
				/*
				So in scr_delete_combat_chars, whenever we delete a pc, we need to check their neutrals_following_this_char_ar, 
				and for every neutral in that array that is not dead or fled (they can never be unconscious), we then iterate 
				through the global.combat_init_ar again, and reassign them to the first valid pc char in here that is not dead or fled. 
				Once reassigned, we print a generic message about it: “With their master slain, {neutral_name} was automatically 
				reassigned to follow {new_pc_owner_name} instead.”
				
				And if we can't find a valid new owner, we change this neutral's has_died bool to == true just for good measure, 
				and call scr_delete_char_from_global_and_room_ar() to actually delete it from the room and global arrays, 
				because it's possible we may have already passed over in them in our for-loop when they were considered alive.
				*/
			}
			
			scr_delete_char_from_global_and_room_ar(char_struct_to_delete);
		}
	}
	
	//Combat is finished - We don't need the combat_init_ar and combat_rank_ar at all anymore - we can simply wipe these:
	global.combat_initiative_ar = -1;
	global.combat_initiative_ar = [];
	global.combat_rank_ar = -1;
	global.combat_rank_ar = [];
	scr_reset_global_overwatch_ar(); //Reset our global overwatch array.
}