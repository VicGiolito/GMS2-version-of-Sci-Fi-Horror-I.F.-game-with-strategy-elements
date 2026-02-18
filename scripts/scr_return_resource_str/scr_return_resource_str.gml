

function scr_return_resource_str(resource_enum){
	
	var resource_enum_str = "undefined";
	
	if resource_enum == scavenge_resource.food resource_enum_str = "food";
	
	else if resource_enum == scavenge_resource.scrap resource_enum_str = "scrap";
	
	else if resource_enum == scavenge_resource.tech_basic resource_enum_str = "basic technology";
	
	else if resource_enum == scavenge_resource.tech_advanced resource_enum_str = "advanced technology";
	
	else if resource_enum == scavenge_resource.ammo resource_enum_str = "ammunition";
	
	else if resource_enum == scavenge_resource.engine_fuel resource_enum_str = "engine fuel";
	
	return resource_enum_str;
}