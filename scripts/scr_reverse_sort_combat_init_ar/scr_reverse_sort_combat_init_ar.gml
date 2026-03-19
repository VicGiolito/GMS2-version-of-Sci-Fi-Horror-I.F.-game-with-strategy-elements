/// @function	scr_reverse_sort_ar(array)
/// @param		{Array} array	The array to sort in descending order
/// @return		{Array}			The sorted array (highest value at index 0)
/// @description Sorts an array using bubble sort in descending order.
///              Highest values bubble up to the top (index 0),
///              lowest values sink to the bottom (array_length - 1).


function scr_reverse_sort_combat_init_ar(arr){
	
	var _len  = array_length(arr);
	var _temp = 0;
	
	//First, assign each struct's ran_init_val:
	for (var i = 0; i < _len; i++) {
		arr[i].ran_init_val = irandom_range(0,MAX_RAN_SPD_VAL);
	}
	
	// Outer pass — each pass guarantees the next smallest
	// value has sunk to its correct position at the bottom
	for (var i = 0; i < _len - 1; i++) {
		
		// Inner pass — walk through the unsorted portion
		// and swap neighbours if they are in the wrong order
		for (var j = 0; j < _len - 1 - i; j++) {
			
			// If the current element is LESS than the next,
			// swap them so the larger value moves toward index 0
			if (arr[j].ran_init_val + arr[j].spd) < (arr[j + 1].ran_init_val + arr[j + 1].spd) {
				_temp = arr[j];
				arr[j] = arr[j + 1];
				arr[j + 1] = _temp;
			}
		}
	}
	
	return arr;
}