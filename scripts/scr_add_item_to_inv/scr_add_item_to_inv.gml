

function scr_add_item_to_inv(char_struct_id, item_struct_id, equipping_during_creation = false){
	
	if array_length(char_struct_id.inv_ar) < global.max_player_inv {
		
		array_push(char_struct_id.inv_ar, item_struct_id);
	
		if equipping_during_creation == false {
			
			scr_add_str_to_dialogue_ar($"{char_struct_id.name} has picked up the {item_struct_id.item_name}.\n");
		}
		
		return true;
	}
	else {
		scr_add_str_to_dialogue_ar($"{char_struct_id.name} is already carrying too many items to pick that up! Drop or pass an item before attempting to pick up again.");
		
		return false;
	}
}