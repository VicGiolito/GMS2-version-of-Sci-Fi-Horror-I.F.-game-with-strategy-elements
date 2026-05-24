

function scr_delete_mob_struct(mob_struct_id){
	
	var ar_index = array_get_index(global.enemy_mob_ar, mob_struct_id);
	
	if ar_index != -1 {
		array_delete(global.enemy_mob_ar, ar_index, 1);
		delete mob_struct_id; //extraneous, but good practice I suppose
		d($"scr_delete_mob_struct: enemy_mob struct destroyed.");
		return true;
	}
	
	d($"scr_delete_mob_struct: could not find mob_struct_id: {mob_struct_id} and did NOT delete it.");
	return false;
}