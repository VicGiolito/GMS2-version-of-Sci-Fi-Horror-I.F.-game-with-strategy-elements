

/*Currently called in game_state init_combat, whenever we're completely exiting from combat and returning to the main game state,
in the scr_post_combat_reset_vars() script.

Resets most status effects except for unconscious, infected, etc.

*/

function scr_reset_status_effects(char_struct_id){
	
	char_struct_id.stun_count = 0;
	
	char_struct_id.burning_count = 0;
	
	char_struct_id.poisoned_count = 0;
	
	char_struct_id.bleeding_count = 0;
	
	char_struct_id.suppressed_count = 0;
	
	char_struct_id.adrenal_pen_count = 0;
	
	char_struct_id.healing_nanites_count = 0;
}