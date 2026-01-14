

/*str_separator: example: ", "

ending_str: example : "."

Flattens the array, also converts the elements in the arrays to strings.

*/

function scr_concat_ar(ar_to_concat,str_separator,ending_str = ""){
	
	var ar_len = array_length(ar_to_concat);
	var concat_str = "";
	
	for(var i = 0; i < ar_len; i++) {
		if i < ar_len - 1 {
			concat_str += string(ar_to_concat[i])+string(str_separator);
		}
		else if i == ar_len - 1 {
			concat_str += string(ar_to_concat[i])+string(ending_str);	
		}
	}
	
	return concat_str;
}