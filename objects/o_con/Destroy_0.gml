/// @description //Destroy data structures:

if ds_exists(global.research_vessel_grid,ds_type_grid) {
	ds_grid_destroy(global.research_vessel_grid);
	global.research_vessel_grid = -1;
}

if ds_exists(global.cur_grid,ds_type_grid) {
	ds_grid_destroy(global.cur_grid);
	global.cur_grid = -1;
}

if ds_exists(global.visited_grid,ds_type_grid) {
	ds_grid_destroy(global.visited_grid);
	global.visited_grid = -1;
}

if ds_exists(global.steps_grid,ds_type_grid) {
	ds_grid_destroy(global.steps_grid);
	global.steps_grid = -1;
}

if ds_exists(global.frontier_queue,ds_type_priority) {
	ds_priority_destroy(global.frontier_queue);
	global.frontier_queue = -1;
}















