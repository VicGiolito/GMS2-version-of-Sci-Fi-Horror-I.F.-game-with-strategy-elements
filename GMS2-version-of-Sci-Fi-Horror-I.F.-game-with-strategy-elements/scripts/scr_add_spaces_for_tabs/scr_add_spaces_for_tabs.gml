
//Also flattens a string array if it's an array:

function scr_add_spaces_for_tabs(str_to_format){

	// If this is already an array, flatten it into a string
    if (is_array(str_to_format)) {
        var str = "";
        for(var i = 0; i < array_length(str_to_format); i++) {
            str += str_to_format[i];
        }
        str_to_format = str;
    }

	// Replace tabs with spaces
    var spaces = "";
    for(var i = 0; i < global.tab_spaces_count; i++) {
        spaces += " ";
    }
	
    str_to_format = string_replace_all(str_to_format, "\t", spaces);
	
	return str_to_format;
}