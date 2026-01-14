// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function python_item_methods(){
	
	/*
	
    def print_item_desc(self):
        import __main__

        #__main__.add_text_to_buffer(f"print_item_desc method called for item with name: {self.item_name}")
        wrapped_item_desc_str = textwrap.fill(self.item_desc, TOTAL_LINE_W)
        __main__.add_text_to_buffer(wrapped_item_desc_str)
        __main__.add_text_to_buffer("")

    #target_char_id: the char_id that we're 'u'sing the item on:
    def use_item(self,target_char_id):
        import __main__

        #Medkit or field medicine - they fucntion the same
        if self.item_enum == ENUM_ITEM_MEDKIT or self.item_enum == ENUM_ITEM_FIELD_MEDICINE:
            target_char_id.hp_cur += 5
            #cap:
            if target_char_id.hp_cur > target_char_id.hp_max:
                target_char_id.hp_cur = target_char_id.hp_max
            #Remove applicable debuffs:
            target_char_id.burning_count = 0
            target_char_id.poisoned_count = 0
            target_char_id.bleeding_count = 0
            #Print result:
            result_str = f"{target_char_id.name} has been healed for 5 hit points. They have also been cleared of the burning, poisoned, and bleeding status effects."
            wrapped_message = textwrap.fill(result_str, width=TOTAL_LINE_W)
            __main__.add_text_to_buffer(wrapped_message)
            __main__.add_text_to_buffer("")
            #If target was unconscious - 'wake' them up:
            if target_char_id.unconscious_boolean == True and target_char_id.hp_cur > 0:
                target_char_id.unconscious_boolean = False
                __main__.add_text_to_buffer(f"{target_char_id.name} has woken up!\n")

        elif self.item_enum == ENUM_ITEM_HEALING_NANITE_INJECTOR:
            target_char_id.healing_nanites_count += 3
            result_str = textwrap.fill(f"{target_char_id.name} has been injected with regeneration nanites. They will rapidly heal tissue damage for the next 3 turns.\n",TOTAL_LINE_W)
            __main__.add_text_to_buffer(result_str)
            __main__.add_text_to_buffer("")

        elif self.item_enum == ENUM_ITEM_ADRENAL_PEN:
            target_char_id.adrenal_pen_count += 3
            result_str = textwrap.fill(f"{target_char_id.name} has been injected with adrenaline. They will receive +2 accuracy and +2 speed for the next 3 turns.\n",TOTAL_LINE_W)
            __main__.add_text_to_buffer(result_str)
            __main__.add_text_to_buffer("")

        elif self.item_enum == ENUM_ITEM_ENERGIZING_STIM_PRICK:
            target_char_id.ability_points_cur += ENUM_STIM_PRICK_AP_BOOST
            if target_char_id.ability_points_cur > target_char_id.ability_points_max:
                target_char_id.ability_points_cur = target_char_id.ability_points_max
            result_str = textwrap.fill(f"{target_char_id.name} has been injected with the ENERGIZING STIM. They feel revitalized! (+2 Ability points)\n",TOTAL_LINE_W)
            __main__.add_text_to_buffer(result_str)
            __main__.add_text_to_buffer("")


	
	
	
	
	
	*/
}