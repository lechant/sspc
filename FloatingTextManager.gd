extends Node

var floating_text = preload("res://objects/FloatingText.tscn")

func create(text):
	var new_text = floating_text.instance()
	new_text.text = "hello world"
	new_text.global_position = Vector2(2,2)
	get_parent().add_child(new_text)
