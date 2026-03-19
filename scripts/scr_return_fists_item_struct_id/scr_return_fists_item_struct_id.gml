

function scr_return_fists_item_struct_id(char_struct_id){
	
	var fists_item_struct_id;
	
	if char_struct_id.char_type_enum == character.ogre {
		fists_item_struct_id = global.item_reference_table[item_type.fists_giant];
	}	
	else if char_struct_id.char_type_enum == character.child {
		fists_item_struct_id = global.item_reference_table[item_type.fists_child];
	}
	else {
		fists_item_struct_id = global.item_reference_table[item_type.fists_adult];	
	}
	
	return fists_item_struct_id;
}