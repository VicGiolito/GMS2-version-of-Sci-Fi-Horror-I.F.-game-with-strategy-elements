
/* We just iterate through the ar_to_check, if we find the neutral_char_id_to_check within that array, then we return 
the name of the character that controls this neutral.

ar_to_check should be an array that contains pc_ids, such as cur_room_id.pcs_in_room_ar, or global.pc_char_ar.

if return_arr_bool = true, we return the neutrals_following_this_char_ar id;

otherwise, if it == false, we just return the name of the owner as a string.

*/

function scr_return_neutral_owner_id_or_ar(ar_to_check, neutral_char_id_to_check, return_arr_bool){
	
	var ar_len = array_length(ar_to_check), pc_id, neutral_id;
	
	for(var i = 0; i < ar_len; i++) {
		
		pc_id = ar_to_check[i];
		
		if is_struct(pc_id) && pc_id.struct_type_enum == struct_type.Character && pc_id.char_team_enum == team_type.pc {
		
			if is_array(pc_id.neutrals_following_this_char_ar) && array_length(pc_id.neutrals_following_this_char_ar) > 0 {
			
				for(var yy = 0; yy < array_length(pc_id.neutrals_following_this_char_ar); yy++) {
				
					neutral_id = pc_id.neutrals_following_this_char_ar[yy];
				
					if is_struct(neutral_id) && neutral_id.struct_type_enum == struct_type.Character && neutral_id.char_team_enum == team_type.neutral {
					
						//return pc_id
						if return_arr_bool == false {
							if neutral_id == neutral_char_id_to_check {
								return pc_id;	
							}
						}
						//return array:
						else if return_arr_bool == true {
							if neutral_id == neutral_char_id_to_check {
								return pc_id.neutrals_following_this_char_ar;	
							}	
						}
					}
				}
			}
		}
	}
	
	return -1;
}