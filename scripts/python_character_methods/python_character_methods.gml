// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function python_character_methods(){
	
	/*

    def update_cur_room_id(self):
        self.cur_room_id = self.cur_grid[self.cur_grid_y][self.cur_grid_x]

    def print_char_inv(self):

        import __main__

        #Import helper module for displaying item stats:
        from util.utils import return_item_stats_str, wrap_str

        __main__.add_text_to_buffer(f"{self.name} is wearing and carrying the following items:")

        for i in range(0,len(self.inv_list)):

            #Set default as nothing
            intro_str = ""

            if i == ENUM_EQUIP_SLOT_BODY:
                intro_str = f"Wearing on body: "
            elif i == ENUM_EQUIP_SLOT_ACCESSORY:
                intro_str = f"Wearing as accessory: "
            elif i == ENUM_EQUIP_SLOT_RH:
                intro_str = f"Wielding in right hand: "
            elif i == ENUM_EQUIP_SLOT_LH:
                intro_str = f"Wielding in left hand: "

            if i == ENUM_EQUIP_SLOT_TOTAL_SLOTS:
                __main__.add_text_to_buffer("They are carrying on their person:")

            if isinstance(self.inv_list[i], Item):
                intro_str += f"{i}.) {self.inv_list[i].item_name}. "
                if self.inv_list[i].slot_designation_str == "Accessory":
                    equip_slot_str = f"({self.inv_list[i].slot_designation_str})"
                    intro_str += f"{equip_slot_str}"

                #Add min-max damage, range, max_hits, and all status effects:
                item_stats_str = return_item_stats_str(self.inv_list[i])
                intro_str += item_stats_str

            else:
                intro_str += f"{i}.) Nothing."

            intro_str = wrap_str(intro_str,TOTAL_LINE_W,False)
            __main__.add_text_to_buffer(intro_str)

        __main__.add_text_to_buffer("")
        print \
            ("Simply enter the associated number to use, equip, unequip, or swap an item; or enter 'BACK' to leave the inventory screen.")
        __main__.add_text_to_buffer("You can also enter 'L{ITEM NUMBER} to get a description of the corresponding item;")
        __main__.add_text_to_buffer("Or 'G{ITEM NUMBER} to give the corresponding item to another player;")
        print \
            ("Or 'D{ITEM NUMBER} to drop the item back into your current room (you could retrieve it again with 'SCAVENGE').")
        __main__.add_text_to_buffer("Enter your selection now >")


    def unequip_item(self ,item_inst_id, item_index, starting_equip_boolean = False):
        
        import __main__

        # Remove from corresponding self.inv_list position:
        self.inv_list[item_index] = -1
        # Check to see if this item has a nested list, which indicates that it is a two-handed item;
        # If it is, then be sure to remove from both hand slots:
        if isinstance(item_inst_id.equip_slot_list[0],list):
            self.inv_list[ENUM_EQUIP_SLOT_RH] = -1
            self.inv_list[ENUM_EQUIP_SLOT_LH] = -1
        # add to end of list:
        self.inv_list.append(item_inst_id)
        __main__.add_text_to_buffer(f"{self.name} has unequipped the {item_inst_id.item_name}")
        if item_inst_id.changes_stats_boolean:
            self.change_char_stats(item_inst_id, False, starting_equip_boolean)

    def defunct_swap_equip_item(self ,first_item_id ,first_item_index ,second_item_id ,second_item_index
                        ,starting_equip_boolean = False):
        
        import __main__

        self.inv_list[first_item_index] = second_item_id
        self.inv_list[second_item_index] = first_item_id
        __main__.add_text_to_buffer(f"{self.name} has unequipped the {first_item_id.item_name}, and equipped the {second_item_id.item_name}")
        if first_item_id.changes_stats_boolean:
            self.change_char_stats(first_item_id ,False ,starting_equip_boolean)
        if second_item_id.changes_stats_boolean:
            self.change_char_stats(second_item_id, True ,starting_equip_boolean)

    def add_item_to_backpack(self ,item_id_to_add ,starting_equip_boolean = False):

        import __main__

        self.inv_list.append(item_id_to_add)
        if not starting_equip_boolean:
            __main__.add_text_to_buffer(f"{self.name} has picked up the {item_id_to_add.item_name}")

    def drop_item_into_room(self ,item_id ,item_index ,room_inst_id, print_drop = True,print_change_stats = True):

        import __main__

        # Change stats:
        if item_id.changes_stats_boolean == True:
            if print_change_stats:
                self.change_char_stats(item_id ,False, False)
            else:
                self.change_char_stats(item_id, False, True)
        if item_index < ENUM_EQUIP_SLOT_TOTAL_SLOTS:
            self.inv_list[item_index] = -1 # Change corresponding slot to 'empty'
        elif item_index >= ENUM_EQUIP_SLOT_TOTAL_SLOTS:
            # Delete corresponding position in one of the 'backpack slots':
            del self.inv_list[item_index]
        # Add to room scavenge list:
        # Create scavenge_resource_list for room_inst_id:
        if isinstance(room_inst_id.scavenge_resource_list, list) == False:
            room_inst_id.scavenge_resource_list = []
            for i in range(0 ,ENUM_EQUIP_SLOT_TOTAL_SLOTS):
                room_inst_id.scavenge_resource_list.append(-1)
            room_inst_id.scavenge_resource_list.append(item_id)
        else:
            #Resource indices in the scavenge_resource_list should already exist with integer values, just add item to the end.
            room_inst_id.scavenge_resource_list.append(item_id)

        if print_drop:
            print \
                (f"{self.name} has dropped the {item_id.item_name}. It can be retrieved again from this room using the 'SCAVENGE' command, or by using 'get [item name]' or 'g [item name]'.")
            __main__.add_text_to_buffer("")

    def print_char_stats(self):

        import __main__

        __main__.add_text_to_buffer(f"{self.name} has the following stats:")
        char_stats_str = f"Security: {self.security}, Engineering: {self.engineering}, Science: {self.science}, Stealth: {self.stealth}, Strength: {self.strength}, Intelligence: {self.intelligence}, Widsom: {self.wisdom}, Dexterity: {self.dexterity}, Accuracy: {self.accuracy}, Vacuum Res.: {self.res_vacuum}, Fire Res.: {self.res_fire}, Electric Res.: {self.res_fire}, Gas Res.: {self.res_gas}."
        char_stats_str = textwrap.fill(char_stats_str, TOTAL_LINE_W)
        __main__.add_text_to_buffer(char_stats_str)
        __main__.add_text_to_buffer("")

    def check_valid_item_equip(self,item_id_to_equip):

        import __main__

        #It's a list:
        if isinstance(item_id_to_equip.equip_slot_list,list):
            #Before iterating through the list, set this == False
            invalid_equip_found = False
            #Iterate through our outer list - applicable for all items
            for i in range(0,len(item_id_to_equip.equip_slot_list)):
                #Check to see if there is a nested_list here; if there is, it indicates a two-handed item:
                if isinstance(item_id_to_equip.equip_slot_list[i], list):
                    #In this case we're checking a two-handed item, so if ANY of the equip_slot positions in the char inv_list are filled, return false.
                    for nested_i in range(0,len(item_id_to_equip.equip_slot_list[i])):
                        item_equip_slot = item_id_to_equip.equip_slot_list[i][nested_i]
                        if self.inv_list[item_equip_slot] != -1:
                            __main__.add_text_to_buffer("This item requires two hands to wield; make sure that both of your hands are free before equipping.")
                            invalid_equip_found = True
                            return False
                        #If we iterate through this list and the last corresponding item_equip_slot on the char_inv_list
                        #is still == -1, then this is a valid equip, we can return true now:
                        elif self.inv_list[item_equip_slot] == -1 and nested_i == len(item_id_to_equip.equip_slot_list[i])-1:
                            #__main__.add_text_to_buffer("Debug only: check_valid_item_equip returning TRUE for a two-handed item.")
                            return True

                if invalid_equip_found:
                    break

                #In this case we're checking for a ONE handed item, so if ANY of the corresponding equip slots in the
                # char inv_list are empty, return TRUE
                item_equip_slot = item_id_to_equip.equip_slot_list[i]
                if self.inv_list[item_equip_slot] == -1:
                    #__main__.add_text_to_buffer("Debug only: check_valid_item_equip returning TRUE for one-handed item, body item, or accessory item.")
                    return True
        else: #Else: It must therefore == -1
            __main__.add_text_to_buffer(f"The {item_id_to_equip.item_name} is not an item that can be equipped.")
            return False

        #__main__.add_text_to_buffer(f"check_valid_item_equip method for char_inst {self.name}, for item name: {item_id_to_equip.item_name}, none of our conditions executed, something likely went wrong, returning False.")
        __main__.add_text_to_buffer(f"Can't equip the {item_id_to_equip.item_name}--make sure that the corresponding equipment slot is free.")
        return False

	
	*/
}