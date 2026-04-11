


function scr_return_hazards_str_in_room(room_struct_id){
	
	var hazards_str = "undefined";
	
	if is_array(room_struct_id.hazard_ar) && array_length(room_struct_id.hazard_ar) > 0 {
	
		var hazards_str = "The following environmental hazards are in this room:\n";
	
		var hazard_enum, specific_hazard_str;
		for(var i = 0; i < array_length(room_struct_id.hazard_ar); i++){
		
			hazard_enum = room_struct_id.hazard_ar[i];

			if hazard_enum == hazard_type.toxic_gas specific_hazard_str = $"TOXIC GAS - End of turn: Lose {DOT_HAZARD_DMG_TOXIC_GAS} hp. Spreads to adjacent rooms if adjoining door is destroyed.";
			else if hazard_enum == hazard_type.fire specific_hazard_str = $"FIRE - End of turn: Lose {DOT_HAZARD_DMG_FIRE} hp. 50% chance of spreading to adjacent rooms, regardless of door state. Destroys doors as it spreads.";
			else if hazard_enum == hazard_type.vacuum specific_hazard_str = $"VACUUM - Immediately: Lose hp equal to 50% of maximum health. Instantly spreads to all interconnected rooms if adjoining door is destroyed.";
			else if hazard_enum == hazard_type.electric_current specific_hazard_str = $"ELECTRICAL CURRENT - Immediately: Lose {DOT_HAZARD_ELECTRIC_DMG} hp. Deals triple damage to synthetic and cybernetic characters. Organic characters: 50% of becoming stunned for 1 turn; synthetic and cybernetic characters: 100% chance of becoming stunned for 1 turn.";
		
			hazards_str += specific_hazard_str+"\n";
		}
	}
	
	return hazards_str;
}