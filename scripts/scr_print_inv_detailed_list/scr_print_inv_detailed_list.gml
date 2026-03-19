
/*Prints a more detailed list of the applicable stats for each item in the char's inventory.

All item types:
--armor: evasion and armor mods, plus any resistences conferred.
--shields: evasion and armor mods, plys any resistences conferred.
--weapons: min and max damage, range, shots per attack (aoe_count).
--accessory. items: any and all stat boosts conferred: accuracy, evasion, armor, skills, stat modifiers, etc.
--'use'able items: show 'single use: true/false.' Also print the item's item_desc var.

**The only stats not in the stat_boost_list: dmg_min and max; max_range; status effect chances: bleed, stun, etc.
**aoe_count; can_overwatch_boolean; requires_ammo_boolean; ability_point_cost

*/

function scr_print_inv_detailed_list(char_struct_id){
	
	scr_add_str_to_dialogue_ar("\n");
	
	var inv = char_struct_id.inv_ar;
	
	var ar_len = array_length(inv);
	
	var item_struct_id, item_str, evasion_mod, armor_mod, accuracy_mod, min_dmg, max_dmg, range, shots_per_attack;
	var single_use_bool, bleed_mod, stun_mod, infection_mod, poison_mod, burn_mod, suppress_mod;
	var gas_res, electric_res, fire_res, vacuum_res;
	var item_found = false;
	
	scr_add_str_to_dialogue_ar($"{char_struct_id.name} is carrying the following items:");
	
	for(var i = 0; i < ar_len; i++) {
		
		item_struct_id = inv[i];
		
		item_str = "";
		
		if i == equip_slot.accessory item_str += "Accessory: ";
		else if i == equip_slot.body item_str += "Body: ";
		else if i == equip_slot.rh item_str += "Right hand: ";
		else if i == equip_slot.lh item_str += "Left hand: ";
		
		if is_struct(item_struct_id) && item_struct_id.struct_type_enum == struct_type.Item {
			
			if i >= equip_slot.total_slots item_str += "Carrying: ";
			
			item_found = true;
			
			gas_res = item_struct_id.stat_boost_list[stat_boost.gas_res];
			electric_res = item_struct_id.stat_boost_list[stat_boost.electric_res];
			fire_res = item_struct_id.stat_boost_list[stat_boost.fire_res];
			vacuum_res = item_struct_id.stat_boost_list[stat_boost.vacuum_res];
		
			evasion_mod = item_struct_id.stat_boost_list[stat_boost.evasion];
			armor_mod = item_struct_id.stat_boost_list[stat_boost.armor];
			accuracy_mod = item_struct_id.stat_boost_list[stat_boost.accuracy];
		
			bleed_mod = item_struct_id.bleed_chance;
			stun_mod = item_struct_id.stun_chance;
			infection_mod = item_struct_id.infection_chance;
			poison_mod = item_struct_id.poison_chance;
			burn_mod = item_struct_id.burn_chance;
			suppress_mod = item_struct_id.suppress_chance;
		
			min_dmg = item_struct_id.dmg_min;
			max_dmg = item_struct_id.dmg_max;
			range = item_struct_id.max_range;
			shots_per_attack = item_struct_id.aoe_count;
			single_use_bool = item_struct_id.single_use_boolean;
		
			item_str += item_struct_id.item_name+" - ";
		
			//Shield:
			if item_struct_id.is_shield_boolean == true {
				if evasion_mod > 0 {
					item_str += $"Evasion: {evasion_mod} ";	
				}
				if armor_mod > 0 {
					item_str += $"Armor: {armor_mod}";
				}
			}
			//Useable item:
			else if item_struct_id.usable_boolean == true {
				item_str += item_struct_id.item_desc;	
			}
			else if is_array(item_struct_id.equip_slot_list) && array_length(item_struct_id.equip_slot_list) > 0 {
				//Body equipment:
				if item_struct_id.equip_slot_list[0] == equip_slot.body {
					if evasion_mod > 0 {
						item_str += $"Evasion: {evasion_mod} ";	
					}
					if armor_mod > 0 {
						item_str += $"Armor: {armor_mod} ";
					}	
					if gas_res > 0 {
						item_str += $"Toxic Gas Res.: {gas_res} ";	
					}
					if electric_res > 0 {
						item_str += $"Electric Res.: {electric_res} ";	
					}
					if fire_res > 0 {
						item_str += $"Fire Res.: {fire_res} ";	
					}
					if vacuum_res > 0 {
						item_str += $"Toxic Gas Res.: {vacuum_res}";	
					}
				}
				//Accessory
				else if item_struct_id.equip_slot_list[0] == equip_slot.accessory {
					if evasion_mod > 0 {
						item_str += $"Evasion: {evasion_mod} ";	
					}
					if armor_mod > 0 {
						item_str += $"Armor: {armor_mod} ";
					}
					if accuracy_mod > 0 {
						item_str += $"Accuracy: {accuracy_mod} ";
					}
				}
				//Weapon:
				else {
					if min_dmg >= 0 {
						item_str += $"Dmg.Min-Max: {min_dmg} ";	
					}
					if max_dmg >= 0 {
						item_str += $"-{max_dmg} ";
					}	
					if range >= 0 {
						item_str += $"Range: {range} ";	
					}
					if shots_per_attack > 0 {
						item_str += $"Shots per attack: Up to {shots_per_attack}% ";	
					} 
					if bleed_mod > 0 {
						item_str += $"Bleed: {bleed_mod}% ";	
					}
					if stun_mod > 0 {
						item_str += $"Stun: {stun_mod}% ";	
					}
					if infection_mod > 0 {
						item_str += $"Infection: {infection_mod}% ";	
					}
					if poison_mod > 0 {
						item_str += $"Poison: {poison_mod}% ";	
					}
					if burn_mod > 0 {
						item_str += $"Burn: {burn_mod}% ";	
					}
					if suppress_mod > 0 {
						item_str += $"Suppress: {suppress_mod}% ";	
					}
					if item_struct_id.item_enum == item_type.pulse_pistol || item_struct_id.item_enum == item_type.pulse_rifle {
						item_str += "**Does not consume ammunition**";
					}
				}
			}
		} //End of if is_struct
		
		scr_add_str_to_dialogue_ar($"{item_str}");
	} //End of for loop
	
	if !item_found {
		scr_add_str_to_dialogue_ar($"{char_struct_id.name} has no items.");
	}
}