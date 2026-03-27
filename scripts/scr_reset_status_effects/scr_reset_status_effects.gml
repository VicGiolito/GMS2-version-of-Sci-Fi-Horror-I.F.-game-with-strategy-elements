

/*Currently called in game_state init_combat, whenever we're completely exiting from combat and returning to the main game state,
in the scr_post_combat_reset_vars() script.

Resets most status effects except for unconscious, infected, etc.

Important: if the associated status effect also applied some sort of stat debuff or buff, we also need to reset that!

*/

function scr_reset_status_effects(char_struct_id){
	
	char_struct_id.stun_count = 0;
	
	char_struct_id.burning_count = 0;
	
	char_struct_id.poisoned_count = 0;
	
	char_struct_id.bleeding_count = 0;
	
	if char_struct_id.treacherous_count > 0 {
		char_struct_id.treacherous_count = 0;
		char_struct_id.char_team_enum = team_type.pc;	
	}
	
	char_struct_id.cowering_bool = false;
	
	if char_struct_id.berserk_count > 0 {
		char_struct_id.berserk_count = 0;
		char_struct_id.char_team_enum = team_type.pc;	
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
}