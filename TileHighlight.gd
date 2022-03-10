extends TileMap

onready var path_cells = $"../Path"

var flood_fill_bucket = []

func _ready():
	pass
	
func radial_highlight(unit_position,move_range):
	clear()
	var unit_grid_position = world_to_map(unit_position)
	area_fill(unit_grid_position,move_range)
	for point in flood_fill_bucket:
		drawInCell(point,0,Vector2(3,0))
	flood_fill_bucket = []
		
func area_fill(init,max_range):
	for x in range(init.x - max_range - 1, init.x + max_range):
		for y in range(init.y - max_range - 1, init.y + max_range):
			var point := Vector2(x,y)
			if flood_fill_bucket.has(point):
				continue
			if !path_cells.get_used_cells().has(point):
				continue
			if !path_cells.get_astar_path(init,point):
				continue
			if path_cells.get_astar_path(init,point).size() > max_range:
				continue
			flood_fill_bucket.push_back(point)
	
func drawInCell(cell_pos,tile_id,autotile_coord):
	set_cell(cell_pos.x,cell_pos.y,tile_id,false,false,false,autotile_coord)
