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
        "\tThe ultimate goal is to either escape from section 17 with every party member, or utterly destroy the alien threat that has infested this sector of space.\n",
        "\tThere are multiple endings and you'll be awarded points at the end of each run depending upon how much you accomplish.\n",
        "\tA word of advice: while it is technically possible to beat the game with any party combination, a party that includes a diverse set of skills will serve you best. That being said, there is no 'perfect party,' and it is useful to play with every character to learn their strengths and weaknesses--so don't bother deliberating over your first party composition too much.\n",
        "\tGood luck!\n",
        "Press enter to continue.\n"
		]
		
	start_new_game_intro_2 = [
		"Klaxons blare deep within the metal womb of the spindle-ship 'K.C. Niffy,' adrift somewhere within the endless sea of stars...\n",
        "\t... Yet outside the vessel, in the vacuum of the void, there is only silence.\n",
        "\tWe move closer toward the starship, a jagged splinter tumbling through the abyss...\n",
        "\t... Moving closer and closer still...\n",
        "\t... Moving through layers of steel hull, insulation, electronics, metal grating...\n",
        "\t... Emerging from a ceiling fan into an oval-shaped room, dimly lit by pulsing-red emergency lights. Here the sound of the klaxons is deafening. The walls of the room have nearly been torn asunder and quake with the impact of some distant explosion. Wrent paneling and torn steel reveal the steaming and sparking guts of the ship's infrastructure.\n",
        "\tNear the center of the room, raised upon a wide dais, row upon row of stasis pods are gleaming in the gloom like white pearls with red bellies, beckoning us closer.\n",
        "\tAbove the stasis pods, through glass casings filmed with frost, one can see that most of the sleepers wear placid expressions, totally at ease within their pale cribs, indifferent to the apparent chaos raging all around them.\n",
        "\tThree of the occupants, however, are stirring. They seem convinced that these glass cages with their white velvet cushions will not become their coffins. Sweat beads upon their brows. Their features twist and contort, fighting against the ephemeral pull of some discontented dream.\n",
        "\tIn the shadow of the eerie purgatory light, it is difficult to make out their faces.\n",
        "\tWho among them will wake, shaken by the last gasp of a failing power system?...\n",
        "\t... And who among them will slip deeper still from slumber, into death?\n",
		"Press enter to peruse the stasis pods."
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
		temp_char_id = new Character(i,0,0,global.cur_grid,team_type.pc,false);
		char_name = temp_char_id.name;
		array_push(char_str_ar,string(char_name));
		
		if i == character.ogre {
			primary_role_str = "SECURITY";
			char_class_snippet = "This stubbled brute almost looks like the standard variant of the Keth Corporation clone, only... bigger. Much bigger. Uglier, too.";
			
			array_push(char_bio_ar, [
				"Cragos, 'The Ogre':\n",
                "\tCragos was intended to be just another of the millions of faceless clones born into servitude by the Kethas Corporation, but a power surge in his gestation vat caused an excessive amount of growth hormone to be released into his developmental stew. As a result, he emerged from his birthing chamber weeks before his brothers and sisters, a hulking giant of a man with the mind of a child, and a misshapen face that only a mother could love... If only he had one.\n",
                "\tThe scientists at Keth Corp. were bemused by this unanticipated variant, and rigorously tested his physical and mental capabilities to determine the viability of his strain. They called it 'testing,' but Cragos would soon come to know the euphimism for what it truly was: torture.\n",
                "\tHe was only six weeks old by the time they had subjected him to a battery of tests that included blunt force trauma, precision tissue damage, and unimaginable G-forces, all to determine the tolerances of his physical structure, and also the rate of his healing factor, which surpassed even that of his kin. He was at least spared the psychological conditioning, not by any act of mercy, but merely because he was overlooked and forgotten after the researchers grew bored of his screams, and labeled his mutation as 'UNSATISFACTORY.'\n",
				"\tHe was deemed too large and clumsy to be useful on the battlefield, and a terrible shot, too, owing to the fact that his left eye was positioned considerably lower than his right. He was too hideous even to serve as steward in the gilded homes of the elite back in the Core.\n",
                "\tA simple barcode stamped to the back of his neck designated him as such. He was slated to be reprocessed and recycled, in fact, liquified and fed back to his fellow clones as essential nutrients, had the interstellar freighter that was his home not been attacked by raiders from the Fringe. It was of course Keth Corp. policy to never reveal the secrets of their proprietary technology, and so they reduced the massive hulk of their own starship to ruins in the depths of space, rather than submit to the pirates' boarding party. The brigands did not leave empty handed, however.\n",
                "\tThey found Cragos still clinging to life in a small pressurized compartment in a field of floating debris, like a cockroach that refused to die, or a caterpillar cocooned in stasis, patiently awaiting chrysalis. Unlike the scientists at Keth Corp., they found good use for his muscle among their ranks, all right.\n",
                "\tBanditry was their trade, and his healing factor an invaluable asset. The absence of psychological conditioning had made it possible for Cragos to adjust to their nomadic lifestyle, to view himself as an invidual at last, as a person who could inspire respect--if never love.\n",
                "\tThey named him 'Cragos,' after the son of the stone god who ruled the mountains of their homeworld. And as the years passed he became well known as the most vicious and relentless of their clan. Eventually he outlived them all, and when the very last of their clan had been shot down by enforcers from the Core, Cragos struck out into the void to earn his own coin, plying his trade as a mercenary for hire, a dealer of death and punishment alike. Yet he never forgot the faces of his tormentors who had given him life, and always he hoarded the horror of his past as fuel for future conquests.\n",
                "\tIt was a kidnapping job gone sideways that found him in a stasis chamber aboard the Keth Corp. research vessel 'Niffy.' And there he remains: a caged animal once more, eyes closed, yet not sleeping--always dreaming of vengeance against the inexhaustible and inexorable corporation that made him...\n",
                "\tAlways dreaming... And always promising pain.\n"
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
            char_class_snippet = "Another trans-humanist, this one more machine than woman. Her skin is deathly pale. Huge metal slits have been carved into the sides of her skull, presumably to vent the massive amount of heat generated by her mechanically enhanced brain. A clear violation of the Keth Corporation's law against cybernetic enhancement, if ever there was one."
		
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
		
		else {
			array_push(char_str_ar,"UNDEFINED");
			array_push(char_bio_ar,"This char's backstory has not been defined.");
		}
		
		array_push(char_stats_ar, $"{i}.) {temp_char_id.name}: Primary role: {primary_role_str}.\n{char_class_snippet}\nSecurity: {temp_char_id.security}; Engineering: {temp_char_id.engineering}; Science: {temp_char_id.science}; Stealth: {temp_char_id.stealth}\n");
	
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