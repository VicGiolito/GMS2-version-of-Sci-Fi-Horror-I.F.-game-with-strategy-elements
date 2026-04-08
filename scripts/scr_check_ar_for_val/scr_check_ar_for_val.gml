

function scr_check_ar_for_val(arr, val_to_check){
	
	var ar_len = array_length(arr);
	
	for(var i = 0; i < ar_len; i++) {
		if arr[i] == val_to_check {
			return true;	
		}
	}
	
	return false;
}