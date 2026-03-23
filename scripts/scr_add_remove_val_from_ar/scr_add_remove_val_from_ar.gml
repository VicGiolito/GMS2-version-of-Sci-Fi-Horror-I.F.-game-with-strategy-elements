
/*if add_or_remove_boolean == true: we add, and remove_only_one_boolean can == anything (-1); 

if add_or_remove_boolean == false, we delete, either every val that matches val_to_remove_or_add, or just once,
(based upon remove_only_one_boolean).

When removing a val from array, if no matching value can be found to remove, the ar_to_pass will simply remain unmodified.

//IMPORTANT: This script RETURNS the modified array, so you need capture it when you call it.

*/

function scr_add_remove_val_from_ar(ar_to_pass, val_to_remove_or_add, remove_only_one_boolean, add_or_remove_boolean){
	
	if !add_or_remove_boolean {
		
		if remove_only_one_boolean {
			var index = array_get_index(ar_to_pass,val_to_remove_or_add);
			if index != -1 {	
				array_delete(ar_to_pass,index,1);
				return ar_to_pass;
			}
		}
		else if !remove_only_one_boolean {
			var ar_len = array_length(ar_to_pass);
			var temp_ar = [];
			for(var i = 0; i < ar_len; i++) {
				if ar_to_pass[i] != val_to_remove_or_add {
					array_push(temp_ar,ar_to_pass[i]);
				}
			}
			return temp_ar;
		}
	}
	
	else if add_or_remove_boolean {
		array_push(ar_to_pass,val_to_remove_or_add);
		return ar_to_pass;
	}
}