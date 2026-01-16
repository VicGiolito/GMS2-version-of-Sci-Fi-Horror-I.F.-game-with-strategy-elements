

function scr_return_chars_str_in_room(room_struct_id){
	
	var chars_in_room_str = "";
	
	if is_array(room_struct_id.enemies_in_room_ar) {
		if array_length(room_struct_id.enemies_in_room_ar) > 0 {
			
			chars_in_room_str += "There are the following enemies in this room:\n";
			
			var grouped_ar = scr_return_grouped_chars_ar(room_struct_id.enemies_in_room_ar);
			
			var grouped_ar_len = array_length(grouped_ar);
			
			if grouped_ar_len > 0 {
				var entity_struct, entity_str = "";
				
				for(var i = 0; i < grouped_ar_len; i++) {
					entity_struct = grouped_ar[i];
					entity_count = entity_struct.char_count;
					entity_str = entity_struct.char_name+"\n";
					if entity_count > 1 {
						entity_str = string_delete(entity_str,string_length(entity_str),1); //Remove our '\n'
						entity_str +=" ("+string(entity_struct.char_count)+")\n";
					}
					
					chars_in_room_str += entity_str;
				}
			}
		}
	}
	
	if is_array(room_struct_id.neutrals_in_room_ar) {
		if array_length(room_struct_id.neutrals_in_room_ar) > 0 {
			
			chars_in_room_str += "There are the following friendly characters in this room:\n";
			
			var grouped_ar = scr_return_grouped_chars_ar(room_struct_id.neutrals_in_room_ar);
			
			var grouped_ar_len = array_length(grouped_ar);
			if grouped_ar_len > 0 {
				var entity_struct, entity_str = "";
				for(var i = 0; i < grouped_ar_len; i++) {
					entity_struct = grouped_ar[i];
					entity_count = entity_struct.char_count;
					entity_str = entity_struct.char_name+"\n";
					if entity_count > 1 {
						entity_str = string_delete(entity_str,string_length(entity_str),1); //Remove our '\n'
						entity_str +=" ("+string(entity_struct.char_count)+")\n";
					}
					
					chars_in_room_str += entity_str;
				}
			}
		}
	}
	
	if is_array(room_struct_id.pcs_in_room_ar) {
		if array_length(room_struct_id.pcs_in_room_ar) > 0 {
			
			chars_in_room_str += "There are the following playable characters in this room:\n";
			
			var grouped_ar = scr_return_grouped_chars_ar(room_struct_id.pcs_in_room_ar);
			
			var grouped_ar_len = array_length(grouped_ar);
			if grouped_ar_len > 0 {
				var entity_struct, entity_str = "", entity_count;
				for(var i = 0; i < grouped_ar_len; i++) {
					entity_struct = grouped_ar[i];
					entity_count = entity_struct.char_count;
					entity_str = entity_struct.char_name+"\n";
					if entity_count > 1 {
						entity_str = string_delete(entity_str,string_length(entity_str),1); //Remove our '\n'
						entity_str +=" ("+string(entity_struct.char_count)+")\n";
					}
					
					chars_in_room_str += entity_str;
				}
			}
		}
	}
	
	return chars_in_room_str;
	
}