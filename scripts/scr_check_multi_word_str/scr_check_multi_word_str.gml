
//Checks to see if a string has at least 2 'words', as indicated by an

function scr_check_multi_word_str(str_to_parse){
	
	var str_len = string_length(str_to_parse);
	
	d($"Entering scr_check_multi_word_str...");
	
	if str_len >= 1 {
		
		//If the very first character is a space, just return false.
		if string_char_at(str_to_parse, 1) == " " return false;
		
		var char_at_i, checking_first_word = true;
		
		for(var char_i = 1; char_i <= str_len; char_i++) {
			
			char_at_i = string_char_at(str_to_parse, char_i);
			
			d($"scr_check_multi_word_str: char_i = {char_i}, char_at_i == {char_at_i}");
			
			if char_at_i != " " && !checking_first_word {
				d($"scr_check_multi_word_str: char_at_i != ' ' and checking_first_word == false, returning TRUE.");
				return true;	
			}
			
			if char_at_i == " " && checking_first_word {
				d($"scr_check_multi_word_str: char_at_i == ' ' and checking_first_word == true, switching checking_first_word to FALSE and continuing to next iteration.");
				checking_first_word = false;
				continue;
			}
		}
	}
	
	return false;
}