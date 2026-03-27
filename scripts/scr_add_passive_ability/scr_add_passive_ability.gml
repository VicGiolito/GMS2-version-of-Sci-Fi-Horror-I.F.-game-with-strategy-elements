


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
	else if passive_abil_enum == passive_abil_type.thick_hide {
		char_struct_id.armor += 1;	
	}
	else if passive_abil_enum == passive_abil_type.cybernetic {	
		char_struct_id.res_fire += 50;
        char_struct_id.res_vacuum += 50;
        char_struct_id.res_gas += 50;
        char_struct_id.res_electric += -50;
        char_struct_id.char_max_infection = BASE_MAX_INFECTION + 4;
        char_struct_id.res_infect += 50;
        char_struct_id.res_poison += 50;
	}
	else if passive_abil_enum == passive_abil_type.synthetic {
		char_struct_id.armor += 1;	
		
		//Base 'mechanical' resistences
        char_struct_id.res_fire += 100;
        char_struct_id.res_vacuum += 100;
        char_struct_id.res_gas += 100;
        char_struct_id.res_electric += -100;
        char_struct_id.char_max_infection = BASE_MAX_INFECTION + 4;
        char_struct_id.res_infect += 500;
        char_struct_id.res_poison += 500;
        char_struct_id.res_stun += 50;
			
		char_struct_id.morale_immune = true;
		char_struct_id.infection_immune = true;
	}
}