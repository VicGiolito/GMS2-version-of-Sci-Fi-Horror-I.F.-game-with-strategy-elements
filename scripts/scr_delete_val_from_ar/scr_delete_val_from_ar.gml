
function scr_delete_val_from_ar(ar_id,val_to_remove){

	var index = array_get_index(ar_id,val_to_remove);
	if index != -1 {	
		array_delete(ar_id,index,1);
		return true;
	}
	else return false;
}