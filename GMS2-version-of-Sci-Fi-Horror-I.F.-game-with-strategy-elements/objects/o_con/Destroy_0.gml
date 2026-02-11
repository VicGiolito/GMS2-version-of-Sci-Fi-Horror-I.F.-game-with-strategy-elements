/// @description //Destroy data structures:

if ds_exists(global.research_vessel_grid,ds_type_grid) {
	ds_grid_destroy(global.research_vessel_grid);
	global.research_vessel_grid = -1;
}

if ds_exists(global.cur_grid,ds_type_grid) {
	ds_grid_destroy(global.cur_grid);
	global.cur_grid = -1;
}
















