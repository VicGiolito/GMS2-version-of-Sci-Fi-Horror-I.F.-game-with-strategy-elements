

function scr_return_rank_str(rank_pos_int){
	
	var rank_str = "undefined";
	
	if rank_pos_int == rank_pos.enemy_far rank_str = "distant enemy position";
	else if rank_pos_int == rank_pos.enemy_middle rank_str = "middle enemy position";
	else if rank_pos_int == rank_pos.enemy_near rank_str = "close enemy position";
	else if rank_pos_int == rank_pos.pc_near rank_str = "close player position";
	else if rank_pos_int == rank_pos.pc_middle rank_str = "middle player position";
	else if rank_pos_int == rank_pos.pc_far rank_str = "distant player position";
	
	return rank_str;
}