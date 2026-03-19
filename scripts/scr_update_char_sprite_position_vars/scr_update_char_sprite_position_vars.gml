
/*

room_char_ar: currently should only be the room's pcs_in_room_ar

should be run from the scope of o_con; char_spr_w and h are instance vars.

should be called every time a char moves and only AFTER its cur_room and cur_grid_x and y vars have been updated;

the room array (pcs_in_room_ar) should be for the new room it has moved to.

You need only provide the cur_char_struct_id of the char who has just had their cur_room and cur_grid and y reassigned;
we'll find the appropriate room struct array from there:

*/

function scr_update_char_sprite_position_vars(cur_char_struct_id){
	
	var cur_room_struct_id = cur_char_struct_id.cur_room_id;
	
	var char_team_enum_ = cur_char_struct_id.char_team_enum;
	
	var room_char_ar;
	
	if char_team_enum_ == team_type.pc room_char_ar = cur_room_struct_id.pcs_in_room_ar;
	else if char_team_enum_ == team_type.enemy room_char_ar = cur_room_struct_id.enemies_in_room_ar;
	else if char_team_enum_ == team_type.neutral room_char_ar = cur_room_struct_id.neutrals_in_room_ar;
	
	if is_array(room_char_ar) && array_length(room_char_ar) > 0 {
				
		var ar_len = array_length(room_char_ar), char_id;
		var spr_offset = 16, xx = 0, yy = 0;
				
		for(var i = 0; i < ar_len; i++) {
			
			char_id = room_char_ar[i];
			
			//Define char_sprite_room_x and y:
			char_id.char_sprite_room_x = char_id.cur_grid_x*global.cell_size+global.grid_offset_x+char_spr_w+spr_offset+((char_spr_w*2) * xx);
			char_id.char_sprite_room_y = char_id.cur_grid_y*global.cell_size+global.grid_offset_y+char_spr_h+spr_offset+((char_spr_h*3) * yy);
			
			//Iterate xx:
			xx++;
			
			//Iterate yy:
			if xx >= 7 { xx = 0; yy++; }
		}
	}
	
	
}