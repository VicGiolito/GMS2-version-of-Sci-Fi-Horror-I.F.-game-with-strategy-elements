/// @description o_char_struct_spr - draw event


if sprite_index != -1 && !invisible_boolean {
	
	draw_self();
	
	//Draw name:
	scr_center_font_align();
	draw_set_font(fnt_default_8);
	var char_name = represents_struct_id.nick_name;
	draw_text_color(x,y-(sprite_height * .75),char_name,c_white,c_white,c_white,c_white,1);
	scr_reset_font_align();
	scr_reset_font();
}












