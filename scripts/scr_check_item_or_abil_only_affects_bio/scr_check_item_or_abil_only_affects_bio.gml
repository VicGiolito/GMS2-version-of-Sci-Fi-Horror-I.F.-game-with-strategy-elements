
/* If true, the item or abil will only affect bio characters (medkit, regen nanites, etc.);

if false, the item or abil will affect any type of character.

*/

function scr_check_item_or_abil_only_affects_bio(item_or_abil_enum){
	
	if item_or_abil_enum == item_type.medkit || item_or_abil_enum == item_type.regen_nanites || item_or_abil_enum == item_type.adrenal_pen ||
	item_or_abil_enum == item_type.energizing_stim_prick || item_or_abil_enum == item_type.anti_anxiety_meds || item_or_abil_enum == item_type.field_medicine ||
	item_or_abil_enum == item_type.dna_tester {
		return true;	
	}
	
	return false;
}