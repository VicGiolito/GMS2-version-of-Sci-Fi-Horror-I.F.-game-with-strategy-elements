

function scr_shuffle_ar(arr) {
    
	//var new_ar = [];
	//new_ar = arr;
	
	var n = array_length(arr);
    
	for (var i = n - 1; i > 0; i--) {
        var j = irandom(i);
        var temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }
    
	return arr;
}