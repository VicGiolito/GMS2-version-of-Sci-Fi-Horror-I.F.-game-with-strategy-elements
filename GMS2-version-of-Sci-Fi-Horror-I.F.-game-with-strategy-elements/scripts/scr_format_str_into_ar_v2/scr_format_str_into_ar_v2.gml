/* 
 * ALTERNATIVE VERSION: More efficient (recalculates width less often)
 * Now also handles newline characters (\n)
 */
function scr_format_str_into_ar_v2(str_to_format, max_str_len) {
    
    var formatted_str_ar = [];
    
    // If this is already an array, flatten it into a string
    if (is_array(str_to_format)) {
        var str = "";
        for(var i = 0; i < array_length(str_to_format); i++) {
            str += str_to_format[i];
        }
        str_to_format = str;
    }
    
    var start_pos = 1;
    var accumulated_width = 0;
    var last_space_pos = 0;  // Track the last space we encountered
    
    for(var i = 1; i <= string_length(str_to_format); i++) {
        
        var current_char = string_char_at(str_to_format, i);
        
        // Check for newline character
        if (current_char == "\n") {
            // Push the substring up to (but not including) the newline
            var substring = string_copy(str_to_format, start_pos, i - start_pos);
            array_push(formatted_str_ar, substring);
            
            // Remove the newline from the string
            str_to_format = string_delete(str_to_format, i, 1);
            
            // Reset for next line
            start_pos = i;  // Don't add 1 because we deleted a character
            last_space_pos = 0;
            accumulated_width = 0;
            i = i - 1;  // Adjust i since we deleted a character
            continue;
        }
        
        var char_width = string_width(current_char);
        
        // Track spaces as potential break points
        if (current_char == " ") {
            last_space_pos = i;
        }
        
        accumulated_width += char_width;
        
        // Check if we've exceeded the limit
        if (accumulated_width >= max_str_len) {
            
            // Try to break at the last space
            if (last_space_pos > start_pos) {
                
                // Break at the last space
                var substring = string_copy(str_to_format, start_pos, last_space_pos - start_pos);
                array_push(formatted_str_ar, substring);
                
                // Start after the space
                start_pos = last_space_pos + 1;
                last_space_pos = 0;
                
                // Recalculate accumulated width from new start position
                accumulated_width = 0;
                i = start_pos - 1;  // Will be incremented by loop
                
            } else {
                // No space found - force break at current position
                var substring = string_copy(str_to_format, start_pos, i - start_pos);
                array_push(formatted_str_ar, substring);
                
                start_pos = i;
                last_space_pos = 0;
                accumulated_width = char_width;
            }
        }
    }
    
    // Add remaining text
    if (start_pos <= string_length(str_to_format)) {
        var remaining = string_copy(str_to_format, start_pos, string_length(str_to_format) - start_pos + 1);
        if (string_length(string_trim(remaining)) > 0) {
            array_push(formatted_str_ar, remaining);
        }
    }
    
    return formatted_str_ar;
}