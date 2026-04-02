

/*Currently called in game_state init_combat, whenever we're completely exiting from combat and returning to the main game state,
in the scr_post_combat_reset_vars() script.

Resets most status effects except for unconscious, infected, etc.

Important: if the associated status effect also applied some sort of stat debuff or buff, we also need to reset that!

*/

function scr_reset_status_effects(char_struct_id, called_from_str){
	
	if is_undefined(called_from_str) throw("scr_reset_status_effects: called_from_str undefined, we need to know where this script is being called.");
	
	else d($"\nEntering scr_reset_status_effects FOR CHAR: {char_struct_id.name}, it was called from: {called_from_str}\n");
	
	char_struct_id.stun_count = 0;
	
	char_struct_id.burning_count = 0;
	
	char_struct_id.poisoned_count = 0;
	
	char_struct_id.bleeding_count = 0;
	
	if char_struct_id.treacherous_count > 0 {
		char_struct_id.treacherous_count = 0;
		char_struct_id.char_team_enum = char_struct_id.origin_team;
		d($"****{char_struct_id.name} is NO LONGER TREACHEROUS, their team changed to origin team.****");
	}
	
	char_struct_id.cowering_bool = false;
	
	if char_struct_id.berserk_count > 0 {
		char_struct_id.berserk_count = 0;
		char_struct_id.char_team_enum = char_struct_id.origin_team;	
		d($"****{char_struct_id.name} is NO LONGER BERSERK, their team changed to origin team.****");
	}
	
	if char_struct_id.suppressed_count > 0 {
		char_struct_id.suppressed_count = 0;
		char_struct_id.spd += SUPPRESSED_SPEED_DEBUFF;
		char_struct_id.evasion += SUPPRESSED_EVASION_DEBUFF;
	}
	
	if char_struct_id.adrenal_pen_count > 0 {
		char_struct_id.adrenal_pen_count = 0;
		char_struct_id.spd -= ADRENAL_PEN_SPD_BUFF;
		char_struct_id.accuracy -= ADRENAL_PEN_ACC_BUFF;
		d("\n\n*********ADRENAL PEN RESET************\n\n")
	}
	
	//Regen nanites:
	char_struct_id.healing_nanites_count = 0;
	
	if char_struct_id.smoke_grenade_count > 0 {
		char_struct_id.smoke_grenade_count = 0;
		char_struct_id.evasion -= SMOKE_GRENADE_EVADE_BUFF;
	}
	
	if char_struct_id.shield_bubble_count > 0 {
		char_struct_id.shield_bubble_count = 0;
		char_struct_id.armor -= PERSONAL_SHIELD_ARMOR_BUFF;
		char_struct_id.evasion -= PERSONAL_SHIELD_EVASION_BUFF;
	}
	
	if char_struct_id.evading_boolean == true {
		char_struct_id.evasion -= EVADING_BUFF;	
		char_struct_id.evading_boolean = false;
	}
}