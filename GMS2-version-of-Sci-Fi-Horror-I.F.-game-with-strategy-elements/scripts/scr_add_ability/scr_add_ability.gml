

function scr_add_ability(char_struct_id,item_enum){
	
	if !is_array(char_struct_id.ability_ar) char_struct_id.ability_ar = [];
	array_push(char_struct_id.ability_ar,new global.Item(item_enum));
}