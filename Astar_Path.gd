class_name Astar_Path
extends TileMap

onready var astar = AStar2D.new();
onready var cells = get_used_cells();

const neighbours = [Vector2.RIGHT,Vector2.LEFT,Vector2.UP,Vector2.DOWN,Vector2(1,1),Vector2(-1,-1),Vector2(-1,1),Vector2(1,-1)]

func _ready():
	#print("cell count: " + String(cells.size()))
	_add_points()
	_connect_points()
	#print(get_astar_path(Vector2(1,1),Vector2(9,7)))

func _add_points():
	for cell in cells:
		astar.add_point(id(cell),cell,1.0)
		
func _connect_points():
	for cell in cells:
		for neighbour in neighbours:
			var next_cell = cell + neighbour
			if cells.has(next_cell):
				astar.connect_points(id(cell),id(next_cell))
				
func get_astar_path(a,b):
	return astar.get_point_path(id(a),id(b))
	
func connect_cell(cell):
	astar.add_point(id(cell),cell,1.0)
	for neighbour in neighbours:
		var next_cell = cell + neighbour
		if cells.has(next_cell):
			#print("connecting cell to " + String(next_cell))
			astar.connect_points(id(cell),id(next_cell))
			astar.connect_points(id(next_cell),id(cell))

#cantor pairing function	
func id(point):
	var a = point.x
	var b = point.y
	return (a + b) * (a + b + 1) / 2 + a
