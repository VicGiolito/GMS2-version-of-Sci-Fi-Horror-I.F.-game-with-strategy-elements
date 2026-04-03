

function scr_shuffle_ar(arr) {
	
	var new_ar = [];
	
	array_copy(new_ar,0,arr,0,array_length(arr));
	
	var n = array_length(new_ar);
    
	for (var i = n - 1; i > 0; i--) {
        var j = irandom(i);
        var temp = new_ar[i];
        new_ar[i] = new_ar[j];
        new_ar[j] = temp;
    }
    
	return new_ar;
}