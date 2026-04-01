



function scr_check_combat_start(){
	
	/* Iterate through every char in our g.pc_char_ar. If they haven't participated in a battle and there's
	enemies in their same room, then build our combat_initiative_list, using all other pcs in that room.
	*/
	
	global.char_is_fleeing_bool = false; //reset
	
	d($"Entering scr_check_combat_start now...")
	
	var ar_len = array_length(global.pc_char_ar);
	
	var temp_shuffled_ar = [];
	
	array_copy(temp_shuffled_ar,0,global.pc_char_ar,0,array_length(global.pc_char_ar));
	
	temp_shuffled_ar = scr_shuffle_ar(temp_shuffled_ar);
	
	var char_struct_id, cur_room_struct_id, combat_initiated = false;
	for(var i = 0; i < ar_len; i++) {
		
		char_struct_id = temp_shuffled_ar[i]; //temp_shuffled_ar == pc_char_ar.
		
		d($"scr_check_combat_start: For char_struct_id: {char_struct_id.name}, participated_in_new_turn_battle == {char_struct_id.participated_in_new_turn_battle}, the name of its cur_room is: {char_struct_id.cur_room_id.room_name_str}");
	
		if char_struct_id.participated_in_new_turn_battle == false {
			
			cur_room_struct_id = char_struct_id.cur_room_id;
			
			if is_array(cur_room_struct_id.enemies_in_room_ar) && array_length(cur_room_struct_id.enemies_in_room_ar) > 0 {
				
				d($"scr_check_combat_start: For char_struct_id: {char_struct_id.name}, the enemies in room ar was an array and its length was > 0. Its length is: {array_length(cur_room_struct_id.enemies_in_room_ar)}. This script will return TRUE.");
				
				combat_initiated = true;
				
				//Build our global.combat_rank_ar and global.combat_initiative_ar
				global.combat_rank_ar = -1;
				global.combat_rank_ar = [];
				for(var yy = 0; yy <= 5; yy++) {
					global.combat_rank_ar[yy] = [];	
				}
				
				global.combat_initiative_ar = -1;
				global.combat_initiative_ar = [];
				
				d($"scr_check_combat_start, before adding to g.combat_rank_ar, g.combat_rank_ar looks like: {global.combat_rank_ar}");
				
				//Add pcs in this room to the last combat rank, switch their participated_in_new_turn_battle var:
				var pc_struct_id;
				if is_array(cur_room_struct_id.pcs_in_room_ar) && array_length(cur_room_struct_id.pcs_in_room_ar) > 0 {
					for(var pc_i = 0; pc_i < array_length(cur_room_struct_id.pcs_in_room_ar); pc_i++) {
					
						pc_struct_id = cur_room_struct_id.pcs_in_room_ar[pc_i];
					
						var starting_combat_rank = rank_pos.pc_far;
						array_push(global.combat_rank_ar[starting_combat_rank],pc_struct_id);
						//d($"scr_check_combat_start: At nested array at index 5, pc_struct_id.name == {pc_struct_id.name}");
					
						array_push(global.combat_initiative_ar,pc_struct_id);
						pc_struct_id.participated_in_new_turn_battle = true; //reset
						pc_struct_id.has_fled_combat_bool = false; //reset
						pc_struct_id.cur_combat_rank = starting_combat_rank;
						d($"scr_check_combat_start: {pc_struct_id.name} cur_combat_rank == {pc_struct_id.cur_combat_rank}");
					}
				}
				
				//Add neutrals in this room to the last combat rank:
				var neutral_struct_id;
				if is_array(cur_room_struct_id.neutrals_in_room_ar) && array_length(cur_room_struct_id.neutrals_in_room_ar) > 0 {
					for(var pc_i = 0; pc_i < array_length(cur_room_struct_id.neutrals_in_room_ar); pc_i++) {
					
						neutral_struct_id = cur_room_struct_id.neutrals_in_room_ar[pc_i];
					
						var starting_combat_rank = rank_pos.pc_far;
						array_push(global.combat_rank_ar[starting_combat_rank],neutral_struct_id);
						//d($"scr_check_combat_start: At nested array at index 5, neutral_struct_id.name == {neutral_struct_id.name}");
					
						array_push(global.combat_initiative_ar,neutral_struct_id);
						neutral_struct_id.has_fled_combat_bool = false; //reset
						neutral_struct_id.cur_combat_rank = starting_combat_rank;
						d($"scr_check_combat_start: {neutral_struct_id.name} cur_combat_rank == {neutral_struct_id.cur_combat_rank}");
					}
				}
				
				//Add all enemies in this room to the first combat rank:
				var enemy_struct_id;
				for(var enemy_i = 0; enemy_i < array_length(cur_room_struct_id.enemies_in_room_ar); enemy_i++) {
					
					enemy_struct_id = cur_room_struct_id.enemies_in_room_ar[enemy_i];
					
					var starting_combat_rank = rank_pos.enemy_far; //unless some unique story case calls for it, should be enemy_far
					array_push(global.combat_rank_ar[starting_combat_rank],enemy_struct_id);
					//d($"scr_check_combat_start: At nested array at index 0, enemy_struct_id.name == {enemy_struct_id.name}");
					
					array_push(global.combat_initiative_ar,enemy_struct_id);
					
					enemy_struct_id.cur_combat_rank = starting_combat_rank;
					enemy_struct_id.has_fled_combat_bool = false; //reset
				}
				
				//Randomize, then sort global.combat_initiative_ar based upon speed, and a random value.
				scr_shuffle_ar(global.combat_initiative_ar);
				
				global.combat_initiative_ar = scr_reverse_sort_combat_init_ar(global.combat_initiative_ar);
				
				scr_add_str_to_dialogue_ar($"\nYou are {char_struct_id.name}. There are enemies in the {cur_room_struct_id.room_name_str} that have discovered you and anyone else in the room that was also not hidden. There's no choice now--you'll have to fight for your lives!\n")
				
				d($"\nscr_check_combat_start: after building g.combat_initiative_ar, it looks like this:\n");
				for(var i = 0; i < array_length(global.combat_initiative_ar); i++) {
					
					d($"\ng.combat_initiative_ar[{i}].name == {global.combat_initiative_ar[i].name}\n");	
					
				}
				
				global.combat_begun = true;
				
				return true;
			}
		}
		
		d($"scr_check_combat_start: For char_struct_id: {char_struct_id.name}, the enemies_in_room_ar for this char's cur room either does not exists or its length is not greater than 0.");
	}
	
	d($"scr_check_combat_start: we iterated through every char in the pc_char_ar, but not all of the following conditions returned true: participated_in_new_turn_battle was all == false, and/or enemies_in_room_ar for each char's corresponding room either did not exist or its ar_len was == 0.");
	
	return false;
}