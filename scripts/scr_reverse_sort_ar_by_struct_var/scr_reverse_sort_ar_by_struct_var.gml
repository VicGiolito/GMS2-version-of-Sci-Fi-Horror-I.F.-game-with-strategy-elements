
/* Just a bubble sort algorithm that sorts the struct instances within an array by REVERSE ORDER 
(those of the highest specified value will end up in index 0);
the struct instances within the array are sorted by the 'variable name' argument we provide.

--If either the structs or their accompanying variables do not exist, we return -1.

*/

function scr_reverse_sort_ar_by_struct_var(arr, var_name_str){
	
	var ar_len  = array_length(arr);
	
	var temp_val = 0, initial_struct_id, next_struct_id, initial_struct_var_exists, initial_struct_var_val, next_struct_var_exists, next_struct_var_val;
	
	// Outer pass — each pass guarantees the next smallest
	// value has sunk to its correct position at the bottom
	for (var i = 0; i < ar_len - 1; i++) {
		
		// Inner pass — walk through the unsorted portion
		// and swap neighbours if they are in the wrong order
		for (var j = 0; j < ar_len - 1 - i; j++) {
			
			initial_struct_id = arr[j];
			next_struct_id = arr[j +1];
			
			if is_struct(initial_struct_id) && is_struct(next_struct_id) {
				
				initial_struct_var_exists = variable_struct_exists(initial_struct_id, var_name_str);
			
				next_struct_var_exists = variable_struct_exists(next_struct_id, var_name_str);
			
				if initial_struct_var_exists && next_struct_var_exists {
				
					initial_struct_var_val = variable_struct_get(initial_struct_id, var_name_str);
				
					next_struct_var_val = variable_struct_get(next_struct_id, var_name_str);
				
					// If the current element is LESS than the next,
					// swap them so the larger value moves toward index 0
					if (initial_struct_var_val) < (next_struct_var_val) {
						temp_val = arr[j];
						arr[j] = arr[j + 1];
						arr[j + 1] = temp_val;
					}
				}
				else return -1;	
				
			} else return -1;
		}
	}
	
	return arr;
}