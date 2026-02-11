function scr_define_global_and_con_data(){
	
	#region Define our main menu options arrays:
	
	options_menu_str_ar = ["VIDEO OPTIONS","SOUND OPTIONS","GAMEPLAY OPTIONS","BACK"];
	video_options_str_ar = ["CHANGE RESOLUTION","ADJUST BRIGHTNESS","CHANGE FONT","BACK"];
	resolutions_str_ar = ["3840 x 2160","2560 x 1440","1920x1080","1600 x 900","1366 x 768","1280 x 720"];
	
	#endregion
	
	#region Define our intro text:
	
	intro_state = 0; //after pressing enter while on 1, we advance to choose chars.
	
	start_new_game_intro_1 = [
		"Welcome to 'Sector 17', an interactive, science-fiction and horror story generator.\n",
        "\tIn order to survive this scenario, you'll need to use your wits, utilize your party members' strengths, and mitigate their weaknesses.\n",
        "\tThe ultimate goal is to either escape from section 17 with every party member, or utterly destroy the sinister threat that has infested this sector of space.\n",
        "\tThere are multiple endings, and you'll be awarded points at the end of each playthrough depending upon how much you accomplish.\n",
        "\tA word of advice: it is in your best interest to experiment with different characters to fully learn about their strengths and weaknesses--so if this your first playthrough, don't bother deliberating over your party composition too much. You will fail at least several times before learning the strategies that will help you succeed.\n",
		"\tYou can also always enter 'H' or 'HELP' to receive a full list of commands for every stage of the game.\n",
        "\tGood luck!\n",
		"\n",
        "Press enter to continue.\n"
		]
		
	start_new_game_intro_2 = [
		"Somewhere deep within the void of space, the jagged silhouette of a starship passes before a field of stars. Its hard lines and angles are proof of the existence of some greater intelligence in this cold and unforgiving realm. Its towering spires and minarets are testament to the ingenuity and perseverance of untold generations. Yet the vessel is utterly dark, as if it has succumbed at last to the yawning abyss of the universe. It moves as though adrift, pin-wheeling slowly around its center axis.\n",
		"\n",
		"We move closer to it, aiming toward a bulbous section of hull somewhere near its middle...\n",
		"\n",
		"... Moving closer, and closer still, passing through a golden plaque engraved with runes, a serial number, and the image of a wire framed globe, with the spreading rays of some distant star cresting its shoulder...\n",
		"\n",
		"... Moving closer, through layers of steel hull, electronics, insulation...\n",
		"\n",
		"... Emerging from a ceiling fan into a wide circular room.\n",
		"\n",
		"Here the deafening silence of the void is replaced by the hue and cry of wailing klaxons. Red emergency lighting pulses from the floor like the frenzied heart beat of some wounded beast. The room is in ruins, the guts and bones of the ship's infrastructure on full display. Frayed wiring hangs in sheets from the ceiling, while toppled steel girders splay upon the floor. An exposed pipe in one of the walls has been severed and is rapidly leaking a white gas that settles like fog across the room.\n",
		"\n",
		"Row upon row of stasis pods barely breach above the layer of the mist, looming like so many metal coffins in the gloom. They wait like white pearls with throbbing red bellies, beckoning us closer. Their glass lids are fogged with frost.\n",
		"\n",
		"From here, one can see that most of the sleepers within the stasis pods appear entirely content within their pale cribs, indifferent to the apparent chaos that is raging all around them.\n",
		"\n",
		"Three of the sleepers, however, are stirring. Even in hibernation they appear convinced that these glass cages with their white velvet cushions will not become their caskets. Sweat beads upon their brows. Their features twist and contort, fighting against the ephemeral pull of discontented dreams.\n",
		"\n",
		"In the wash of the throbbing, purgatory light, it is difficult to make out their faces.\n",
	    "\n",
		"Who among them will wake, shaken by the last gasp of a failing power system?...\n",
	    "\n",
		"... And who among them will slip deeper still from slumber, into death?\n",
		"\n",
		"Press enter to peruse the stasis pods."
		];
		
	#endregion
	
	#region Help instructions:
	
	global.help_instructions_str_ar = [
		"When choosing characters, enter 'A' or 'ADD' to add a character to your party, or 'R' or 'REMOVE' to remove them. Using the up and down arrow keys changes the currently selected statis pod. You can also enter 'B' or 'BIO' to learn about a character's backstory.\n\n",
        "The following is a list of available commands to be used in the primary game state:\n\n",
        "'SCAVENGE': This command can only be used once per room, and will automatically collect any global resources and items that can be found within the room.\n",
        "\nDirectional commands to move between rooms: 'E' or 'EAST'; 'W' or 'WEST'; 'N' or 'NORTH'; 'S' or 'SOUTH': Costs 1 action point and 1 food per character. You will then be asked which characters in the same room you would also like to move with you, if any. The corresponding direction must be accessible.\n",
        "\n'UNLOCK {DIRECTION}': Consumes one of your key cards to unlock the door in the corresponding direction.\n",
        "\n'JAM {DIRECTION}': Costs 1 action point per character. You will then be asked how many characters in the same room will attempt to jam the door. Uses random scrap items found in the room and your character(s) strength to attempt to jam the door in the corresponding direction. A strength-based skill test will ensue to determine if the action was successful.\n",
        "\n'HIDE': Costs 1 action point to hide a character in the current room, using whatever cover they can find. A stealth-based skill check ensues to determine if this action was successful. Note that the effectiveness of this action is dependent upon the level of cover in the current room, with 'low amounts of cover' providing a 30% chance to remain concealed in the room; 'medium amounts of cover' providing a 60% chance to remain concealed in the room; and 'large amounts of cover' providing a 90% chance to remain concealed in the room.\n",
        "\n'AMBUSH': Costs 1 action point to initiate combat against an enemy or enemies in the current room while a character is HIDDEN, giving you a full extra turn against the enemy. Initiating an ambush will also allow you to add other currently hidden characters to the combat. If you choose not to add them, they will remain hidden and not participate in the battle.\n",
        "\n'INV' or 'INVENTORY': Access the inventory options for the current character.\n",
        "\n'L' or 'LOOK': Describe the room that the current character is standing in once more.\n",
        "\n'STAT' or 'STATS': Examine each of the current character's statistics.\n",
        "\n'P' or 'PARTY': Show a list of all player-controlled characters, along with their corresponding number, which can be used to change the current character.\n",
        "\n<, >, or 0-9: Change control to the corresponding character.\n",
        "\nYou will also notice that many rooms contain keywords in ALL CAPS that represent a feature of the room that the player can interact with. Simply entering the name of these capitalized keywords will allow you to fully interact with that feature.\n",
		"\nThe combat screen has its own unique set of commands, as described in that game state.\n"
	];
	
	#endregion
	
	#region Define our choose_chars game state data:
	
	char_stats_ar = [];
	char_str_ar = [];
	char_bio_ar = [];
	var temp_char_id, primary_role_str, char_class_snippet,char_name;
	
	for(var i = 0; i <= character.security_guard; i++) {
		
		primary_role_str = "Undefined";
        char_class_snippet = "Undefined";
		temp_char_id = new global.Character(i,0,0,global.cur_grid,team_type.pc,false);
		char_name = temp_char_id.name;
		array_push(char_str_ar,string(char_name));
		
		if i == character.ogre {
			primary_role_str = "SECURITY";
			char_class_snippet = "This stubbled brute almost looks like the standard variant of the Keth Corporation clone, only... bigger. Much bigger. Uglier, too.";
			
			array_push(char_bio_ar, [
				"Cragos, 'The Ogre':\n",
                "\nCragos was intended to be just another of the millions of faceless clones born into servitude by the Kethas Corporation, but a power surge in his gestation vat caused an excessive amount of growth hormone to be released into his developmental stew. As a result, he emerged from his birthing chamber weeks before his brothers and sisters, a hulking giant of a man with the mind of a child, and a misshapen face that only a mother could love... If only he had one.\n",
                "\nThe scientists at Keth Corp. were bemused by this unanticipated variant, and rigorously tested his physical and mental capabilities to determine the viability of his strain. They called it 'testing,' but Cragos would soon come to know the euphimism for what it truly was: torture.\n",
                "\nHe was only six weeks old by the time they had subjected him to a battery of tests that included blunt force trauma, precision tissue damage, and unimaginable G-forces, all to determine the tolerances of his physical structure, and also the rate of his healing factor, which surpassed even that of his kin. He was at least spared the psychological conditioning, not by any act of mercy, but merely because he was overlooked and forgotten after the researchers grew bored of his screams, and labeled his mutation as 'UNSATISFACTORY.'\n",
				"\nHe was deemed too large and clumsy to be useful on the battlefield, and a terrible shot, too, owing to the fact that his left eye was positioned considerably lower than his right. He was too hideous even to serve as steward in the gilded homes of the elite back in the Core.\n",
                "\nA simple barcode stamped to the back of his neck designated him as such. He was slated to be reprocessed and recycled, in fact, liquified and fed back to his fellow clones as essential nutrients, had the interstellar freighter that was his home not been attacked by raiders from the Fringe. It was of course Keth Corp. policy to never reveal the secrets of their proprietary technology, and so they reduced the massive hulk of their own starship to ruins in the depths of space, rather than submit to the pirates' boarding party. The brigands did not leave empty handed, however.\n",
                "\nThey found Cragos still clinging to life in a small pressurized compartment in a field of floating debris, like a cockroach that refused to die, or a caterpillar cocooned in stasis, patiently awaiting chrysalis. Unlike the scientists at Keth Corp., they found good use for his muscle among their ranks, all right.\n",
                "\nBanditry was their trade, and his healing factor an invaluable asset. The absence of psychological conditioning had made it possible for Cragos to adjust to their nomadic lifestyle, to view himself as an invidual at last, as a person who could inspire respect--if never love.\n",
                "\nThey named him 'Cragos,' after the son of the stone god who ruled the mountains of their homeworld. And as the years passed he became well known as the most vicious and relentless of their clan. Eventually he outlived them all, and when the very last of their clan had been shot down by enforcers from the Core, Cragos struck out into the void to earn his own coin, plying his trade as a mercenary for hire, a dealer of death and punishment alike. Yet he never forgot the faces of his tormentors who had given him life, and always he hoarded the horror of his past as fuel for future conquests.\n",
                "\nIt was a kidnapping job gone sideways that found him in a stasis chamber aboard the Keth Corp. research vessel 'Niffy.' And there he remains: a caged animal once more, eyes closed, yet not sleeping--always dreaming of vengeance against the inexhaustible and inexorable corporation that made him...\n",
                "\nAlways dreaming... And always promising pain.\n"
				]);
		}
		
		else if i == character.security_guard {
			primary_role_str = "SECURITY";
            char_class_snippet = "If the data on his identity tag is any indication, then this poor fellow's contract was nearly up. Judging by his flabby gullet, it looks like he hasn't seen the inside of a gym in years. At least he entered the stasis pod while wearing some decent equipment."	
		
			array_push(char_bio_ar,"This character's bio hasn't been written yet.");
		}
		
		else if i == character.playboy {
			primary_role_str = "CIVILIAN";
            char_class_snippet = "Immediately identifiable is the handsome scion of the rival conglomerate Boros Incorporated, better known for his sexual conquests than his contributions to the family's sterling legacy. What is he doing here?"
		
			array_push(char_bio_ar,"This character's bio hasn't been written yet.");
		}
		
		else if i == character.criminal {
			primary_role_str = "CIVILIAN";
            char_class_snippet = "The barcode branded across this man's forehead displays his status as nothing more than chattle. It's not difficult to end up on the wrong side of the law as a citizen of any one of the thousands of worlds owned by Keth Corp. What is this man's crime?"
		
			array_push(char_bio_ar,"This character's bio hasn't been written yet.");
		}
		
		else if i == character.child {
			primary_role_str = "CIVILIAN";
            char_class_snippet = "This unfortunate little girl must have been in the wrong place at the wrong time. Where are her parents?"
		
			array_push(char_bio_ar,"This character's bio hasn't been written yet.");
		}
		
		else if i == character.engineer {
			primary_role_str = "ENGINEER";
            char_class_snippet = "His blue overcoat is emblazoned with the Keth Corporation's sigil of a star cresting the shoulder of a shadowed planet. The patch suggests that this is a company man, while the tool belt around his waist indicates that he works for the engineering department, most likely."
		
			array_push(char_bio_ar,"This character's bio hasn't been written yet.");
		}
		
		else if i == character.ceo {
			primary_role_str = "CIVILIAN";
            char_class_snippet = "Oh how the mighty have fallen! This face has been seen by almost everyone with a video feed this side of the galaxy. It's Celeste Mattix, Chief Executive Officer of the interstellar research and development corporation Zephyr Industries. One can only wonder how she lost her first-class seat."
		
			array_push(char_bio_ar,"This character's bio hasn't been written yet.");
		}
		
		else if i == character.service_droid {
			primary_role_str = "ENGINEER";
            char_class_snippet = "This standard service droid has been deactivated for reasons unknown. It is roughly the same size and shape as a man, with a burnished steel frame, articulated joints, and an expressionless face that sports two large mustaches engraved over a mouth slit. It sleeps in the corner of the stasis chamber with the camera lenses of its eyes wide open, seeing nothing. There is some blackened scoring around the junction box on its metal chest; the old scars of laser blasts, no doubt. Is it still operational?"
		
			array_push(char_bio_ar,"This character's bio hasn't been written yet.");
		}
		
		else if i == character.mercenary_cyborg {
			primary_role_str = "SECURITY";
            char_class_snippet = "Half of this man's face has been replaced by steel plating and electronics. A trans-humanist from the Fringe, then; such modifications are generally outlawed within the Core, especially on worlds owned by the Keth Corporation. Even in sleep he wears a malevolent grin."
		
			array_push(char_bio_ar,"This character's bio hasn't been written yet.");
		}
		
		else if i == character.mechanician {
			primary_role_str = "ENGINEER";
            char_class_snippet = "Another trans-humanist, this one more machine than woman. Her skin is deathly pale. Huge metal slits have been carved into the sides of her skull, presumably to vent the massive amount of heat generated by her cybernetic brain. A clear violation of the Keth Corporation's law against cybernetic enhancement, if ever there was one."
		
			array_push(char_bio_ar,"This character's bio hasn't been written yet.");
		}
		
		else if i == character.doctor {
			primary_role_str = "SCIENTIST";
            char_class_snippet = "This woman is wearing a white lab coat emblazoned with the Keth Corporation's sigil. It is disconcerting to know that she chose refuge here, in a stasis chamber, rather than face head-on whatever terrible crisis has clearly paralyzed this vessel. Surely she must know more about what happened here."
		
			array_push(char_bio_ar,"This character's bio hasn't been written yet.");
		}
		
		else if i == character.janitor {
			primary_role_str = "CIVILIAN";
            char_class_snippet = "An older man in the gray overalls of a technician. A company man, by his sigil. He has a nasty looking head wound. Perhaps he saw something before his sense of self-preservation brought him here?"
		
			array_push(char_bio_ar,"This character's bio hasn't been written yet.");
		}
		
		else if i == character.biologist {
			primary_role_str = "SCIENTIST";
            char_class_snippet = "Another bespeckled gray beard in a white lab coat, they seem to populate most star ships--especially those that operate well outside of the known regions of space. This one has an imperious look and a slight sneer, even in stasis."
		
			array_push(char_bio_ar,"This character's bio hasn't been written yet.");
		}
		
		else if i == character.veteran {
			primary_role_str = "SECURITY";
            char_class_snippet = "Not every planet from the Fringe submitted so quietly to corporate 'sponsorship' from the Core. Some resisted--though all yielded, in the end. Corvax was one such world that sought independence from corporate rule. The insurgents there adorned themselves with the same tribal tatoos that surround this woman's left eye. Her ascetic features and weathered skin also suggest a life of extreme deprivation. The militia of Corvax often sought refuge from the Enforcers within the vast jungles that once blanketed that world. It was even said that some of them modified their genetic code to become like the beasts of those forests, to make themselves stronger, faster, and escape detection... But surely those reports were just unfounded rumors. After all, cross-splicing the human genome with non-human DNA was always a risky endeavor and prone to dangerous side effects, and such techniques were never perfected outside of the Core. Still, there's a bestial aspect to this woman's features that makes you wonder...";
		
			array_push(char_bio_ar,"This character's bio hasn't been written yet.");
		}
		
		else {
			array_push(char_str_ar,"UNDEFINED");
			array_push(char_bio_ar,"This char's backstory has not been defined.");
		}
		
		array_push(char_stats_ar, $"{temp_char_id.name}: Primary role: {primary_role_str}.\n\n{char_class_snippet}\n\nSecurity: {temp_char_id.security}; Engineering: {temp_char_id.engineering}; Science: {temp_char_id.science}; Stealth: {temp_char_id.stealth}\n\n");
	
		delete temp_char_id;
	}
	
	#endregion
	
	/*

		else:
            total_chars_bio_list.append("This character's backstory is not yet defined.")
        #Add stats string to total_char_stats_list
        total_chars_stats_list.append(
            f"{i}.) {temp_pc_char.name}: Primary role: {primary_role_str}. {char_class_snippet} Security: {temp_pc_char.security}; Engineering: {temp_pc_char.engineering}; Science: {temp_pc_char.science}; Stealth: {temp_pc_char.stealth}")
        #De-reference (destroy) this instance:
        temp_pc_char = -1
	
	*/
	
}