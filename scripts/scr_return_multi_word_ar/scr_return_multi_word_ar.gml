

function scr_return_multi_word_ar(str_to_parse){
	
	d($"Entering scr_return_multi_word_ar: str_to_parse == {str_to_parse}");
	
	var str_len = string_length(str_to_parse);
	
	var char_at_i, ar_index = 0, str_ar = [];
	
	//Initialize array with -1 values:
	for(var i = 0; i < str_len; i++) {
		str_ar[i] = -1;	
	}
		
	for(var char_i = 1; char_i <= str_len; char_i++) {
		
		char_at_i = string_char_at(str_to_parse,char_i);
		
		if char_at_i != " " {
			if str_ar[ar_index] == -1 str_ar[ar_index] = "";
			str_ar[ar_index] += char_at_i;
		}
		else {
			ar_index++;
			continue;
		}
	}
	
	d($"scr_return_multi_word_ar, before removing -1 from str_ar, str_ar == {str_ar}"); 
	
	//In the case of many spaces separating words, we would end with array indices that are completely empty (-1).
	//We want to remove those from the array now:
	var parsed_array = [];
	for(var i = 0; i < array_length(str_ar); i++) {
		if str_ar[i] != -1 {
			parsed_array[i] = str_ar[i];
		}
	}
	
	d($"scr_return_multi_word_ar: parsed_ar == {parsed_array}");
	
	return parsed_array;
}