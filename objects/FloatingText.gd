extends Position2D

onready var tween = $Tween

var velocity = Vector2(10,-60)
var gravity = Vector2(0,1)
var mass = 100

var color = Color(1.0,1.0,1.0)
var type = null
var lifespan = 0.8
var duration = 0.5

var text setget set_text, get_text
var font_size setget set_font_size, get_font_size

func _ready():
#	if !color:
#		color = Color(rand_range(0.0,1.0),rand_range(0.0,1.0),rand_range(0.0,1.0))
	modulate = color
	
func damage_text(node,text):
	set_text(text)
	node.add_child(self)
	tween.interpolate_property(self, "position", position, position + Vector2(0,-10),duration,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	handle_tween()
	
func prompt_text(node,text):
	set_text(text)
	lifespan = 10.0
	node.add_child(self)
	tween.interpolate_property(self, "position", position, position + Vector2(0,-10),duration,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	handle_tween()
	
func handle_tween():
	tween.interpolate_callback(self,lifespan,"queue_free")
	tween.start()

#func _process(delta):
#	velocity += gravity * mass * delta
#	position += velocity * delta
	
func set_text(new_text):
	$Label.bbcode_text = str(new_text)
	
func get_text():
	return $Label.text
	
func set_font_size(size):
	$Label.get("custom_fonts/font").set_size(size)
	
func get_font_size():
	return $Label.get("custom_fonts/font").get_size()
