extends MarginContainer

onready var description = $Description

var text setget set_text

func set_text(val):
	text = val
	description.bbcode_text = val
