
/* This is literally just GMS2's 'point_distance' algorithm;
it's useful for calculating pixel distances between two points.
*/

function scr_return_euclidean_dist(x1,y1,x2,y2){
	
	var euclidean_dist = sqrt(sqr(x1 - x2) + sqr(y1 - y2));
	
	return euclidean_dist;
}