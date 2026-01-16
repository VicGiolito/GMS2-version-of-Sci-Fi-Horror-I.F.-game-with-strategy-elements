


function scr_return_grouped_chars_ar(ar_to_check){
	
	var grouped_ar = [];
	
	var ar_len = array_length(ar_to_check), char_id;
	
	for(var i = 0; i < ar_len; i++){
		
		char_id = ar_to_check[i];
		
		if is_struct(char_id){
			
			if char_id.struct_type_enum == struct_type.Character {
				
				//Iterate through our grouped_ar and see if they are already there:
				var valid_add = false, nested_ar_len = array_length(grouped_ar);
				
				if nested_ar_len > 0 {
					for(var nested_i = 0; nested_i < nested_ar_len; nested_i++){
						if grouped_ar[nested_i].char_name == char_id.name {
							valid_add = true;
							grouped_ar[nested_i].char_count += 1;
							break;
						}
					}
				}
				
				//Add char_name and char_count as struct to grouped_ar:
				if !valid_add {
					array_push(grouped_ar,{ char_name: char_id.name, char_count: 1 });
				}
			}
		}
	}
	
	return grouped_ar;
}