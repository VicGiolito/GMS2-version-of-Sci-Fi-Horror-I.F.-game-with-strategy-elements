/* Uses the room 'room_enum' from the Room structs stored in w.e the g.cur_grid is to define the tile
for that specific coordinate of the tilemap layer.
*/

function scr_define_tilemap_from_grid_structs(grid_to_use){
	
	var lay_id = layer_get_id("tile_main");
	var tile_id = layer_tilemap_get_id(lay_id);
	
	//tilemap_clear(tile_id,0); //Black space, nothing.
	
	var grid_w = ds_grid_width(grid_to_use), grid_h = ds_grid_height(grid_to_use);
	
	var struct_id, tile_enum;
	
	for(var xx = 0; xx < grid_w; xx++){
		for(var yy = 0; yy < grid_h; yy++){
			
			struct_id = grid_to_use[# xx,yy];
			
			if is_struct(struct_id) {	
				
				if struct_id.struct_type_enum == struct_type.Room {
					
					tile_enum = struct_id.room_enum; //We can use this room_enum as the tile enum b.c the order in which these enums are arranged matches the order in which the tiles are arranged in our corresponding tileset.
					
					if tilemap_set(tile_id,tile_enum,xx,yy) == true {
						d($"scr_define_tilemap_from_grid_structs: TILEMAP SUCCESSFULLY SET AT GRID_X: {xx}, GRID_Y: {yy}, with tile_enum: {tile_enum}" );
					}
					else {
						d($"+++++++FAILED TO SET TILEMAP AT x:{xx}, y:{yy} ")	
					}
				}
			}
		}
	}
}