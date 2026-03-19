
/* Most useful when calculating distances between cells on a grid and 
diagonal movements are considered to cost the same amount as cardinal movements.
*/

function scr_return_chebyshev_dist(x1,y1,x2,y2){
	
	var dist_x = abs(x1-x2);
	var dist_y = abs(y1-y2);
	
	var chebyshev_dist = max(dist_x, dist_y);
	
	return chebyshev_dist;
}