

function scr_return_passive_abil_enum_name(passive_abil_enum){
	
	var abil_str = "undefined";
	
	switch(passive_abil_enum) {
		
		case passive_abil_type.hardened_skin:
			abil_str = "Hardened Frame";
		break;
		
		case passive_abil_type.healing_factor:
			abil_str = "Healing Factor";
		break;
		
		case passive_abil_type.cybernetic:
			abil_str = "Cybernetic";
		break;
		
		case passive_abil_type.synthetic:
			abil_str = "Synthetic";
		break;
		
		case passive_abil_type.giant:
			abil_str = "Giant Mutant";
		break;
		
		case passive_abil_type.thick_hide:
			abil_str = "Thick Hide";
		break;
		
		case passive_abil_type.child:
			abil_str = "Child";
		break;
		
		default:
			abil_str = "not captured by switch case.";
		break;
	}
	
	return abil_str;
}