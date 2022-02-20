extends TileMap

onready var path_tiles := $"../Path"
onready var highlight_tiles := $"../TileHighlight"

export var register_dict = {
	0 : "res://objects/floor_spike.tscn",
	1 : "res://objects/gate.tscn"
}

var object_dict = {}

func _ready():
	tilemap_load_objects()
	
func tilemap_load_objects():
	#load all paths into objects first
	for key in register_dict.keys():
		object_dict[key] = load(register_dict[key])
	#load objects onto designated tile positions in tilemap
	for cell in get_used_cells():
		var cell_val = get_cell(cell.x,cell.y)
		if !object_dict.has(cell_val):
			continue
		var temp_object = object_dict[cell_val].instance()
		#set autotile value based off value used in tilemap
		temp_object.set_atlas(get_cell_autotile_coord(cell.x,cell.y))
		temp_object.global_position = map_to_world(cell) + cell_size/2
		set_cell(cell.x,cell.y,-1)
		add_child(temp_object)
