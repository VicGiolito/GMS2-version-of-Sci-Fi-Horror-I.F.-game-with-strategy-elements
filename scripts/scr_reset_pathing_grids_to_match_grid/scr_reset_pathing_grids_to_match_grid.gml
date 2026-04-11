/*
 Resets the visited_grid and steps_grid and recreates them to match the dimensions of the supplied grid;
 
 more thorough than simply using grid_resize

*/

function scr_reset_pathing_grids_to_match_grid(grid_to_match){
	
	var grid_w = ds_grid_width(grid_to_match), grid_h = ds_grid_height(grid_to_match);
	
	global.visited_grid = -1;
	global.visited_grid = ds_grid_create(grid_w, grid_h);
	ds_grid_clear(global.visited_grid, UNVISITED_CELL);
	
	global.steps_grid = -1;
	global.steps_grid = ds_grid_create(grid_w, grid_h);
	ds_grid_clear(global.steps_grid, UNVISITED_STEP_VAL);
}