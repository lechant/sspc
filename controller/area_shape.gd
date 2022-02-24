extends Resource

func area_line(init,length,direction,width=0,trim=true):
	var area_arr = []
	var end_point = init + direction * length
	for y in range(0,length):
		for x in range(0 - width,1 + width ):
			var point = init + direction * y + Vector2(x,0)
			var is_diagonal = !(direction.x == 0 || direction.y == 0)
			if trim && (point.x < init.x || point.x >= end_point.x) && is_diagonal:
				continue
			area_arr.push_back(point)
	return area_arr
