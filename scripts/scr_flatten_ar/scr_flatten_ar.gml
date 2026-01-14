
//Elements in the array should be of the same type; really only to be used for string arrays.

function scr_flatten_ar(ar_to_pass){
	
	if is_array(ar_to_pass) {
	
		var single_element;
	
		for(var i = 0; i < array_length(ar_to_pass); i++){
			single_element += ar_to_pass[i];
		}
	
		return single_element;
	}
	else return ar_to_pass;
}