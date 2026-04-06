
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
		
		//Reset their broken_morale_ar:
		if is_array(char_struct_to_delete.permanent_broken_morale_ar) && array_length(char_struct_to_delete.permanent_broken_morale_ar) > 0 {
			char_struct_to_delete.broken_morale_ar = -1;
			char_struct_to_delete.broken_morale_ar = [];
			array_copy(char_struct_to_delete.broken_morale_ar,0,char_struct_to_delete.permanent_broken_morale_ar, 0, array_length(char_struct_to_delete.permanent_broken_morale_ar) );
		}
		//If its dead, delete from corresponding room ar and corresponding global array:
		if char_struct_to_delete.has_died_bool == true {
			
			scr_auto_reassign_neutrals_owner(char_struct_to_delete);
			
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