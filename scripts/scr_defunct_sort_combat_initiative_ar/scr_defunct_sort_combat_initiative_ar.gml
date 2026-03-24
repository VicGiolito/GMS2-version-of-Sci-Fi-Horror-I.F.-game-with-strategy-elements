

//This script is defunct - I don't use it for sorting the combat init ar

function scr_defunct_sort_combat_initiative_ar(arr){
	
    var swapped, size = array_length(arr);
    
	//First, assign each struct's ran_init_val:
	for (var i = 0; i < size; i++) {
		arr[i].ran_init_val = irandom_range(0,MAX_RAN_SPD_VAL);
	}
	
	//Then actually sort:
    for (var i = 0; i < size - 1; i++) {
        swapped = false;
        
        for (var j = 0; j < size - 1 - i; j++) {
            if (arr[j].spd + arr[j].ran_init_val > arr[j + 1].spd + arr[j + 1].ran_init_val) {
                // Swap elements
                var temp = arr[j];
                arr[j]   = arr[j + 1];
                arr[j + 1] = temp;
                swapped = true;
            }
        }
        
        // If no swaps occurred, array is already sorted
        if (!swapped) break;
    }
    
    return arr;
}