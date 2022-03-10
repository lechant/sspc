extends MarginContainer

var ability_data = null

var option_scene = preload("res://gui/GUI_options.tscn")
var abilities_data = preload("res://controller/ability_data.tres")

onready var sub_option_container = $ScrollContainer/GridContainer

signal skill_select(name)

func _ready():
	load_combat_options()

func load_combat_options():
	for skill in abilities_data.get_character_abilities("summoner"):
		var option_item = option_scene.instance()
		option_item.text = skill['name']
		sub_option_container.add_child(option_item)
	
func select_skill(name):
	emit_signal("skill_select",name)
