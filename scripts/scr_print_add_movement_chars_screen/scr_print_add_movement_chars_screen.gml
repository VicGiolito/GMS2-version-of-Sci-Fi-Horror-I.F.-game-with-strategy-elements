
/* moving_party_ar and local_party_ar should already be defined.


*/

function scr_print_add_movement_chars_screen(move_dir_str){
	
	var total_move_party_str = "";
	
	if is_array(moving_party_ar) && array_length(moving_party_ar) > 0 {
		
		for(var i = 0; i < array_length(moving_party_ar); i++) {
			total_move_party_str += $" {moving_party_ar[i].name}";
			//Add semi colon if this is not the last index position:
			if i < array_length(moving_party_ar)-1 { total_move_party_str += ";" }
		}
	}
	
	if total_move_party_str == "" total_move_party_str = " none.";
	
	var local_party_str = "";
	
	if is_array(local_party_ar) && array_length(local_party_ar) > 0 {
		
		for(var i = 0; i < array_length(local_party_ar); i++) {
			local_party_str += $"{i}.) {local_party_ar[i].name}\n";	
		}
	}
	
	scr_add_str_to_dialogue_ar($"\nThe following characters are moving {move_dir_str}:{total_move_party_str}\nWho else will join this party?");
	
	
	scr_add_str_to_dialogue_ar($"{local_party_str}\nEnter the corresponding number of the character to add to the group that is moving {move_dir_str}; or enter 'C' or 'CONTINUE' to move with the party you currently have; or enter 'B' or 'BACKUP' to return to the main game state.", true);
	
	/*
	“The following chars are moving {movement direction string (Global.acting_cur_char_id.party_moving_dir_str)}: 
	{List the pc members who are moving {our moving_party_ar} WITHOUT line breaks.}\nWho else will join them?
	\n{List of pc chars in the same room who are not part of the current party {our local_party_ar} WITH line breaks}\n
	Enter the corresponding number of the character to add to your party; or enter 'C' or 'CONTINUE' to move with the party you current have; 
	or enter 'B' or 'BACKUP' to return to the main game state.”
	*/
}