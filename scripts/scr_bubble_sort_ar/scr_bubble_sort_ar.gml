/// @function bubble_sort(arr, size)
/// @description Sorts an array in ascending order using bubble sort
/// @param {Array} arr  The array to sort
/// @param {Real}  size The number of elements in the array
/// @returns {Array} The sorted array

function scr_bubble_sort_ar(arr) {
	
    var swapped, size = array_length(arr);
    
    for (var i = 0; i < size - 1; i++) {
        swapped = false;
        
        for (var j = 0; j < size - 1 - i; j++) {
            if (arr[j] > arr[j + 1]) {
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