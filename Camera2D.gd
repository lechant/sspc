extends Camera2D

onready var character_manager = $"../CharacterManager"
var turn_order = preload("res://controller/turn_order.tres")

func _ready():
	#character_manager.connect_character_unit_events(self)
	pass # Replace with function body.
	
func _process(delta):
	global_position = global_position.move_toward(character_manager.get_active_unit().global_position,delta * 200)
