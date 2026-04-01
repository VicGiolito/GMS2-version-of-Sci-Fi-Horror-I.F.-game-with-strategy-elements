

function scr_return_plural_s(real_num_var){
	
	var plural_str = "";
	
	if !is_undefined(real_num_var) && is_real(real_num_var) && real_num_var > 1 plural_str = "s";
	
	return plural_str;
}