
/* We iterate through an array of char structs, 



*/

function scr_build_char_count_str_from_ar(ar_to_pass){
	
	var char_ar = [];
	
	var char_struct_id, ar_len = array_length(ar_to_pass);
	for(var i = 0; i < ar_len; i++) {
		
		char_struct_id = ar_to_pass[i];
		
		if char_struct_id.has_died_bool == false && char_struct_id.has_fled_combat_bool == false {
	
			if array_length(char_ar) == 0 {
				array_push(char_ar, { char_struct_name: char_struct_id.name, char_count: 1} );
			} else {
				//We iterate through our char_ar, and if its not there, we add it; 
				//if it, we simply increase the corresponding char_count:
				var duplicate_found = false;
				for(var yy = 0; yy < array_length(char_ar); yy++) {
					if char_ar[yy].char_struct_name == char_struct_id.name {
						duplicate_found = true;
						char_ar[yy].char_count++;
						break;
					}
				}
				if !duplicate_found {
					array_push(char_ar, { char_struct_name: char_struct_id.name, char_count: 1 } );	
				}
			}
		}
	}
	
	//Now we build our char_count_str:
	var char_count_str = "";
	
	for(var i = 0; i < array_length(char_ar); i++) {
		char_count_str += $" {char_ar[i].char_struct_name}";
		if char_ar[i].char_count > 1 {
			char_count_str += $" ({char_ar[i].char_count})";		
		}
		//Add semi-colon unless its the last index:
		if i != array_length(char_ar)-1 {
			char_count_str += ";"
		}
	}
	
	return char_count_str;
}