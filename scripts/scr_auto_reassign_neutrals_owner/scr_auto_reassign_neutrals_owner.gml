

function scr_auto_reassign_neutrals_owner(cur_char_struct_id){
	
	//If this is a pc, we also need to check their neutrals_following_this_char_ar, and reassign or delete any within it:
	if cur_char_struct_id.char_team_enum == team_type.pc && is_array(cur_char_struct_id.neutrals_following_this_char_ar) && array_length(cur_char_struct_id.neutrals_following_this_char_ar) > 0 {
				
		//Iterate through neutrals_following_this_char_ar
		for(var kk = 0; kk < array_length(cur_char_struct_id.neutrals_following_this_char_ar); kk++) {
					
			var neutral_id = cur_char_struct_id.neutrals_following_this_char_ar[kk];
					
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
	}
	
}