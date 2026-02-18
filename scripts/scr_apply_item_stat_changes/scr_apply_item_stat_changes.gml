

function scr_apply_item_stat_changes(char_struct_id, item_struct_id, equip_boolean, equipped_during_creation_boolean = false){
	
	if is_array(item_struct_id.stat_boost_list) && array_length(item_struct_id.stat_boost_list) {
		var ar_len = array_length(item_struct_id.stat_boost_list);
		if equip_boolean {
			var equip_val = 1;	
		} else var equip_val = -1;
		
		for(var i = 0; i < ar_len; i++){
			
			var stat_boost_val = item_struct_id.stat_boost_list[i];
			
			if stat_boost_val != 0 {
				
				if i == stat_boost.security char_struct_id.security += stat_boost_val*equip_val;
				
				else if i == stat_boost.engineering char_struct_id.engineering += stat_boost_val*equip_val;
				
				else if i == stat_boost.science char_struct_id.science += stat_boost_val*equip_val;
				
				else if i == stat_boost.stealth char_struct_id.stealth += stat_boost_val*equip_val;
				
				else if i == stat_boost.scavenging char_struct_id.scavenging += stat_boost_val*equip_val;
				
				else if i == stat_boost.strength char_struct_id.strength += stat_boost_val*equip_val;
				
				else if i == stat_boost.wisdom char_struct_id.wisdom += stat_boost_val*equip_val;
				
				else if i == stat_boost.intelligence char_struct_id.intelligence += stat_boost_val*equip_val;
				
				else if i == stat_boost.dexterity char_struct_id.dexterity += stat_boost_val*equip_val;
				
				else if i == stat_boost.accuracy char_struct_id.accuracy += stat_boost_val*equip_val;
				
				else if i == stat_boost.hp char_struct_id.hp_max += stat_boost_val*equip_val;
				
				else if i == stat_boost.sanity char_struct_id.sanity += stat_boost_val*equip_val;
				
				else if i == stat_boost.action_points char_struct_id.action_points += stat_boost_val*equip_val;
				
				else if i == stat_boost.armor char_struct_id.armor += stat_boost_val*equip_val;
				
				else if i == stat_boost.evasion char_struct_id.evasion += stat_boost_val*equip_val;
				
				else if i == stat_boost.fire_res char_struct_id.res_fire += stat_boost_val*equip_val;
				
				else if i == stat_boost.gas_res char_struct_id.res_gas += stat_boost_val*equip_val;
				
				else if i == stat_boost.vacuum_res char_struct_id.res_vacuum += stat_boost_val*equip_val;
				
				else if i == stat_boost.electric_res char_struct_id.res_electric += stat_boost_val*equip_val;
				
				if !equipped_during_creation_boolean {
				
					var stat_boost_str = scr_return_stat_boost_str(i);
				
					scr_add_str_to_dialogue_ar($"{char_struct_id.name} had their {stat_boost_str} modified by {stat_boost_val*equip_val} from the {item_struct_id.item_name}.\n");
				}
			}
		}
	}
	
	
}