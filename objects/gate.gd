extends Interactive_Object

onready var tween = $Tween
onready var sprite = $Sprite

func _ready():
	tween.interpolate_property(self,"modulate",Color(1,1,1,1),Color(1,1,1,0),1.2,Tween.TRANS_LINEAR,Tween.EASE_IN)
	if atlas_cord:
		sprite.frame = atlas_cord.x
	pass
	
func interact(unit):
	tween.start()
	var path_tiles = get_parent().path_tiles
	var map_position = path_tiles.world_to_map(global_position)
	path_tiles.set_cell(map_position.x,map_position.y,0)
	path_tiles.connect_cell(map_position)
	
	#var highlight_tiles = get_parent().highlight_tiles
	#highlight_tiles.movement_range(path_tiles.world_to_map(unit.global_position))
	unit.get_unit_manager().highlight_move_range()
