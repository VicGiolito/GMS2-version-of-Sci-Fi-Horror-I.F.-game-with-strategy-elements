
//must be run from scope of o_con

function scr_print_char_select_instructions(){
	
	var remaining_chars_count = party_limit-array_length(global.pc_char_ar);
	var plural_s = "";
	if remaining_chars_count > 1 plural_s = "s";
	scr_add_str_to_dialogue_ar($"\nYou must choose {remaining_chars_count} more character{plural_s} to add to your party.\nEnter 'A' or 'ADD' to add this character to your party;\n'R' or 'REMOVE' to remove them;\nor 'B' or 'BIO' to learn about their backstory.\nCommands are not case-sensitive.\nUse the up and down arrow keys to move between stasis pods.",true);
}