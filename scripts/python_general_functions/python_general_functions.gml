

function python_general_functions(){
	
	/*
	
"""

from models.item import Item
from models.room import Room
"""

#User defined modules
from models.character import Character
from constants import *

#Built in python modules
import random
import textwrap
from operator import attrgetter

from models.item import Item
from models.room import Room


#region Define help funcs and essential funcs

def test1():
    import __main__

    __main__.add_text_to_buffer("OUTSIDE OF MAIN: FUCK")

def test2():
    import __main__

    __main__.add_text_to_buffer("INSIDE OF MAIN: FUCK")

def return_first_alive_pc(pc_char_list):

    if isinstance(pc_char_list,list):
        if len(pc_char_list) > 0:
            for i in range(0,len(pc_char_list)):
                char_id = pc_char_list[i]
                if char_id.unconscious_boolean == False and char_id.hp_cur > 0:
                    return char_id

    raise Exception("return_first_alive_pc: couldn't find a valid alive pc in our pc_char_list, and yet we called this function. Something went wrong or was poorly planned.")


def drop_all_pc_inventory(pc_id,room_id_to_drop_into):

    two_handed_wep_just_dropped = False

    if isinstance(pc_id.inv_list,list):
        if len(pc_id.inv_list) > 0:
            for i in range(0,len(pc_id.inv_list)):
                item_id = pc_id.inv_list[i]
                if isinstance(item_id,Item):
                    if two_handed_wep_just_dropped == False:
                        pc_id.drop_item_into_room(item_id,i,room_id_to_drop_into,False,False)
                    else:
                        two_handed_wep_just_dropped = False
                        continue
                    #Check to set two_handed_wep_just_dropped var
                    if check_two_handed_item(item_id) == True:
                        two_handed_wep_just_dropped = True

def spawn_combat_minion(spawner_id,combat_initiative_list,combat_rank_list,spawner_was_just_killed_boolean):
    import __main__

    # Spawn a certain number of skittering larva:
    for i in range(0, spawner_id.spawn_minion_count):
        minion_inst = Character(
            ENUM_CHARACTER_ENEMY_SKITTERING_LARVA,
            spawner_id.cur_grid_x,
            spawner_id.cur_grid_y,
            spawner_id.cur_grid,
            ENUM_CHAR_TEAM_ENEMY, True)
        # Add to end of initiative_queue and to spawner's current rank in combat_rank_list
        combat_initiative_list.append(minion_inst)

        combat_rank_list[
            spawner_id.cur_combat_rank].append(
            minion_inst)

        #Set spawned minion's rank:
        minion_inst.cur_combat_rank = spawner_id.cur_combat_rank

        # Print result:
        if spawner_was_just_killed_boolean:
            __main__.add_text_to_buffer(
                f"While in its death throes, a {minion_inst.name} has just violently spawned from the {spawner_id.name}'s back!\n")
        else:
            __main__.add_text_to_buffer(f"A {minion_inst.name} has just violently spawned from the {spawner_id.name}'s back!\n")

    spawner_id.spawn_minion_count = 0

    return combat_initiative_list, combat_rank_list

#Check if a weapon is two handed (true) or one handed (false); if it's neither, returns -1
def check_two_handed_item(item_id):

    if isinstance(item_id.equip_slot_list,list):
        if len(item_id.equip_slot_list) > 0:
            #Indicates two-handed weapon, which are a nested list contained RH and LH equip slot enums:
            if isinstance(item_id.equip_slot_list[0], list):
                return True
            else:
                #Indicates weapon can be equipped in either hand
                if item_id.equip_slot_list[0] == ENUM_EQUIP_SLOT_LH or item_id.equip_slot_list[0] == ENUM_EQUIP_SLOT_RH:
                    return False

    return -1

#removes ALL instances of Character from the corresponding room list:
def remove_team_chars_from_room(room_id,team_enum):

    if team_enum == ENUM_CHAR_TEAM_NEUTRAL:
        if isinstance(room_id.neutrals_in_room_list, list):
            if len(room_id.neutrals_in_room_list) > 0:
                room_id.neutrals_in_room_list.clear()
                return True
    elif team_enum == ENUM_CHAR_TEAM_ENEMY:
        if isinstance(room_id.enemies_in_room_list, list):
            if len(room_id.enemies_in_room_list) > 0:
                room_id.enemies_in_room_list.clear()
                return True
    elif team_enum == ENUM_CHAR_TEAM_PC:
        if isinstance(room_id.pcs_in_room_list, list):
            if len(room_id.pcs_in_room_list) > 0:
                room_id.pcs_in_room_list.clear()
                return True

    return False

#Only checks 1 dimensional lists:
def return_first_team_member_in_list(list_to_check,team_enum):

    if isinstance(list_to_check,list):
        if len(list_to_check) > 0:
            for i in range(0,len(list_to_check)):
                if isinstance(list_to_check[i],Character):
                    if list_to_check[i].char_team_enum == team_enum:
                        return list_to_check[i]

    return -1

def execute_char_combat_flee(combat_initiative_list,combat_rank_list,cur_combat_room_id,fleeing_combat_char_id,fled_to_another_map_boolean):

    import __main__

    if fled_to_another_map_boolean == False:

        #switch boolean var:
        fleeing_combat_char_id.already_fled_this_turn_boolean = True
        #Delete from combat lists:
        rank_pos = fleeing_combat_char_id.cur_combat_rank
        combat_initiative_list.remove(fleeing_combat_char_id)
        combat_rank_list[rank_pos].remove(fleeing_combat_char_id)
        # Delete from curent room:
        fleeing_combat_char_id.add_or_remove_char_from_room_list(cur_combat_room_id, False)
        # Define next room:
        next_room_id = fleeing_combat_char_id.cur_grid[fleeing_combat_char_id.cur_grid_y + fleeing_combat_char_id.fleeing_dir_y][
            fleeing_combat_char_id.cur_grid_x + fleeing_combat_char_id.fleeing_dir_x]
        # Add to next room:
        fleeing_combat_char_id.add_or_remove_char_from_room_list(next_room_id, True)
        #Change 'already explored' boolean in next room to == True
        next_room_id.already_explored_boolean = True
        #Important: Update our char's 'cur' vars:
        fleeing_combat_char_id.cur_grid_x += fleeing_combat_char_id.fleeing_dir_x
        fleeing_combat_char_id.cur_grid_y += fleeing_combat_char_id.fleeing_dir_y
        fleeing_combat_char_id.cur_room_id = fleeing_combat_char_id.cur_grid[fleeing_combat_char_id.cur_grid_y][fleeing_combat_char_id.cur_grid_x]

        #This will allow a new combat to begin in their next room:
        fleeing_combat_char_id.participated_in_new_turn_battle = False

        __main__.add_text_to_buffer(f"{fleeing_combat_char_id.name} has fled {fleeing_combat_char_id.flee_directional_str}...\n")

    #We need to change this char's location_grid, but we haven't implemented any of that yet,
    # so not sure how to proceed just yet:
    elif fled_to_another_map_boolean:
        __main__.add_text_to_buffer(f"fled_to_another_map_boolean == TRUE -- THIS FEATURE HASN'T BEEN IMPLEMENTED YET.")

#If a door is not locked or jammed, it's considered valid
def return_valid_door_dir(room_id,dir_dict_key):

    import __main__

    if isinstance(room_id,Room):
        if dir_dict_key in room_id.directional_dict:
            if (room_id.directional_dict[dir_dict_key] != ENUM_DOOR_LOCKED and
            room_id.directional_dict[dir_dict_key] != ENUM_DOOR_JAMMED):
                return True
    else:
        __main__.add_text_to_buffer(f"return_valid_door_dir: room_id: {room_id} was not an instance of Room, something went wrong.")
    return False

def return_combat_char_summary_string(cur_combat_char,ammo_total):
    # Use vars to account for things like adrenal pen and other abilities, which boost stats in combat only - they don't permanently boost the actual stat.
    cur_char_infection = cur_combat_char.infection_count
    total_char_spd = cur_combat_char.speed
    total_char_acc = cur_combat_char.accuracy
    total_char_armor = cur_combat_char.armor
    total_char_evasion = cur_combat_char.evasion
    if cur_combat_char.shield_bonus_count > 0:
        total_char_evasion += ENUM_PERSONAL_SHIELD_BONUS
        total_char_armor += ENUM_PERSONAL_SHIELD_BONUS
    if cur_combat_char.hold_the_line_count > 0:
        total_char_evasion += ENUM_HOLD_THE_LINE_EVADE_BONUS
    if cur_combat_char.adrenal_pen_count > 0:
        total_char_spd += ENUM_ADRENAL_PEN_BONUS
        total_char_acc += ENUM_ADRENAL_PEN_BONUS
    status_effects_str = return_status_effects_str(cur_combat_char)
    char_summary_str = wrap_str(f"You are {cur_combat_char.name}. "
                                f"You have {cur_combat_char.hp_cur}/{cur_combat_char.hp_max} hit points, "
                                f"{cur_combat_char.sanity_cur}/{cur_combat_char.sanity_max} sanity points, "
                                f"{cur_combat_char.ability_points_cur}/{cur_combat_char.ability_points_max} ability points, "
                                f"{total_char_armor} armor, "
                                f"{total_char_evasion} evasion, "
                                f"{total_char_acc} accuracy, "
                                f"{total_char_spd} speed, "
                                f"and {cur_char_infection}/{cur_combat_char.char_max_infection} infection points. "
                                f"The party has {ammo_total} ammunition between them. {status_effects_str}",
                                TOTAL_LINE_W, False)

    return char_summary_str

#Functions similarly to our INIT_COMBAT game state, we just check our pc_char_list, and if there's an enemy in that
#room, we return true
def check_combat_start(pc_char_list):

    for i in range(0, len(pc_char_list)):
        # Define pc_char vars:
        pc_inst = pc_char_list[i]
        occupying_grid_id = pc_inst.cur_grid
        cur_combat_room_id = occupying_grid_id[pc_inst.cur_grid_y][pc_inst.cur_grid_x]

        if isinstance(cur_combat_room_id.enemies_in_room_list, list) and len(cur_combat_room_id.enemies_in_room_list) > 0:
            if pc_inst.participated_in_new_turn_battle == False:
                return True

    return False

def execute_non_attack_ability(item_id,casting_char_id,combat_initiative_list,combat_rank_list):

    import __main__

    abil_enum = item_id.item_enum

    if abil_enum == ENUM_ITEM_PERSONAL_SHIELD_GENERATOR:
        casting_char_id.shield_bonus_count = 4
        casting_char_id.suppress_immune_boolean = True
        if casting_char_id.suppressed_count > 0:
            casting_char_id.suppressed_count = 0
        result_str = wrap_str(f"{casting_char_id.name} has activated their {item_id.item_name}. They have been cleared of suppression and have become suppression immune, and will also receive +{ENUM_PERSONAL_SHIELD_BONUS} armor and +{ENUM_PERSONAL_SHIELD_BONUS} evasion for {casting_char_id.shield_bonus_count-1} turns.\n",TOTAL_LINE_W,False)
        __main__.add_text_to_buffer(result_str)
        __main__.add_text_to_buffer("")

    elif abil_enum == ENUM_ITEM_HOLD_THE_LINE:

        for i in range(0,len(combat_initiative_list)):
            if (combat_initiative_list[i].char_team_enum == ENUM_CHAR_TEAM_PC
                    or combat_initiative_list[i].char_team_enum == ENUM_CHAR_TEAM_NEUTRAL):
                combat_initiative_list[i].hold_the_line_count = 4

        dialogue_str = wrap_str(f"'SMOKE OUT!' Cooper tosses a smoke grenade. (All friendly characters receive +{ENUM_HOLD_THE_LINE_EVADE_BONUS} evasion for {combat_initiative_list[i].hold_the_line_count-1} turns.)",TOTAL_LINE_W,False)
        __main__.add_text_to_buffer(dialogue_str)
        __main__.add_text_to_buffer("")

    elif (abil_enum == ENUM_ITEM_SPAWN_LIGHT_SENTRY_GUN or abil_enum == ENUM_ITEM_SPAWN_BUZZSAW_DROID or
    abil_enum == ENUM_ITEM_SPAWN_LIGHT_SENTINEL_DROID or abil_enum == ENUM_ITEM_SPAWN_LIGHT_FLAMER_DROID or
    abil_enum == ENUM_ITEM_SPAWN_LIGHT_SHOTGUN_DROID):

        char_enum = None
        #Whipstich sentinel:
        if abil_enum == ENUM_ITEM_SPAWN_LIGHT_SENTINEL_DROID:
            char_enum = ENUM_CHARACTER_NEUTRAL_WHIPSTICH_SENTINEL
        #Light sentry gun:
        elif abil_enum == ENUM_ITEM_SPAWN_LIGHT_SENTRY_GUN:
            char_enum = ENUM_CHARACTER_NEUTRAL_LIGHT_SENTRY_DRONE
        #Jittering buzzsaw:
        elif abil_enum == ENUM_ITEM_SPAWN_BUZZSAW_DROID:
            char_enum = ENUM_CHARACTER_NEUTRAL_JITTERING_BUZZSAW
        #Spinning scattershot:
        elif abil_enum == ENUM_ITEM_SPAWN_LIGHT_SHOTGUN_DROID:
            char_enum = ENUM_CHARACTER_NEUTRAL_SPINNING_SCATTERSHOT
        #Fumigating flamer:
        elif abil_enum == ENUM_ITEM_SPAWN_LIGHT_FLAMER_DROID:
            char_enum = ENUM_CHARACTER_NEUTRAL_FUMIGATING_FLAMER

        minion_inst = Character(char_enum, casting_char_id.cur_grid_x,
                                casting_char_id.cur_grid_y, casting_char_id.cur_grid,
                                ENUM_CHAR_TEAM_NEUTRAL, True)
        # Add to end of initiative_queue and to attacker's current rank in combat_rank_list
        combat_initiative_list.append(minion_inst)
        combat_rank_list[casting_char_id.cur_combat_rank].append(minion_inst)
        minion_inst.cur_combat_rank = casting_char_id.cur_combat_rank
        # Print result:
        __main__.add_text_to_buffer(f"{casting_char_id.name} has just finished building a {minion_inst.name} at this position!\n")

#Should only be used for 'abilities' that also function as combat weapons:
def return_abil_stats(item_enum):
    # Gather relevant stats for combat weapon-type ability:
    item_stats_str = ""
    item_id = Item(item_enum)
    aoe_count_str = item_id.aoe_count
    if aoe_count_str == -1:
        aoe_count_str = "ALL"

    item_stats_str += f"Damage: {item_id.dmg_min}-{item_id.dmg_max}, range: {item_id.max_range}, max. hits: {aoe_count_str}."

    # region Build status effects string:
    item_status_effects_str_list = []
    if item_id.burn_chance > 0:
        item_status_effects_str_list.append(f" BURN: {item_id.burn_chance}%")
    if item_id.bleed_chance > 0:
        item_status_effects_str_list.append(f" BLEED: {item_id.bleed_chance}%")
    if item_id.poison_chance > 0:
        item_status_effects_str_list.append(f" POISON: {item_id.poison_chance}%")
    if item_id.stun_chance > 0:
        item_status_effects_str_list.append(f" STUN: {item_id.stun_chance}%")
    if item_id.suppress_chance > 0:
        item_status_effects_str_list.append(f" SUPPRESS: {item_id.suppress_chance}%")

    if len(item_status_effects_str_list) >= 1:
        item_status_effects_str = ", ".join(item_status_effects_str_list)
        item_stats_str += item_status_effects_str

    return item_stats_str

def return_item_stats_str(item_id):

    # Display min-max damage, range, max_hits, and all status effects for lh or rh items;
    # or armor-evasion and other resistences/buffs/debuffs if body or accessory slot:
    item_stats_str = ""

    #Display min-max damage, range, max_hits:
    item_is_lh_or_rh = False
    item_is_body_or_accessory_slot = False
    break_from_outer_loop = False

    if isinstance(item_id.equip_slot_list,list):
        for i in range(0,len(item_id.equip_slot_list)):
            if isinstance(item_id.equip_slot_list[i],list):
                for nested_i in range(0,len(item_id.equip_slot_list[i])):

                    if ((item_id.equip_slot_list[i][nested_i] == ENUM_EQUIP_SLOT_LH or
                    item_id.equip_slot_list[i][nested_i] == ENUM_EQUIP_SLOT_RH) and
                    item_id.is_shield_boolean == False):
                        item_is_lh_or_rh = True
                        break_from_outer_loop = True
                        break

                    elif ((item_id.equip_slot_list[i][nested_i] == ENUM_EQUIP_SLOT_BODY or
                    item_id.equip_slot_list[i][nested_i] == ENUM_EQUIP_SLOT_ACCESSORY) or
                    item_id.is_shield_boolean == True):
                        item_is_body_or_accessory_slot = True
                        break_from_outer_loop = True
                        break
            else:
                if break_from_outer_loop:
                    break

                if ((item_id.equip_slot_list[i] == ENUM_EQUIP_SLOT_LH or
                item_id.equip_slot_list[i] == ENUM_EQUIP_SLOT_RH) and
                item_id.is_shield_boolean == False):
                    item_is_lh_or_rh = True
                    break

                elif (item_id.equip_slot_list[i] == ENUM_EQUIP_SLOT_BODY or
                item_id.equip_slot_list[i] == ENUM_EQUIP_SLOT_ACCESSORY
                or item_id.is_shield_boolean == True):
                    item_is_body_or_accessory_slot = True
                    break

        if item_is_lh_or_rh:
            #Gather relevant stats for lh or rh item:
            aoe_count_str = item_id.aoe_count
            if aoe_count_str == -1:
                aoe_count_str = "ALL"

            item_stats_str += f"Damage: {item_id.dmg_min}-{item_id.dmg_max}, range: {item_id.max_range}, max. hits: {aoe_count_str}."

             # region Build status effects string:
            item_status_effects_str_list = []

            if item_id.burn_chance > 0:
                item_status_effects_str_list.append(f" BURN: {item_id.burn_chance}%")
            if item_id.bleed_chance > 0:
                item_status_effects_str_list.append(f" BLEED: {item_id.bleed_chance}%")
            if item_id.poison_chance > 0:
                item_status_effects_str_list.append(f" POISON: {item_id.poison_chance}%")
            if item_id.stun_chance > 0:
                item_status_effects_str_list.append(f" STUN: {item_id.stun_chance}%")
            if item_id.suppress_chance > 0:
                    item_status_effects_str_list.append(f" SUPPRESS: {item_id.suppress_chance}%")

            if len(item_status_effects_str_list) >= 1:
                #add_text_to_buffer(f"DEBUG: return_status_effects_str: status_effects_str == {status_effect_str_list}")
                item_status_effects_str = ", ".join(item_status_effects_str_list)
                item_stats_str += item_status_effects_str

        #Gather relevant stats if this is a body or accessory item:
        elif item_is_body_or_accessory_slot:
            stat_change_str_list = []
            if isinstance(item_id.stat_boost_list,list):
                #add_text_to_buffer(f"DEBUG: return_item_stats_str: item_id.status_effect_list == {item_id.stat_boost_list}")
                for i in range(0, len(item_id.stat_boost_list)):
                    if i == ENUM_ITEM_STAT_BOOST_SECURITY and item_id.stat_boost_list[i] != 0:
                        stat_change_str_list.append(f"Security: {item_id.stat_boost_list[i]}")
                    elif i == ENUM_ITEM_STAT_BOOST_ENGINEERING and item_id.stat_boost_list[i] != 0:
                        stat_change_str_list.append(f"Engineering: {item_id.stat_boost_list[i]}")
                    elif i == ENUM_ITEM_STAT_BOOST_SCIENCE and item_id.stat_boost_list[i] != 0:
                        stat_change_str_list.append(f"Science: {item_id.stat_boost_list[i]}")
                    elif i == ENUM_ITEM_STAT_BOOST_STEALTH and item_id.stat_boost_list[i] != 0:
                        stat_change_str_list.append(f"Stealth: {item_id.stat_boost_list[i]}")
                    elif i == ENUM_ITEM_STAT_BOOST_STRENGTH and item_id.stat_boost_list[i] != 0:
                        stat_change_str_list.append(f"Strength: {item_id.stat_boost_list[i]}")
                    elif i == ENUM_ITEM_STAT_BOOST_WISDOM and item_id.stat_boost_list[i] != 0:
                        stat_change_str_list.append(f"Wisdom: {item_id.stat_boost_list[i]}")
                    elif i == ENUM_ITEM_STAT_BOOST_INTELLIGENCE and item_id.stat_boost_list[i] != 0:
                        stat_change_str_list.append(f"Intelligence: {item_id.stat_boost_list[i]}")
                    elif i == ENUM_ITEM_STAT_BOOST_DEXTERITY and item_id.stat_boost_list[i] != 0:
                        stat_change_str_list.append(f"Dexterity: {item_id.stat_boost_list[i]}")
                    elif i == ENUM_ITEM_STAT_BOOST_ACCURACY and item_id.stat_boost_list[i] != 0:
                        stat_change_str_list.append(f"Accuracy: {item_id.stat_boost_list[i]}")
                    elif i == ENUM_ITEM_STAT_BOOST_HP and item_id.stat_boost_list[i] != 0:
                        stat_change_str_list.append(f"Hp Max: {item_id.stat_boost_list[i]}")
                    elif i == ENUM_ITEM_STAT_BOOST_SANITY and item_id.stat_boost_list[i] != 0:
                        stat_change_str_list.append(f"Sanity Max: {item_id.stat_boost_list[i]}")
                    elif i == ENUM_ITEM_STAT_BOOST_ACTION_POINTS and item_id.stat_boost_list[i] != 0:
                        stat_change_str_list.append(f"Sanity Max: {item_id.stat_boost_list[i]}")
                    elif i == ENUM_ITEM_STAT_BOOST_ABILITY_POINTS and item_id.stat_boost_list[i] != 0:
                        stat_change_str_list.append(f"Ability Points Max: {item_id.stat_boost_list[i]}")
                    elif i == ENUM_ITEM_STAT_BOOST_SCAVENGING and item_id.stat_boost_list[i] != 0:
                        stat_change_str_list.append(f"Scavenge: {item_id.stat_boost_list[i]}")
                    elif i == ENUM_ITEM_STAT_BOOST_ARMOR and item_id.stat_boost_list[i] != 0:
                        stat_change_str_list.append(f"Armor: {item_id.stat_boost_list[i]}")
                    elif i == ENUM_ITEM_STAT_BOOST_EVASION and item_id.stat_boost_list[i] != 0:
                        stat_change_str_list.append(f"Evasion: {item_id.stat_boost_list[i]}")
                    elif i == ENUM_ITEM_STAT_BOOST_FIRE_RES and item_id.stat_boost_list[i] != 0:
                        stat_change_str_list.append(f"Fire Res.: {item_id.stat_boost_list[i]}")
                    elif i == ENUM_ITEM_STAT_BOOST_GAS_RES and item_id.stat_boost_list[i] != 0:
                        stat_change_str_list.append(f"Gas Res.: {item_id.stat_boost_list[i]}")
                    elif i == ENUM_ITEM_STAT_BOOST_VACUUM_RES and item_id.stat_boost_list[i] != 0:
                        stat_change_str_list.append(f"Vacuum Res.: {item_id.stat_boost_list[i]}")
                    elif i == ENUM_ITEM_STAT_BOOST_ELECTRIC_RES and item_id.stat_boost_list[i] != 0:
                        stat_change_str_list.append(f"Electric Res.: {item_id.stat_boost_list[i]}")

            #Append to str as string element if applicable:
            if len(stat_change_str_list) >= 1:
                #add_text_to_buffer(f"DEBUG: return_status_effects_str: status_effects_str == {status_effect_str_list}")
                stat_change_str = ", ".join(stat_change_str_list)
                item_stats_str += stat_change_str

    return item_stats_str

def return_status_effects_str(char_id):

    status_effect_str_list = []

    if char_id.burning_count > 0:
        status_effect_str_list.append("burning")
    if char_id.bleeding_count > 0:
        status_effect_str_list.append("bleeding")
    if char_id.infection_count > 0:
        status_effect_str_list.append("infected")
    if char_id.poisoned_count > 0:
        status_effect_str_list.append("poisoned")
    if char_id.stun_count > 0:
        status_effect_str_list.append("stunned")
    if char_id.suppressed_count > 0:
        status_effect_str_list.append("suppressed")
    if char_id.adrenal_pen_count > 0:
        status_effect_str_list.append("adrenalized")
    if char_id.hold_the_line_count > 0:
        status_effect_str_list.append("smoke screen")
    if char_id.shield_bonus_count > 0:
        status_effect_str_list.append("personal shield")
    if char_id.healing_nanites_count > 0:
        status_effect_str_list.append("regeneration nanites")
    if char_id.healing_factor_boolean:
        status_effect_str_list.append("healing factor")

    if len(status_effect_str_list) >= 1:
        #add_text_to_buffer(f"DEBUG: return_status_effects_str: status_effects_str == {status_effect_str_list}")
        status_effects_str = ", ".join(status_effect_str_list)
        full_str = "You have the following active status effects: " + status_effects_str + "."
        return full_str
    else:
        return ""

def return_overwatch_rank(acting_char_id,combat_rank_list, char_max_range):
    # Define move_dir as: "which direction is the target rank to my current position?"
    if acting_char_id.cur_combat_rank > acting_char_id.targeted_rank:
        move_dir = -1
    elif acting_char_id.cur_combat_rank < acting_char_id.targeted_rank:
        move_dir = 1
    # elif it == this should never be the case

    #Define max_range:

    overwatch_rank = acting_char_id.cur_combat_rank + (char_max_range * move_dir)

    # Cap:
    if overwatch_rank < 0:
        overwatch_rank = 0
    elif overwatch_rank >= len(combat_rank_list):
        overwatch_rank = len(combat_rank_list) - 1

    return overwatch_rank

def return_target_max_min_weapon_range(combat_rank_list,find_from_rank_int,acting_char_id):

    #Define iterate range:
    if find_from_rank_int != -1:
        starting_rank = find_from_rank_int
        ending_rank = find_from_rank_int+1
    else:
        starting_rank = 0
        ending_rank = len(combat_rank_list)

    weapon_range_list = []

    for i in range(starting_rank,ending_rank):
        if isinstance(combat_rank_list[i],list):
            for nested_i in range(0,len(combat_rank_list[i])):

                char_id = combat_rank_list[i][nested_i]

                #As this script will onyl be used by AI (enemy or neutral) -
                # We only want to check and add item ranges from the opposite team:
                if acting_char_id.char_team_enum == ENUM_CHAR_TEAM_ENEMY and char_id.char_team_enum == ENUM_CHAR_TEAM_ENEMY:
                    continue
                if (acting_char_id.char_team_enum == ENUM_CHAR_TEAM_NEUTRAL and
                (char_id.char_team_enum == ENUM_CHAR_TEAM_NEUTRAL or char_id.char_team_enum == ENUM_CHAR_TEAM_PC)):
                    continue

                #Alright, we've forbidden the opposite team; now change to checking either inv_list (if we're an enemy checking a pc),
                #or ability list if we're an enemy checking a neutral or a neutral checking an enemy (any other case):
                if acting_char_id.char_team_enum == ENUM_CHAR_TEAM_ENEMY and char_id.char_team_enum == ENUM_CHAR_TEAM_PC:
                    item_list_to_check = char_id.inv_list
                else:
                    item_list_to_check = char_id.ability_list

                if isinstance(item_list_to_check,list):
                    for inv_i in range(0,len(item_list_to_check)):
                        if isinstance(item_list_to_check[inv_i],Item):
                            weapon_range_list.append(item_list_to_check[inv_i].max_range)

    random.shuffle(weapon_range_list)
    weapon_range_list.sort()
    max_range = weapon_range_list[len(weapon_range_list)-1]
    min_range = weapon_range_list[0]

    return max_range, min_range

#Used in combat for enemy and neutral AI; simply adds char_ids of the opposing team to the combat_initiative_list,
#and defines their dist_to_enemy attribute by using return_distance_between_ranks(); afterwards, we'll sort the
#nearest_target_list by this attribute to find our nearest target or most distant target rank:
def build_nearest_target_list(combat_initiative_list,origin_char_id):

    nearest_target_list = []

    # Iterate through combat_initiative_list, add pc or neutral (or enemy, if this is a neutral char);
    # Calc dist between each once and self; add:
    for i in range(0, len(combat_initiative_list)):

        char_id = combat_initiative_list[i]

        if origin_char_id.char_team_enum == ENUM_CHAR_TEAM_ENEMY:
            if char_id.char_team_enum == ENUM_CHAR_TEAM_NEUTRAL or char_id.char_team_enum == ENUM_CHAR_TEAM_PC:
                if char_id.unconscious_boolean == False:
                    char_id.dist_to_enemy = return_distance_between_ranks(char_id.cur_combat_rank, origin_char_id.cur_combat_rank)
                    nearest_target_list.append(char_id)

        elif origin_char_id.char_team_enum == ENUM_CHAR_TEAM_NEUTRAL:
            if char_id.char_team_enum == ENUM_CHAR_TEAM_ENEMY:
                char_id.dist_to_enemy = return_distance_between_ranks(char_id.cur_combat_rank, origin_char_id.cur_combat_rank)
                nearest_target_list.append(char_id)

    return nearest_target_list

def print_combat_initiative_list(combat_initiative_list,cur_char):

    import __main__

    __main__.add_text_to_buffer("This is the order of the combat initiative queue:")
    for i in range(0,len(combat_initiative_list)):
        asterisk_str = ""
        if combat_initiative_list[i] == cur_char:
            asterisk_str = "*"
        unconscious_str = ""
        if combat_initiative_list[i].unconscious_boolean:
            plural_str = ""
            if combat_initiative_list[i].unconscious_count-1 != 1:
                plural_str = "s"
            unconscious_str = f"-unconscious: {combat_initiative_list[i].unconscious_count-1} turn{plural_str} left-"
        if combat_initiative_list[i].char_team_enum != ENUM_CHAR_TEAM_ENEMY:
            __main__.add_text_to_buffer(f"{i}.) {combat_initiative_list[i].name}. H.P.:{combat_initiative_list[i].hp_cur}/{combat_initiative_list[i].hp_max}. {unconscious_str}{return_status_effects_str(combat_initiative_list[i])}{asterisk_str}")
        else:
            __main__.add_text_to_buffer(f"{i}.) {combat_initiative_list[i].name}")

def return_status_effect_enum_str(status_effect_enum):

    status_effect_enum_str = "Not defined"

    if status_effect_enum == ENUM_STATUS_EFFECT_POISON:
        status_effect_enum_str = "POISONED"
    elif status_effect_enum == ENUM_STATUS_EFFECT_INFECT:
        status_effect_enum_str = "INFECTED"
    elif status_effect_enum == ENUM_STATUS_EFFECT_BLEED:
        status_effect_enum_str = "BLEED"
    elif status_effect_enum == ENUM_STATUS_EFFECT_STUN:
        status_effect_enum_str = "STUN"
    elif status_effect_enum == ENUM_STATUS_EFFECT_FIRE:
        status_effect_enum_str = "FIRE"
    elif status_effect_enum == ENUM_STATUS_EFFECT_SUPPRESSED:
        status_effect_enum_str = "SUPPRESS"

    return status_effect_enum_str


def apply_status_effects(char_id,item_id):

    import __main__

    #add_text_to_buffer(f"DEBUG: ENTERING FUCKING APPLY_STATUS_EFFECTS: CHAR_id == {char_id.name} for item_id: {item_id.item_name}")
    #Because char_id.status_res_list and item_id.status_effect_list match, we can iterate through them both simultaneously:
    for i in range(0,len(item_id.status_effect_list)):

        status_chance = item_id.status_effect_list[i]
        status_resistence = char_id.status_res_list[i]
        status_effect_str = return_status_effect_enum_str(i)

        #add_text_to_buffer(
            #f"DEBUG: attacker's item was: {item_id.item_name} against defender: {char_id.name}. FOR STATUS EFFECT {status_effect_str}, status_chance == {status_chance}, status_resistence == {status_resistence}")

        if item_id.status_effect_list[i] > 0:

            total_status_chance = status_chance - status_resistence

            if total_status_chance > 0:

                ran_val = random.randint(1,100)

                #add_text_to_buffer(
                    #f"DEBUG: apply_status_effects: their total_status_chance: {total_status_chance} and ran_val = {ran_val}.")

                if ran_val <= total_status_chance:
                    #Define status_effect_str, as this status was applied:
                    if i == ENUM_STATUS_EFFECT_POISON:
                        status_effect_str = "POISONED"
                        char_id.poisoned_count += 2 #Poison can stack, making it more dangerous than fire.
                    elif i == ENUM_STATUS_EFFECT_INFECT:
                        status_effect_str = "INFECTED"
                        char_id.infection_count += 1 #Infection counters don't start to build until back into the main game state
                    elif i == ENUM_STATUS_EFFECT_BLEED:
                        status_effect_str = "BLEEDING"
                        char_id.bleeding_count += 1 #Bleeding can stack
                    elif i == ENUM_STATUS_EFFECT_STUN:
                        #Already stunned characters can't get re-stunned:
                        if char_id.stun_count <= 0 and char_id.stun_immune_boolean == False:
                            status_effect_str = "STUNNED"
                            char_id.stun_count = 2 #Stun can't stack
                            #Also reset some of their stats:
                            char_id.dodge_bonus_boolean = False
                            char_id.will_suppress_boolean = False
                            char_id.will_overwatch_boolean = False
                            char_id.overwatch_rank = -1
                        else:
                            continue
                    elif i == ENUM_STATUS_EFFECT_FIRE:
                        status_effect_str = "BURNING"
                        char_id.burning_count = 3 #Can't stack
                    elif i == ENUM_STATUS_EFFECT_SUPPRESSED:
                        if char_id.suppress_immune_boolean == False:
                            status_effect_str = "SUPPRESSED (can't move, -2 evasion, -2 speed)"
                            char_id.suppressed_count = 2  # Can't stack.
                        else:
                            continue

                    __main__.add_text_to_buffer(f"{char_id.name} is {status_effect_str}!\n")

def resolve_dot_effects(char_id):

    import __main__

    #Fire:
    if char_id.burning_count > 0:
        if not char_id.unconscious_boolean:
            dmg_reduction = int(ENUM_DOT_FIRE * (char_id.res_fire * .01))
            fire_dmg = ENUM_DOT_FIRE - dmg_reduction
            if fire_dmg > 0:
                char_id.hp_cur -= fire_dmg
                #Cap:
                if char_id.hp_cur < 0:
                    char_id.hp_cur = 0
                char_id.burning_count -= 1
                __main__.add_text_to_buffer(f"... {char_id.name} is burning for {fire_dmg} fire damage!... \n")
        #Just clear their DOT stacks:
        else:
            char_id.burning_count = 0

    #Bleeding - deal proportional damage:
    if char_id.bleeding_count > 0:
        if not char_id.unconscious_boolean:
            bleed_dmg = int(char_id.hp_max * .25)
            dmg_reduction = int(bleed_dmg * (char_id.res_bleed * .01))
            bleed_dmg = bleed_dmg - dmg_reduction
            if bleed_dmg > 0:
                char_id.hp_cur -= bleed_dmg
                # Cap:
                if char_id.hp_cur < 0:
                    char_id.hp_cur = 0
                char_id.bleeding_count -= 1
                __main__.add_text_to_buffer(
                    f"... {char_id.name} is bleeding out for {bleed_dmg} damage!... \n")
        # Just clear their DOT stacks:
        else:
            char_id.bleeding_count = 0

    #Poisoned - deal static damage
    if char_id.poisoned_count > 0:
        if not char_id.unconscious_boolean:
            poison_dmg = ENUM_DOT_POISON
            dmg_reduction = int(poison_dmg * (char_id.res_poison * .01))
            poison_dmg = poison_dmg - dmg_reduction
            if poison_dmg > 0:
                char_id.hp_cur -= poison_dmg
                # Cap:
                if char_id.hp_cur < 0:
                    char_id.hp_cur = 0
                char_id.poisoned_count -= 1
                __main__.add_text_to_buffer(f"... {char_id.name} feels the poison coursing in their veins for {poison_dmg} poison damage!... \n")
        # Just clear their DOT stacks:
        else:
            char_id.poisoned_count = 0

    #Always deal damage if you have the boolean for it:
    if char_id.inside_toxic_gas_boolean:
        if not char_id.unconscious_boolean:
            toxic_gas_dmg = int(char_id.hp_max * .25)
            dmg_reduction = int(toxic_gas_dmg * (char_id.res_gas * .01))
            toxic_gas_dmg = toxic_gas_dmg - dmg_reduction
            if toxic_gas_dmg > 0:
                char_id.hp_cur -= toxic_gas_dmg
                # Cap:
                if char_id.hp_cur < 0:
                    char_id.hp_cur = 0
                __main__.add_text_to_buffer(f"... {char_id.name} is choking on toxic fumes for {toxic_gas_dmg} damage!... \n")
        # Don't take any additional damage while already unconscious:
        else:
            pass

    #Always deal damage if you have the boolean for it:
    if char_id.inside_vacuum_boolean:
        if not char_id.unconscious_boolean:
            vacuum_dmg = int(char_id.hp_max * .5)
            dmg_reduction = int(vacuum_dmg * (char_id.res_vacuum * .01))
            vacuum_dmg = vacuum_dmg - dmg_reduction
            if vacuum_dmg > 0:
                char_id.hp_cur -= vacuum_dmg
                # Cap:
                if char_id.hp_cur < 0:
                    char_id.hp_cur = 0
                __main__.add_text_to_buffer(f"... {char_id.name} is asphyxiating from the lack of oxygen, they have taken {toxic_gas_dmg} damage!... \n")
        #Don't take any additional damage while already unconscious:
        else:
            pass

    #Reduce by 1:
    if char_id.unconscious_boolean:
        char_id.unconscious_count -= 1

    if char_id.suppressed_count > 0:
        char_id.suppressed_count -= 1

    if char_id.adrenal_pen_count > 0:
        char_id.adrenal_pen_count -= 1

    if char_id.hold_the_line_count > 0:
        char_id.hold_the_line_count -= 1
        if char_id.hold_the_line_count <= 0:
            result_str = wrap_str(f"{char_id.name}'s is no longer affected by the 'smoke screen' bonus (-{ENUM_HOLD_THE_LINE_EVADE_BONUS} evasion).\n",TOTAL_LINE_W,False)
            __main__.add_text_to_buffer(result_str)

    if char_id.shield_bonus_count > 0:
        char_id.shield_bonus_count -= 1
        if char_id.shield_bonus_count <= 0:
            char_id.suppress_immune_boolean = False
            __main__.add_text_to_buffer(f"{char_id.name}'s PERSONAL SHIELD GENERATOR has flickered off.\n")

    mention_stun_recovery = False
    if char_id.stun_count > 0:
        char_id.stun_count -= 1
        if char_id.stun_count <= 0:
            mention_stun_recovery = True

    #Resolve passive healing effects:
    if char_id.healing_factor_boolean:
        if char_id.healing_factor_cd <= 0:
            if char_id.infection_count > 0:
                char_id.infection_count -= 1
                __main__.add_text_to_buffer(f"**... {char_id.name} has passively purged 1 infection point, due to their HEALING FACTOR.**\n")
            elif char_id.hp_cur < char_id.hp_max:
                char_id.hp_cur += 1
                __main__.add_text_to_buffer(f"**... {char_id.name} has passively healed 1 hit point, due to their HEALING FACTOR.**\n")
            #Reset cd:
            char_id.healing_factor_cd = 2
        #Reduce cd
        char_id.healing_factor_cd -= 1

    if char_id.healing_nanites_count > 0:
        if char_id.hp_cur < char_id.hp_max:
            char_id.hp_cur += 3
            __main__.add_text_to_buffer(f"**... {char_id.name} has passively healed 3 hit points, due to their REGENERATION NANITES.**\n")
            #Cap:
            if char_id.hp_cur > char_id.hp_max:
                char_id.hp_cur = char_id.hp_max
        # Reduce cd
        char_id.healing_nanites_count -= 1


    #Check to see if char 'wakes up'
    if char_id.hp_cur > 0 and char_id.unconscious_boolean:
        char_id.unconscious_boolean = False
        __main__.add_text_to_buffer(f"{char_id.name} has woken up!\n")
        if isinstance(char_id.revived_dialogue_str_list, list):
            ran_int = random.randint(0, len(char_id.revived_dialogue_str_list)-1)
            wrapped_dialogue_str = wrap_str(char_id.revived_dialogue_str_list[ran_int],TOTAL_LINE_W,False)
            __main__.add_text_to_buffer(wrapped_dialogue_str)
            __main__.add_text_to_buffer("")

    new_combat_char_killed_boolean = False
    dot_result_str = "undefined"
    if char_id.unconscious_boolean == False and char_id.hp_cur <= 0:
        new_combat_char_killed_boolean = True
        char_id.unconscious_boolean = True
        char_id.unconscious_count = ENUM_BASE_UNCONSCIOUS_COUNT
        dot_result_str = "has collapsed!"
    elif char_id.unconscious_boolean and char_id.unconscious_count <= 0:
        new_combat_char_killed_boolean = True
        char_id.completely_dead_boolean = True
        dot_result_str = "has gasped their last breath!"
    elif mention_stun_recovery and char_id.hp_cur > 0:
        __main__.add_text_to_buffer(f"**{char_id.name} is no longer stunned!**\n")

    if new_combat_char_killed_boolean:
        __main__.add_text_to_buffer(f"**{char_id.name} {dot_result_str}**\n")

    return new_combat_char_killed_boolean

def build_overwatch_list(moving_char_id,combat_initiative_list):
    overwatch_attacker_list = []
    moving_char_team = moving_char_id.char_team_enum

    #Iterate through combat_init_list, adding Chars to the overwatch_attacker_list if they're of the
    #opposing team, and their self.overwatch_rank == moving_char_id.current_rank
    for i in range(0,len(combat_initiative_list)):

        char_id = combat_initiative_list[i]

        if moving_char_team == ENUM_CHAR_TEAM_ENEMY:

            if char_id.char_team_enum == ENUM_CHAR_TEAM_PC or char_id.char_team_enum == ENUM_CHAR_TEAM_NEUTRAL:

                if (char_id.overwatch_rank == moving_char_id.cur_combat_rank and char_id.will_overwatch_boolean
                        and not char_id.unconscious_boolean):

                    overwatch_attacker_list.append(char_id)

        elif moving_char_team == ENUM_CHAR_TEAM_PC or moving_char_team == ENUM_CHAR_TEAM_NEUTRAL:

            if (char_id.char_team_enum == ENUM_CHAR_TEAM_ENEMY and
            char_id.overwatch_rank == moving_char_id.cur_combat_rank and char_id.will_overwatch_boolean and not char_id.unconscious_boolean):

                overwatch_attacker_list.append(char_id)

    return overwatch_attacker_list

#region return_overwatch_or_suppress_capable: if check_overwatch_or_suppress_boolean == true: we check for overwatch;
# if false: we check for suppress.
#returns true if the specified wep ability is available; returns false otherwise
def return_overwatch_or_suppress_capable(char_id,check_overwatch_or_suppress_boolean):
    for i in range(ENUM_EQUIP_SLOT_RH,ENUM_EQUIP_SLOT_LH+1):
        if isinstance(char_id.inv_list[i], Item):
            item_id = char_id.inv_list[i]
            if check_overwatch_or_suppress_boolean:
                if item_id.can_overwatch_boolean:
                    #add_text_to_buffer(f"Debug: return_overwatch_or_suppress_capable: check_overwatch_or_suppress_boolean == {check_overwatch_or_suppress_boolean}, returning TRUE")
                    return True
            elif not check_overwatch_or_suppress_boolean:
                if item_id.can_suppress_boolean:
                    #add_text_to_buffer(f"Debug: return_overwatch_or_suppress_capable: check_overwatch_or_suppress_boolean == {check_overwatch_or_suppress_boolean}, returning TRUE")
                    return True
    #add_text_to_buffer(f"Debug: return_overwatch_or_suppress_capable: check_overwatch_or_suppress_boolean == {check_overwatch_or_suppress_boolean}, returning FALSE")
    return False
#endregion

def advance_or_withdraw_char(move_dir,combat_rank_list,cur_combat_char):

    import __main__

    # Add to next rank in combat_rank_list
    combat_rank_list[cur_combat_char.cur_combat_rank + move_dir].append(cur_combat_char)
    # Remove from cur rank in combat_rank_list
    combat_rank_list[cur_combat_char.cur_combat_rank].remove(cur_combat_char)
    #Update rank:
    cur_combat_char.cur_combat_rank += move_dir
    #print results - whether a character is 'withdrawing' or 'advancing' depends upon their team perspective
    if move_dir == -1:
        if cur_combat_char.char_team_enum != ENUM_CHAR_TEAM_ENEMY:
            __main__.add_text_to_buffer(f"{cur_combat_char.name} advances...\n")
        else:
            __main__.add_text_to_buffer(f"{cur_combat_char.name} withdraws...\n")
    elif move_dir == 1:
        if cur_combat_char.char_team_enum != ENUM_CHAR_TEAM_ENEMY:
            __main__.add_text_to_buffer(f"{cur_combat_char.name} withdraws...\n")
        else:
            __main__.add_text_to_buffer(f"{cur_combat_char.name} advances...\n")
    else:
        __main__.add_text_to_buffer(f"advance_or_withdraw_char: move_dir != -1 or 1, something went wrong. move_dir == {move_dir}.")

    return combat_rank_list

    #Simply returns true if either the ENUM_EQUIP_SLOT_RH or ENUM_EQUIP_SLOT_LH are found in equip_slot_list

#Simply checks to see if there is an item in any position in the char's equip_slot_list that can be equipped in the rh or lh
def check_equip_slot_list_for_rh_or_lh(equip_slot_list):
    for i in range(0,len(equip_slot_list)):
        if isinstance(equip_slot_list[i],list):
            for nested_i in range(0,len(equip_slot_list[i])):
                if (equip_slot_list[i][nested_i] == ENUM_EQUIP_SLOT_RH or
                        equip_slot_list[i][nested_i] == ENUM_EQUIP_SLOT_LH):
                    return True
        else:
            if equip_slot_list[i] == ENUM_EQUIP_SLOT_RH or equip_slot_list[i] == ENUM_EQUIP_SLOT_LH:
                return True

    return False

#Returns TRUE if the combat has concluded
def check_combat_end_condition(cur_combat_room_id):

    import __main__

    combat_concluded_boolean = False
    enemies_won_boolean = False

    if isinstance(cur_combat_room_id.enemies_in_room_list, list):
        if len(cur_combat_room_id.enemies_in_room_list) <= 0:
            __main__.add_text_to_buffer("The last enemy in this room has either fled or been killed!\n")
            combat_concluded_boolean = True
            enemies_won_boolean = False

            return combat_concluded_boolean, enemies_won_boolean

    if isinstance(cur_combat_room_id.pcs_in_room_list, list):
        if len(cur_combat_room_id.pcs_in_room_list) <= 0:
            __main__.add_text_to_buffer("The last playable character in this room has either fled or been killed!\n")
            combat_concluded_boolean = True
            enemies_won_boolean = True

            return combat_concluded_boolean, enemies_won_boolean

    return combat_concluded_boolean, enemies_won_boolean

def return_fists_enum(char_inst_id):
    if char_inst_id.char_type_enum == ENUM_CHARACTER_GAMER:
        fists_item_enum = ENUM_ITEM_FISTS_CHILD
    elif char_inst_id.char_type_enum == ENUM_CHARACTER_OGRE:
        fists_item_enum = ENUM_ITEM_FISTS_GIANT
    else:
        fists_item_enum = ENUM_ITEM_FISTS_ADULT

    return fists_item_enum

def destroy_combatant_inst(combat_rank_list, combat_initiative_list,destroyed_combatant_id, pc_char_list,enemy_char_list,neutral_char_list):

    # Remove from combat_rank_list:
    for i in range(0,len(combat_rank_list)):
        if isinstance(combat_rank_list[i],list):
            try:
                combat_rank_list[i].remove(destroyed_combatant_id)
            except ValueError:
                pass

    # Remove from combat_initiative_list:
    if destroyed_combatant_id in combat_initiative_list:
        combat_initiative_list.remove(destroyed_combatant_id)

    # Remove from corresponding list in room:
    destroyed_combatant_id.add_or_remove_char_from_room_list(destroyed_combatant_id.cur_room_id,False)

    # Remove from our global lists: pc,enemy,neutral:
    if destroyed_combatant_id in pc_char_list:
        pc_char_list.remove(destroyed_combatant_id)
    if destroyed_combatant_id in enemy_char_list:
        enemy_char_list.remove(destroyed_combatant_id)
    if destroyed_combatant_id in neutral_char_list:
        neutral_char_list.remove(destroyed_combatant_id)

    #Not strictly necessary, but good practice:
    del destroyed_combatant_id

    #Always need to return the globals:
    return combat_rank_list, combat_initiative_list, pc_char_list, enemy_char_list,neutral_char_list

def advance_combat_cur_char(cur_combat_char,combat_initiative_list,cur_combat_room_id,cur_combat_round, prev_index_for_cur_combat_char, called_from_str = "undefined",print_called_from_str = False):

    import __main__

    #Trace exactly when this function is being called:
    if print_called_from_str:
        debug_str = wrap_str(f"advance_combat_cur_char: called from: {called_from_str}",TOTAL_LINE_W,False)
        __main__.add_text_to_buffer(debug_str)

    #Deliberately throw error is cur_combat_char is not even an instance of the char class:
    if isinstance(cur_combat_char,Character) == False:
        __main__.add_text_to_buffer(f"advance_combat_cur_char: ERROR: cur_combat_char did not even == an instance of Character. It == {cur_combat_char}. Throw error: {cur_combat_char.non_existant_attribute}")

    # Advance cur_combat_char global var:
    try:
        cur_index = combat_initiative_list.index(cur_combat_char)
    #If they died during the course of their turn (such as while withdrawing or advancing under overwatch),
    #then just use their previous index from when before they died as a reference:
    except ValueError:
        #add_text_to_buffer(f"Debug: advance_combat_cur_char: cur_index for the {cur_combat_char.name} could not be found, which means they were killed and deleted from the combat_init_list; therefore we're using the prev_index_for_cur_combat_char: {prev_index_for_cur_combat_char} as reference instead. We'll attempt to adjust it by - 1 and use it, or 0.")

        #They were deleted from the list, so we need to adjust the cur_index appropriately:
        if prev_index_for_cur_combat_char - 1 >= 0 and prev_index_for_cur_combat_char - 1 < len(combat_initiative_list):
            cur_index = prev_index_for_cur_combat_char-1
        else:
            cur_index = 0
        #add_text_to_buffer(f"Debug: advance_combat_cur_char: cur_index now == {cur_index}. We had to adjust it b.c the {cur_combat_char.name} couldn't be found in the combat_init_list.")

    # check to see if we need to fill and reorganize the combat_initiative_list:
    if cur_index + 1 >= len(combat_initiative_list):
        # Setup combat init list
        combat_initiative_list = fill_combat_initiative_list(cur_combat_room_id)
        # Organize it by speed:
        combat_initiative_list = organize_initiative_list(combat_initiative_list)
        # Assign global cur_combat_char as the first index position:
        cur_combat_char = combat_initiative_list[0]
        #Increment round
        cur_combat_round += 1
        #Print round change:
        __main__.add_text_to_buffer(f"... Round {cur_combat_round} begins... \n")
    else:
        # Assign cur_combat_char as the next char in our initiative_list
        cur_combat_char = combat_initiative_list[cur_index + 1]

    #Now that the cur_combat_char has been defined, reset various 1-turn-only vars for them:
    cur_combat_char.dodge_bonus_boolean = False
    cur_combat_char.will_suppress_boolean = False
    cur_combat_char.will_overwatch_boolean = False
    cur_combat_char.overwatch_rank = -1
    cur_combat_char.resolve_dot_effects_boolean = True
    cur_combat_char.chosen_weapon = -1
    cur_combat_char.is_opportunity_attacker_boolean = False

    # Move to assign commands or execute ai
    if cur_combat_char.char_team_enum == ENUM_CHAR_TEAM_PC:
        cur_game_state = GAME_STATE_COMBAT_ASSIGN_COMMAND
    else:
        cur_game_state = GAME_STATE_COMBAT_EXECUTE_ACTION
        debug_str = wrap_str(f"ADVANCING_COMBAT_CUR_CHAR just executed: cur_combat_char is an enemy or neutral, its: {cur_combat_char.name}, cur_combat_char.resolve_dot_effects_boolean {cur_combat_char.resolve_dot_effects_boolean}, unconscious_boolean = {cur_combat_char.unconscious_boolean}, stun count = {cur_combat_char.stun_count}",TOTAL_LINE_W,False)
        print(debug_str)

    # Always need to return the globals:
    return cur_combat_char, cur_combat_round, cur_game_state, combat_initiative_list

def return_distance_between_ranks(rank_1,rank_2):
    dist_between_ranks = abs(rank_1 - rank_2)
    return dist_between_ranks

def check_for_equipped_weapon(char_id):
    if isinstance(char_id.inv_list,list):
        for i in range(0,len(char_id.inv_list)):
            if isinstance(char_id.inv_list[i],Item):
                if char_id.inv_list[i].is_shield_boolean == False:
                    #This char has at least 1 non-shield item, equipped return true
                    return True

    return False

def return_accuracy_debuff(coord_1, coord_2,item_max_range):
    accuracy_debuff = 0
    dist_to_target = abs(coord_1 - coord_2)
    if dist_to_target > item_max_range:
        accuracy_debuff = abs(dist_to_target - item_max_range)

    return accuracy_debuff

def print_combat_ranks(combat_rank_list,show_distance_debuff = False, item_max_range = 0,acting_char_rank = 0):

    import __main__

    #Create our overwatch_str_list, which lets us know who is targeting what rank with overwatch:
        #Initialize a mirror of our combat_rank_list
    overwatch_str_list = []
    for i in range(0, len(combat_rank_list)):
        if isinstance(combat_rank_list[i], list):
            overwatch_str_list.append([])

    #Fill overwatch_str_list with names from our combat_rank_list, in their corresponding positions:
    for i in range(0, len(combat_rank_list)):
        if isinstance(combat_rank_list[i], list):
            for nested_i in range(0, len(combat_rank_list[i])):
                char_id = combat_rank_list[i][nested_i]
                if char_id.overwatch_rank >= 0:
                    overwatch_str_list[char_id.overwatch_rank].append(char_id.name)

    for i in range(0, len(combat_rank_list)):
        rank_str = ""
        if i == ENUM_RANK_ENEMY_FAR:
            rank_str = f"Distant enemy position: {i}.) "
        elif i == ENUM_RANK_ENEMY_MIDDLE:
            rank_str = f"Middle enemy position: {i}.) "
        elif i == ENUM_RANK_ENEMY_NEAR:
            rank_str = f"Near enemy position: {i}.) "
        elif i == ENUM_RANK_PC_NEAR:
            rank_str = f"Near friendly position: {i}.) "
        elif i == ENUM_RANK_PC_MIDDLE:
            rank_str = f"Middle friendly position: {i}.) "
        elif i == ENUM_RANK_PC_FAR:
            rank_str = f"Distant friendly position: {i}.) "

        characters_at_rank = combat_rank_list[i]

        if len(characters_at_rank) > 0:
            # Count how many of each character name
            name_counts = {}
            for char in characters_at_rank:
                if char.name in name_counts:
                    name_counts[char.name] += 1
                else:
                    name_counts[char.name] = 1

            # Build the string: "Name (count); Name (count)"
            groups = [f"{name} ({count})" if count > 1 else name for name, count in name_counts.items()]
            rank_str += "; ".join(groups)

        #Add '*{OVERWATCH: {names of individual char overwatching this rank}; {another name}; etc*'
        if isinstance(overwatch_str_list[i], list):
            overwatch_str = "" #reset
            title_initialized = False
            for nested_i in range(0,len(overwatch_str_list[i])):
                char_name = overwatch_str_list[i][nested_i]
                if not title_initialized:
                    title_initialized = True
                    overwatch_str += " *OVERWATCHED:"
                overwatch_str += f" {char_name}"
                if nested_i != len(overwatch_str_list[i])-1:
                    overwatch_str += ","
                elif nested_i == len(overwatch_str_list[i])-1 and title_initialized:
                    overwatch_str += "*"

            #Add to rank_str:
            rank_str += overwatch_str

        #Add ' *BEYOND WEAPON'S RANGE* ' to positions beyond this character's item.max_range:
        if show_distance_debuff and item_max_range != -1:
            dist_between_ranks = return_distance_between_ranks(acting_char_rank,i)
            if dist_between_ranks > item_max_range:
                rank_str += f" **BEYOND WEAPON'S RANGE** "

        rank_str = wrap_str(rank_str, TOTAL_LINE_W, False)

        __main__.add_text_to_buffer(rank_str)

def fill_combat_initiative_list(room_inst_id):

    combat_initiative_list = []

    if isinstance(room_inst_id.enemies_in_room_list,list):
        for enemy_i in range(0, len(room_inst_id.enemies_in_room_list)):
            combat_initiative_list.append(room_inst_id.enemies_in_room_list[enemy_i])
    if isinstance(room_inst_id.pcs_in_room_list, list):
        for pc_i in range(0, len(room_inst_id.pcs_in_room_list)):
            combat_initiative_list.append(room_inst_id.pcs_in_room_list[pc_i])
            room_inst_id.pcs_in_room_list[pc_i].participated_in_new_turn_battle = True
    if isinstance(room_inst_id.neutrals_in_room_list, list):
        for pc_i in range(0, len(room_inst_id.neutrals_in_room_list)):
            combat_initiative_list.append(room_inst_id.neutrals_in_room_list[pc_i])
            room_inst_id.neutrals_in_room_list[pc_i].participated_in_new_turn_battle = True

    return combat_initiative_list

#organize organize combat_rank_list by each char's starting_combat_rank:
def organize_combat_rank_list(combat_initiative_list):
    #setup ranklist
    rank_list_to_return = []
    for i in range(0,ENUM_RANK_TOTAL_RANKS):
        rank_list_to_return.append([])

    for rank_i in range(0,len(rank_list_to_return)):
        for char_i in range(0,len(combat_initiative_list)):
            combat_rank = combat_initiative_list[char_i].starting_combat_rank
            if combat_rank == rank_i:
                rank_list_to_return[combat_rank].append(combat_initiative_list[char_i])

    return rank_list_to_return

#Organizes the list and returns a new copy of it using character speed as the organizing factor:
#ar_to_pass should be the main.combat_initiative_list, and should already contain all of the combatants involved in the battle.
def organize_initiative_list(ar_to_pass):

    import __main__

    #Determine random values for each char's ran_init_val
    for i in range(0,len(ar_to_pass)):
        if isinstance(ar_to_pass[i],Character):
            char_inst = ar_to_pass[i]
            suppressed_debuff = 0
            adrenal_pen_buff = 0
            if char_inst.suppressed_count > 0:
                suppressed_debuff = ENUM_SUPPRESSED_SPEED_DEBUFF
            if char_inst.adrenal_pen_count > 0:
                adrenal_pen_buff = ENUM_ADRENAL_PEN_BONUS
            char_inst.ran_init_val = random.randint(0,ENUM_MAX_RAN_INITIATIVE_VAL) + char_inst.speed - suppressed_debuff + adrenal_pen_buff
        else:
            __main__.add_text_to_buffer(f"organize_initiative_list: ar_to_pass[i]: {ar_to_pass[i]} was not an instance of Character, something went very wrong.")
            return False

    #Shuffle first to ensure randomness of tie-breakers:
    random.shuffle(ar_to_pass)

    #Use method to organize ar_to_pass
    ar_to_pass.sort(key=attrgetter('ran_init_val'), reverse = True)

    return ar_to_pass

#Very simple func:
def return_val_in_list(ar_to_search,val_to_find):
    for i in ar_to_search:
        if i == val_to_find:
            return True

    return False

#Expects and returns a list if list_boolean == true
def wrap_str(string_to_wrap,max_len,list_boolean):

    if not list_boolean:
        wrapped_str = textwrap.fill(string_to_wrap, max_len)
    else:
        wrapped_str = []
        for i in string_to_wrap:
            wrapped_str.append(textwrap.fill(i, max_len))
    return wrapped_str

#endregion

	
	
	
	
	
	*/
}