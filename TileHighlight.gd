extends TileMap

onready var path_cells = $"../Path"

onready var area_shape = preload("res://controller/area_shape.tres")

var highlight_stack = [] setget set_highlight_stack

#func _ready():
#	highlight_stack = [
#		{"id":"1","order":"movement_range"}
#	]
#	draw_tile_line(Vector2(1,1),5,Vector2(0,1),1)
	
func draw_stack_items():
	for item in highlight_stack:
		call(item['order'])

func draw_tile_line(init,length,direction,width=0,trim=true):
	for tile in area_shape.area_line(init,length,direction,width,trim):
		drawInCell(tile,0,Vector2(1,0))

func movement_range(unit_position,move_range):
	clear()
	var unit_grid_position = world_to_map(unit_position)
	for point in area_fill(unit_grid_position,move_range):
		drawInCell(point,0,Vector2(3,0))
		
func area_fill(init,max_range):
	var flood_fill_bucket = []
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
	return flood_fill_bucket
	
func drawInCell(cell_pos,tile_id,autotile_coord):
	set_cell(cell_pos.x,cell_pos.y,tile_id,false,false,false,autotile_coord)
	
func set_highlight_stack(val):
	highlight_stack = val
