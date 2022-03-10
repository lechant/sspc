extends Control

onready var option_scene = preload("res://gui/GUI_options.tscn")
onready var option_menu = $ColorRect/HBoxContainer/OptionsMenu/VContainer
onready var sub_option_menu = $ColorRect/HBoxContainer/SubOptionMenu/ScrollContainer/GridContainer
onready var description = $ColorRect/HBoxContainer/Description

var abilities_data = preload("res://controller/ability_data.tres")

const options = ["Skills","Items","End Turn"]

signal skill_select(name)

func _ready():
	load_main_options()
	pass

func load_main_options():
	for option in options:
		var option_item = option_scene.instance()
		option_item.text = option
		option_menu.add_child(option_item)

func _on_SubOptionMenu_skill_select(name):
	description.text = abilities_data.get_ability_data("summoner",name)['description']
	emit_signal("skill_select",name)
