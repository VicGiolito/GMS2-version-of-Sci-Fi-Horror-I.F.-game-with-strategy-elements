

function scr_check_if_char_may_revive(char_struct_id){
	
	if is_array(char_struct_id.passive_abil_ar) && (scr_check_ar_for_val(char_struct_id.passive_abil_ar, passive_abil_type.healing_factor) || 
	char_struct_id.healing_nanites_count > 0 ) {
		return true;	
	}
	
	return false;
}