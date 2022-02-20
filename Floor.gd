extends Astar_Path

onready var sprite = $"../Sprite"

var moving = false

signal move_complete

func map_path_to_world(path,path_follow_offset):
	var world_path = []
	for point in path:
		world_path.push_back(map_to_world(point) - path_follow_offset)
	return world_path
