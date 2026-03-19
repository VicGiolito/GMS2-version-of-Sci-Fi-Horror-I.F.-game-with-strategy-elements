
//Capitalizes the very first letter in a string

function scr_string_capitalize(str) {
    if (string_length(str) == 0) return str;
    return string_upper(string_copy(str, 1, 1)) + string_copy(str, 2, string_length(str) - 1);
}