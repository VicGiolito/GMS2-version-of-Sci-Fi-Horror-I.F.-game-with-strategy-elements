
function scr_check_backpack_size_restriction(char_struct_id){
	
	if (array_length(char_struct_id.inv_ar) + 1) <= global.max_player_inv {
		d($"scr_check_backpack_size_restriction: returning true. global.max_player_inv = {global.max_player_inv}, array_length(char_struct_id.inv_ar) + 1 == {array_length(char_struct_id.inv_ar) + 1}");
		return true;	
	}
	
	d($"scr_check_backpack_size_restriction: returning false. global.max_player_inv = {global.max_player_inv}, array_length(char_struct_id.inv_ar) + 1 == {array_length(char_struct_id.inv_ar) }")
	return false;
}