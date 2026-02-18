
/* Abilities in char's ability_ar are 1 of 2 things:
An actual item struct id for an instantiated struct of an item.
Just an integer value from the ability_type enum, usuallly representative of a passive ability;
the actual names of such abilities are obtained with scr_return_abil_enum_name
*/

function scr_add_ability(char_struct_id,abil_enum,is_ability_item_boolean = true, equipped_during_creation_boolean = false){
	
	if !is_array(char_struct_id.ability_ar) char_struct_id.ability_ar = [];
	
	if is_ability_item_boolean {
		
		array_push(char_struct_id.ability_ar,abil_enum);
		
	} else {
		array_push(char_struct_id.ability_ar,abil_enum);
		//Apply passive ability result:
		if abil_enum == ability_type.hardened_skin {
			char_struct_id.armor += 1;	
		}
	}
}