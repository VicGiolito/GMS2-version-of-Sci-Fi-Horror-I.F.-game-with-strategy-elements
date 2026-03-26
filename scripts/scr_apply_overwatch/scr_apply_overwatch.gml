
//char_id.chosen weapon and char_id.targeted_rank must be defined first

function scr_apply_overwatch(char_id){
	
		var ar_to_use;
		if char_id.char_team_enum == team_type.enemy {
			ar_to_use = global.overwatch_rank_ar[char_id.targeted_rank].enemy_overwatch_ar;	
		}
		else { ar_to_use = global.overwatch_rank_ar[char_id.targeted_rank].player_overwatch_ar; }
						
		array_push(ar_to_use, char_id);
					
		//Display result message:
		scr_add_str_to_dialogue_ar($"\n{char_id.name}({char_id.unique_id}) aims the {char_id.chosen_weapon.item_name} at the {scr_return_rank_str(char_id.targeted_rank)}. They will automatically fire upon any enemy moving into that position until the start of their next turn.");
}