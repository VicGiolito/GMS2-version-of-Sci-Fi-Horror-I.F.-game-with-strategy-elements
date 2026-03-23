
//if add_or_remove_boolean == true, add to corrseponding global ar;

//if false, remove from corresponding global ar:

function scr_add_remove_char_from_global_ar(char_struct_id,add_or_remove_boolean){
	
	var char_team = char_struct_id.char_team_enum;
	
	if char_team == team_type.pc {
		if add_or_remove_boolean {
			if !is_array(global.pc_char_ar) {
				global.pc_char_ar = [];	
			}
			array_push(global.pc_char_ar,char_struct_id);
		} 
		else {
			global.pc_char_ar = scr_add_remove_val_from_ar(global.pc_char_ar,char_struct_id,true,false);
		}
	}
	
	else if char_team == team_type.enemy {
		if add_or_remove_boolean {
			if !is_array(global.enemy_char_ar) {
				global.enemy_char_ar = [];	
			}
			array_push(global.enemy_char_ar,char_struct_id);
		} 
		else {
			global.enemy_char_ar = scr_add_remove_val_from_ar(global.enemy_char_ar,char_struct_id,true,false);
		}
	}
	
	else if char_team == team_type.neutral {
		if add_or_remove_boolean {
			if !is_array(global.neutral_char_ar) {
				global.neutral_char_ar = [];	
			}
			array_push(global.neutral_char_ar,char_struct_id);
		} 
		else {
			global.neutral_char_ar = scr_add_remove_val_from_ar(global.neutral_char_ar,char_struct_id,true,false);
		}
	}
}