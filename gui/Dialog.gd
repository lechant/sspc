extends Control

export var dialog_file_path = "res://data/dialog_test.json"
export(float) var text_speed = 0.03

var json_reader = preload("res://controller/Json_reader.tres")

var dialog

var dialog_index = 0
var finished = false 

func _ready():
	$Timer.wait_time = text_speed
	dialog = get_dialog()
	next_phrase()
	
func get_dialog():
	var output = json_reader.read_json(dialog_file_path)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []

func next_phrase():
	if dialog_index >= len(dialog):
		$Tween.interpolate_property(self,"modulate",Color(modulate.r,modulate.g,modulate.b,modulate.a),Color(modulate.r,modulate.g,modulate.b,0.0),0.55,Tween.EASE_IN,Tween.TRANS_LINEAR)
		$Tween.start()
		yield($Tween,"tween_completed")
		queue_free()
		return
	finished = false
	
	$Name.bbcode_text = dialog[dialog_index]["name"]
	$Text.bbcode_text = dialog[dialog_index]["text"]
	
	$Text.percent_visible =0.0

	var percentage_scale = 1.0/len($Text.text)
	while $Text.percent_visible < 1.0:
		$Text.percent_visible += percentage_scale
		$Timer.start()
		yield($Timer,"timeout")
	
	finished = true
	dialog_index += 1
	return
	
func _input(event):
	if event.is_action_pressed("ui_down") && finished:
		next_phrase()
	elif event.is_action_pressed("ui_down") && !finished:
		$Text.percent_visible = 1.0
