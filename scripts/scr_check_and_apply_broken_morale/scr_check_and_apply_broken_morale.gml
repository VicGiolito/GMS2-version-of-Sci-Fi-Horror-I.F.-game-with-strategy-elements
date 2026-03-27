

function scr_check_and_apply_broken_morale(char_struct_id){
	
	var broken_morale_str = "";
	
	if char_struct_id.sanity_cur >= char_struct_id.sanity_max {
		
		broken_morale_str += $"**{scr_string_capitalize(char_struct_id.name)}'s sanity has been broken!\n**";
		
		//Choose random status effect from applicable options:
		var ran_broken_morale_struct = char_struct_id.broken_morale_ar[irandom_range(0,array_length(char_struct_id.broken_morale_ar)-1)];
		
		var ran_broken_morale_status_effect_enum = ran_broken_morale_struct.broken_morale_status_effect_enum;
		
		var status_effect_str = "";
		if ran_broken_morale_status_effect_enum == broken_morale_status_effects.treacherous {
			status_effect_str = "--Treacherous--";
			
			char_struct_id.treacherous_count = TREACHEROUS_DURATION;
			
			char_struct_id.char_team_enum = team_type.enemy;
		}
		else if ran_broken_morale_status_effect_enum == broken_morale_status_effects.berserk {
			status_effect_str = "--Berserk--";
			
			char_struct_id.berserk_count = BERSERK_DURATION;
			
			char_struct_id.char_team_enum = team_type.neutral;
		}
		else if ran_broken_morale_status_effect_enum == broken_morale_status_effects.fleeing {
			status_effect_str = "--Fleeing--";	
			
			
		}
		if ran_broken_morale_status_effect_enum == broken_morale_status_effects.cowering {
			status_effect_str = "--Cowering--";	
			
			char_struct_id.stun_count = COWERING_STUNNED_DURATION;
			char_struct_id.cowering_bool = true;
		}
		
		//Add to string:
		broken_morale_str += $"**{ran_broken_morale_struct} ({status_effect_str})**";
		
		//Reduce/reset sanity after its ill effects have been triggered:
		char_struct_id.sanity_cur = 0; //Reset sanity to half max, if applicable:
	}
	
	if broken_morale_str != "" {
		scr_add_str_to_dialogue_ar($"\n{broken_morale_str}")	
	}
}