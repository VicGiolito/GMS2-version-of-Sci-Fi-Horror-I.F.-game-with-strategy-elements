
/* 
	Reset char_struct_id.participated_in_new_turn_battle to = false
	Increment total turn counter.
	Reduce food global resource
	Apply starvation dmg, if applicable
	Reset AP
	Resolve hazard damage effects.
*/

function scr_end_turn(){
	
	global.full_game_turn_completed = true; //is reset to false whenever game_state.init_combat concludes with no more combat, and we then spread_hazards.
	
	global.total_turn_counter++;
	
	//Reduce global food:
	global.resources_food--;
	
	//Cap: 
	if global.resources_food < 0 { global.resources_food = 0; }
	
	//Check starvation damage:
	
	//Reset AP:
	var ar_len = array_length(global.pc_char_ar);
	for(var i = 0; i < ar_len; i++) {
		//Increase, cap:
		global.pc_char_ar[i].ability_points_cur += 2;
		if global.pc_char_ar[i].ability_points_cur > global.pc_char_ar[i].ability_points_max {
			global.pc_char_ar[i].ability_points_cur = global.pc_char_ar[i].ability_points_max;	
		}
		//Reset:
		global.pc_char_ar[i].move_points_cur = global.pc_char_ar[i].move_points_max;
		global.pc_char_ar[i].already_fled_this_turn_boolean = false;
		global.pc_char_ar[i].participated_in_new_turn_battle = false;
	}
	
}