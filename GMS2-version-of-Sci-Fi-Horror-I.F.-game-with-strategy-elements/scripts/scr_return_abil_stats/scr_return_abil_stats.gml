//Should only be used for 'abilities' that also function as combat weapons:

function scr_return_abil_stats(item_enum) {
    //Gather relevant stats for combat weapon-type ability:
    var item_stats_str = "";
    var item_id = Item(item_enum);
    var aoe_count_str = item_id.aoe_count;
    if aoe_count_str == -1 aoe_count_str = "ALL";

    item_stats_str += $"Damage: {item_id.dmg_min}-{item_id.dmg_max}, range: {item_id.max_range}, max. hits: {aoe_count_str}.";

    //region Build status effects string:
    var item_status_effects_str_ar = [];
    if item_id.burn_chance > 0 array_push(item_status_effects_str_ar,$" BURN: {item_id.burn_chance}%");
    if item_id.bleed_chance > 0 array_push(item_status_effects_str_ar,$" BLEED: {item_id.bleed_chance}%");
    if item_id.poison_chance > 0 array_push(item_status_effects_str_ar,$" POISON: {item_id.poison_chance}%");
    if item_id.stun_chance > 0 array_push(item_status_effects_str_ar,$" STUN: {item_id.stun_chance}%");
    if item_id.suppress_chance > 0 array_push(item_status_effects_str_ar,$" SUPPRESS: {item_id.suppress_chance}%");

    if array_length(item_status_effects_str_ar) >= 1 {
        var item_status_effects_str = scr_concat_ar(item_status_effects_str_ar,", ",".");
        item_stats_str += item_status_effects_str
	}
	
    return item_stats_str
}