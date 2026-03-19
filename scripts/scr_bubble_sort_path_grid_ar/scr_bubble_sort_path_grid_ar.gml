/// @function bubble_sort(arr, size)
/// @description Sorts an array in ascending order using bubble sort
/// @param {Array} arr  The array to sort
/// @returns {Array} The sorted array

function scr_bubble_sort_path_grid_ar(arr) {
	
    var swapped, size = array_length(arr);
    
    for (var i = 0; i < size - 1; i++) {
        swapped = false;
        
        for (var j = 0; j < size - 1 - i; j++) {
            if (arr[j].path_grid_step_val > arr[j + 1].path_grid_step_val) {
                // Swap elements
                var temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
                swapped = true;
            }
        }
        
        // If no swaps occurred, array is already sorted
        if (!swapped) break;
    }
    
    return arr;
}