
/* Should be run only from the scope of o_con,
and only after next_combat_char has been properly defined, usually with scr_return_next_combat_char_in_init_queue.

Should generally always be run after scr_return_next_combat_char_in_init_queue() is called.
	
	Does the following:
	--Gives us a combat_concluded_result enum with scr_check_combat_end(); 
	--Brings us to combat_paused state.
	--From there, either brings us to init_combat (combat or game has ended);
			or execute_action (enemy is acting next)
			or pc combat assign command (pc is acting next).
	--Defines next_combat_game_state, and next_combat_char (if applicable).
*/

function scr_evaluate_combat_conclusion(called_from_str){
	
	scr_reset_wait();
	
	if is_undefined(called_from_str) throw("scr_evaluate_combat_conclusion: called_from_str was undefined");
	
	d($"\nEntering scr_evaluate_combat_conclusion now, it was called from: {called_from_str} g.cur_combat_char == {global.cur_combat_char.name}, next_combat_char == {next_combat_char.name} and g_cur_combat_char_index == {global.cur_combat_char_index}. Our g.combat_init_ar looks like this:...");
	
	var ar_len = array_length(global.combat_initiative_ar);
	
	for(var uu = 0; uu < ar_len; uu++) {
		d($"... At index ({uu}): {global.combat_initiative_ar[uu].name}...");	
	}
	
	//Advance our g.cur_char:
	
	var char_struct_id, valid_char_found = false, failsafe_val = 0, failsafe_max = array_length(global.combat_initiative_ar)+1;
		
	do {
		//Advance:
		global.cur_combat_char_index++;
			
		if global.cur_combat_char_index < ar_len {
			
			char_struct_id = global.combat_initiative_ar[global.cur_combat_char_index];
			
			if char_struct_id.has_died_bool == false && char_struct_id.has_fled_combat_bool == false {
				valid_char_found = true;
				next_combat_char = global.combat_initiative_ar[global.cur_combat_char_index];
				d($"\nscr_evaluate_combat_conclusion: while ADVANCING the cur_combat_char_index, we found a valid char. next_combat_char = {next_combat_char.name}({next_combat_char.unique_id}), and cur_combat_char_index == {global.cur_combat_char_index}");
				break;
			}
			
			d($"scr_evaluate_combat_conclusion: ADVANCING the char_index: For char_struct_id: {char_struct_id.name}, either its has_died_bool == true or its has_fled_combat_bool == true. cur_combat_char_index == {global.cur_combat_char_index}. We will continue to iterate in this do-until loop.");
		}
		else {
			d($"\nscr_evaluate_combat_conclusion: while ADVANCING the cur_combat_char_index, our index ({global.cur_combat_char_index}) was >= our combat_init_ar ar_len ({ar_len}), therefore we are now resetting index to 0 and assigning -1 to next_combat_char.");
			global.cur_combat_char_index = 0;
			next_combat_char = -1;
			
			break;
		}
			
		failsafe_val++;
	}
	until(valid_char_found == true || failsafe_val >= failsafe_max);
		
	if failsafe_val >= failsafe_max throw("scr_return_next_combat_char_in_init_queue: failsafe_val >= failsafe_max after our do-until trying to determine our next_combat_char while advancing g.cur_combat_char_index -- this should never trigger");
	
	var combat_has_concluded = false; //Reset
	
	var combat_concluded_enum = scr_check_combat_end();
		
	//Provide messages for cases where combat has ended:
	if combat_concluded_enum == combat_concluded_result.pcs_won {
		scr_add_str_to_dialogue_ar("\n");
		scr_add_str_to_dialogue_ar($"All enemies have either fled or been killed. You have lived to fight another day. Press any key to continue.");	
		combat_has_concluded = true;
	}
	else if combat_concluded_enum == combat_concluded_result.enemies_won {
		scr_add_str_to_dialogue_ar("\n");
		scr_add_str_to_dialogue_ar($"All playable characters in this room have either fleed or been killed. The enemies cavort and slaver in the wake of their victory. Press any key to continue.");	
		combat_has_concluded = true;
	}
	
	//We move to the next char in the initiative queue:
	if !combat_has_concluded {
		
		d($"scr_evaluate_combat_conclusion: combat has not concluded, therefore we are moving to either combat_assign_pc_command or combat_execute_action...");
		
		//Check to see if our next_combat_char still == -1, which indicates that we reached the end of the g.combat_init_ar;
		//In such a case, we advance g.cur_combat_round, reverse our combat_init_ar based upon speed, and manually g.cur_char index and i:
		if next_combat_char == -1 {
			global.cur_combat_round++;
			
			scr_add_str_to_dialogue_ar("\n");
			scr_add_str_to_dialogue_ar($"Round {global.cur_combat_round} begins.");
			
			d($"\nscr_evaluate_combat_conclusion: next_combat_char == -1, so BEFORE we shuffle and perform a reverse sort on our g.combat_init_ar, it looks like:.... ");
			for(var yy = 0; yy < array_length(global.combat_initiative_ar); yy++) {
				d($"... at index: {yy}: {global.combat_initiative_ar[yy].name} with unique id: {global.combat_initiative_ar[yy].unique_id}");	
			}
			
			//Randomize, then sort global.combat_initiative_ar based upon speed, and a random value.
			global.combat_initiative_ar = scr_shuffle_ar(global.combat_initiative_ar);
				
			global.combat_initiative_ar = scr_reverse_sort_combat_init_ar(global.combat_initiative_ar);
			
			d($"\nscr_evaluate_combat_conclusion: next_combat_char == -1, now AFTER we shuffled and performed a reverse sort on our g.combat_init_ar, now it looks like:.... ");
			for(var yy = 0; yy < array_length(global.combat_initiative_ar); yy++) {
				d($"... at index: {yy}: {global.combat_initiative_ar[yy].name} with unique id: {global.combat_initiative_ar[yy].unique_id}");	
			}
			
			global.cur_combat_char_index = 0;
			
			//Now we need to find our next applicable character again, and adjust our g.cur_combat_char_index appropriately:
			var valid_char_found = false, failsafe_val = 0, failsafe_max = array_length(global.combat_initiative_ar)+1;
			var next_char_id;
			do {
				next_char_id = global.combat_initiative_ar[global.cur_combat_char_index];
				
				//Throw debug error:
				if global.cur_combat_char_index >= array_length(global.combat_initiative_ar) {
					throw("scr_evaluate_combat_conclusion: combat_has_concluded == false and next_combat_char returned -1, so we reset combat_init_ar and started iterating through it from the beginning, yet could not find an applicable char in our array with has_died_bool == false and has_fled_combat_bool == false; something went wrong.");
				}
				
				if next_char_id.has_died_bool == false && next_char_id.has_fled_combat_bool == false {
					d($"\nscr_evaluate_combat_conclusion: next_combat_char == -1 and we finished shuffling and organizing the g.combat_init_ar, then we reset cur_combat_char to 0 and started iterating through g.combat_init_ar again. The first valid char we landed upon was: {next_char_id.name}({next_char_id.unique_id}) and has been assigned to next_combat_char.");
					next_combat_char = global.combat_initiative_ar[global.cur_combat_char_index];
					valid_char_found = true;
					break;
				}
				
				global.cur_combat_char_index++;
				
				failsafe_val++;
			}
			until(valid_char_found || failsafe_val >= failsafe_max);
			
			if failsafe_val >= failsafe_max throw("scr_evaluate_combat_conclusion: failsafe_val >= failsafe_max after our do-until trying to determine our next_combat_char after next_combat_char returned == -1 -- this should never trigger");
		}
		
		//The next_combat_char should now be a struct, reset or reduce some of their combat vars:
		scr_mid_combat_reset_or_reduce_char_combat_vars(next_combat_char);
		
		//Then we decide if we need to move to assign pc command or execute action next:
		if next_combat_char.char_team_enum == team_type.pc {
				
			next_combat_game_state = game_state.combat_assign_pc_command;
				
			global.cur_game_state = game_state.combat_paused;
			
			d($"\nscr_evaluate_combat_conclusion: we will be advancing to combat_assign_pc_command...");
		}
		else {
			
			next_combat_game_state = game_state.combat_execute_action;
			
			global.cur_game_state = game_state.combat_paused;
			
			d($"\nscr_evaluate_combat_conclusion: we will be advancing to execute_action...");
		}
		
		scr_add_str_to_dialogue_ar("\n");
		scr_add_str_to_dialogue_ar($"... Press any key to continue to the next character in the initiative queue...");
	}
	
	else if combat_has_concluded {
		
		global.combat_begun = false;
		
		next_combat_game_state = game_state.init_combat;
		
		global.cur_game_state = game_state.combat_paused;
	}
}