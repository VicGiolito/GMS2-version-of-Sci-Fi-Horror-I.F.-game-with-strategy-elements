/// @description o_char_struct_spr - draw event


if sprite_index != -1 {
	
	draw_self();
	
	//Draw name:
	var char_name = represents_struct_id.name;
	draw_text_color(x,y-sprite_height-8,char_name,c_white,c_white,c_white,c_white,1);
}












