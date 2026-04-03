
/* These are the status effects were need to reset whenever a char flees - 
note that things like burning, poisoned, etc., do NOT get reset.



*/

function scr_reset_status_effects_from_fleeing(char_struct_id){
	
	//If this char was hiding, it's been canceled now that they've run:
	char_struct_id.char_hiding_in_room = false;
	
	if char_struct_id.cowering_bool == true {
		char_struct_id.cowering_bool = false;
		char_struct_id.stun_count = 0;
	}
	
	if char_struct_id.berserk_count > 0 {
		char_struct_id.berserk_count = 0;
		char_struct_id.char_team_enum = char_struct_id.origin_team;		
		d($"****{char_struct_id.name} is NO LONGER BERSERK, their team changed to origin team.****");
	}
	
	char_struct_id.char_fleeing_from_broken_morale = false;
	
	if char_struct_id.treacherous_count > 0 {
		char_struct_id.treacherous_count = 0;
		char_struct_id.char_team_enum = char_struct_id.origin_team;	
		d($"****{char_struct_id.name} is NO LONGER TREACHEROUS, their team changed to origin team.****");
	}
	
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
	}
	
	if char_struct_id.adrenal_pen_count > 0 {
		char_struct_id.adrenal_pen_count = 0;
		char_struct_id.spd -= ADRENAL_PEN_SPD_BUFF;
		char_struct_id.accuracy -= ADRENAL_PEN_ACC_BUFF;
	}
	
	//We also need to apply this to any neutrals that may be fleeing with them:
	if is_array(char_struct_id.neutrals_following_this_char_ar) && array_length(char_struct_id.neutrals_following_this_char_ar) > 0 {
		var ar_len = array_length(char_struct_id.neutrals_following_this_char_ar);
		
		for(var i = 0; i < ar_len; i++) {
			scr_reset_status_effects_from_fleeing(char_struct_id.neutrals_following_this_char_ar[i]); //Neutrals should never have this array: neutrals_following_this_char_ar, so this should never create an infinite loop.
		}
	}
}