

function scr_delete_enemy_struct_from_mob(mob_struct_id, enemy_struct_id){
	
	var enemy_id_found = false;
	
	if is_array(mob_struct_id.enemies_in_mob_ar) && array_length(mob_struct_id.enemies_in_mob_ar) > 0 {
		for(var i = 0; i < array_length(mob_struct_id.enemies_in_mob_ar); i++) {
			
			if mob_struct_id.enemies_in_mob_ar[i] == enemy_struct_id {
				array_delete(mob_struct_id.enemies_in_mob_ar, i, 1);
				enemy_id_found = true;
				break;
			}
		}
	}
	
	if enemy_id_found && array_length(mob_struct_id.enemies_in_mob_ar) <= 0 {
		d($"scr_delete_enemy_struct_from_mob: enemy_struct_id: {enemy_struct_id.name} WAS found and deleted from the mob_struct_id: {mob_struct_id}; that mob is now empty, destroying it now...");
		scr_delete_mob_struct(mob_struct_id);	
	}
	
	if enemy_id_found {
		d($"scr_delete_enemy_struct_from_mob: enemy_struct_id: {enemy_struct_id.name} WAS found and deleted from the mob_struct_id: {mob_struct_id}");
		return true;	
	}
	else {
		d($"scr_delete_enemy_struct_from_mob: enemy_struct_id: {enemy_struct_id.name} was NOT found or deleted from the mob_struct_id: {mob_struct_id}");
		return false;
	}
}