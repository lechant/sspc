extends Camera2D

onready var character_manager = $"../CharacterManager"
var turn_order = preload("res://controller/turn_order.tres")

func _ready():
	#character_manager.connect_character_unit_events(self)
	pass # Replace with function body.
	
func _process(delta):
	var mov_pos = null
	if character_manager.get_active_unit():
		mov_pos = character_manager.get_active_unit().global_position
	else:
		mov_pos = character_manager.get_unit_by_id(turn_order.cycle_unit_list("player").id).global_position
	global_position = global_position.move_toward(mov_pos,delta * 200)

