
/* Reduces/resets the following:
--evasion bonus
--pc_is_combat_moving AI tag.
--Removes from overwatch rank array.


*/

function scr_reset_certain_char_combat_vars(char_struct_id){
	
	if char_struct_id.evading_boolean == true {
		char_struct_id.evading_boolean = false;
		char_struct_id.evasion -= EVADE_BONUS;
	}
	
	char_struct_id.pc_is_combat_moving = false; //We use this bool var because pcs actually move in execute_combat game state
	
	//If applicable, remove this char from the corresponding position in the global.overwatch_rank_ar and instance scope overwatch_attackers_ar:
	scr_remove_char_from_overwatch_arrays(char_struct_id);
	
}