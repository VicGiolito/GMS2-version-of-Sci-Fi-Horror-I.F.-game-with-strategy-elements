

function scr_reset_global_overwatch_ar(){
	
	global.overwatch_rank_ar = -1;
	global.overwatch_rank_ar = [];
	
	for(var i = 0; i <= rank_pos.pc_far; i++) {
		global.overwatch_rank_ar[i] = { 
			player_overwatch_ar : [], //Contains both pc and neutral structs
			enemy_overwatch_ar : [] //Contains only enemy structs	
		}	
	}
}