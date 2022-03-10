extends Panel

var text setget set_text 
export var suboption_type = ""

onready var sub_option_manager = $"../../../../SubOptionMenu"

func _ready():
	pass # Replace with function body.

func set_text(val):
	$label.text = val
	
func _input(event):
	if event.is_action_pressed("ui_click"):
		var bounds = Rect2(rect_position, rect_size)
		if bounds.has_point(event.position):
			print("clicked: " + $label.text)

func _on_Button_pressed():
	print("clicked: " + $label.text)
	#NOTE: change later to use suboption_type to dynamically call parent method
	sub_option_manager.select_skill($label.text)
	
func _on_Panel_mouse_entered():
	pass
