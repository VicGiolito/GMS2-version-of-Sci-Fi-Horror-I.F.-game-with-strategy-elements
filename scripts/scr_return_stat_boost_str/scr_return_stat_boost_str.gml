

function scr_return_stat_boost_str(stat_boost_enum){
	
	var stat_boost_str = "undefined";
	
	if stat_boost_enum== stat_boost.security stat_boost_str = "security";
				
	else if stat_boost_enum== stat_boost.engineering stat_boost_str = "engineering";
				
	else if stat_boost_enum== stat_boost.science stat_boost_str = "science";
				
	else if stat_boost_enum== stat_boost.stealth stat_boost_str = "stealth";
				
	else if stat_boost_enum== stat_boost.scavenging stat_boost_str = "scavenging";
				
	else if stat_boost_enum== stat_boost.strength stat_boost_str = "strength";
				
	else if stat_boost_enum== stat_boost.wisdom stat_boost_str = "wisdom";
				
	else if stat_boost_enum== stat_boost.intelligence stat_boost_str = "intelligence";
				
	else if stat_boost_enum== stat_boost.dexterity stat_boost_str = "dexterity";
				
	else if stat_boost_enum== stat_boost.accuracy stat_boost_str = "accuracy";
				
	else if stat_boost_enum== stat_boost.hp stat_boost_str = "maximum hit points";
				
	else if stat_boost_enum== stat_boost.sanity stat_boost_str = "sanity";
				
	else if stat_boost_enum== stat_boost.action_points stat_boost_str = "action points";
				
	else if stat_boost_enum== stat_boost.armor stat_boost_str = "armor";
				
	else if stat_boost_enum== stat_boost.evasion stat_boost_str = "evasion";
				
	else if stat_boost_enum== stat_boost.fire_res stat_boost_str = "fire resistence";
				
	else if stat_boost_enum== stat_boost.gas_res stat_boost_str = "toxic gas resistence";
				
	else if stat_boost_enum== stat_boost.vacuum_res stat_boost_str = "vacuum resistence";
				
	else if stat_boost_enum== stat_boost.electric_res stat_boost_str = "electric resistence";
	
	return stat_boost_str;
	
}