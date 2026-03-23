


function scr_add_passive_ability(char_struct_id, passive_abil_enum, called_from_str){
	
	if is_undefined(called_from_str) throw("scr_add_passive_ability: called_from_str == undefined");
	
	d($"Entering scr_add_passive_ability: it was called from {called_from_str}, for char: {char_struct_id.name} with passive_abil_enum: {passive_abil_enum}");
	
	if !is_array(char_struct_id.passive_abil_ar) char_struct_id.passive_abil_ar = [];
	
	//Add to ar:
	array_push(char_struct_id.passive_abil_ar,passive_abil_enum);
	
	//Apply passive ability result:
	if passive_abil_enum == passive_abil_type.hardened_skin {
		char_struct_id.armor += 1;	
	}
	
}