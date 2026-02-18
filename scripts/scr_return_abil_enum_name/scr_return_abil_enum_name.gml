

function scr_return_abil_enum_name(abil_enum){
	
	var abil_str = "undefined";
	
	if abil_enum == ability_type.healing_factor {
		abil_str = "Healing Factor (passive).";	
	}
	else if abil_enum == ability_type.hardened_skin {
		abil_str = "Hardened Frame (passive).";	
	}
	else if abil_enum == ability_type.thick_hide {
		abil_str = "Thick Hide (passive)";	
	}
	
	return abil_str;
}