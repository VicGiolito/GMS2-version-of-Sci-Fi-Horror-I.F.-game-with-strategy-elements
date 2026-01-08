


function methods_and_funcs_from_python_that_need_converting(){
	
	/*
	
	 def print_room_directions(self):
        import __main__

        __main__.add_text_to_buffer("The following directions are available to you:")

        if len(self.directional_dict) > 0:
            for key, value in self.directional_dict.items():
                move_dir_x = 0
                move_dir_y = 0
                if key == "WEST":
                    move_dir_x = -1
                elif key == "NORTH":
                    move_dir_y = -1
                elif key == "EAST":
                    move_dir_x = 1
                elif key == "SOUTH":
                    move_dir_y = 1
                door_state_str = "undefined"
                if value == ENUM_DOOR_UNLOCKED:
                    door_state_str = "UNLOCKED DOOR"
                elif value == ENUM_DOOR_JAMMED:
                    door_state_str = "JAMMED DOOR"
                elif value == ENUM_DOOR_DESTROYED:
                    door_state_str = "DESTROYED DOOR"
                elif value == ENUM_DOOR_LOCKED:
                    door_state_str = "LOCKED DOOR"
                elif value == ENUM_DOOR_OPEN_SPACE:
                    door_state_str = "OPEN SPACE"

                room_name_str = ""
                #This check is important, as grid locations that are VACUUM are not instantiated as a room.
                if isinstance(self.location_grid[self.grid_y+move_dir_y][self.grid_x+move_dir_x],Room):
                    if self.location_grid[self.grid_y+move_dir_y][self.grid_x+move_dir_x].already_explored_boolean:
                        room_name_str = ": "+self.location_grid[self.grid_y+move_dir_y][self.grid_x+move_dir_x].room_name

                        if isinstance(self.location_grid[self.grid_y+move_dir_y][self.grid_x+move_dir_x].enemies_in_room_list,list):
                            if len(self.location_grid[self.grid_y+move_dir_y][self.grid_x+move_dir_x].enemies_in_room_list) > 0:
                                room_name_str += " (...Enemies lurk here...)"
                    else:
                        room_name_str = ": UNEXPLORED."

                __main__.add_text_to_buffer(f"{key}: {door_state_str}{room_name_str}")


    def print_room_desc(self):
        import __main__

        if not self.powered_status_boolean:
            for i in self.unpowered_room_desc:
                room_str = textwrap.fill(i, TOTAL_LINE_W)
                __main__.add_text_to_buffer(room_str)
                __main__.add_text_to_buffer("")

        else:
            for i in self.powered_room_desc:
                room_str = textwrap.fill(i, TOTAL_LINE_W)
                __main__.add_text_to_buffer(room_str)
                __main__.add_text_to_buffer("")

    def collect_scavenge_from_room(self ,scavenging_char_id):
        import __main__

        #Define instance level vars, these will be returned to our main.py file:
        food_total, ammo_total, basic_tech_total, advanced_tech_total, fuel_total, credits_total = 0, 0, 0, 0, 0, 0
        # This will cause our main loop to show any items on the floor in this room:
        self.scavenged_once_boolean = True

        output_str = f"{scavenging_char_id.name} has found the following items in this room:\n"

        for i in range(0 ,len(self.scavenge_resource_list)):
            if i == ENUM_SCAVENGE_RESOURCE_FOOD:
                if self.scavenge_resource_list[i] > 0:
                    food_total += self.scavenge_resource_list[i]
                    output_str += f"+{self.scavenge_resource_list[i]} FOOD.\n"
            elif i == ENUM_SCAVENGE_RESOURCE_AMMO:
                if self.scavenge_resource_list[i] > 0:
                    ammo_total += self.scavenge_resource_list[i]
                    output_str += f"+{self.scavenge_resource_list[i]} AMMUNITION.\n"
            elif i == ENUM_SCAVENGE_RESOURCE_TECH_BASIC:
                if self.scavenge_resource_list[i] > 0:
                    basic_tech_total += self.scavenge_resource_list[i]
                    output_str += f"+{self.scavenge_resource_list[i]} BASIC TECHNOLOGY.\n"
            elif i == ENUM_SCAVENGE_RESOURCE_TECH_ADVANCED:
                if self.scavenge_resource_list[i] > 0:
                    advanced_tech_total += self.scavenge_resource_list[i]
                    output_str += f"+{self.scavenge_resource_list[i]} ADVANCED TECHNOLOGY.\n"
            elif i == ENUM_SCAVENGE_RESOURCE_FUEL_ENGINE:
                if self.scavenge_resource_list[i] > 0:
                    fuel_total += self.scavenge_resource_list[i]
                    plural_s = ""
                    if self.scavenge_resource_list[i] > 1:
                        plural_s = "S"
                    output_str += f"+{self.scavenge_resource_list[i]} NEUTRONIUM FUEL CELL{plural_s}.\n"
            elif i == ENUM_SCAVENGE_RESOURCE_CREDITS:
                if self.scavenge_resource_list[i] > 0:
                    credits_total += self.scavenge_resource_list[i]
                    plural_s = ""
                    if self.scavenge_resource_list[i] > 1:
                        plural_s = "S"
                    output_str += f"+{self.scavenge_resource_list[i]} CREDIT{plural_s}.\n"
            elif i >= ENUM_SCAVENGE_TOTAL_RESOURCES:
                # We are now adding items to the scavenging_char_id's inv_list:
                if isinstance(self.scavenge_resource_list[i], Item):
                    scavenging_char_id.add_item_to_backpack(self.scavenge_resource_list[i])
                    output_str += f"+{self.scavenge_resource_list[i].item_name}.\n"

        # Actually print the massive string we just created:
        __main__.add_text_to_buffer(output_str)

        # Delete the list but keep the variable
        self.scavenge_resource_list = -1
        self.scavenge_resource_list = []
        # Initialize:
        for i in range(0 ,ENUM_SCAVENGE_TOTAL_RESOURCES +1):
            self.scavenge_resource_list.append(-1)

        return food_total, ammo_total, basic_tech_total, advanced_tech_total, fuel_total, credits_total

    def print_scavenge_list_item(self):
        import __main__

        item_found = False
        items_found_str = "There are the following items in this room:\n"
        if len(self.scavenge_resource_list) >= ENUM_SCAVENGE_TOTAL_RESOURCES+1:
            for i in range(ENUM_SCAVENGE_TOTAL_RESOURCES,len(self.scavenge_resource_list)):
                if isinstance(self.scavenge_resource_list[i], Item):
                    item_found = True
                    items_found_str += self.scavenge_resource_list[i].item_name+"\n"

        if item_found:
            __main__.add_text_to_buffer(items_found_str)

    def print_char_list(self,char_team_enum):
        import __main__

        if char_team_enum == ENUM_CHAR_TEAM_PC:
            ar_to_use = self.pcs_in_room_list
        elif char_team_enum == ENUM_CHAR_TEAM_ENEMY:
            ar_to_use = self.enemies_in_room_list
        else:
            ar_to_use = self.neutrals_in_room_list

        if isinstance(ar_to_use, list) and len(ar_to_use) > 0:
            if ar_to_use == self.pcs_in_room_list:
                __main__.add_text_to_buffer("There are the following playable characters in this room:")
                for i in range(0,len(ar_to_use)):
                    __main__.add_text_to_buffer(f"{ar_to_use[i].name}")
                __main__.add_text_to_buffer("")
            else:
                team_str = "enemy"
                if char_team_enum == ENUM_CHAR_TEAM_NEUTRAL:
                    team_str = "friendly"
                # Count occurrences by name using Counter obj from imports
                name_counts = Counter(char.name for char in ar_to_use)
                # Print results
                __main__.add_text_to_buffer(f"There are the following {team_str} characters in this room:")
                for name, count in name_counts.items():
                    plural_str = ""
                    if count > 1:
                        plural_str = f"({count})"
                    __main__.add_text_to_buffer(f"{name} {plural_str}")
                __main__.add_text_to_buffer("")





	*/	
}